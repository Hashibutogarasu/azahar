import 'package:babstrap_settings_screen/babstrap_settings_screen.dart'
    as babstrap;
import 'package:flutter/material.dart';

import '../../../app_services.dart';
import '../../../data/settings/settings_item.dart';
import '../../../data/settings/settings_value_store.dart';
import '../dialogs/choice_dialog.dart';
import '../dialogs/date_time_picker.dart';
import '../dialogs/input_binding_dialog.dart';
import '../dialogs/slider_value_dialog.dart';
import '../dialogs/text_input_dialog.dart';
import 'settings_group_card.dart';
import 'toggle_settings_item.dart';

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

  SettingsValueStore _storeFor(SettingsValueStore? store) =>
      store ?? _repository;

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
      SettingsHeaderItem() => throw StateError(
        'Headers are consumed while grouping.',
      ),
      SettingsSwitchItem() => ToggleSettingsItem(
        icon: Icons.toggle_on_outlined,
        title: item.title,
        subtitle: item.description,
        value: _storeFor(item.store).readBool(item.setting),
        onChanged: (value) async {
          await _storeFor(item.store).writeBool(item.setting, value);
          await _persist(item.store);
          setState(() {});
        },
      ),
      SettingsSliderItem() => babstrap.SettingsItem(
        icons: Icons.tune,
        title: item.title,
        subtitle: item.description,
        trailing: Text(
          '${_storeFor(item.store).readInt(item.setting)}${item.units}',
        ),
        onTap: () => _editSlider(item),
      ),
      SettingsSingleChoiceItem() => babstrap.SettingsItem(
        icons: Icons.list,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_singleChoiceLabel(item)),
        onTap: () => _editSingleChoice(item),
      ),
      SettingsFloatSliderItem() => babstrap.SettingsItem(
        icons: Icons.tune,
        title: item.title,
        subtitle: item.description,
        trailing: Text(
          '${_storeFor(item.store).readFloat(item.setting).round()}${item.units}',
        ),
        onTap: () => _editFloatSlider(item),
      ),
      SettingsStringSingleChoiceItem() => babstrap.SettingsItem(
        icons: Icons.list,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_stringSingleChoiceLabel(item)),
        onTap: () => _editStringSingleChoice(item),
      ),
      SettingsStringInputItem() => babstrap.SettingsItem(
        icons: Icons.edit_outlined,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_storeFor(item.store).readString(item.setting)),
        onTap: () => _editStringInput(item),
      ),
      SettingsDateTimeItem() => babstrap.SettingsItem(
        icons: Icons.schedule,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_dateTimeLabel(item)),
        onTap: () => _editDateTime(item),
      ),
      SettingsInputBindingItem() => babstrap.SettingsItem(
        icons: Icons.sports_esports_outlined,
        title: item.title,
        subtitle: item.description,
        trailing: Text(_storeFor(item.store).readString(item.setting)),
        onTap: () => _editInputBinding(item),
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
    final dateTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    ).toLocal();
    return dateTime.toString();
  }

  Future<void> _editSlider(SettingsSliderItem item) async {
    final store = _storeFor(item.store);
    final result = await SliderValueDialog.show(
      context,
      title: item.title,
      min: item.min,
      max: item.max,
      units: item.units,
      initialValue: store.readInt(item.setting),
      defaultValue: item.setting.defaultValue,
    );
    if (result == null) return;
    await store.writeInt(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editFloatSlider(SettingsFloatSliderItem item) async {
    final store = _storeFor(item.store);
    final result = await SliderValueDialog.show(
      context,
      title: item.title,
      min: item.min.round(),
      max: item.max.round(),
      units: item.units,
      initialValue: store.readFloat(item.setting).round(),
      defaultValue: item.setting.defaultValue.round(),
    );
    if (result == null) return;
    await store.writeFloat(item.setting, result.toDouble());
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editSingleChoice(SettingsSingleChoiceItem item) async {
    final store = _storeFor(item.store);
    final result = await ChoiceDialog.show<int>(
      context,
      title: item.title,
      labels: item.choiceLabels,
      values: item.choiceValues,
      current: store.readInt(item.setting),
    );
    if (result == null) return;
    await store.writeInt(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editStringSingleChoice(
    SettingsStringSingleChoiceItem item,
  ) async {
    final store = _storeFor(item.store);
    final result = await ChoiceDialog.show<String>(
      context,
      title: item.title,
      labels: item.choiceLabels,
      values: item.choiceValues,
      current: store.readString(item.setting),
    );
    if (result == null) return;
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editStringInput(SettingsStringInputItem item) async {
    final store = _storeFor(item.store);
    final result = await TextInputDialog.show(
      context,
      title: item.title,
      initialText: store.readString(item.setting),
      maxLength: item.maxLength,
    );
    if (result == null) return;
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editDateTime(SettingsDateTimeItem item) async {
    final store = _storeFor(item.store);
    final seconds = int.tryParse(store.readString(item.setting));
    final initial = seconds == null
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(
            seconds * 1000,
            isUtc: true,
          ).toLocal();
    final result = await DateTimePicker.show(context, initial: initial);
    if (result == null) return;
    await store.writeString(
      item.setting,
      (result.toUtc().millisecondsSinceEpoch ~/ 1000).toString(),
    );
    await _persist(item.store);
    setState(() {});
  }

  Future<void> _editInputBinding(SettingsInputBindingItem item) async {
    final store = _storeFor(item.store);
    final result = await InputBindingDialog.show(context, title: item.title);
    if (result == null) return;
    await store.writeString(item.setting, result);
    await _persist(item.store);
    setState(() {});
  }
}
