import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import 'dart:async';
import 'dart:convert';

import 'user_files.dart';

/// Single owner of where the emulator log is stored. The native logging backend only reports
/// lines; this service decides the location inside the user directory and writes them there.
class LoggingService {
  LoggingService(this._nativeBridge, this._files);

  static const _logDirectory = 'log';
  static const _currentLogPath = '$_logDirectory/azahar_log.txt';
  static const _previousLogPath = '$_logDirectory/azahar_log.old.txt';
  static const _maxPendingLines = 20000;
  static const _writeLimitBytes = 100 * 1024 * 1024;

  final NativeBridge _nativeBridge;
  final UserFiles _files;
  final List<String> _pendingLines = [];

  StreamSubscription<List<String>>? _subscription;
  Future<void> _writeQueue = Future.value();
  bool _rotated = false;
  int _bytesWritten = 0;

  void start() {
    _subscription ??= _nativeBridge.logLines().listen(
      _enqueue,
      onError: (Object _) {},
    );
  }

  /// Starts a fresh log in the newly confirmed user directory and writes what was held back.
  Future<void> userDirectoryChanged() {
    _writeQueue = _writeQueue.then((_) {
      _rotated = false;
      _bytesWritten = 0;
      return _writePending();
    });
    return _writeQueue;
  }

  /// Shares the previous run's log when there is one, otherwise the current log.
  Future<bool> share() async {
    await _flush();
    final path = await _files.exists(_previousLogPath)
        ? _previousLogPath
        : _currentLogPath;
    if (!await _files.exists(path)) return false;
    return _files.share(path);
  }

  void _enqueue(List<String> lines) {
    _pendingLines.addAll(lines);
    final overflow = _pendingLines.length - _maxPendingLines;
    if (overflow > 0) _pendingLines.removeRange(0, overflow);
    unawaited(_flush());
  }

  Future<void> _flush() {
    _writeQueue = _writeQueue.then((_) => _writePending());
    return _writeQueue;
  }

  Future<void> _writePending() async {
    if (_pendingLines.isEmpty) return;
    if (_bytesWritten > _writeLimitBytes) {
      _pendingLines.clear();
      return;
    }
    if (!_rotated && !await _files.rotate(_currentLogPath, _previousLogPath)) {
      return;
    }
    final lines = List<String>.of(_pendingLines);
    _pendingLines.clear();
    final text = '${lines.join('\n')}\n';
    if (await _files.append(_currentLogPath, text)) {
      _rotated = true;
      _bytesWritten += utf8.encode(text).length;
    } else {
      _pendingLines.insertAll(0, lines);
    }
  }
}
