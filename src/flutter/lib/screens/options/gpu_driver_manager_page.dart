import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/settings/gpu_driver_provider.dart';
import '../../i18n/translations.g.dart';
import '../../models/gpu_driver_info.dart';

class GpuDriverManagerPage extends ConsumerStatefulWidget {
  const GpuDriverManagerPage({super.key});

  @override
  ConsumerState<GpuDriverManagerPage> createState() => _GpuDriverManagerPageState();
}

class _GpuDriverManagerPageState extends ConsumerState<GpuDriverManagerPage> {
  late Future<(List<GpuDriverInfo>, String?)> _loaded = _load();

  GpuDriverService get _service => ref.read(gpuDriverProvider);

  Future<(List<GpuDriverInfo>, String?)> _load() async {
    final drivers = await _service.listDrivers();
    final selected = await _service.selectedDriverName();
    return (drivers, selected);
  }

  Future<void> _installDriver() async {
    final t = context.t;
    final result = await FilePicker.pickFile(type: FileType.custom, allowedExtensions: ['zip']);
    final path = result?.path;
    if (path == null) return;
    final success = await _service.installDriver(path);
    if (!success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.gpuDriverManager.installFailed)));
    }
    setState(() => _loaded = _load());
  }

  Future<void> _selectDriver(String uri) async {
    await _service.selectDriver(uri.isEmpty ? null : uri);
    setState(() => _loaded = _load());
  }

  @override
  Widget build(BuildContext context) {
    final t = context.t;
    return Scaffold(
      appBar: AppBar(title: Text(t.gpuDriverManager.title)),
      body: FutureBuilder<(List<GpuDriverInfo>, String?)>(
        future: _loaded,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final (drivers, selected) = snapshot.data!;
          return RadioGroup<String>(
            groupValue: selected == null ? '' : (drivers.firstWhere(
                  (d) => d.name == selected,
                  orElse: () => const GpuDriverInfo(uri: ''),
                ).uri),
            onChanged: (value) {
              if (value != null) _selectDriver(value);
            },
            child: ListView(
              children: [
                ListTile(
                  title: Text(t.gpuDriverManager.installDriver),
                  subtitle: Text(t.gpuDriverManager.installDriverDescription),
                  trailing: const Icon(Icons.file_open_outlined),
                  onTap: _installDriver,
                ),
                const Divider(),
                RadioListTile<String>(
                  title: Text(t.gpuDriverManager.systemDriver),
                  value: '',
                ),
                for (final driver in drivers.where((d) => d.uri.isNotEmpty))
                  RadioListTile<String>(
                    title: Text(driver.name ?? driver.uri),
                    subtitle: driver.version == null ? null : Text(driver.version!),
                    value: driver.uri,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
