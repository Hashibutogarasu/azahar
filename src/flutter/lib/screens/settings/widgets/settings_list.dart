import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/settings_item.dart';
import '../../../errors/app_exception.dart';
import '../../../i18n/translations.g.dart';

/// Renders a list of [SettingsItem]s using standard Material widgets, reading and writing each
/// item's value through [AppServices.emulatorSettingsRepository].
class SettingsList extends StatefulWidget {
  const SettingsList({super.key, required this.items});

  final List<SettingsItem> items;

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  final _repository = AppServices.emulatorSettingsRepository;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (context, index) => _buildItem(context, widget.items[index]),
    );
  }

  Widget _buildItem(BuildContext context, SettingsItem item) {
    return switch (item) {
      SettingsHeaderItem() => ListTile(
        title: Text(item.title, style: Theme.of(context).textTheme.labelLarge),
        subtitle: item.description == null ? null : Text(item.description!),
        enabled: false,
      ),
      SettingsSwitchItem() => SwitchListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        value: _repository.readBool(item.setting),
        onChanged: (value) async {
          await _repository.writeBool(item.setting, value);
          setState(() {});
        },
      ),
      SettingsSliderItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text('${_repository.readInt(item.setting)}${item.units}'),
        onTap: () => _showSliderDialog(item),
      ),
      SettingsSingleChoiceItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text(_singleChoiceLabel(item)),
        onTap: () => _showSingleChoiceDialog(item),
      ),
      SettingsSubmenuItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => item.onTap(context),
      ),
    };
  }

  String _singleChoiceLabel(SettingsSingleChoiceItem item) {
    final value = _repository.readInt(item.setting);
    final index = item.choiceValues.indexOf(value);
    return index == -1 ? '' : item.choiceLabels[index];
  }

  Future<void> _showSliderDialog(SettingsSliderItem item) async {
    final initial = _repository.readInt(item.setting);
    var sliderValue = initial;
    var pendingText = initial.toString();
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    final textController = TextEditingController(text: pendingText);
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            void applySliderValue(int newValue) {
              sliderValue = newValue;
              pendingText = newValue.toString();
              textController.value = TextEditingValue(
                text: pendingText,
                selection: TextSelection.collapsed(offset: pendingText.length),
              );
            }

            return AlertDialog(
              title: Text(item.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: textController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(suffixText: item.units),
                    onChanged: (text) {
                      pendingText = text;
                      final parsed = int.tryParse(text);
                      if (parsed != null && parsed >= item.min && parsed <= item.max) {
                        setDialogState(() => sliderValue = parsed);
                      }
                    },
                  ),
                  Slider(
                    value: sliderValue.toDouble(),
                    min: item.min.toDouble(),
                    max: item.max.toDouble(),
                    divisions: item.max - item.min,
                    label: '$sliderValue${item.units}',
                    onChanged: (newValue) {
                      setDialogState(() => applySliderValue(newValue.round()));
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () =>
                      setDialogState(() => applySliderValue(item.setting.defaultValue)),
                  child: Text(t.settings.sliderDialog.kDefault),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    final parsed = int.tryParse(pendingText);
                    if (parsed == null || parsed < item.min || parsed > item.max) {
                      throw InvalidSettingValueException(
                        t.settings.sliderDialog.invalidValue(
                          title: item.title,
                          min: item.min,
                          max: item.max,
                        ),
                      );
                    }
                    Navigator.of(context).pop(parsed);
                  },
                  child: Text(localizations.okButtonLabel),
                ),
              ],
            );
          },
        );
      },
    );
    textController.dispose();
    if (result == null) return;
    await _repository.writeInt(item.setting, result);
    setState(() {});
  }

  Future<void> _showSingleChoiceDialog(SettingsSingleChoiceItem item) async {
    final current = _repository.readInt(item.setting);
    final result = await showDialog<int>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(item.title),
          children: [
            RadioGroup<int>(
              groupValue: current,
              onChanged: (value) => Navigator.of(context).pop(value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < item.choiceValues.length; i++)
                    RadioListTile<int>(
                      title: Text(item.choiceLabels[i]),
                      value: item.choiceValues[i],
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
    if (result == null) return;
    await _repository.writeInt(item.setting, result);
    setState(() {});
  }
}
