part of '../abstract_base_option.dart';

/// An item that runs [onTap] when pressed. It has no value of its own. A [destructive] action is
/// shown in the error color.
@freezed
abstract class ActionOption with _$ActionOption implements AbstractBaseOption {
  const ActionOption._();

  const factory ActionOption({
    required TranslationText title,
    TranslationText? description,
    required IconData icon,
    required Future<void> Function(BuildContext context, WidgetRef ref) onTap,
    @Default(false) bool destructive,
  }) = _ActionOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => ActionOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
