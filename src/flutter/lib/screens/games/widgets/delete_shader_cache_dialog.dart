import 'package:flutter/material.dart';
import 'package:azahar_for_flutter/azahar_for_flutter.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/dialog_cancel_button.dart';

/// Mirrors the Compose client's `DeleteShaderCacheButton`: asks which graphics backend's disk
/// shader cache to delete for [game], then removes it.
class DeleteShaderCacheDialog extends StatefulWidget {
  const DeleteShaderCacheDialog({super.key, required this.game});

  final Game game;

  static Future<void> show(BuildContext context, Game game) {
    return showDialog<void>(
      context: context,
      builder: (_) => DeleteShaderCacheDialog(game: game),
    );
  }

  @override
  State<DeleteShaderCacheDialog> createState() =>
      _DeleteShaderCacheDialogState();
}

class _DeleteShaderCacheDialogState extends State<DeleteShaderCacheDialog> {
  ShaderCacheBackend? _selected;

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(t.games.deleteCacheSelectBackend),
      content: RadioGroup<ShaderCacheBackend>(
        groupValue: _selected,
        onChanged: (value) => setState(() => _selected = value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ShaderCacheBackend>(
              title: Text(t.games.vulkan),
              value: ShaderCacheBackend.vulkan,
            ),
            RadioListTile<ShaderCacheBackend>(
              title: Text(t.games.opengles),
              value: ShaderCacheBackend.opengl,
            ),
          ],
        ),
      ),
      actions: [
        const DialogCancelButton(),
        TextButton(
          onPressed: _selected == null
              ? null
              : () async {
                  final backend = _selected!;
                  final messenger = ScaffoldMessenger.of(context);
                  Navigator.of(context).pop();
                  await AppServices.nativeBridge.deleteShaderCache(
                    widget.game,
                    backend,
                  );
                  messenger.showSnackBar(
                    SnackBar(content: Text(t.games.shaderCacheDeleted)),
                  );
                },
          child: Text(localizations.okButtonLabel),
        ),
      ],
    );
  }
}
