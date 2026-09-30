import 'package:flutter/material.dart';

/// A titled group of [EmulationMenuItem]s. When [iconsOnly] is set the title is replaced by a
/// divider.
class EmulationMenuSection extends StatelessWidget {
  const EmulationMenuSection({
    super.key,
    required this.title,
    required this.children,
    this.iconsOnly = false,
  });

  final String title;
  final List<Widget> children;
  final bool iconsOnly;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (iconsOnly)
          const Divider(height: 16)
        else
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              title,
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}
