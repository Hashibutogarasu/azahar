use std::env;
use std::path::PathBuf;

/// Links the prebuilt C++ core when the `link_core` feature is enabled.
///
/// The core build directory is taken from `AZAHAR_CORE_BUILD_DIR` and defaults
/// to the `build` directory at the repository root.
fn main() {
    println!("cargo:rerun-if-env-changed=AZAHAR_CORE_BUILD_DIR");
    println!("cargo:rerun-if-changed=build.rs");

    if env::var_os("CARGO_FEATURE_LINK_CORE").is_none() {
        return;
    }

    let manifest_dir = PathBuf::from(env::var("CARGO_MANIFEST_DIR").unwrap());
    let build_dir = env::var_os("AZAHAR_CORE_BUILD_DIR")
        .map(PathBuf::from)
        .unwrap_or_else(|| manifest_dir.join("../../build"));

    println!("cargo:rustc-link-search=native={}", build_dir.join("src").display());
    println!("cargo:rustc-link-search=native={}", build_dir.join("externals").display());
    println!("cargo:rustc-link-arg=-Wl,--start-group");
    for entry in ["citra_core", "citra_common", "network", "input_common", "web_service"] {
        println!("cargo:rustc-link-lib=static={entry}");
    }
    println!("cargo:rustc-link-arg=-Wl,--end-group");
    println!("cargo:rustc-link-lib=dylib=stdc++");
}
