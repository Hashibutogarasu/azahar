import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Graphics category: the pages for the renderer, screen layout and camera settings.
final graphicsOptionsProvider = Provider<OptionCategory>(
  (ref) => const OptionCategory(
    id: 'graphics',
    titleKey: 'options.groups.graphics',
    sections: [
      OptionSection(
        options: [
          NestedOption(
            titleKey: 'settings.graphics.title',
            icon: Icons.monitor,
            destination: OptionsGraphicsSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'settings.layout.title',
            icon: Icons.fit_screen,
            destination: OptionsLayoutSettingsRoute(),
          ),
          NestedOption(
            titleKey: 'settings.camera.title',
            icon: Icons.camera_alt,
            destination: OptionsCameraSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
