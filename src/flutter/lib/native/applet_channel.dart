import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../i18n/translations.g.dart';

class AppletChannel {
  AppletChannel(this._navigatorKey)
      : _channel = const MethodChannel('org.citra.citra_emu/azahar_bridge/applet') {
    _channel.setMethodCallHandler(_handle);
  }

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
        return _showKeyboard(context, (call.arguments as Map).cast<String, Object?>());
      case 'showMiiSelector':
        return _showMiiSelector(context, (call.arguments as Map).cast<String, Object?>());
      case 'showKeyboardError':
        _showKeyboardError(context, (call.arguments as Map).cast<String, Object?>());
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
    final t = context.t;

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
        actions: _keyboardActions(dialogContext, localizations, t, buttonConfig, buttonText),
      ),
    );

    return {'button': button ?? 0, 'text': controller.text};
  }

  List<Widget> _keyboardActions(
    BuildContext dialogContext,
    MaterialLocalizations localizations,
    Translations t,
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
          button(0, localizations.cancelButtonLabel),
          button(1, localizations.okButtonLabel),
        ];
      case 2:
        return [
          button(0, localizations.cancelButtonLabel),
          button(1, t.applets.iForgot),
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
    final t = context.t;

    final index = await showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => SimpleDialog(
        title: title != null ? Text(title) : null,
        children: [
          for (var i = 0; i <= miiNames.length; i++)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(i),
              child: Text(i == 0 ? t.applets.standardMii : miiNames[i - 1]),
            ),
          if (enableCancelButton)
            SimpleDialogOption(
              onPressed: () => Navigator.of(dialogContext).pop(null),
              child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
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
        title: Text(context.t.applets.softwareKeyboard),
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
