import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app_services.dart';
import '../../../i18n/translations.g.dart';
import '../../../routing/app_routes.dart';
import '../../setup/widgets/setup_navigation_bar.dart';
import 'profile_draft_provider.dart';

/// The first step of adding a profile: its name, which must not be empty or taken.
class ProfileNamePage extends ConsumerStatefulWidget {
  const ProfileNamePage({super.key});

  @override
  ConsumerState<ProfileNamePage> createState() => _ProfileNamePageState();
}

class _ProfileNamePageState extends ConsumerState<ProfileNamePage> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(profileDraftProvider).name,
  );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final t = context.t;
    final name = _controller.text.trim();
    final String? error;
    if (name.isEmpty) {
      error = t.profiles.create.nameEmpty;
    } else if (await AppServices.profileRepository.nameExists(name)) {
      error = t.profiles.create.nameTaken;
    } else {
      error = null;
    }
    if (!mounted) return;
    setState(() => _error = error);
    if (error != null) return;
    ref.read(profileDraftProvider.notifier).setName(name);
    await const ProfileUserDirectoryRoute().push<void>(context);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.badge, size: 150),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    t.profiles.create.nameTitle,
                    style: textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    t.profiles.create.nameDescription,
                    style: textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: TextField(
                    controller: _controller,
                    autofocus: true,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _confirm(),
                    onChanged: (_) {
                      if (_error != null) setState(() => _error = null);
                    },
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: t.profiles.create.nameHint,
                      errorText: _error,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SetupNavigationBar(
          showBack: false,
          showNext: true,
          onBack: () {},
          onNext: _confirm,
        ),
      ],
    );
  }
}
