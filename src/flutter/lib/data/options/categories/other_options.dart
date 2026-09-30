import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../../../screens/options/actions/change_legacy_settings_ui_action.dart';
import '../../../screens/options/actions/reset_settings_action.dart';
import '../../settings/options_settings_provider.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';
import '../option_value.dart';

/// The Other category: the legacy UI switch, the debug and advanced pages, About and the reset.
final otherOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'other',
    titleKey: 'options.groups.other',
    sections: [
      OptionSection(
        options: [
          BoolOption(
            titleKey: 'options.useLegacySettingsUI',
            descriptionKey: 'options.useLegacySettingsUIDescription',
            icon: Icons.history_toggle_off,
            value: CallbackOptionValue<bool>(
              onRead: (ref) =>
                  ref.read(optionsSettingsProvider).useLegacySettingsUI,
              onWrite: ChangeLegacySettingsUiAction.run,
            ),
          ),
          const NestedOption(
            titleKey: 'settings.debug.title',
            icon: Icons.code,
            destination: OptionsDebugSettingsRoute(),
          ),
          const NestedOption(
            titleKey: 'options.advanced',
            descriptionKey: 'options.advancedDescription',
            icon: Icons.tune,
            destination: OptionsAdvancedSettingsRoute(),
          ),
          const NestedOption(
            titleKey: 'options.about',
            descriptionKey: 'options.aboutDescription',
            icon: Icons.info_outline,
            destination: AboutRoute(),
          ),
          ActionOption(
            titleKey: 'settings.resetToDefault',
            icon: Icons.restore,
            onTap: ResetSettingsAction.run,
            destructive: true,
          ),
        ],
      ),
    ],
  ),
);
