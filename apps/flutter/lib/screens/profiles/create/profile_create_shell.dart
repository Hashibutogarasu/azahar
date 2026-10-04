import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../i18n/translations.g.dart';
import '../../../widgets/busy_pop_scope.dart';
import 'profile_draft_provider.dart';

/// The layout shared by the pages for adding a profile. It keeps [profileDraftProvider] alive
/// while the steps are shown, and the back button of its app bar leaves all of them.
class ProfileCreateShell extends ConsumerWidget {
  const ProfileCreateShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(profileDraftProvider);
    return BusyPopScope(
      child: Scaffold(
        appBar: AppBar(
          leading: busyBackButtonFor(context),
          title: Text(context.t.profiles.create.title),
        ),
        body: SafeArea(child: child),
      ),
    );
  }
}
