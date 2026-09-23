import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/system_files_provider.dart';
import '../../i18n/translations.g.dart';
import 'dialogs/artic_base_address_entry_dialog.dart';

class SystemFilesPage extends ConsumerStatefulWidget {
  const SystemFilesPage({super.key});

  @override
  ConsumerState<SystemFilesPage> createState() => _SystemFilesPageState();
}

class _SystemFilesPageState extends ConsumerState<SystemFilesPage> {
  static const _regionLabels = ['JPN', 'USA', 'EUR', 'AUS', 'CHN', 'KOR', 'TWN'];

  SystemFilesService get _service => ref.read(systemFilesProvider);

  bool _consoleLinked = false;
  bool _runSystemSetup = false;
  int _selectedRegion = 0;

  @override
  void initState() {
    super.initState();
    _service.isFullConsoleLinked().then((value) => setState(() => _consoleLinked = value));
    _service.isSystemSetupNeeded().then((value) => setState(() => _runSystemSetup = value));
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
    await _service.launchArticInstall(address: result.address, installO3ds: result.installO3ds);
  }

  Future<void> _confirmDeleteSystemFiles() async {
    final t = context.t;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t.systemFiles.deleteSystemFiles),
        content: Text(t.systemFiles.deleteSystemFilesDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _service.unlinkConsole();
    final linked = await _service.isFullConsoleLinked();
    if (mounted) setState(() => _consoleLinked = linked);
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
          FilledButton(onPressed: _connectSetupTool, child: Text(s.connectSetupTool)),
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
              for (var i = 0; i < _regionLabels.length; i++)
                DropdownMenuItem(value: i, child: Text(_regionLabels[i])),
            ],
            onChanged: (value) => setState(() => _selectedRegion = value ?? 0),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => _service.launchHomeMenu(_selectedRegion),
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
