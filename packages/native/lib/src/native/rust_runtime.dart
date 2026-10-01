import 'dart:io';

import 'package:flutter_rust_bridge/flutter_rust_bridge_for_generated.dart';

import '../rust/frb_generated.dart';

/// Name of the shared library that contains the crate where it is linked into the native library.
const _nativeLibraryName = 'libcitra-android.so';

/// Loads the `azahar_rust` crate.
///
/// Where the crate is linked statically into the executable, its symbols are looked up in the
/// running process. Otherwise they are looked up in the native library of the plugin. It must
/// be called once before any session function is used.
Future<void> initializeRust() {
  if (Platform.isAndroid) {
    return RustLib.init(
      externalLibrary: ExternalLibrary.open(_nativeLibraryName),
    );
  }
  return RustLib.init(
    externalLibrary: ExternalLibrary.process(iKnowHowToUseIt: true),
  );
}
