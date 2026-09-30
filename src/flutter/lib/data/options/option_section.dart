import 'package:freezed_annotation/freezed_annotation.dart';

import 'abstract_base_option.dart';
import 'translation_text.dart';

part 'option_section.freezed.dart';

/// A run of Options items shown together. [title] reads its heading from the translations, or is
/// null for a run without one.
@freezed
abstract class OptionSection with _$OptionSection {
  const factory OptionSection({
    TranslationText? title,
    required List<AbstractBaseOption> options,
  }) = _OptionSection;
}
