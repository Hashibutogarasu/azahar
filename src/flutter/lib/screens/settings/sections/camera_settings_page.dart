import 'package:flutter/material.dart';

import '../../../data/options/categories/camera_page_options.dart';
import '../../options/option_category_page.dart';

class CameraSettingsPage extends StatelessWidget {
  const CameraSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return OptionCategoryPage(provider: cameraPageOptionsProvider);
  }
}
