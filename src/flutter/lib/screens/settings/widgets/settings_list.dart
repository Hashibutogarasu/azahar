import 'package:babstrap_settings_screen/babstrap_settings_screen.dart' as babstrap;
import 'package:flutter/material.dart';
import 'package:gamepads/gamepads.dart';

import '../../../app_services.dart';
import '../../../data/settings/settings_item.dart';
import '../../../data/settings/settings_value_store.dart';
import '../../../errors/app_exception.dart';
import '../../../i18n/translations.g.dart';
import '../../../widgets/app_toggle_switch.dart';
import '../../../widgets/dialog_cancel_button.dart';
import 'settings_group_card.dart';

/// Renders a list of [SettingsItem]s using [SettingsGroupCard]/[babstrap.SettingsItem], so
/// every settings screen shares the same visual design as the redesigned Options page. Items are
/// split into groups at each [SettingsHeaderItem]; a header's title becomes the group's title
/// instead of being rendered as its own row. Reads and writes each item's value through
/// [AppServices.emulatorSettingsRepository] (or the item's own [SettingsValueStore]), saving
/// immediately after every change.
class SettingsList extends StatefulWidget {
  const SettingsList({
    super.key,
    required this.items,
    this.shrinkWrap = false,
    this.padding = const EdgeInsets.all(16),
  });

  final List<SettingsItem> items;

  final bool shrinkWrap;

  final EdgeInsets padding;

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  final _repository = AppServices.emulatorSettingsRepository;

  SettingsValueStore _storeFor(SettingsValueStore? store) => store ?? _repository;

  Future<void> _persist(SettingsValueStore? store) async {
    if ((store ?? _repository) == _repository) {
      await _repository.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    final groups = <(String?, List<SettingsItem>)>[];
    String? currentTitle;
    var currentItems = <SettingsItem>[];
    for (final item in widget.items) {
      if (item is SettingsHeaderItem) {
        if (currentItems.isNotEmpty || currentTitle != null) {
          groups.add((currentTitle, currentItems));
        }
        currentTitle = item.title;
        currentItems = [];
      } else {
        currentItems.add(item);
      }
    }
    if (currentItems.isNotEmpty || currentTitle != null) {
      groups.add((currentTitle, currentItems));
    }

    return ListView(
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      children: [
        for (final group in groups)
          if (group.$2.isNotEmpty)
            SettingsGroupCard(
              settingsGroupTitle: group.$1,
              items: [for (final item in group.$2) _buildItem(context, item)],
            ),
      ],
    );
  }

  babstrap.SettingsItem _buildItem(BuildContext context, SettingsItem item) {
    return switch (item) {
      SettingsHeaderItem() => throw StateError('Headers are consumed while grouping.'),
      SettingsSwitchItem() => babstrap.SettingsItem(
        icons: Icons.toggle_on_outlined,
        title: item.title,
        subtitle: item.description,
        trailing: AppToggleSwitch(
          value: _storeFor(item.store).readBool(item.setting),
          onChanged: (value) async {
            await _storeFor(item.store).writeBool(item.setting, value);
            await _persist(item.store);
            setState(() {});
          },
        ),
      ),
      SettingsSliderItem() => babstrap.SettingsItem(
        icons: Icons.tune,
        title: item.title,
        subtitle: item.description,
        trailing: Text('${_storeFor(item.store).readInt(item.setting)}${item.units}'),
        onTap: () => _showSliderDialog(item),
      ),
      SettingsSingleChoiceItem() => babstrap.SettingsItem(
        icons: Icons.list,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_singleChoiceLabel(item)),
        onTap: () => _showSingleChoiceDialog(item),
      ),
      SettingsFloatSliderItem() => babstrap.SettingsItem(
        icons: Icons.tune,
        title: item.title,
        subtitle: item.description,
        trailing: Text('${_storeFor(item.store).readFloat(item.setting).round()}${item.units}'),
        onTap: () => _showFloatSliderDialog(item),
      ),
      SettingsStringSingleChoiceItem() => babstrap.SettingsItem(
        icons: Icons.list,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_stringSingleChoiceLabel(item)),
        onTap: () => _showStringSingleChoiceDialog(item),
      ),
      SettingsStringInputItem() => babstrap.SettingsItem(
        icons: Icons.edit_outlined,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_storeFor(item.store).readString(item.setting)),
        onTap: () => _showStringInputDialog(item),
      ),
      SettingsDateTimeItem() => babstrap.SettingsItem(
        icons: Icons.schedule,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_dateTimeLabel(item)),
        onTap: () => _showDateTimeDialog(item),
      ),
      SettingsInputBindingItem() => babstrap.SettingsItem(
        icons: Icons.sports_esports_outlined,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_storeFor(item.store).readString(item.setting)),
        onTap: () => _showInputBindingDialog(item),
      ),
      SettingsActionItem() => babstrap.SettingsItem(
        icons: item.icon ?? Icons.chevron_right,
        title: item.title,
        subtitle: item.description,
        trailing: const SizedBox.shrink(),
        onTap: () => item.onTap(context),
      ),
      SettingsSubmenuItem() => babstrap.SettingsItem(
        icons: item.icon ?? Icons.chevron_right,
        title: item.title,
        subtitle: item.description,
        onTap: () => item.onTap(context),
      ),
    };
  }

  String _singleChoiceLabel(SettingsSingleChoiceItem item) {
    final value = _storeFor(item.store).readInt(item.setting);
    final index = item.choiceValues.indexOf(value);
    return index == -1 ? '' : item.choiceLabels[index];
  }

  String _stringSingleChoiceLabel(SettingsStringSingleChoiceItem item) {
    final value = _storeFor(item.store).readString(item.setting);
    final index = item.choiceValues.indexOf(value);
    return index == -1 ? '' : item.choiceLabels[index];
  }

  String _dateTimeLabel(SettingsDateTimeItem item) {
    final raw = _storeFor(item.store).readString(item.setting);
    final seconds = int.tryParse(raw);
    if (seconds == null) return raw;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(seconds * 1000, isUtc: true).toLocal();
    return dateTime.toString();
  }

  Future<void> _showSliderDialog(SettingsSliderItem item) async {
    final store = _storeFor(item.store);
    final initial = store.readInt(item.setting);
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
                const DialogCancelButton(),
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
    await store.writeInt(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showSingleChoiceDialog(SettingsSingleChoiceItem item) async {
    final store = _storeFor(item.store);
    final current = store.readInt(item.setting);
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
    await store.writeInt(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showFloatSliderDialog(SettingsFloatSliderItem item) async {
    final store = _storeFor(item.store);
    final initial = store.readFloat(item.setting).round();
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
                const DialogCancelButton(),
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
    await store.writeFloat(item.setting, result.toDouble());
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showStringSingleChoiceDialog(SettingsStringSingleChoiceItem item) async {
    final store = _storeFor(item.store);
    final current = store.readString(item.setting);
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
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showStringInputDialog(SettingsStringInputItem item) async {
    final store = _storeFor(item.store);
    final localizations = MaterialLocalizations.of(context);
    final textController = TextEditingController(text: store.readString(item.setting));
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item.title),
          content: TextField(controller: textController, maxLength: item.maxLength),
          actions: [
            const DialogCancelButton(),
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
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showDateTimeDialog(SettingsDateTimeItem item) async {
    final store = _storeFor(item.store);
    final raw = store.readString(item.setting);
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
    await store.writeString(
      item.setting,
      (combined.toUtc().millisecondsSinceEpoch ~/ 1000).toString(),
    );
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _showInputBindingDialog(SettingsInputBindingItem item) async {
    final store = _storeFor(item.store);
    final t = context.t;
    final subscription = Gamepads.events
        .where((event) => event.type == KeyType.button && event.value > 0.5)
        .listen(null);
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        subscription.onData((event) {
          if (context.mounted) Navigator.of(context).pop(event.key);
        });
        return AlertDialog(
          title: Text(item.title),
          content: Text(t.settings.inputBindingDialog.waitingForInput),
          actions: [
            const DialogCancelButton(),
          ],
        );
      },
    );
    await subscription.cancel();
    if (result == null) return;
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }
}
