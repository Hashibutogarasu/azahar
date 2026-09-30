import 'package:flutter/material.dart';

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
  }) : assert(icon != null || imageAsset != null),
       assert(actions.length > 0);

  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String description;
  final List<SetupAction> actions;

  bool get isCompleted => actions.every((action) => action.isCompleted);
}
