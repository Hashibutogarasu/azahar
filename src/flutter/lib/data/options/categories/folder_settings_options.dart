import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../screens/options/actions/select_games_folder_action.dart';
import '../../../screens/options/actions/select_user_folder_action.dart';
import '../abstract_base_option.dart';
import '../option_category.dart';
import '../option_section.dart';

/// The Folder Settings category: choosing the user folder and the games folder.
final folderSettingsOptionsProvider = Provider<OptionCategory>(
  (ref) => OptionCategory(
    id: 'folderSettings',
    titleKey: 'options.groups.folderSettings',
    sections: [
      OptionSection(
        options: [
          ActionOption(
            titleKey: 'options.selectUserFolder',
            descriptionKey: 'options.selectUserFolderDescription',
            icon: Icons.folder_outlined,
            onTap: SelectUserFolderAction.run,
          ),
          ActionOption(
            titleKey: 'options.selectGamesFolder',
            descriptionKey: 'options.selectGamesFolderDescription',
            icon: Icons.videogame_asset_outlined,
            onTap: SelectGamesFolderAction.run,
          ),
        ],
      ),
    ],
  ),
);
