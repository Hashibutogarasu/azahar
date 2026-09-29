import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Localized labels shown by the applet dialogs.
class AppletStrings {
  /// Creates the label set used by [AppletChannel].
  const AppletStrings({
    required this.cancel,
    required this.iForgot,
    required this.standardMii,
    required this.softwareKeyboard,
  });

  final String cancel;
  final String iForgot;
  final String standardMii;
  final String softwareKeyboard;
}

/// Shows the emulator applets (software keyboard, Mii selector) requested by
/// the native side as Flutter dialogs.
class AppletChannel {
  /// Registers the applet method channel handler.
  ///
  /// [stringsOf] supplies the localized labels for the given context.
  AppletChannel(this._navigatorKey, {required this.stringsOf})
    : _channel = const MethodChannel(
        'org.citra.citra_emu/azahar_bridge/applet',
      ) {
    _channel.setMethodCallHandler(_handle);
  }

  final AppletStrings Function(BuildContext context) stringsOf;
  final GlobalKey<NavigatorState> _navigatorKey;
  final MethodChannel _channel;

  BuildContext? get _context => _navigatorKey.currentContext;

  Future<Object?> _handle(MethodCall call) async {
    final context = _context;
    if (context == null) {
      return switch (call.method) {
        'showKeyboard' => {'button': 0, 'text': ''},
        'showMiiSelector' => {'returnCode': 1, 'index': 0},
        _ => null,
      };
    }

    switch (call.method) {
      case 'showKeyboard':
        return _showKeyboard(
          context,
          (call.arguments as Map).cast<String, Object?>(),
        );
      case 'showMiiSelector':
        return _showMiiSelector(
          context,
          (call.arguments as Map).cast<String, Object?>(),
        );
      case 'showKeyboardError':
        _showKeyboardError(
          context,
          (call.arguments as Map).cast<String, Object?>(),
        );
        return null;
      default:
        return null;
    }
  }

  Future<Map<String, Object?>> _showKeyboard(
    BuildContext context,
    Map<String, Object?> args,
  ) async {
    final buttonConfig = args['buttonConfig'] as int;
    final multilineMode = args['multilineMode'] as bool;
    final hintText = args['hintText'] as String?;
    final buttonText = (args['buttonText'] as List).cast<String>();
    final controller = TextEditingController();
    final localizations = MaterialLocalizations.of(context);
    final t = stringsOf(context);

    final button = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: multilineMode ? null : 1,
          decoration: InputDecoration(hintText: hintText),
        ),
        actions: _keyboardActions(
          dialogContext,
          localizations,
          t,
          buttonConfig,
          buttonText,
        ),
      ),
    );

    return {'button': button ?? 0, 'text': controller.text};
  }

  List<Widget> _keyboardActions(
    BuildContext dialogContext,
    MaterialLocalizations localizations,
    AppletStrings t,
    int buttonConfig,
    List<String> buttonText,
  ) {
    Widget button(int index, String fallback) {
      return TextButton(
        onPressed: () => Navigator.of(dialogContext).pop(index),
        child: Text(buttonText.length > index ? buttonText[index] : fallback),
      );
    }

    switch (buttonConfig) {
      case 1:
        return [
          button(0, t.cancel),
          button(1, localizations.okButtonLabel),
        ];
      case 2:
        return [
          button(0, t.cancel),
          button(1, t.iForgot),
          button(2, localizations.okButtonLabel),
        ];
      default:
        return [button(0, localizations.okButtonLabel)];
    }
  }

  Future<Map<String, Object?>> _showMiiSelector(
    BuildContext context,
    Map<String, Object?> args,
  ) async {
    final title = args['title'] as String?;
    final enableCancelButton = args['enableCancelButton'] as bool;
    final miiNames = (args['miiNames'] as List).cast<String>();
    final t = stringsOf(context);

    final index = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimpleDialog(
        title: title != null ? Text(title) : null,
        children: [
          for (var i = 0; i <= miiNames.length; i++)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(i),
              child: Text(i == 0 ? t.standardMii : miiNames[i - 1]),
            ),
          if (enableCancelButton)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(t.cancel),
            ),
        ],
      ),
    );

    if (index == null) {
      return {'returnCode': 1, 'index': 0};
    }
    return {'returnCode': 0, 'index': index};
  }

  void _showKeyboardError(BuildContext context, Map<String, Object?> args) {
    final message = args['message'] as String? ?? '';
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(stringsOf(context).softwareKeyboard),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(MaterialLocalizations.of(dialogContext).okButtonLabel),
          ),
        ],
      ),
    );
  }
}
