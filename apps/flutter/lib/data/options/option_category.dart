import 'package:freezed_annotation/freezed_annotation.dart';

import 'option_entry.dart';
import 'option_section.dart';
import 'translation_text.dart';

part 'option_category.freezed.dart';

/// A named group of Options items. [id] is stable across releases and is only used to identify
/// its items; [title] reads its title from the translations. When [excludeFromHistory] is true,
/// using its items is not recorded in the history.
@freezed
abstract class OptionCategory with _$OptionCategory {
  const OptionCategory._();

  const factory OptionCategory({
    required String id,
    required TranslationText title,
    required List<OptionSection> sections,
    @Default(false) bool excludeFromHistory,
  }) = _OptionCategory;

  /// Every item of this category with the location that identifies it in pins and history.
  List<OptionEntry> get entries => [
    for (final (sectionIndex, section) in sections.indexed)
      for (final (optionIndex, option) in section.options.indexed)
        OptionEntry(
          location: (
            categoryId: id,
            sectionIndex: sectionIndex,
            optionIndex: optionIndex,
          ),
          category: this,
          section: section,
          option: option,
        ),
  ];
}
