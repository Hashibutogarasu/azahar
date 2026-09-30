import 'package:freezed_annotation/freezed_annotation.dart';

import 'abstract_base_option.dart';

part 'option_section.freezed.dart';

/// A run of Options items shown together. [titleKey] is the translation key of its heading, or
/// null for a run without one.
@freezed
abstract class OptionSection with _$OptionSection {
  const factory OptionSection({
    String? titleKey,
    required List<AbstractBaseOption> options,
  }) = _OptionSection;
}
