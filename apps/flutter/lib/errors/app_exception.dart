/// Base type for errors this app throws deliberately, so the global handler in `main.dart` can
/// tell them apart from unexpected framework/platform errors.
sealed class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Thrown when the native side reports it could not fulfill a request (e.g. a `MethodChannel`
/// call the platform side rejected).
class NativeBridgeException extends AppException {
  const NativeBridgeException(super.message);
}

/// Thrown when a settings dialog is confirmed with a value outside its allowed range.
class InvalidSettingValueException extends AppException {
  const InvalidSettingValueException(super.message);
}

/// Thrown when some of the files a game changed could not be written to the storage when it
/// stopped.
class SaveFailedException extends AppException {
  const SaveFailedException(super.message);
}
