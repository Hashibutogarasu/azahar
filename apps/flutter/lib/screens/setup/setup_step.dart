import 'package:flutter/material.dart';

import '../../i18n/translations.g.dart';

class SetupAction {
  const SetupAction({
    required this.icon,
    required this.label,
    required this.performAction,
    required this.isCompleted,
    this.isUnskippable = false,
    this.hasWarning = false,
    this.warningTitle,
    this.warningDescription,
    this.warningHelpUrl,
  });

  final IconData icon;
  final String label;
  final Future<bool> Function(BuildContext context) performAction;
  final bool isCompleted;
  final bool isUnskippable;
  final bool hasWarning;
  final String? warningTitle;
  final String? warningDescription;
  final String? warningHelpUrl;
}

class SetupStep {
  const SetupStep({
    this.icon,
    this.imageAsset,
    required this.title,
    required this.description,
    required this.actions,
    this.nextLabel,
  }) : assert(icon != null || imageAsset != null),
       assert(actions.length > 0);

  /// The step for choosing the user folder and the games folder. The setup wizard and the pages
  /// for adding a profile both use it, so choosing the folders looks and works the same in both.
  factory SetupStep.dataFolders(
    Translations t, {
    required bool userDirectoryCompleted,
    required bool gamesDirectoryCompleted,
    required Future<bool> Function(BuildContext context) selectUserDirectory,
    required Future<bool> Function(BuildContext context) selectGamesDirectory,
    String? nextLabel,
  }) {
    return SetupStep(
      icon: Icons.folder_open,
      title: t.setup.dataFolders.title,
      description: t.setup.dataFolders.description,
      nextLabel: nextLabel,
      actions: [
        SetupAction(
          icon: Icons.home,
          label: t.setup.userDirectory.title,
          isCompleted: userDirectoryCompleted,
          performAction: selectUserDirectory,
        ),
        SetupAction(
          icon: Icons.sports_esports,
          label: t.setup.gamesDirectory.title,
          isCompleted: gamesDirectoryCompleted,
          performAction: selectGamesDirectory,
        ),
      ],
    );
  }

  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String description;
  final List<SetupAction> actions;
  final String? nextLabel;

  bool get isCompleted => actions.every((action) => action.isCompleted);
}
