import 'package:freezed_annotation/freezed_annotation.dart';

import 'option_entry.dart';
import 'option_section.dart';

part 'option_category.freezed.dart';

/// A named group of Options items. [id] is stable across releases and is only used to build the
/// ids of its items; [titleKey] is the translation key of its title.
@freezed
abstract class OptionCategory with _$OptionCategory {
  const OptionCategory._();

  const factory OptionCategory({
    required String id,
    required String titleKey,
    required List<OptionSection> sections,
  }) = _OptionCategory;

  /// Every item of this category with the id that identifies it in pins and history.
  List<OptionEntry> get entries => [
    for (final section in sections)
      for (final option in section.options)
        OptionEntry(
          id: '$id|${section.titleKey ?? ''}|${option.titleKey}',
          category: this,
          section: section,
          option: option,
        ),
  ];
}
