import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/options/options_search_provider.dart';
import '../../data/settings/settings_load_provider.dart';
import '../../i18n/translations.g.dart';
import '../../widgets/app_search_bar.dart';
import '../../widgets/gamepad/gamepad_focus_region.dart';
import 'widgets/options_home_content.dart';
import 'widgets/options_search_results.dart';

/// The Options tab: a search bar above either the categories of settings or, once the search bar
/// is used, the search results. The settings themselves are defined as data under
/// `data/options/` and turned into tiles by [OptionsHomeContent] and [OptionsSearchResults].
class OptionsPage extends ConsumerStatefulWidget {
  const OptionsPage({super.key});

  @override
  ConsumerState<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends ConsumerState<OptionsPage> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _handleFocusChanged(bool focused) {
    final notifier = ref.read(optionsSearchProvider.notifier);
    if (focused) {
      notifier.activate();
    } else if (_queryController.text.isEmpty) {
      notifier.deactivate();
    }
  }

  void _handleClear() {
    _queryController.clear();
    ref.read(optionsSearchProvider.notifier).deactivate();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(settingsLoadProvider);
    final isSearching = ref.watch(optionsSearchProvider).isActive;
    return PopScope(
      canPop: !isSearching,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _handleClear();
      },
      child: SafeArea(
        child: Column(
          children: [
            GamepadFocusRegion(
              child: AppSearchBar(
                controller: _queryController,
                hintText: context.t.options.searchHint,
                onChanged: ref.read(optionsSearchProvider.notifier).setQuery,
                onClear: _handleClear,
                onFocusChanged: _handleFocusChanged,
              ),
            ),
            Expanded(
              child: GamepadFocusRegion(
                child: isSearching
                    ? const OptionsSearchResults()
                    : const OptionsHomeContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
