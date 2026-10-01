import 'package:azahar_for_flutter/azahar_for_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/games/game_title_provider.dart';
import '../../../data/games/user_game_infos_provider.dart';
import '../../../i18n/translations.g.dart';

/// The name of [game] shown large and editable in place.
///
/// The edit is saved when the field is submitted or loses focus. A blank name, or the default name,
/// restores the default. While the name is edited, a close icon next to it restores the default.
class EditableGameTitle extends ConsumerStatefulWidget {
  const EditableGameTitle({super.key, required this.game});

  final Game game;

  @override
  ConsumerState<EditableGameTitle> createState() => _EditableGameTitleState();
}

class _EditableGameTitleState extends ConsumerState<EditableGameTitle> {
  late final _controller = TextEditingController(
    text: ref.read(gameTitleProvider(widget.game.path)),
  );
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) _commit();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _commit() {
    final game = widget.game;
    final text = _controller.text.trim();
    if (text == ref.read(gameTitleProvider(game.path))) return;
    final restoresDefault = text.isEmpty || text == game.title;
    ref
        .read(userGameInfosProvider.notifier)
        .setName(game.path, restoresDefault ? null : text);
  }

  void _reset() {
    ref.read(userGameInfosProvider.notifier).setName(widget.game.path, null);
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final game = widget.game;
    final theme = Theme.of(context);
    final isEdited = ref.watch(isGameTitleEditedProvider(game.path));
    ref.listen(gameTitleProvider(game.path), (_, next) {
      if (!_focusNode.hasFocus && _controller.text != next) {
        _controller.text = next;
      }
    });
    final style = theme.textTheme.headlineSmall?.copyWith(
      fontWeight: FontWeight.bold,
    );
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            style: style,
            maxLines: null,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: game.title,
              border: InputBorder.none,
              isDense: true,
            ),
            onSubmitted: (_) => _commit(),
          ),
        ),
        if (isEdited)
          IconButton(
            tooltip: context.t.games.resetTitle,
            icon: const Icon(Icons.close),
            onPressed: _reset,
          ),
      ],
    );
  }
}
