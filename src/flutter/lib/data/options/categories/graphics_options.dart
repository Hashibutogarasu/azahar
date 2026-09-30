import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/app_routes.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Graphics category: the pages for the renderer, screen layout and camera settings.
final graphicsOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'graphics',
    title: (t) => t.options.groups.graphics,
    sections: [
      OptionSection(
        options: [
          NestedOption(
            title: (t) => t.settings.graphics.title,
            icon: Icons.monitor,
            destination: const OptionsGraphicsSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.settings.layout.title,
            icon: Icons.fit_screen,
            destination: const OptionsLayoutSettingsRoute(),
          ),
          NestedOption(
            title: (t) => t.settings.camera.title,
            icon: Icons.camera_alt,
            destination: const OptionsCameraSettingsRoute(),
          ),
        ],
      ),
    ],
  ),
);
