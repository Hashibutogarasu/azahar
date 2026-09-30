import 'abstract_base_option.dart';
import 'option_category.dart';
import 'option_section.dart';

/// Where an Options item is defined: the id of its category and the positions of its section and
/// of the item inside it. It does not depend on the language in use.
typedef OptionLocation = ({
  String categoryId,
  int sectionIndex,
  int optionIndex,
});

/// One Options item together with where it lives. [location] identifies it, and [id] is the same
/// identity as the text stored for pins and history.
class OptionEntry {
  const OptionEntry({
    required this.location,
    required this.category,
    required this.section,
    required this.option,
  });

  final OptionLocation location;
  final OptionCategory category;
  final OptionSection section;
  final AbstractBaseOption option;

  String get id =>
      '${location.categoryId}/${location.sectionIndex}/${location.optionIndex}';
}
