import 'package:flutter/material.dart';

class SetupStep {
  const SetupStep({
    this.icon,
    this.imageAsset,
    required this.title,
    required this.description,
    required this.actionLabel,
    required this.performAction,
    this.buttonIcon,
    this.isUnskippable = false,
    this.hasWarning = false,
    required this.isCompleted,
    this.warningTitle,
    this.warningDescription,
    this.warningHelpUrl,
  }) : assert(icon != null || imageAsset != null);

  final IconData? icon;
  final String? imageAsset;
  final String title;
  final String description;
  final String actionLabel;
  final IconData? buttonIcon;
  final Future<bool> Function(BuildContext context) performAction;
  final bool isUnskippable;
  final bool hasWarning;
  final bool isCompleted;
  final String? warningTitle;
  final String? warningDescription;
  final String? warningHelpUrl;
}
