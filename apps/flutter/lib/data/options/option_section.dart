import 'package:flutter_riverpod/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'abstract_base_option.dart';
import 'translation_text.dart';

part 'option_section.freezed.dart';

/// A run of Options items shown together. [title] reads its heading from the translations, or is
/// null for a run without one.
///
/// While [disabledWhen] is true the whole section is shown disabled and cannot be used, so an
/// operation that changes what the section shows can finish before the section is used again.
@freezed
abstract class OptionSection with _$OptionSection {
  const factory OptionSection({
    TranslationText? title,
    required List<AbstractBaseOption> options,
    ProviderListenable<bool>? disabledWhen,
  }) = _OptionSection;
}
