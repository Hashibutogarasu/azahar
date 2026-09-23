///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element

class Translations with BaseTranslations<AppLocale, Translations> {
  /// Returns the current translations of the given [context].
  ///
  /// Usage:
  /// final t = Translations.of(context);
  static Translations of(BuildContext context) =>
      InheritedLocaleData.of<AppLocale, Translations>(context).translations;

  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  Translations({
    Map<String, Node>? overrides,
    PluralResolver? cardinalResolver,
    PluralResolver? ordinalResolver,
    TranslationMetadata<AppLocale, Translations>? meta,
  }) : assert(
         overrides == null,
         'Set "translation_overrides: true" in order to enable this feature.',
       ),
       _meta =
           meta ??
           TranslationMetadata(
             locale: AppLocale.en,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <en>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  dynamic operator [](String key) => _meta.getTranslation(key);

  late final Translations _root = this; // ignore: unused_field

  Translations $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => Translations(meta: meta ?? this.$meta);

  // Translations

  /// en: 'Azahar'
  String get appName => 'Azahar';

  late final Translations$setup$en setup = Translations$setup$en.internal(
    _root,
  );
  late final Translations$games$en games = Translations$games$en.internal(
    _root,
  );
  late final Translations$emulation$en emulation =
      Translations$emulation$en.internal(_root);
  late final Translations$applets$en applets = Translations$applets$en.internal(
    _root,
  );
}

// Path: setup
class Translations$setup$en {
  Translations$setup$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Next'
  String get next => 'Next';

  /// en: 'Back'
  String get back => 'Back';

  /// en: 'Complete!'
  String get stepComplete => 'Complete!';

  /// en: 'Skip'
  String get warningSkip => 'Skip';

  /// en: 'Cancel'
  String get warningCancel => 'Cancel';

  /// en: 'Help'
  String get warningHelp => 'Help';

  /// en: 'Close'
  String get close => 'Close';

  late final Translations$setup$welcome$en welcome =
      Translations$setup$welcome$en.internal(_root);
  late final Translations$setup$notifications$en notifications =
      Translations$setup$notifications$en.internal(_root);
  late final Translations$setup$microphone$en microphone =
      Translations$setup$microphone$en.internal(_root);
  late final Translations$setup$camera$en camera =
      Translations$setup$camera$en.internal(_root);
  late final Translations$setup$userDirectory$en userDirectory =
      Translations$setup$userDirectory$en.internal(_root);
  late final Translations$setup$gamesDirectory$en gamesDirectory =
      Translations$setup$gamesDirectory$en.internal(_root);
  late final Translations$setup$done$en done =
      Translations$setup$done$en.internal(_root);
}

// Path: games
class Translations$games$en {
  Translations$games$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Applications'
  String get title => 'Applications';

  /// en: 'Search Applications'
  String get searchHint => 'Search Applications';

  /// en: 'No files were found or no game directory has been selected yet.'
  String get emptyGamelist =>
      'No files were found or no game directory has been selected yet.';
}

// Path: emulation
class Translations$emulation$en {
  Translations$emulation$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Loading…'
  String get loading => 'Loading…';

  /// en: 'Preparing Shaders'
  String get preparingShaders => 'Preparing Shaders';

  /// en: 'Building Shaders'
  String get buildingShaders => 'Building Shaders';

  /// en: '${progress}/${max}'
  String shaderProgress({required Object progress, required Object max}) =>
      '${progress}/${max}';
}

// Path: applets
class Translations$applets$en {
  Translations$applets$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Software Keyboard'
  String get softwareKeyboard => 'Software Keyboard';

  /// en: 'I Forgot'
  String get iForgot => 'I Forgot';

  /// en: 'Standard Mii'
  String get standardMii => 'Standard Mii';
}

// Path: setup.welcome
class Translations$setup$welcome$en {
  Translations$setup$welcome$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Welcome!'
  String get title => 'Welcome!';

  /// en: 'Learn how to set up Azahar and jump into emulation.'
  String get description =>
      'Learn how to set up Azahar and jump into emulation.';

  /// en: 'Get started'
  String get getStarted => 'Get started';
}

// Path: setup.notifications
class Translations$setup$notifications$en {
  Translations$setup$notifications$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Notifications'
  String get title => 'Notifications';

  /// en: 'Grant the notification permission with the button below.'
  String get description =>
      'Grant the notification permission with the button below.';

  /// en: 'Grant permission'
  String get givePermission => 'Grant permission';

  /// en: 'Skip granting the notification permission?'
  String get warningTitle => 'Skip granting the notification permission?';

  /// en: 'Azahar won't be able to notify you of important information.'
  String get warningDescription =>
      'Azahar won\'t be able to notify you of important information.';
}

// Path: setup.microphone
class Translations$setup$microphone$en {
  Translations$setup$microphone$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Microphone'
  String get title => 'Microphone';

  /// en: 'Grant the microphone permission below to emulate the 3DS microphone.'
  String get description =>
      'Grant the microphone permission below to emulate the 3DS microphone.';

  /// en: 'Grant permission'
  String get givePermission => 'Grant permission';
}

// Path: setup.camera
class Translations$setup$camera$en {
  Translations$setup$camera$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Camera'
  String get title => 'Camera';

  /// en: 'Grant the camera permission below to emulate the 3DS camera.'
  String get description =>
      'Grant the camera permission below to emulate the 3DS camera.';

  /// en: 'Grant permission'
  String get givePermission => 'Grant permission';
}

// Path: setup.userDirectory
class Translations$setup$userDirectory$en {
  Translations$setup$userDirectory$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Select User Folder'
  String get title => 'Select User Folder';

  /// en: 'Select your user data directory with the button below.'
  String get description =>
      'Select your user data directory with the button below.';

  /// en: 'Select'
  String get select => 'Select';

  /// en: 'You can't skip this step'
  String get warningTitle => 'You can\'t skip this step';

  /// en: 'This step is required to allow Azahar to work. Please select a directory and then you can continue.'
  String get warningDescription =>
      'This step is required to allow Azahar to work. Please select a directory and then you can continue.';

  /// en: 'https://web.archive.org/web/20240304193549/https://github.com/citra-emu/citra/wiki/Citra-Android-user-data-and-storage'
  String get warningHelpUrl =>
      'https://web.archive.org/web/20240304193549/https://github.com/citra-emu/citra/wiki/Citra-Android-user-data-and-storage';

  /// en: 'Move Data'
  String get moveData => 'Move Data';

  /// en: 'Moving Data…'
  String get movingData => 'Moving Data…';
}

// Path: setup.gamesDirectory
class Translations$setup$gamesDirectory$en {
  Translations$setup$gamesDirectory$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Applications'
  String get title => 'Applications';

  /// en: 'Select your Applications folder with the button below.'
  String get description =>
      'Select your Applications folder with the button below.';

  /// en: 'Select'
  String get select => 'Select';

  /// en: 'Skip selecting applications folder?'
  String get warningTitle => 'Skip selecting applications folder?';

  /// en: 'Software won't be displayed in the Applications list if a folder isn't selected.'
  String get warningDescription =>
      'Software won\'t be displayed in the Applications list if a folder isn\'t selected.';

  /// en: 'https://web.archive.org/web/20240304210021/https://citra-emu.org/wiki/dumping-game-cartridges/'
  String get warningHelpUrl =>
      'https://web.archive.org/web/20240304210021/https://citra-emu.org/wiki/dumping-game-cartridges/';
}

// Path: setup.done
class Translations$setup$done$en {
  Translations$setup$done$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Done'
  String get title => 'Done';

  /// en: 'You're all set. Enjoy using the emulator!'
  String get description => 'You\'re all set.\nEnjoy using the emulator!';

  /// en: 'Continue'
  String get continueLabel => 'Continue';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
      'appName' => 'Azahar',
      'setup.next' => 'Next',
      'setup.back' => 'Back',
      'setup.stepComplete' => 'Complete!',
      'setup.warningSkip' => 'Skip',
      'setup.warningCancel' => 'Cancel',
      'setup.warningHelp' => 'Help',
      'setup.close' => 'Close',
      'setup.welcome.title' => 'Welcome!',
      'setup.welcome.description' =>
        'Learn how to set up Azahar and jump into emulation.',
      'setup.welcome.getStarted' => 'Get started',
      'setup.notifications.title' => 'Notifications',
      'setup.notifications.description' =>
        'Grant the notification permission with the button below.',
      'setup.notifications.givePermission' => 'Grant permission',
      'setup.notifications.warningTitle' =>
        'Skip granting the notification permission?',
      'setup.notifications.warningDescription' =>
        'Azahar won\'t be able to notify you of important information.',
      'setup.microphone.title' => 'Microphone',
      'setup.microphone.description' =>
        'Grant the microphone permission below to emulate the 3DS microphone.',
      'setup.microphone.givePermission' => 'Grant permission',
      'setup.camera.title' => 'Camera',
      'setup.camera.description' =>
        'Grant the camera permission below to emulate the 3DS camera.',
      'setup.camera.givePermission' => 'Grant permission',
      'setup.userDirectory.title' => 'Select User Folder',
      'setup.userDirectory.description' =>
        'Select your user data directory with the button below.',
      'setup.userDirectory.select' => 'Select',
      'setup.userDirectory.warningTitle' => 'You can\'t skip this step',
      'setup.userDirectory.warningDescription' =>
        'This step is required to allow Azahar to work. Please select a directory and then you can continue.',
      'setup.userDirectory.warningHelpUrl' =>
        'https://web.archive.org/web/20240304193549/https://github.com/citra-emu/citra/wiki/Citra-Android-user-data-and-storage',
      'setup.userDirectory.moveData' => 'Move Data',
      'setup.userDirectory.movingData' => 'Moving Data…',
      'setup.gamesDirectory.title' => 'Applications',
      'setup.gamesDirectory.description' =>
        'Select your Applications folder with the button below.',
      'setup.gamesDirectory.select' => 'Select',
      'setup.gamesDirectory.warningTitle' =>
        'Skip selecting applications folder?',
      'setup.gamesDirectory.warningDescription' =>
        'Software won\'t be displayed in the Applications list if a folder isn\'t selected.',
      'setup.gamesDirectory.warningHelpUrl' =>
        'https://web.archive.org/web/20240304210021/https://citra-emu.org/wiki/dumping-game-cartridges/',
      'setup.done.title' => 'Done',
      'setup.done.description' => 'You\'re all set.\nEnjoy using the emulator!',
      'setup.done.continueLabel' => 'Continue',
      'games.title' => 'Applications',
      'games.searchHint' => 'Search Applications',
      'games.emptyGamelist' =>
        'No files were found or no game directory has been selected yet.',
      'emulation.loading' => 'Loading…',
      'emulation.preparingShaders' => 'Preparing Shaders',
      'emulation.buildingShaders' => 'Building Shaders',
      'emulation.shaderProgress' =>
        ({required Object progress, required Object max}) =>
            '${progress}/${max}',
      'applets.softwareKeyboard' => 'Software Keyboard',
      'applets.iForgot' => 'I Forgot',
      'applets.standardMii' => 'Standard Mii',
      _ => null,
    };
  }
}
