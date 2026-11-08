import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';

/// Temporary content for screens that have not been built yet.
///
/// Shows the screen title and optional buttons that open other routes,
/// so that navigation can be tested before the real UI exists.
class ScreenPlaceholder extends StatelessWidget {
  final String title;

  /// Button label -> route name
  final Map<String, String> links;

  const ScreenPlaceholder({
    super.key,
    required this.title,
    this.links = const {},
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // ListView instead of Column so small screens never overflow.
    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        Text(title, style: textTheme.titleLarge, textAlign: TextAlign.center),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'This screen is not built yet.',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        for (final link in links.entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, link.value),
              child: Text(link.key),
            ),
          ),
      ],
    );
  }
}