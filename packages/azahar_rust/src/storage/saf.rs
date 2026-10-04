use std::ffi::c_void;
use std::os::fd::RawFd;
use std::sync::OnceLock;

use jni::errors::Result as JniResult;
use jni::objects::{GlobalRef, JClass, JObject, JObjectArray, JString, JValue};
use jni::{JNIEnv, JavaVM};

use super::{OpenMode, Storage};

/// The Storage Access Framework can only be reached from Java, and `NativeLibrary` already keeps
/// the document tree that resolves the paths of the core, so the backend calls into it.
const NATIVE_LIBRARY: &str = "com.karasu256.azahar_reloaded.lib.azahar_for_flutter.NativeLibrary";

unsafe extern "C" {
    fn azahar_host_java_vm() -> *mut c_void;
    fn azahar_host_class_loader() -> *mut c_void;
}

struct Bridge {
    vm: JavaVM,
    class: GlobalRef,
}

static BRIDGE: OnceLock<Bridge> = OnceLock::new();

/// Created on first use instead of at load time, because the Java VM is only known after
/// `JNI_OnLoad` ran.
fn bridge() -> Option<&'static Bridge> {
    if let Some(bridge) = BRIDGE.get() {
        return Some(bridge);
    }
    let vm = unsafe { azahar_host_java_vm() };
    let loader = unsafe { azahar_host_class_loader() };
    if vm.is_null() || loader.is_null() {
        return None;
    }
    let vm = unsafe { JavaVM::from_raw(vm.cast()) }.ok()?;
    let class = {
        let mut env = vm.attach_current_thread_permanently().ok()?;
        let loader = unsafe { JObject::from_raw(loader.cast()) };
        let name = env.new_string(NATIVE_LIBRARY).ok()?;
        let class = env
            .call_method(
                &loader,
                "loadClass",
                "(Ljava/lang/String;)Ljava/lang/Class;",
                &[JValue::Object(&name)],
            )
            .and_then(|value| value.l());
        if env.exception_check().unwrap_or(false) {
            let _ = env.exception_clear();
        }
        env.new_global_ref(class.ok()?).ok()?
    };
    let _ = BRIDGE.set(Bridge { vm, class });
    BRIDGE.get()
}

/// Runs `f` in a local frame, because the threads of the core stay attached and would otherwise
/// keep every local reference alive.
fn call<T>(f: impl FnOnce(&mut JNIEnv, &JClass<'static>) -> JniResult<T>) -> Option<T> {
    let bridge = bridge()?;
    let mut env = bridge.vm.attach_current_thread_permanently().ok()?;
    let class = <&JClass>::from(bridge.class.as_obj());
    let result = env.with_local_frame(16, |env| f(env, class));
    if env.exception_check().unwrap_or(false) {
        let _ = env.exception_describe();
        let _ = env.exception_clear();
    }
    result.ok()
}

fn strings<'local>(env: &mut JNIEnv<'local>, values: &[&str]) -> JniResult<Vec<JObject<'local>>> {
    values
        .iter()
        .map(|value| env.new_string(value).map(JObject::from))
        .collect()
}

fn call_bool(name: &str, signature: &str, arguments: &[&str]) -> bool {
    call(|env, class| {
        let arguments = strings(env, arguments)?;
        let values: Vec<JValue> = arguments.iter().map(JValue::Object).collect();
        env.call_static_method(class, name, signature, &values)?.z()
    })
    .unwrap_or(false)
}

/// Splits `path` into its parent and its name, because a document is created by its parent.
fn split_parent(path: &str) -> (&str, &str) {
    let trimmed = path.trim_end_matches('/');
    match trimmed.rfind('/') {
        Some(0) | None => ("/", trimmed.trim_start_matches('/')),
        Some(index) => (&trimmed[..index], &trimmed[index + 1..]),
    }
}

/// Mode strings of `ParcelFileDescriptor.parseMode`, which differ from the ones of `fopen`.
fn descriptor_mode(mode: OpenMode) -> &'static str {
    match (mode.read, mode.write, mode.append, mode.truncate) {
        (true, false, _, _) => "r",
        (true, true, true, _) => "rwa",
        (true, true, _, true) => "rwt",
        (true, true, _, _) => "rw",
        (false, _, true, _) => "wa",
        (false, _, _, true) => "wt",
        _ => "w",
    }
}

/// Reaches the user directory of the Storage Access Framework and content URIs.
pub struct SafStorage;

impl Storage for SafStorage {
    fn exists(&self, path: &str) -> bool {
        call_bool("fileExists", "(Ljava/lang/String;)Z", &[path])
    }

    fn is_directory(&self, path: &str) -> bool {
        call_bool("isDirectory", "(Ljava/lang/String;)Z", &[path])
    }

    fn size(&self, path: &str) -> u64 {
        call(|env, class| {
            let path = env.new_string(path)?;
            env.call_static_method(class, "getSize", "(Ljava/lang/String;)J", &[
                JValue::Object(&path),
            ])?
            .j()
        })
        .map_or(0, |size| size.max(0) as u64)
    }

    fn create_dir(&self, path: &str) -> bool {
        let (parent, name) = split_parent(path);
        call_bool(
            "createDir",
            "(Ljava/lang/String;Ljava/lang/String;)Z",
            &[parent, name],
        )
    }

    fn remove_file(&self, path: &str) -> bool {
        call_bool("deleteDocument", "(Ljava/lang/String;)Z", &[path])
    }

    fn remove_dir(&self, path: &str) -> bool {
        call_bool("deleteDocument", "(Ljava/lang/String;)Z", &[path])
    }

    /// A document can only be renamed in place, so only the name of `to` is used.
    fn rename(&self, from: &str, to: &str) -> bool {
        let (_, name) = split_parent(to);
        call_bool(
            "renameFile",
            "(Ljava/lang/String;Ljava/lang/String;)Z",
            &[from, name],
        )
    }

    fn copy(&self, from: &str, to: &str) -> bool {
        let (parent, name) = split_parent(to);
        call_bool(
            "copyFile",
            "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z",
            &[from, parent, name],
        )
    }

    fn open(&self, path: &str, mode: OpenMode) -> Option<RawFd> {
        if mode.creates() && !self.exists(path) {
            let (parent, name) = split_parent(path);
            if !call_bool(
                "createFile",
                "(Ljava/lang/String;Ljava/lang/String;)Z",
                &[parent, name],
            ) {
                return None;
            }
        }
        let fd = call(|env, class| {
            let arguments = strings(env, &[path, descriptor_mode(mode)])?;
            let values: Vec<JValue> = arguments.iter().map(JValue::Object).collect();
            env.call_static_method(
                class,
                "openContentUri",
                "(Ljava/lang/String;Ljava/lang/String;)I",
                &values,
            )?
            .i()
        })?;
        (fd >= 0).then_some(fd)
    }

    fn list(&self, path: &str) -> Option<Vec<String>> {
        call(|env, class| {
            let path = env.new_string(path)?;
            let array = JObjectArray::from(
                env.call_static_method(
                    class,
                    "getFilesName",
                    "(Ljava/lang/String;)[Ljava/lang/String;",
                    &[JValue::Object(&path)],
                )?
                .l()?,
            );
            let length = env.get_array_length(&array)?;
            let mut names = Vec::with_capacity(length.max(0) as usize);
            for index in 0..length {
                let item = env.get_object_array_element(&array, index)?;
                if item.is_null() {
                    continue;
                }
                let item = JString::from(item);
                names.push(env.get_string(&item)?.into());
                env.delete_local_ref(item)?;
            }
            Ok(names)
        })
    }
}
