import 'abstract_base_option.dart';
import 'option_category.dart';
import 'option_section.dart';

/// One Options item together with where it lives and the stable [id] that identifies it in pins
/// and history. The id is the category id, the section title key and the item title key joined
/// together, so items sharing a title in different sections do not collide.
class OptionEntry {
  const OptionEntry({
    required this.id,
    required this.category,
    required this.section,
    required this.option,
  });

  final String id;
  final OptionCategory category;
  final OptionSection section;
  final AbstractBaseOption option;
}
