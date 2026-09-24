import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../models/create_shortcut_request.dart';
import '../../../models/game.dart';
import 'game_icon.dart';

/// Mirrors the Compose client's `CreateShortcutDialog`: lets the user rename the shortcut and
/// optionally replace its icon with a picked image before pinning it to the home screen.
class CreateShortcutDialog extends StatefulWidget {
  const CreateShortcutDialog({super.key, required this.game});

  final Game game;

  static Future<void> show(BuildContext context, Game game) {
    return showDialog<void>(context: context, builder: (_) => CreateShortcutDialog(game: game));
  }

  @override
  State<CreateShortcutDialog> createState() => _CreateShortcutDialogState();
}

class _CreateShortcutDialogState extends State<CreateShortcutDialog> {
  late final TextEditingController _nameController = TextEditingController(text: widget.game.title);
  bool _nameError = false;
  String? _customImagePath;
  bool _stretch = false;

  Future<void> _pickImage() async {
    final picked = await FilePicker.pickFile(type: FileType.image);
    if (picked?.path != null) {
      setState(() {
        _customImagePath = picked!.path;
        _stretch = false;
      });
    }
  }

  Future<void> _confirm() async {
    final name = _nameController.text;
    if (name.isEmpty) {
      setState(() => _nameError = true);
      return;
    }
    Navigator.of(context).pop();
    await AppServices.nativeBridge.createGameShortcut(
      CreateShortcutRequest(
        titleId: widget.game.titleId,
        path: widget.game.path,
        name: name,
        iconFilePath: _customImagePath ?? widget.game.iconPath,
        stretch: _stretch,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(t.games.createShortcut),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 96,
                height: 96,
                child: GameIcon(iconPath: _customImagePath ?? widget.game.iconPath),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(t.games.shortcutImageStretchToggle),
                Switch(
                  value: _stretch,
                  onChanged: _customImagePath == null
                      ? null
                      : (value) => setState(() => _stretch = value),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: t.games.shortcutName,
                errorText: _nameError ? t.games.shortcutNameEmpty : null,
              ),
              onChanged: (_) {
                if (_nameError) setState(() => _nameError = false);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(localizations.cancelButtonLabel),
        ),
        TextButton(onPressed: _confirm, child: Text(localizations.okButtonLabel)),
      ],
    );
  }
}
