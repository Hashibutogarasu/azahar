part of '../abstract_base_option.dart';

/// An item that leads to another page. It has no value of its own; tapping it pushes
/// [destination].
@freezed
abstract class NestedOption with _$NestedOption implements AbstractBaseOption {
  const NestedOption._();

  const factory NestedOption({
    required String titleKey,
    String? descriptionKey,
    required IconData icon,
    required GoRouteData destination,
  }) = _NestedOption;

  @override
  Widget toWidget({
    required VoidCallback onAccessed,
    required VoidCallback onLongPress,
  }) => NestedOptionTile(
    option: this,
    onAccessed: onAccessed,
    onLongPress: onLongPress,
  );
}
