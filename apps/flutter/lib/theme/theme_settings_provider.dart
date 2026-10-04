import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_services.dart';
import '../data/user/user_database.dart';
import 'theme_style.dart';

final themeSettingsProvider =
    NotifierProvider<ThemeSettingsNotifier, ThemeSetting>(
      ThemeSettingsNotifier.new,
    );

class ThemeSettingsNotifier extends Notifier<ThemeSetting> {
  @override
  ThemeSetting build() {
    _load();
    return const ThemeSetting(
      id: 0,
      themeMode: 'system',
      staticThemeColor: 0,
      blackBackgrounds: false,
      materialYou: false,
      themeStyle: ThemeStyle.azahar,
    );
  }

  Future<void> _load() async {
    state = await AppServices.themeSettingsRepository.read();
  }

  Future<void> _update(
    ThemeSetting Function(ThemeSetting current) transform,
  ) async {
    final updated = transform(state);
    state = updated;
    await AppServices.themeSettingsRepository.write(updated);
  }

  Future<void> setThemeMode(String themeMode) {
    return _update((current) => current.copyWith(themeMode: themeMode));
  }

  Future<void> setStaticThemeColor(int staticThemeColor) {
    return _update(
      (current) => current.copyWith(staticThemeColor: staticThemeColor),
    );
  }

  Future<void> setBlackBackgrounds(bool blackBackgrounds) {
    return _update(
      (current) => current.copyWith(blackBackgrounds: blackBackgrounds),
    );
  }

  Future<void> setMaterialYou(bool materialYou) {
    return _update((current) => current.copyWith(materialYou: materialYou));
  }

  Future<void> setThemeStyle(ThemeStyle themeStyle) {
    return _update((current) => current.copyWith(themeStyle: themeStyle));
  }
}
