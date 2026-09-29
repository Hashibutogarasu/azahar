import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/system_files_provider.dart';
import '../../i18n/translations.g.dart';
import '../../widgets/confirmation_dialog.dart';
import 'dialogs/artic_base_address_entry_dialog.dart';

class SystemFilesPage extends ConsumerStatefulWidget {
  const SystemFilesPage({super.key});

  @override
  ConsumerState<SystemFilesPage> createState() => _SystemFilesPageState();
}

class _SystemFilesPageState extends ConsumerState<SystemFilesPage> {
  static const _regionLabels = [
    'JPN',
    'USA',
    'EUR',
    'AUS',
    'CHN',
    'KOR',
    'TWN',
  ];

  SystemFilesService get _service => ref.read(systemFilesProvider);

  bool _consoleLinked = false;
  bool _runSystemSetup = false;
  int? _selectedRegion;

  Map<int, String> _homeMenuPaths = {};

  @override
  void initState() {
    super.initState();
    _service.isFullConsoleLinked().then(
      (value) => setState(() => _consoleLinked = value),
    );
    _service.isSystemSetupNeeded().then(
      (value) => setState(() => _runSystemSetup = value),
    );
    _loadHomeMenuPaths();
  }

  Future<void> _loadHomeMenuPaths() async {
    final paths = <int, String>{};
    for (var i = 0; i < _regionLabels.length; i++) {
      final path = await _service.getHomeMenuPath(i);
      if (path.isNotEmpty) paths[i] = path;
    }
    if (!mounted) return;
    setState(() {
      _homeMenuPaths = paths;
      _selectedRegion = paths.keys.isEmpty ? null : paths.keys.first;
    });
  }

  Future<void> _connectSetupTool() async {
    final t = context.t;
    final navigator = Navigator.of(context);
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(t.systemFiles.title),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(t.systemFiles.detecting)),
            ],
          ),
        ),
      ),
    );
    final installed = await _service.areSystemTitlesInstalled();
    navigator.pop();
    if (!mounted) return;

    final result = await ArticBaseAddressEntryDialog.show(
      context,
      o3dsInstalled: installed[0],
      n3dsInstalled: installed[1],
    );
    if (result == null) return;

    if (!mounted) return;
    unawaited(
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: Text(t.systemFiles.title),
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(t.systemFiles.preparing)),
            ],
          ),
        ),
      ),
    );
    await _service.installSystemFiles(result.installO3ds);
    if (mounted) Navigator.of(context, rootNavigator: true).pop();
    final linked = await _service.isFullConsoleLinked();
    if (mounted) setState(() => _consoleLinked = linked);
    unawaited(_loadHomeMenuPaths());
    await _service.launchArticInstall(
      address: result.address,
      installO3ds: result.installO3ds,
    );
  }

  Future<void> _confirmDeleteSystemFiles() async {
    final t = context.t;
    final confirmed = await ConfirmationDialog.show(
      context,
      title: t.systemFiles.deleteSystemFiles,
      message: t.systemFiles.deleteSystemFilesDescription,
      confirmLabel: MaterialLocalizations.of(context).okButtonLabel,
    );
    if (!confirmed) return;
    await _service.unlinkConsole();
    final linked = await _service.isFullConsoleLinked();
    if (mounted) setState(() => _consoleLinked = linked);
    unawaited(_loadHomeMenuPaths());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    final s = t.systemFiles;
    return Scaffold(
      appBar: AppBar(title: Text(s.title)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          Text(s.preamble),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _connectSetupTool,
            child: Text(s.connectSetupTool),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _consoleLinked ? _confirmDeleteSystemFiles : null,
            child: Text(s.deleteSystemFiles),
          ),
          const Divider(height: 32),
          Text(s.bootHomeMenu, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _selectedRegion,
            items: [
              for (final i in _homeMenuPaths.keys)
                DropdownMenuItem(value: i, child: Text(_regionLabels[i])),
            ],
            onChanged: _homeMenuPaths.isEmpty
                ? null
                : (value) => setState(() => _selectedRegion = value),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _selectedRegion == null
                ? null
                : () => _service.launchHomeMenu(_selectedRegion!),
            child: Text(s.start),
          ),
          SwitchListTile(
            title: Text(s.runSystemSetup),
            value: _runSystemSetup,
            onChanged: (value) {
              setState(() => _runSystemSetup = value);
              _service.setSystemSetupNeeded(value);
            },
          ),
        ],
      ),
    );
  }
}
