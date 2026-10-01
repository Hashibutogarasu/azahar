import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../options/translation_text.dart';

/// What every feature flag has in common: its [title], an optional [description] and [icon], and how
/// it is read and switched.
///
/// The [id] tells the flags of the list apart, so a switch can find its flag there. The title and
/// description are [TranslationText] functions, applied to the current locale when the flag is
/// shown.
abstract class FeatureFlag {
  const FeatureFlag({
    required this.id,
    required this.title,
    this.description,
    this.icon,
  });

  final String id;

  final TranslationText title;

  final TranslationText? description;

  final IconData? icon;

  /// Whether the flag is on. It is called while building a widget, so an implementation backed by
  /// a Riverpod provider can watch it.
  bool read(WidgetRef ref);

  /// Turns the flag on or off, and keeps the choice.
  Future<void> switchTo(WidgetRef ref, bool value);
}
