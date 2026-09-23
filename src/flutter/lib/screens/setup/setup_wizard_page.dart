import 'dart:async';

import 'package:flutter/material.dart';

import '../../app_services.dart';
import '../../i18n/translations.g.dart';
import '../../routing/app_routes.dart';
import 'dialogs/citra_directory_dialog.dart';
import 'dialogs/copy_dir_progress_dialog.dart';
import 'dialogs/message_dialog.dart';
import 'dialogs/setup_warning_dialog.dart';
import 'setup_step.dart';
import 'setup_wizard_view_model.dart';
import 'widgets/setup_navigation_bar.dart';
import 'widgets/setup_step_view.dart';

class SetupWizardPage extends StatefulWidget {
  const SetupWizardPage({super.key});

  @override
  State<SetupWizardPage> createState() => _SetupWizardPageState();
}

class _SetupWizardPageState extends State<SetupWizardPage> {
  final _pageController = PageController();
  final SetupWizardViewModel _viewModel =
      SetupWizardViewModel(AppServices.nativeBridge, AppServices.settingsRepository);
  final Set<int> _hasBeenWarned = {};
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onViewModelChanged);
    _viewModel.refreshCompletionState();
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();
    super.dispose();
  }

  void _onViewModelChanged() => setState(() {});

  List<SetupStep> _steps(Translations t) {
    return [
      SetupStep(
        imageAsset: 'assets/images/azahar_logo.png',
        title: t.setup.welcome.title,
        description: t.setup.welcome.description,
        actionLabel: t.setup.welcome.getStarted,
        isCompleted: false,
        performAction: (_) async {
          await _advanceTo(1);
          return false;
        },
      ),
      SetupStep(
        icon: Icons.notifications,
        title: t.setup.notifications.title,
        description: t.setup.notifications.description,
        actionLabel: t.setup.notifications.givePermission,
        hasWarning: true,
        warningTitle: t.setup.notifications.warningTitle,
        warningDescription: t.setup.notifications.warningDescription,
        isCompleted: _viewModel.notificationsCompleted,
        performAction: (_) => _viewModel.requestNotificationPermission(),
      ),
      SetupStep(
        icon: Icons.mic,
        title: t.setup.microphone.title,
        description: t.setup.microphone.description,
        actionLabel: t.setup.microphone.givePermission,
        isCompleted: _viewModel.microphoneCompleted,
        performAction: (_) => _viewModel.requestMicrophonePermission(),
      ),
      SetupStep(
        icon: Icons.camera_alt,
        title: t.setup.camera.title,
        description: t.setup.camera.description,
        actionLabel: t.setup.camera.givePermission,
        isCompleted: _viewModel.cameraCompleted,
        performAction: (_) => _viewModel.requestCameraPermission(),
      ),
      SetupStep(
        icon: Icons.folder_open,
        title: t.setup.userDirectory.title,
        description: t.setup.userDirectory.description,
        actionLabel: t.setup.userDirectory.select,
        isUnskippable: true,
        hasWarning: true,
        warningTitle: t.setup.userDirectory.warningTitle,
        warningDescription: t.setup.userDirectory.warningDescription,
        warningHelpUrl: t.setup.userDirectory.warningHelpUrl,
        isCompleted: _viewModel.userDirectoryCompleted,
        performAction: (context) => _performUserDirectorySelection(context),
      ),
      SetupStep(
        icon: Icons.sports_esports,
        title: t.setup.gamesDirectory.title,
        description: t.setup.gamesDirectory.description,
        actionLabel: t.setup.gamesDirectory.select,
        hasWarning: true,
        warningTitle: t.setup.gamesDirectory.warningTitle,
        warningDescription: t.setup.gamesDirectory.warningDescription,
        warningHelpUrl: t.setup.gamesDirectory.warningHelpUrl,
        isCompleted: _viewModel.gamesDirectoryCompleted,
        performAction: (_) async {
          final uri = await _viewModel.pickGamesDirectory();
          if (uri == null) return false;
          return _viewModel.confirmGamesDirectory(uri);
        },
      ),
      SetupStep(
        icon: Icons.check_circle,
        title: t.setup.done.title,
        description: t.setup.done.description,
        actionLabel: t.setup.done.continueLabel,
        buttonIcon: Icons.arrow_forward,
        isCompleted: false,
        performAction: (context) async {
          await _viewModel.completeSetup();
          if (context.mounted) {
            const GamesListRoute().go(context);
          }
          return false;
        },
      ),
    ];
  }

  Future<void> _advanceTo(int page) {
    return _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onNextPressed(List<SetupStep> steps) async {
    final index = _currentPage;
    final step = steps[index];

    if ((step.hasWarning || step.isUnskippable) && !step.isCompleted) {
      if (step.isUnskippable) {
        await MessageDialog.show(
          context,
          title: step.warningTitle!,
          description: step.warningDescription,
          helpUrl: step.warningHelpUrl,
        );
        return;
      }
      if (!_hasBeenWarned.contains(index)) {
        final shouldSkip = await SetupWarningDialog.show(
          context,
          title: step.warningTitle!,
          description: step.warningDescription!,
          helpUrl: step.warningHelpUrl,
        );
        if (shouldSkip == true) {
          setState(() => _hasBeenWarned.add(index));
          await _advanceTo(index + 1);
        }
        return;
      }
    }
    await _advanceTo(index + 1);
  }

  Future<bool> _performUserDirectorySelection(BuildContext context) async {
    final previousUri = await _viewModel.previousUserDirectory();
    final pickedUri = await _viewModel.pickUserDirectory();
    if (pickedUri == null) return false;
    if (!context.mounted) return false;

    final moveData = await CitraDirectoryDialog.show(
      context,
      path: pickedUri,
      showMoveDataCheckbox: previousUri != null && previousUri != pickedUri,
    );
    if (moveData == null) return false;

    final confirmFuture = _viewModel.confirmUserDirectory(
      uri: pickedUri,
      previousUri: previousUri,
      moveData: moveData,
    );
    if (!moveData) {
      return confirmFuture;
    }

    if (!context.mounted) return false;
    unawaited(
      CopyDirProgressDialog.show(context, progressStream: _viewModel.copyDirProgress()),
    );
    final completed = await confirmFuture;
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
    return completed;
  }

  @override
  Widget build(BuildContext context) {
    if (!_viewModel.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final steps = _steps(context.t);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: steps.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  return SetupStepView(
                    step: steps[index],
                    onAction: () => steps[index].performAction(context),
                  );
                },
              ),
            ),
            SetupNavigationBar(
              showBack: _currentPage > 0,
              showNext: _currentPage >= 1 && _currentPage <= steps.length - 2,
              onBack: () => _advanceTo(_currentPage - 1),
              onNext: () => _onNextPressed(steps),
            ),
          ],
        ),
      ),
    );
  }
}
