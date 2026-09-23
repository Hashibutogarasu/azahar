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
      SettingsFloatSliderItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text('${_repository.readFloat(item.setting).round()}${item.units}'),
        onTap: () => _showFloatSliderDialog(item),
      ),
      SettingsStringSingleChoiceItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text(_stringSingleChoiceLabel(item)),
        onTap: () => _showStringSingleChoiceDialog(item),
      ),
      SettingsStringInputItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text(_repository.readString(item.setting)),
        onTap: () => _showStringInputDialog(item),
      ),
      SettingsDateTimeItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        trailing: Text(_dateTimeLabel(item)),
        onTap: () => _showDateTimeDialog(item),
      ),
      SettingsActionItem() => ListTile(
        title: Text(item.title),
        subtitle: item.description == null ? null : Text(item.description!),
        onTap: () => item.onTap(context),
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

  String _stringSingleChoiceLabel(SettingsStringSingleChoiceItem item) {
    final value = _repository.readString(item.setting);
    final index = item.choiceValues.indexOf(value);
    return index == -1 ? '' : item.choiceLabels[index];
  }

  String _dateTimeLabel(SettingsDateTimeItem item) {
    final raw = _repository.readString(item.setting);
    final seconds = int.tryParse(raw);
    if (seconds == null) return raw;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
    return dateTime.toString();
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

  Future<void> _showFloatSliderDialog(SettingsFloatSliderItem item) async {
    final initial = _repository.readFloat(item.setting).round();
    var sliderValue = initial;
    var pendingText = initial.toString();
    final t = context.t;
    final localizations = MaterialLocalizations.of(context);
    final textController = TextEditingController(text: pendingText);
    final min = item.min.round();
    final max = item.max.round();
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
                      if (parsed != null && parsed >= min && parsed <= max) {
                        setDialogState(() => sliderValue = parsed);
                      }
                    },
                  ),
                  Slider(
                    value: sliderValue.toDouble(),
                    min: min.toDouble(),
                    max: max.toDouble(),
                    divisions: max - min,
                    label: '$sliderValue${item.units}',
                    onChanged: (newValue) {
                      setDialogState(() => applySliderValue(newValue.round()));
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => setDialogState(
                    () => applySliderValue(item.setting.defaultValue.round()),
                  ),
                  child: Text(t.settings.sliderDialog.kDefault),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(localizations.cancelButtonLabel),
                ),
                TextButton(
                  onPressed: () {
                    final parsed = int.tryParse(pendingText);
                    if (parsed == null || parsed < min || parsed > max) {
                      throw InvalidSettingValueException(
                        t.settings.sliderDialog.invalidValue(
                          title: item.title,
                          min: min,
                          max: max,
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
    await _repository.writeFloat(item.setting, result.toDouble());
    setState(() {});
  }

  Future<void> _showStringSingleChoiceDialog(SettingsStringSingleChoiceItem item) async {
    final current = _repository.readString(item.setting);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text(item.title),
          children: [
            RadioGroup<String>(
              groupValue: current,
              onChanged: (value) => Navigator.of(context).pop(value),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < item.choiceValues.length; i++)
                    RadioListTile<String>(
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
    await _repository.writeString(item.setting, result);
    setState(() {});
  }

  Future<void> _showStringInputDialog(SettingsStringInputItem item) async {
    final localizations = MaterialLocalizations.of(context);
    final textController = TextEditingController(text: _repository.readString(item.setting));
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: TextField(controller: textController, maxLength: item.maxLength),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancelButtonLabel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(textController.text),
              child: Text(localizations.okButtonLabel),
            ),
          ],
        );
      },
    );
    textController.dispose();
    if (result == null) return;
    await _repository.writeString(item.setting, result);
    setState(() {});
  }

  Future<void> _showDateTimeDialog(SettingsDateTimeItem item) async {
    final raw = _repository.readString(item.setting);
    final seconds = int.tryParse(raw);
    final initial = seconds == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    await _repository.writeString(
      item.setting,
      (combined.toUtc().millisecondsSinceEpoch ~/ 1000).toString(),
    );
    setState(() {});
  }
}
