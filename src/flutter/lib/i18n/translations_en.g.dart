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

  late final Translations$common$en common = Translations$common$en.internal(
    _root,
  );
  late final Translations$setup$en setup = Translations$setup$en.internal(
    _root,
  );
  late final Translations$home$en home = Translations$home$en.internal(_root);
  late final Translations$games$en games = Translations$games$en.internal(
    _root,
  );
  late final Translations$emulation$en emulation =
      Translations$emulation$en.internal(_root);
  late final Translations$applets$en applets = Translations$applets$en.internal(
    _root,
  );
  late final Translations$options$en options = Translations$options$en.internal(
    _root,
  );
  late final Translations$systemFiles$en systemFiles =
      Translations$systemFiles$en.internal(_root);
  late final Translations$gpuDriverManager$en gpuDriverManager =
      Translations$gpuDriverManager$en.internal(_root);
  late final Translations$articBaseConnectDialog$en articBaseConnectDialog =
      Translations$articBaseConnectDialog$en.internal(_root);
  late final Translations$about$en about = Translations$about$en.internal(
    _root,
  );
  late final Translations$settings$en settings =
      Translations$settings$en.internal(_root);
}

// Path: common
class Translations$common$en {
  Translations$common$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Cancel'
  String get cancel => 'Cancel';

  /// en: 'Save'
  String get save => 'Save';
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
  late final Translations$setup$permissions$en permissions =
      Translations$setup$permissions$en.internal(_root);
  late final Translations$setup$dataFolders$en dataFolders =
      Translations$setup$dataFolders$en.internal(_root);
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

// Path: home
class Translations$home$en {
  Translations$home$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Applications'
  String get games => 'Applications';

  /// en: 'Options'
  String get options => 'Options';
}

// Path: games
class Translations$games$en {
  Translations$games$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Search Applications'
  String get searchHint => 'Search Applications';

  /// en: 'No files were found or no game directory has been selected yet.'
  String get emptyGamelist =>
      'No files were found or no game directory has been selected yet.';

  /// en: 'Properties'
  String get properties => 'Properties';

  /// en: 'This application's properties are not yet available. Please wait for the application list to finish loading and try again.'
  String get propertiesNotLoaded =>
      'This application\'s properties are not yet available. Please wait for the application list to finish loading and try again.';

  /// en: 'Play'
  String get play => 'Play';

  /// en: 'Open Folder'
  String get openFolder => 'Open Folder';

  /// en: 'Delete'
  String get delete => 'Delete';

  /// en: 'Create Shortcut'
  String get shortcut => 'Create Shortcut';

  /// en: 'Cheats'
  String get cheats => 'Cheats';

  /// en: 'Cheats are not available yet in this version of the app.'
  String get cheatsUnavailable =>
      'Cheats are not available yet in this version of the app.';

  /// en: 'Compress'
  String get compress => 'Compress';

  /// en: 'ID: ${id}'
  String titleIdLabel({required Object id}) => 'ID: ${id}';

  /// en: 'File: ${name}'
  String fileLabel({required Object name}) => 'File: ${name}';

  /// en: 'Delete Shader Cache'
  String get deleteShaderCache => 'Delete Shader Cache';

  /// en: 'Select the graphics API whose shader cache should be deleted'
  String get deleteCacheSelectBackend =>
      'Select the graphics API whose shader cache should be deleted';

  /// en: 'Vulkan'
  String get vulkan => 'Vulkan';

  /// en: 'OpenGLES'
  String get opengles => 'OpenGLES';

  /// en: 'Shader cache deleted'
  String get shaderCacheDeleted => 'Shader cache deleted';

  /// en: 'Create Shortcut'
  String get createShortcut => 'Create Shortcut';

  /// en: 'Shortcut Name'
  String get shortcutName => 'Shortcut Name';

  /// en: 'The shortcut name cannot be empty'
  String get shortcutNameEmpty => 'The shortcut name cannot be empty';

  /// en: 'Stretch image'
  String get shortcutImageStretchToggle => 'Stretch image';

  /// en: 'Edit icon'
  String get editIcon => 'Edit icon';

  /// en: 'Application'
  String get openApp => 'Application';

  /// en: 'Save Data'
  String get openSaveDir => 'Save Data';

  /// en: 'Updates'
  String get openUpdates => 'Updates';

  /// en: 'DLC'
  String get openDlc => 'DLC';

  /// en: 'Extra Data'
  String get openExtra => 'Extra Data';

  /// en: 'Textures'
  String get openTextures => 'Textures';

  /// en: 'Mods'
  String get openMods => 'Mods';

  /// en: 'Application'
  String get uninstallCia => 'Application';

  /// en: 'Updates'
  String get uninstallUpdates => 'Updates';

  /// en: 'DLC'
  String get uninstallDlc => 'DLC';

  /// en: 'Japan'
  String get regionJapan => 'Japan';

  /// en: 'North America'
  String get regionNorthAmerica => 'North America';

  /// en: 'Europe'
  String get regionEurope => 'Europe';

  /// en: 'Australia'
  String get regionAustralia => 'Australia';

  /// en: 'China'
  String get regionChina => 'China';

  /// en: 'Korea'
  String get regionKorea => 'Korea';

  /// en: 'Taiwan'
  String get regionTaiwan => 'Taiwan';

  /// en: 'Region free'
  String get regionFree => 'Region free';

  /// en: 'Invalid region'
  String get invalidRegion => 'Invalid region';
}

// Path: emulation
class Translations$emulation$en {
  Translations$emulation$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Loading'
  String get loading => 'Loading';

  /// en: 'Closing'
  String get terminating => 'Closing';

  /// en: 'Preparing Shaders'
  String get preparingShaders => 'Preparing Shaders';

  /// en: 'Building Shaders'
  String get buildingShaders => 'Building Shaders';

  /// en: '${progress}/${max}'
  String shaderProgress({required Object progress, required Object max}) =>
      '${progress}/${max}';

  /// en: 'Emulation'
  String get menuSectionEmulation => 'Emulation';

  /// en: 'Pause Emulation'
  String get pauseEmulation => 'Pause Emulation';

  /// en: 'Resume Emulation'
  String get resumeEmulation => 'Resume Emulation';

  /// en: 'Advance Frame'
  String get advanceFrame => 'Advance Frame';

  /// en: 'Tools'
  String get menuSectionTools => 'Tools';

  /// en: 'Cheats'
  String get cheats => 'Cheats';

  /// en: 'No cheats'
  String get noCheats => 'No cheats';

  /// en: 'Add Cheat'
  String get addCheat => 'Add Cheat';

  /// en: 'Name'
  String get cheatName => 'Name';

  /// en: 'Notes'
  String get cheatNotes => 'Notes';

  /// en: 'Code'
  String get cheatCode => 'Code';

  /// en: 'Name can't be empty'
  String get cheatNameEmpty => 'Name can\'t be empty';

  /// en: 'Code can't be empty'
  String get cheatCodeEmpty => 'Code can\'t be empty';

  /// en: 'Error on line ${line}'
  String cheatErrorOnLine({required Object line}) => 'Error on line ${line}';

  /// en: 'Other'
  String get menuSectionOther => 'Other';

  /// en: 'Close Game'
  String get closeGame => 'Close Game';

  /// en: 'Are you sure that you would like to close the current game?'
  String get closeGameMessage =>
      'Are you sure that you would like to close the current game?';
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

// Path: options
class Translations$options$en {
  Translations$options$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get emulatorSettings => 'Settings';

  /// en: 'Configure emulator settings'
  String get emulatorSettingsDescription => 'Configure emulator settings';

  /// en: 'Connect to Artic Base'
  String get articBaseConnect => 'Connect to Artic Base';

  /// en: 'Connect to a real console that is running an Artic Base server'
  String get articBaseConnectDescription =>
      'Connect to a real console that is running an Artic Base server';

  /// en: 'Install CIA file'
  String get installGameContent => 'Install CIA file';

  /// en: 'Install applications, updates or DLC'
  String get installGameContentDescription =>
      'Install applications, updates or DLC';

  /// en: 'CIA install complete'
  String get installGameContentSuccessTitle => 'CIA install complete';

  /// en: 'CIA install failed'
  String get installGameContentFailureTitle => 'CIA install failed';

  /// en: 'System Files'
  String get setupSystemFiles => 'System Files';

  /// en: 'Perform system file operations such as installing system files or booting the Home Menu'
  String get setupSystemFilesDescription =>
      'Perform system file operations such as installing system files or booting the Home Menu';

  /// en: 'Share Log'
  String get shareLog => 'Share Log';

  /// en: 'Share Azahar's log file to debug issues'
  String get shareLogDescription => 'Share Azahar\'s log file to debug issues';

  /// en: 'No log file found'
  String get shareLogNotFound => 'No log file found';

  /// en: 'GPU Driver Manager'
  String get gpuDriverManager => 'GPU Driver Manager';

  /// en: 'Install alternative drivers for potentially better performance or accuracy'
  String get gpuDriverManagerDescription =>
      'Install alternative drivers for potentially better performance or accuracy';

  /// en: 'Select User Folder'
  String get selectUserFolder => 'Select User Folder';

  /// en: 'Changes the files that Azahar uses to load applications'
  String get selectUserFolderDescription =>
      'Changes the files that Azahar uses to load applications';

  /// en: 'Select Applications Folder'
  String get selectGamesFolder => 'Select Applications Folder';

  /// en: 'Allows Azahar to populate the application list'
  String get selectGamesFolderDescription =>
      'Allows Azahar to populate the application list';

  /// en: 'Theme and Color'
  String get themeAndColor => 'Theme and Color';

  /// en: 'Modify the look of the app'
  String get themeAndColorDescription => 'Modify the look of the app';

  /// en: 'Media'
  String get media => 'Media';

  /// en: 'Background playback and media session settings'
  String get mediaDescription =>
      'Background playback and media session settings';

  /// en: 'Accessibility'
  String get accessibility => 'Accessibility';

  /// en: 'Motion and other accessibility settings'
  String get accessibilityDescription =>
      'Motion and other accessibility settings';

  /// en: 'Advanced Settings'
  String get advanced => 'Advanced Settings';

  /// en: 'Configure more advanced options'
  String get advancedDescription => 'Configure more advanced options';

  /// en: 'About'
  String get about => 'About';

  /// en: 'Build version, credits, and more'
  String get aboutDescription => 'Build version, credits, and more';

  /// en: 'Profile'
  String get general => 'Profile';

  /// en: 'Profile and birthday settings'
  String get generalDescription => 'Profile and birthday settings';

  /// en: 'Use Legacy Settings UI'
  String get useLegacySettingsUI => 'Use Legacy Settings UI';

  /// en: 'Switch back to the previous Options screen design'
  String get useLegacySettingsUIDescription =>
      'Switch back to the previous Options screen design';

  late final Translations$options$useLegacySettingsUIDialog$en
  useLegacySettingsUIDialog =
      Translations$options$useLegacySettingsUIDialog$en.internal(_root);

  /// en: 'Search Options'
  String get searchHint => 'Search Options';

  /// en: 'Type to search the settings'
  String get searchPrompt => 'Type to search the settings';

  /// en: 'No matching settings'
  String get searchNoResults => 'No matching settings';

  /// en: 'History'
  String get history => 'History';

  /// en: 'Settings you change or open will appear here.'
  String get historyEmpty => 'Settings you change or open will appear here.';

  /// en: 'Pinned'
  String get pinned => 'Pinned';

  /// en: 'Press and hold a setting to pin it here.'
  String get pinnedEmpty => 'Press and hold a setting to pin it here.';

  /// en: 'Delete'
  String get clear => 'Delete';

  /// en: 'Delete history?'
  String get clearHistoryTitle => 'Delete history?';

  /// en: 'This removes every item from the history. Your settings are not changed.'
  String get clearHistoryMessage =>
      'This removes every item from the history. Your settings are not changed.';

  /// en: 'Unpin all items?'
  String get clearPinnedTitle => 'Unpin all items?';

  /// en: 'This removes every pinned item. Your settings are not changed.'
  String get clearPinnedMessage =>
      'This removes every pinned item. Your settings are not changed.';

  /// en: 'Remove from history'
  String get removeFromHistory => 'Remove from history';

  /// en: 'Pin'
  String get pin => 'Pin';

  /// en: 'Unpin'
  String get unpin => 'Unpin';

  /// en: 'You can pin up to ${count} items.'
  String pinLimitReached({required Object count}) =>
      'You can pin up to ${count} items.';

  late final Translations$options$groups$en groups =
      Translations$options$groups$en.internal(_root);
}

// Path: systemFiles
class Translations$systemFiles$en {
  Translations$systemFiles$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'System Files'
  String get title => 'System Files';

  /// en: 'Azahar needs console unique data and firmware files from a real console to be able to use some of its features. Such files and data can be set up with the Azahar Artic Setup Tool. Notes: • This operation will install console unique data to Azahar, do not share your user or nand folders after performing the setup process! • While doing the setup process, Azahar will link to the console running the setup tool. You can unlink the console later from the System Files tab in the emulator options menu. • Do not go online with both Azahar and your 3DS console at the same time after setting up system files, as this could cause issues. • Old 3DS setup is needed for the New 3DS setup to work (setting up both is recommended). • Both setup modes will work regardless of the model of the console running the setup tool.'
  String get preamble =>
      'Azahar needs console unique data and firmware files from a real console to be able to use some of its features. Such files and data can be set up with the Azahar Artic Setup Tool.\n\nNotes:\n• This operation will install console unique data to Azahar, do not share your user or nand folders after performing the setup process!\n• While doing the setup process, Azahar will link to the console running the setup tool. You can unlink the console later from the System Files tab in the emulator options menu.\n• Do not go online with both Azahar and your 3DS console at the same time after setting up system files, as this could cause issues.\n• Old 3DS setup is needed for the New 3DS setup to work (setting up both is recommended).\n• Both setup modes will work regardless of the model of the console running the setup tool.';

  /// en: 'Connect to Artic Setup Tool'
  String get connectSetupTool => 'Connect to Artic Setup Tool';

  /// en: 'Unlink Console Unique Data'
  String get deleteSystemFiles => 'Unlink Console Unique Data';

  /// en: 'This action will unlink your real console from Azahar, with the following consequences: • Your OTP, SecureInfo and LocalFriendCodeSeed will be removed from Azahar. • Your friend list will reset and you will be logged out of your NNID/PNID account. • System files and eshop titles obtained through Azahar will become inaccessible until the same console is linked again using the setup tool (save data will not be lost). Continue?'
  String get deleteSystemFilesDescription =>
      'This action will unlink your real console from Azahar, with the following consequences:\n• Your OTP, SecureInfo and LocalFriendCodeSeed will be removed from Azahar.\n• Your friend list will reset and you will be logged out of your NNID/PNID account.\n• System files and eshop titles obtained through Azahar will become inaccessible until the same console is linked again using the setup tool (save data will not be lost).\n\nContinue?';

  /// en: 'Boot the HOME Menu'
  String get bootHomeMenu => 'Boot the HOME Menu';

  /// en: 'Start'
  String get start => 'Start';

  /// en: 'Run System Setup when the HOME Menu is launched'
  String get runSystemSetup =>
      'Run System Setup when the HOME Menu is launched';

  /// en: 'Show HOME menu apps in Applications list'
  String get showHomeApps => 'Show HOME menu apps in Applications list';

  /// en: 'Fetching current system files status, please wait...'
  String get detecting =>
      'Fetching current system files status, please wait...';

  /// en: 'Preparing setup, please wait...'
  String get preparing => 'Preparing setup, please wait...';

  /// en: 'Enter Artic Setup Tool address'
  String get enterAddress => 'Enter Artic Setup Tool address';

  /// en: 'Old 3DS Setup'
  String get old3ds => 'Old 3DS Setup';

  /// en: 'New 3DS Setup'
  String get new3ds => 'New 3DS Setup';

  /// en: 'Setup is possible.'
  String get statusPossible => 'Setup is possible.';

  /// en: 'Setup already completed.'
  String get statusCompleted => 'Setup already completed.';

  /// en: 'Old 3DS setup is required first.'
  String get statusOld3dsNeeded => 'Old 3DS setup is required first.';
}

// Path: gpuDriverManager
class Translations$gpuDriverManager$en {
  Translations$gpuDriverManager$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'GPU Driver Manager'
  String get title => 'GPU Driver Manager';

  /// en: 'System Driver'
  String get systemDriver => 'System Driver';

  /// en: 'Install Driver'
  String get installDriver => 'Install Driver';

  /// en: 'Install a custom driver from a zip file'
  String get installDriverDescription =>
      'Install a custom driver from a zip file';

  /// en: 'Failed to install the driver'
  String get installFailed => 'Failed to install the driver';
}

// Path: articBaseConnectDialog
class Translations$articBaseConnectDialog$en {
  Translations$articBaseConnectDialog$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Enter Artic Base server address'
  String get title => 'Enter Artic Base server address';
}

// Path: about
class Translations$about$en {
  Translations$about$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'About'
  String get title => 'About';

  /// en: 'An open-source 3DS emulator'
  String get description => 'An open-source 3DS emulator';

  /// en: 'Contributors'
  String get contributors => 'Contributors';

  /// en: 'Contributors who made Azahar possible'
  String get contributorsDescription => 'Contributors who made Azahar possible';

  /// en: 'Licenses'
  String get licenses => 'Licenses';

  /// en: 'Projects used by Azahar for Android'
  String get licensesDescription => 'Projects used by Azahar for Android';

  /// en: 'Build'
  String get build => 'Build';
}

// Path: settings
class Translations$settings$en {
  Translations$settings$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  /// en: 'Reset to Default'
  String get resetToDefault => 'Reset to Default';

  late final Translations$settings$resetToDefaultDialog$en
  resetToDefaultDialog = Translations$settings$resetToDefaultDialog$en.internal(
    _root,
  );
  late final Translations$settings$sliderDialog$en sliderDialog =
      Translations$settings$sliderDialog$en.internal(_root);
  late final Translations$settings$inputBindingDialog$en inputBindingDialog =
      Translations$settings$inputBindingDialog$en.internal(_root);
  late final Translations$settings$general$en general =
      Translations$settings$general$en.internal(_root);
  late final Translations$settings$emulation$en emulation =
      Translations$settings$emulation$en.internal(_root);
  late final Translations$settings$networking$en networking =
      Translations$settings$networking$en.internal(_root);
  late final Translations$settings$media$en media =
      Translations$settings$media$en.internal(_root);
  late final Translations$settings$graphics$en graphics =
      Translations$settings$graphics$en.internal(_root);
  late final Translations$settings$system$en system =
      Translations$settings$system$en.internal(_root);
  late final Translations$settings$camera$en camera =
      Translations$settings$camera$en.internal(_root);
  late final Translations$settings$gamepad$en gamepad =
      Translations$settings$gamepad$en.internal(_root);
  late final Translations$settings$layout$en layout =
      Translations$settings$layout$en.internal(_root);
  late final Translations$settings$audio$en audio =
      Translations$settings$audio$en.internal(_root);
  late final Translations$settings$debug$en debug =
      Translations$settings$debug$en.internal(_root);
  late final Translations$settings$theme$en theme =
      Translations$settings$theme$en.internal(_root);
  late final Translations$settings$themes$en themes =
      Translations$settings$themes$en.internal(_root);
  late final Translations$settings$accessibility$en accessibility =
      Translations$settings$accessibility$en.internal(_root);
  late final Translations$settings$advanced$en advanced =
      Translations$settings$advanced$en.internal(_root);
  late final Translations$settings$language$en language =
      Translations$settings$language$en.internal(_root);
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

// Path: setup.permissions
class Translations$setup$permissions$en {
  Translations$setup$permissions$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Permissions'
  String get title => 'Permissions';

  /// en: 'Grant optional permissions to use specific features of the emulator'
  String get description =>
      'Grant optional permissions to use specific features of the emulator';
}

// Path: setup.dataFolders
class Translations$setup$dataFolders$en {
  Translations$setup$dataFolders$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Data Folders'
  String get title => 'Data Folders';

  /// en: 'Select data folders (User folder is required)'
  String get description => 'Select data folders\n(User folder is required)';
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

  /// en: 'Moving Data'
  String get movingData => 'Moving Data';
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

// Path: options.useLegacySettingsUIDialog
class Translations$options$useLegacySettingsUIDialog$en {
  Translations$options$useLegacySettingsUIDialog$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Switch Settings UI?'
  String get title => 'Switch Settings UI?';

  /// en: 'This changes how the Options screen looks. You can switch back at any time.'
  String get message =>
      'This changes how the Options screen looks. You can switch back at any time.';

  /// en: 'Switch'
  String get confirm => 'Switch';
}

// Path: options.groups
class Translations$options$groups$en {
  Translations$options$groups$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General'
  String get general => 'General';

  /// en: 'Emulation'
  String get emulation => 'Emulation';

  /// en: 'Clock'
  String get clock => 'Clock';

  /// en: 'Graphics'
  String get graphics => 'Graphics';

  /// en: 'Networking'
  String get networking => 'Networking';

  /// en: 'Controls'
  String get controls => 'Controls';

  /// en: 'Tools'
  String get tools => 'Tools';

  /// en: 'Folder Settings'
  String get folderSettings => 'Folder Settings';

  /// en: 'Other'
  String get other => 'Other';

  /// en: 'Accessibility'
  String get accessibility => 'Accessibility';
}

// Path: settings.resetToDefaultDialog
class Translations$settings$resetToDefaultDialog$en {
  Translations$settings$resetToDefaultDialog$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Reset to Default?'
  String get title => 'Reset to Default?';

  /// en: 'This will reset all settings to their default values. This cannot be undone.'
  String get message =>
      'This will reset all settings to their default values. This cannot be undone.';

  /// en: 'Reset'
  String get confirm => 'Reset';
}

// Path: settings.sliderDialog
class Translations$settings$sliderDialog$en {
  Translations$settings$sliderDialog$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Default'
  String get kDefault => 'Default';

  /// en: '${title}: value must be between ${min} and ${max}.'
  String invalidValue({
    required Object title,
    required Object min,
    required Object max,
  }) => '${title}: value must be between ${min} and ${max}.';
}

// Path: settings.inputBindingDialog
class Translations$settings$inputBindingDialog$en {
  Translations$settings$inputBindingDialog$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Press a button on your controller'
  String get waitingForInput => 'Press a button on your controller';
}

// Path: settings.general
class Translations$settings$general$en {
  Translations$settings$general$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Profile'
  String get title => 'Profile';

  /// en: 'Limit Speed'
  String get frameLimitEnable => 'Limit Speed';

  /// en: 'When enabled, emulation speed will be limited to a specified percentage of normal speed.'
  String get frameLimitEnableDescription =>
      'When enabled, emulation speed will be limited to a specified percentage of normal speed.';

  /// en: 'Limit Speed Percent'
  String get frameLimitSlider => 'Limit Speed Percent';

  /// en: 'Specifies the percentage to limit emulation speed. With the default of 100% emulation will be limited to normal speed. Values higher or lower will increase or decrease the speed limit.'
  String get frameLimitSliderDescription =>
      'Specifies the percentage to limit emulation speed. With the default of 100% emulation will be limited to normal speed. Values higher or lower will increase or decrease the speed limit.';
}

// Path: settings.emulation
class Translations$settings$emulation$en {
  Translations$settings$emulation$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Emulation'
  String get title => 'Emulation';

  /// en: 'Use High-Level Emulation'
  String get useHighLevelEmulation => 'Use High-Level Emulation';

  /// en: 'Uses a reimplementation of the system applets instead of low level emulation. Turning this off may be required for some online features to work.'
  String get useHighLevelEmulationDescription =>
      'Uses a reimplementation of the system applets instead of low level emulation. Turning this off may be required for some online features to work.';
}

// Path: settings.networking
class Translations$settings$networking$en {
  Translations$settings$networking$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Networking'
  String get title => 'Networking';

  /// en: 'Access Network'
  String get accessNetwork => 'Access Network';

  /// en: 'Allows the emulated console to access online features by using low level emulation for the system applets and the modules required for them.'
  String get accessNetworkDescription =>
      'Allows the emulated console to access online features by using low level emulation for the system applets and the modules required for them.';

  /// en: 'Use Wireless'
  String get useWireless => 'Use Wireless';

  /// en: 'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.'
  String get useWirelessDescription =>
      'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.';

  /// en: 'Emulated Network'
  String get emulatedNetwork => 'Emulated Network';

  /// en: 'Inspect the Wi-Fi access points the emulated console can see, and optionally replace them with virtual ones.'
  String get emulatedNetworkDescription =>
      'Inspect the Wi-Fi access points the emulated console can see, and optionally replace them with virtual ones.';

  /// en: 'Real Network'
  String get realNetworkTab => 'Real Network';

  /// en: 'Virtual Network'
  String get virtualNetworkTab => 'Virtual Network';

  /// en: '(Hidden Network)'
  String get hiddenNetwork => '(Hidden Network)';

  /// en: 'SSID'
  String get ssid => 'SSID';

  /// en: 'BSSID'
  String get bssid => 'BSSID';

  /// en: 'Frequency'
  String get frequency => 'Frequency';

  /// en: 'No access points found.'
  String get noAccessPointsFound => 'No access points found.';

  /// en: 'Use Virtual Network'
  String get useVirtualNetwork => 'Use Virtual Network';

  /// en: 'Reports the access points below to the emulated console instead of the real ones.'
  String get useVirtualNetworkDescription =>
      'Reports the access points below to the emulated console instead of the real ones.';

  /// en: 'Add Access Point'
  String get addAccessPoint => 'Add Access Point';

  /// en: 'Edit Access Point'
  String get editAccessPoint => 'Edit Access Point';

  /// en: 'Leave blank for a hidden network'
  String get ssidHint => 'Leave blank for a hidden network';

  /// en: '00:00:00:00:00:00'
  String get bssidHint => '00:00:00:00:00:00';

  /// en: 'MHz, e.g. 2437'
  String get frequencyHint => 'MHz, e.g. 2437';

  /// en: 'Signal level in dBm, e.g. -50'
  String get levelHint => 'Signal level in dBm, e.g. -50';

  /// en: 'Copy selected'
  String get copySelected => 'Copy selected';

  /// en: 'Paste'
  String get pasteAccessPoints => 'Paste';
}

// Path: settings.media
class Translations$settings$media$en {
  Translations$settings$media$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Media'
  String get title => 'Media';

  /// en: 'App'
  String get groupApp => 'App';

  /// en: 'Emulator'
  String get groupEmulator => 'Emulator';

  /// en: 'Master Volume'
  String get masterVolume => 'Master Volume';

  /// en: 'Controls the app's overall output volume independently of the emulated game's own volume setting. Hardware volume buttons adjust this value.'
  String get masterVolumeDescription =>
      'Controls the app\'s overall output volume independently of the emulated game\'s own volume setting. Hardware volume buttons adjust this value.';

  /// en: '${value}%'
  String masterVolumePercent({required Object value}) => '${value}%';

  /// en: 'Treat as Android Media'
  String get treatAudioAsMediaSession => 'Treat as Android Media';

  /// en: 'Shows playback controls on the lock screen and notification like a music app, and keeps audio playing when the app is in the background instead of pausing automatically.'
  String get treatAudioAsMediaSessionDescription =>
      'Shows playback controls on the lock screen and notification like a music app, and keeps audio playing when the app is in the background instead of pausing automatically.';
}

// Path: settings.graphics
class Translations$settings$graphics$en {
  Translations$settings$graphics$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Graphics'
  String get title => 'Graphics';

  /// en: 'Renderer'
  String get renderer => 'Renderer';

  /// en: 'Graphics API'
  String get graphicsApi => 'Graphics API';

  /// en: 'OpenGLES'
  String get graphicsApiOpengles => 'OpenGLES';

  /// en: 'Vulkan'
  String get graphicsApiVulkan => 'Vulkan';

  /// en: 'Enable SPIR-V shader generation'
  String get spirvShaderGen => 'Enable SPIR-V shader generation';

  /// en: 'Emits the fragment shader used to emulate PICA using SPIR-V instead of GLSL'
  String get spirvShaderGenDescription =>
      'Emits the fragment shader used to emulate PICA using SPIR-V instead of GLSL';

  /// en: 'Enable asynchronous shader compilation'
  String get asyncShaders => 'Enable asynchronous shader compilation';

  /// en: 'Compiles shaders in the background to reduce stuttering during gameplay. When enabled expect temporary graphical glitches'
  String get asyncShadersDescription =>
      'Compiles shaders in the background to reduce stuttering during gameplay. When enabled expect temporary graphical glitches';

  /// en: 'Internal Resolution'
  String get internalResolution => 'Internal Resolution';

  /// en: 'Specifies the resolution used to render at. A high resolution will improve visual quality a lot but is also quite heavy on performance and might cause glitches in certain applications.'
  String get internalResolutionDescription =>
      'Specifies the resolution used to render at. A high resolution will improve visual quality a lot but is also quite heavy on performance and might cause glitches in certain applications.';

  /// en: 'Native (400x240)'
  String get internalResolutionNative => 'Native (400x240)';

  /// en: '2x Native (800x480)'
  String get internalResolution2x => '2x Native (800x480)';

  /// en: '3x Native (1200x720)'
  String get internalResolution3x => '3x Native (1200x720)';

  /// en: '4x Native (1600x960)'
  String get internalResolution4x => '4x Native (1600x960)';

  /// en: '5x Native (2000x1200)'
  String get internalResolution5x => '5x Native (2000x1200)';

  /// en: '6x Native (2400x1440)'
  String get internalResolution6x => '6x Native (2400x1440)';

  /// en: '7x Native (2800x1680)'
  String get internalResolution7x => '7x Native (2800x1680)';

  /// en: '8x Native (3200x1920)'
  String get internalResolution8x => '8x Native (3200x1920)';

  /// en: '9x Native (3600x2160)'
  String get internalResolution9x => '9x Native (3600x2160)';

  /// en: '10x Native (4000x2400)'
  String get internalResolution10x => '10x Native (4000x2400)';

  /// en: 'Linear Filtering'
  String get linearFiltering => 'Linear Filtering';

  /// en: 'Enables linear filtering, which causes game visuals to appear smoother.'
  String get linearFilteringDescription =>
      'Enables linear filtering, which causes game visuals to appear smoother.';

  /// en: 'Accurate Multiplication'
  String get shadersAccurateMul => 'Accurate Multiplication';

  /// en: 'Uses more accurate multiplication in hardware shaders, which may fix some graphical bugs. When enabled, performance will be reduced.'
  String get shadersAccurateMulDescription =>
      'Uses more accurate multiplication in hardware shaders, which may fix some graphical bugs. When enabled, performance will be reduced.';

  /// en: 'Disk Shader Cache'
  String get useDiskShaderCache => 'Disk Shader Cache';

  /// en: 'Reduce stuttering by storing and loading generated shaders to disk. It cannot be used without Enabling Hardware Shader.'
  String get useDiskShaderCacheDescription =>
      'Reduce stuttering by storing and loading generated shaders to disk. It cannot be used without Enabling Hardware Shader.';

  /// en: 'Texture Filter'
  String get textureFilterName => 'Texture Filter';

  /// en: 'Enhances the visuals of applications by applying a filter to textures. The supported filters are Anime4K Ultrafast, Bicubic, ScaleForce, xBRZ freescale, and MMPX.'
  String get textureFilterDescription =>
      'Enhances the visuals of applications by applying a filter to textures. The supported filters are Anime4K Ultrafast, Bicubic, ScaleForce, xBRZ freescale, and MMPX.';

  /// en: 'None'
  String get textureFilterNone => 'None';

  /// en: 'Anime4K'
  String get textureFilterAnime4k => 'Anime4K';

  /// en: 'Bicubic'
  String get textureFilterBicubic => 'Bicubic';

  /// en: 'ScaleForce'
  String get textureFilterScaleforce => 'ScaleForce';

  /// en: 'xBRZ'
  String get textureFilterXbrz => 'xBRZ';

  /// en: 'MMPX'
  String get textureFilterMmpx => 'MMPX';

  /// en: 'Delay game render thread'
  String get delayRenderThread => 'Delay game render thread';

  /// en: 'Delay the game render thread when it submits data to the GPU. Helps with performance issues in the (very few) applications with dynamic framerates.'
  String get delayRenderThreadDescription =>
      'Delay the game render thread when it submits data to the GPU. Helps with performance issues in the (very few) applications with dynamic framerates.';

  /// en: 'Stereoscopy'
  String get stereoscopy => 'Stereoscopy';

  /// en: 'Stereoscopic 3D Mode'
  String get render3d => 'Stereoscopic 3D Mode';

  /// en: 'Off'
  String get render3dOff => 'Off';

  /// en: 'Side by Side'
  String get render3dSideBySide => 'Side by Side';

  /// en: 'Reverse Side by Side'
  String get render3dReverseSideBySide => 'Reverse Side by Side';

  /// en: 'Anaglyph'
  String get render3dAnaglyph => 'Anaglyph';

  /// en: 'Interlaced'
  String get render3dInterlaced => 'Interlaced';

  /// en: 'Reverse Interlaced'
  String get render3dReverseInterlaced => 'Reverse Interlaced';

  /// en: 'Cardboard VR'
  String get render3dCardboardVr => 'Cardboard VR';

  /// en: 'Depth'
  String get factor3d => 'Depth';

  /// en: 'Specifies the value of the 3D slider. This should be set to higher than 0% when Stereoscopic 3D is enabled.'
  String get factor3dDescription =>
      'Specifies the value of the 3D slider. This should be set to higher than 0% when Stereoscopic 3D is enabled.';

  /// en: 'Disable Right Eye Render'
  String get disableRightEyeRender => 'Disable Right Eye Render';

  /// en: 'Greatly improves performance in some applications, but can cause flickering in others.'
  String get disableRightEyeRenderDescription =>
      'Greatly improves performance in some applications, but can cause flickering in others.';

  /// en: 'Cardboard VR'
  String get cardboardVr => 'Cardboard VR';

  /// en: 'Cardboard Screen Size'
  String get cardboardScreenSize => 'Cardboard Screen Size';

  /// en: 'Scales the screen to a percentage of its original size.'
  String get cardboardScreenSizeDescription =>
      'Scales the screen to a percentage of its original size.';

  /// en: 'Horizontal Shift'
  String get cardboardXShift => 'Horizontal Shift';

  /// en: 'Specifies the percentage of empty space to shift the screens horizontally. Positive values move the two eyes closer to the middle, while negative values move them away.'
  String get cardboardXShiftDescription =>
      'Specifies the percentage of empty space to shift the screens horizontally. Positive values move the two eyes closer to the middle, while negative values move them away.';

  /// en: 'Vertical Shift'
  String get cardboardYShift => 'Vertical Shift';

  /// en: 'Specifies the percentage of empty space to shift the screens vertically. Positive values move the two eyes towards the bottom, while negative values move them towards the top.'
  String get cardboardYShiftDescription =>
      'Specifies the percentage of empty space to shift the screens vertically. Positive values move the two eyes towards the bottom, while negative values move them towards the top.';

  /// en: 'Utility'
  String get utility => 'Utility';

  /// en: 'Dump Textures'
  String get dumpTextures => 'Dump Textures';

  /// en: 'Textures are dumped to dump/textures/[Title ID]/.'
  String get dumpTexturesDescription =>
      'Textures are dumped to dump/textures/[Title ID]/.';

  /// en: 'Custom Textures'
  String get customTextures => 'Custom Textures';

  /// en: 'Textures are loaded from load/textures/[Title ID]/.'
  String get customTexturesDescription =>
      'Textures are loaded from load/textures/[Title ID]/.';

  /// en: 'Async Custom Texture Loading'
  String get asyncCustomLoading => 'Async Custom Texture Loading';

  /// en: 'Load custom textures asynchronously with background threads to reduce loading stutter.'
  String get asyncCustomLoadingDescription =>
      'Load custom textures asynchronously with background threads to reduce loading stutter.';

  /// en: 'Advanced'
  String get advanced => 'Advanced';

  /// en: 'Texture Sampling'
  String get textureSamplingName => 'Texture Sampling';

  /// en: 'Overrides the sampling filter used by games. This can be useful in certain cases with poorly behaved games when upscaling. If unsure, set this to Game Controlled.'
  String get textureSamplingDescription =>
      'Overrides the sampling filter used by games. This can be useful in certain cases with poorly behaved games when upscaling. If unsure, set this to Game Controlled.';

  /// en: 'Game Controlled'
  String get textureSamplingGameControlled => 'Game Controlled';

  /// en: 'Nearest Neighbor'
  String get textureSamplingNearestNeighbor => 'Nearest Neighbor';

  /// en: 'Linear'
  String get textureSamplingLinear => 'Linear';
}

// Path: settings.system
class Translations$settings$system$en {
  Translations$settings$system$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'System'
  String get title => 'System';

  /// en: 'Emulation Settings'
  String get emulationSettings => 'Emulation Settings';

  /// en: 'New 3DS Mode'
  String get new3ds => 'New 3DS Mode';

  /// en: 'Enables New 3DS exclusive features that are not present on the Old 3DS.'
  String get new3dsDescription =>
      'Enables New 3DS exclusive features that are not present on the Old 3DS.';

  /// en: 'LLE Applets'
  String get lleApplets => 'LLE Applets';

  /// en: 'Uses low level emulation of the system applets when available, instead of high level emulation.'
  String get lleAppletsDescription =>
      'Uses low level emulation of the system applets when available, instead of high level emulation.';

  /// en: 'Enable Required Online LLE Modules'
  String get requiredOnlineLleModules => 'Enable Required Online LLE Modules';

  /// en: 'Uses low level emulation for modules required for online features, even if LLE Applets is disabled.'
  String get requiredOnlineLleModulesDescription =>
      'Uses low level emulation for modules required for online features, even if LLE Applets is disabled.';

  /// en: 'Profile Settings'
  String get profileSettings => 'Profile Settings';

  /// en: 'Emulated Region'
  String get emulatedRegion => 'Emulated Region';

  /// en: 'Auto-Select'
  String get regionAutoSelect => 'Auto-Select';

  /// en: 'JPN'
  String get regionJapan => 'JPN';

  /// en: 'USA'
  String get regionUsa => 'USA';

  /// en: 'EUR'
  String get regionEurope => 'EUR';

  /// en: 'AUS'
  String get regionAustralia => 'AUS';

  /// en: 'CHN'
  String get regionChina => 'CHN';

  /// en: 'KOR'
  String get regionKorea => 'KOR';

  /// en: 'TWN'
  String get regionTaiwan => 'TWN';

  /// en: 'Country'
  String get country => 'Country';

  /// en: 'Emulated Language'
  String get emulatedLanguage => 'Emulated Language';

  /// en: 'Japanese (日本語)'
  String get languageJapanese => 'Japanese (日本語)';

  /// en: 'English'
  String get languageEnglish => 'English';

  /// en: 'French (Français)'
  String get languageFrench => 'French (Français)';

  /// en: 'German (Deutsch)'
  String get languageGerman => 'German (Deutsch)';

  /// en: 'Italian (Italiano)'
  String get languageItalian => 'Italian (Italiano)';

  /// en: 'Spanish (Español)'
  String get languageSpanish => 'Spanish (Español)';

  /// en: 'Simplified Chinese (简体中文)'
  String get languageSimplifiedChinese => 'Simplified Chinese (简体中文)';

  /// en: 'Korean (한국어)'
  String get languageKorean => 'Korean (한국어)';

  /// en: 'Dutch (Nederlands)'
  String get languageDutch => 'Dutch (Nederlands)';

  /// en: 'Portuguese (Português)'
  String get languagePortuguese => 'Portuguese (Português)';

  /// en: 'Russian (Русский)'
  String get languageRussian => 'Russian (Русский)';

  /// en: 'Traditional Chinese (正體中文)'
  String get languageTraditionalChinese => 'Traditional Chinese (正體中文)';

  /// en: 'Username'
  String get username => 'Username';

  /// en: 'Play Coins'
  String get playCoins => 'Play Coins';

  /// en: 'Steps per Hour'
  String get stepsPerHour => 'Steps per Hour';

  /// en: 'The average number of steps to be generated per hour, for pedometer-based features.'
  String get stepsPerHourDescription =>
      'The average number of steps to be generated per hour, for pedometer-based features.';

  /// en: 'Scan for Real Wi-Fi Networks'
  String get scanRealWifiNetworks => 'Scan for Real Wi-Fi Networks';

  /// en: 'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.'
  String get scanRealWifiNetworksDescription =>
      'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.';

  /// en: 'Console ID'
  String get consoleId => 'Console ID';

  /// en: 'Tap to regenerate the console ID. Some applications may use this as a form of parental lock.'
  String get consoleIdDescription =>
      'Tap to regenerate the console ID. Some applications may use this as a form of parental lock.';

  /// en: 'MAC Address'
  String get macAddress => 'MAC Address';

  /// en: 'Tap to regenerate the network MAC address.'
  String get macAddressDescription =>
      'Tap to regenerate the network MAC address.';

  /// en: 'Birthday'
  String get birthday => 'Birthday';

  /// en: 'Birthday Month'
  String get birthdayMonth => 'Birthday Month';

  /// en: 'Birthday Day'
  String get birthdayDay => 'Birthday Day';

  /// en: 'January'
  String get monthJanuary => 'January';

  /// en: 'February'
  String get monthFebruary => 'February';

  /// en: 'March'
  String get monthMarch => 'March';

  /// en: 'April'
  String get monthApril => 'April';

  /// en: 'May'
  String get monthMay => 'May';

  /// en: 'June'
  String get monthJune => 'June';

  /// en: 'July'
  String get monthJuly => 'July';

  /// en: 'August'
  String get monthAugust => 'August';

  /// en: 'September'
  String get monthSeptember => 'September';

  /// en: 'October'
  String get monthOctober => 'October';

  /// en: 'November'
  String get monthNovember => 'November';

  /// en: 'December'
  String get monthDecember => 'December';

  /// en: 'Clock'
  String get clock => 'Clock';

  /// en: 'Initial Clock'
  String get initClock => 'Initial Clock';

  /// en: 'Device Clock'
  String get initClockDeviceClock => 'Device Clock';

  /// en: 'Simulated Clock'
  String get initClockSimulatedClock => 'Simulated Clock';

  /// en: 'Simulated Clock'
  String get simulatedClock => 'Simulated Clock';

  /// en: 'Plugin Loader'
  String get pluginLoader => 'Plugin Loader';

  /// en: 'Plugin Loader'
  String get pluginLoaderEnable => 'Plugin Loader';

  /// en: 'Allows arbitrary plugins to be loaded into the emulated game.'
  String get pluginLoaderEnableDescription =>
      'Allows arbitrary plugins to be loaded into the emulated game.';

  /// en: 'Allow Plugin Loader'
  String get allowPluginLoader => 'Allow Plugin Loader';

  /// en: 'Allows the game itself to request plugins to be loaded.'
  String get allowPluginLoaderDescription =>
      'Allows the game itself to request plugins to be loaded.';

  late final Translations$settings$system$countries$en countries =
      Translations$settings$system$countries$en.internal(_root);
}

// Path: settings.camera
class Translations$settings$camera$en {
  Translations$settings$camera$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Camera'
  String get title => 'Camera';

  /// en: 'Inner Camera'
  String get innerCamera => 'Inner Camera';

  /// en: 'Outer Left Camera'
  String get outerLeftCamera => 'Outer Left Camera';

  /// en: 'Outer Right Camera'
  String get outerRightCamera => 'Outer Right Camera';

  /// en: 'Camera Image Source'
  String get imageSource => 'Camera Image Source';

  /// en: 'Sets the image source of the virtual camera. You can use an image file, or a device camera when supported.'
  String get imageSourceDescription =>
      'Sets the image source of the virtual camera. You can use an image file, or a device camera when supported.';

  /// en: 'Blank'
  String get imageSourceBlank => 'Blank';

  /// en: 'Still Image'
  String get imageSourceStillImage => 'Still Image';

  /// en: 'Device Camera'
  String get imageSourceDeviceCamera => 'Device Camera';

  /// en: 'Camera'
  String get cameraDevice => 'Camera';

  /// en: 'If the "Image Source" setting is set to "Device Camera", this sets the physical camera to use.'
  String get cameraDeviceDescription =>
      'If the "Image Source" setting is set to "Device Camera", this sets the physical camera to use.';

  /// en: 'Default'
  String get cameraDeviceDefault => 'Default';

  /// en: 'Any Front Camera'
  String get cameraDeviceAnyFront => 'Any Front Camera';

  /// en: 'Any Back Camera'
  String get cameraDeviceAnyBack => 'Any Back Camera';

  /// en: 'Flip'
  String get imageFlip => 'Flip';

  /// en: 'None'
  String get imageFlipNone => 'None';

  /// en: 'Horizontal'
  String get imageFlipHorizontal => 'Horizontal';

  /// en: 'Vertical'
  String get imageFlipVertical => 'Vertical';

  /// en: 'Reverse'
  String get imageFlipReverse => 'Reverse';
}

// Path: settings.gamepad
class Translations$settings$gamepad$en {
  Translations$settings$gamepad$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Gamepad'
  String get title => 'Gamepad';

  /// en: 'Controller Input Mode'
  String get controllerInputMode => 'Controller Input Mode';

  /// en: 'Choose how physical game controllers are mapped to 3DS input.'
  String get controllerInputModeDescription =>
      'Choose how physical game controllers are mapped to 3DS input.';

  /// en: 'Manual'
  String get controllerInputModeManual => 'Manual';

  /// en: 'Auto-Detect'
  String get controllerInputModeAutoDetect => 'Auto-Detect';

  /// en: 'Invert Left Stick Y Axis'
  String get invertLeftStickYAxis => 'Invert Left Stick Y Axis';

  /// en: 'Invert the left stick's vertical axis when using auto-detected controllers.'
  String get invertLeftStickYAxisDescription =>
      'Invert the left stick\'s vertical axis when using auto-detected controllers.';

  /// en: 'Gyro Settings'
  String get gyroSettings => 'Gyro Settings';

  /// en: 'Gyro Input Source'
  String get gyroInputSource => 'Gyro Input Source';

  /// en: 'Choose whether motion (gyro) controls come from this device or a connected controller's gyroscope. Falls back to this device if the controller has no gyroscope.'
  String get gyroInputSourceDescription =>
      'Choose whether motion (gyro) controls come from this device or a connected controller\'s gyroscope. Falls back to this device if the controller has no gyroscope.';

  /// en: 'Device'
  String get gyroInputSourceDevice => 'Device';

  /// en: 'Controller'
  String get gyroInputSourceController => 'Controller';

  /// en: 'Gyro Vertical Sensitivity'
  String get gyroSensitivityVertical => 'Gyro Vertical Sensitivity';

  /// en: 'Adjust the gyroscope's vertical (pitch) sensitivity.'
  String get gyroSensitivityVerticalDescription =>
      'Adjust the gyroscope\'s vertical (pitch) sensitivity.';

  /// en: 'Invert Gyro Vertical Axis'
  String get invertGyroVertical => 'Invert Gyro Vertical Axis';

  /// en: 'Invert the gyroscope's vertical (pitch) axis.'
  String get invertGyroVerticalDescription =>
      'Invert the gyroscope\'s vertical (pitch) axis.';

  /// en: 'Gyro Horizontal Sensitivity'
  String get gyroSensitivityHorizontal => 'Gyro Horizontal Sensitivity';

  /// en: 'Adjust the gyroscope's horizontal (yaw) sensitivity.'
  String get gyroSensitivityHorizontalDescription =>
      'Adjust the gyroscope\'s horizontal (yaw) sensitivity.';

  /// en: 'Invert Gyro Horizontal Axis'
  String get invertGyroHorizontal => 'Invert Gyro Horizontal Axis';

  /// en: 'Invert the gyroscope's horizontal (yaw) axis.'
  String get invertGyroHorizontalDescription =>
      'Invert the gyroscope\'s horizontal (yaw) axis.';

  /// en: 'Buttons'
  String get genericButtons => 'Buttons';

  /// en: 'A'
  String get buttonA => 'A';

  /// en: 'B'
  String get buttonB => 'B';

  /// en: 'X'
  String get buttonX => 'X';

  /// en: 'Y'
  String get buttonY => 'Y';

  /// en: 'SELECT'
  String get buttonSelect => 'SELECT';

  /// en: 'START'
  String get buttonStart => 'START';

  /// en: 'HOME'
  String get buttonHome => 'HOME';

  /// en: 'Circle Pad'
  String get circlePad => 'Circle Pad';

  /// en: 'C-Stick'
  String get cStick => 'C-Stick';

  /// en: 'Up/Down Axis'
  String get axisVertical => 'Up/Down Axis';

  /// en: 'Left/Right Axis'
  String get axisHorizontal => 'Left/Right Axis';

  /// en: 'D-Pad (Axis)'
  String get dpadAxis => 'D-Pad (Axis)';

  /// en: 'Some controllers may not be able to map their D-pad as an axis. If that's the case, use the D-Pad (buttons) section.'
  String get dpadAxisDescription =>
      'Some controllers may not be able to map their D-pad as an axis. If that\'s the case, use the D-Pad (buttons) section.';

  /// en: 'D-Pad (Button)'
  String get dpadButtons => 'D-Pad (Button)';

  /// en: 'Only map the D-pad to these if you're facing issues with the D-Pad (Axis) button mappings.'
  String get dpadButtonsDescription =>
      'Only map the D-pad to these if you\'re facing issues with the D-Pad (Axis) button mappings.';

  /// en: 'Up'
  String get buttonUp => 'Up';

  /// en: 'Down'
  String get buttonDown => 'Down';

  /// en: 'Left'
  String get buttonLeft => 'Left';

  /// en: 'Right'
  String get buttonRight => 'Right';

  /// en: 'Triggers'
  String get triggers => 'Triggers';

  /// en: 'L'
  String get buttonL => 'L';

  /// en: 'R'
  String get buttonR => 'R';

  /// en: 'ZL'
  String get buttonZl => 'ZL';

  /// en: 'ZR'
  String get buttonZr => 'ZR';

  /// en: 'Hotkeys'
  String get hotkeys => 'Hotkeys';

  /// en: 'Swap Screens'
  String get hotkeySwapScreens => 'Swap Screens';

  /// en: 'Cycle Layouts'
  String get hotkeyCycleLayout => 'Cycle Layouts';

  /// en: 'Close Game'
  String get hotkeyCloseGame => 'Close Game';

  /// en: 'Toggle Pause'
  String get hotkeyPauseOrResume => 'Toggle Pause';

  /// en: 'Quicksave'
  String get hotkeyQuicksave => 'Quicksave';

  /// en: 'Quickload'
  String get hotkeyQuickload => 'Quickload';

  /// en: 'Miscellaneous'
  String get miscellaneous => 'Miscellaneous';

  /// en: 'Use Artic Controller when connected to Artic Base Server'
  String get useArticBaseController =>
      'Use Artic Controller when connected to Artic Base Server';

  /// en: 'Use the controls provided by Artic Base Server when connected to it instead of the configured input device.'
  String get useArticBaseControllerDescription =>
      'Use the controls provided by Artic Base Server when connected to it instead of the configured input device.';
}

// Path: settings.layout
class Translations$settings$layout$en {
  Translations$settings$layout$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Layout'
  String get title => 'Layout';

  /// en: 'Screen Orientation'
  String get screenOrientation => 'Screen Orientation';

  /// en: 'Automatic'
  String get screenOrientationAutoSensor => 'Automatic';

  /// en: 'Landscape'
  String get screenOrientationLandscape => 'Landscape';

  /// en: 'Reverse Landscape'
  String get screenOrientationLandscapeReverse => 'Reverse Landscape';

  /// en: 'Portrait'
  String get screenOrientationPortrait => 'Portrait';

  /// en: 'Reverse Portrait'
  String get screenOrientationPortraitReverse => 'Reverse Portrait';

  /// en: 'Landscape Custom Layout'
  String get customLandscapeLayout => 'Landscape Custom Layout';

  /// en: 'Portrait Custom Layout'
  String get customPortraitLayout => 'Portrait Custom Layout';

  /// en: 'Top Screen'
  String get topScreen => 'Top Screen';

  /// en: 'Bottom Screen'
  String get bottomScreen => 'Bottom Screen';

  /// en: 'X-Position'
  String get positionX => 'X-Position';

  /// en: 'Y-Position'
  String get positionY => 'Y-Position';

  /// en: 'Width'
  String get width => 'Width';

  /// en: 'Height'
  String get height => 'Height';
}

// Path: settings.audio
class Translations$settings$audio$en {
  Translations$settings$audio$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Audio'
  String get title => 'Audio';

  /// en: 'Volume'
  String get volume => 'Volume';

  /// en: 'The emulated 3DS console's own internal volume level, separate from the app's Master Volume.'
  String get volumeDescription =>
      'The emulated 3DS console\'s own internal volume level, separate from the app\'s Master Volume.';

  /// en: 'Audio Stretching'
  String get audioStretching => 'Audio Stretching';

  /// en: 'Stretches audio to reduce stuttering. Increases audio latency and slightly reduces performance.'
  String get audioStretchingDescription =>
      'Stretches audio to reduce stuttering. Increases audio latency and slightly reduces performance.';

  /// en: 'Realtime Audio'
  String get realtimeAudio => 'Realtime Audio';

  /// en: 'Reduces audio latency, but may cause instability in some applications. Only takes effect when Audio Stretching is disabled.'
  String get realtimeAudioDescription =>
      'Reduces audio latency, but may cause instability in some applications. Only takes effect when Audio Stretching is disabled.';

  /// en: 'Audio Input Type'
  String get audioInputType => 'Audio Input Type';

  /// en: 'Auto'
  String get audioInputTypeAuto => 'Auto';

  /// en: 'None'
  String get audioInputTypeNone => 'None';

  /// en: 'Static Noise'
  String get audioInputTypeStaticNoise => 'Static Noise';

  /// en: 'Real Device (Cubeb)'
  String get audioInputTypeRealCubeb => 'Real Device (Cubeb)';

  /// en: 'Real Device (OpenAL)'
  String get audioInputTypeRealOpenal => 'Real Device (OpenAL)';

  /// en: 'Sound Output Mode'
  String get soundOutputMode => 'Sound Output Mode';

  /// en: 'Mono'
  String get soundOutputModeMono => 'Mono';

  /// en: 'Stereo'
  String get soundOutputModeStereo => 'Stereo';

  /// en: 'Surround'
  String get soundOutputModeSurround => 'Surround';
}

// Path: settings.debug
class Translations$settings$debug$en {
  Translations$settings$debug$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Debug'
  String get title => 'Debug';

  /// en: 'These settings are for debugging purposes only. Changing them may cause instability.'
  String get warning =>
      'These settings are for debugging purposes only. Changing them may cause instability.';

  /// en: 'Log to Standard Output'
  String get logToConsole => 'Log to Standard Output';

  /// en: 'Also prints the native log to the standard output of Flutter.'
  String get logToConsoleDescription =>
      'Also prints the native log to the standard output of Flutter.';

  /// en: 'CPU Clock Speed'
  String get cpuClockSpeed => 'CPU Clock Speed';

  /// en: 'Over/Underclocks the emulated CPU. Not recommended.'
  String get cpuClockSpeedDescription =>
      'Over/Underclocks the emulated CPU. Not recommended.';

  /// en: 'CPU JIT'
  String get cpuJit => 'CPU JIT';

  /// en: 'Uses the Just-In-Time (JIT) compiler for CPU emulation. When disabled, a much slower interpreter is used instead.'
  String get cpuJitDescription =>
      'Uses the Just-In-Time (JIT) compiler for CPU emulation. When disabled, a much slower interpreter is used instead.';

  /// en: 'Hardware Shaders'
  String get hwShaders => 'Hardware Shaders';

  /// en: 'Uses hardware shaders to emulate 3DS shaders, instead of the software renderer. Disabling this greatly reduces performance.'
  String get hwShadersDescription =>
      'Uses hardware shaders to emulate 3DS shaders, instead of the software renderer. Disabling this greatly reduces performance.';

  /// en: 'VSync'
  String get vsync => 'VSync';

  /// en: 'Synchronizes rendering with the host device's display refresh rate.'
  String get vsyncDescription =>
      'Synchronizes rendering with the host device\'s display refresh rate.';

  /// en: 'Renderer Debug'
  String get rendererDebug => 'Renderer Debug';

  /// en: 'Enables additional renderer debugging features. Reduces performance.'
  String get rendererDebugDescription =>
      'Enables additional renderer debugging features. Reduces performance.';

  /// en: 'Instant Debug Log'
  String get instantDebugLog => 'Instant Debug Log';

  /// en: 'Writes to the debug log immediately instead of buffering. Reduces performance.'
  String get instantDebugLogDescription =>
      'Writes to the debug log immediately instead of buffering. Reduces performance.';

  /// en: 'Delay Start for LLE Modules'
  String get delayStartLleModules => 'Delay Start for LLE Modules';

  /// en: 'Delays the start of LLE modules to work around race conditions.'
  String get delayStartLleModulesDescription =>
      'Delays the start of LLE modules to work around race conditions.';

  /// en: 'Deterministic Async Operations'
  String get deterministicAsyncOperations => 'Deterministic Async Operations';

  /// en: 'Forces asynchronous operations to run in a deterministic order. Reduces performance.'
  String get deterministicAsyncOperationsDescription =>
      'Forces asynchronous operations to run in a deterministic order. Reduces performance.';
}

// Path: settings.theme
class Translations$settings$theme$en {
  Translations$settings$theme$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Theme and Color'
  String get title => 'Theme and Color';

  /// en: 'Theme Style'
  String get themeStyle => 'Theme Style';

  /// en: 'Material You'
  String get materialYou => 'Material You';

  /// en: 'Uses colors extracted from your device's wallpaper.'
  String get materialYouDescription =>
      'Uses colors extracted from your device\'s wallpaper.';

  /// en: 'Static Theme Color'
  String get staticThemeColor => 'Static Theme Color';

  /// en: 'Default'
  String get staticThemeColorDefault => 'Default';

  /// en: 'Blue'
  String get staticThemeColorBlue => 'Blue';

  /// en: 'Cyan'
  String get staticThemeColorCyan => 'Cyan';

  /// en: 'Red'
  String get staticThemeColorRed => 'Red';

  /// en: 'Green'
  String get staticThemeColorGreen => 'Green';

  /// en: 'Yellow'
  String get staticThemeColorYellow => 'Yellow';

  /// en: 'Orange'
  String get staticThemeColorOrange => 'Orange';

  /// en: 'Violet'
  String get staticThemeColorViolet => 'Violet';

  /// en: 'Pink'
  String get staticThemeColorPink => 'Pink';

  /// en: 'Gray'
  String get staticThemeColorGray => 'Gray';

  /// en: 'Theme Mode'
  String get themeMode => 'Theme Mode';

  /// en: 'Follow System'
  String get themeModeFollowSystem => 'Follow System';

  /// en: 'Light'
  String get themeModeLight => 'Light';

  /// en: 'Dark'
  String get themeModeDark => 'Dark';

  /// en: 'Use Black Backgrounds'
  String get useBlackBackgrounds => 'Use Black Backgrounds';

  /// en: 'Uses black backgrounds when dark mode is enabled, instead of dark gray.'
  String get useBlackBackgroundsDescription =>
      'Uses black backgrounds when dark mode is enabled, instead of dark gray.';
}

// Path: settings.themes
class Translations$settings$themes$en {
  Translations$settings$themes$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Azahar'
  String get azahar => 'Azahar';

  /// en: 'Legacy'
  String get legacy => 'Legacy';
}

// Path: settings.accessibility
class Translations$settings$accessibility$en {
  Translations$settings$accessibility$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Accessibility'
  String get title => 'Accessibility';

  /// en: 'Reduce Motion'
  String get reduceMotion => 'Reduce Motion';

  /// en: 'Reduces animations and motion effects throughout the app.'
  String get reduceMotionDescription =>
      'Reduces animations and motion effects throughout the app.';
}

// Path: settings.advanced
class Translations$settings$advanced$en {
  Translations$settings$advanced$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Advanced Settings'
  String get title => 'Advanced Settings';

  /// en: 'Animation Speed'
  String get animationSpeedLabel => 'Animation Speed';

  /// en: 'Controls how fast UI transitions play.'
  String get animationSpeedDescription =>
      'Controls how fast UI transitions play.';

  late final Translations$settings$advanced$animationSpeed$en animationSpeed =
      Translations$settings$advanced$animationSpeed$en.internal(_root);
}

// Path: settings.language
class Translations$settings$language$en {
  Translations$settings$language$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Language'
  String get title => 'Language';

  /// en: 'System default'
  String get systemDefault => 'System default';

  /// en: 'English'
  String get english => 'English';

  /// en: 'Japanese (日本語)'
  String get japanese => 'Japanese (日本語)';
}

// Path: settings.system.countries
class Translations$settings$system$countries$en {
  Translations$settings$system$countries$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Japan'
  String get japan => 'Japan';

  /// en: 'Anguilla'
  String get anguilla => 'Anguilla';

  /// en: 'Antigua and Barbuda'
  String get antiguaAndBarbuda => 'Antigua and Barbuda';

  /// en: 'Argentina'
  String get argentina => 'Argentina';

  /// en: 'Aruba'
  String get aruba => 'Aruba';

  /// en: 'Bahamas'
  String get bahamas => 'Bahamas';

  /// en: 'Barbados'
  String get barbados => 'Barbados';

  /// en: 'Belize'
  String get belize => 'Belize';

  /// en: 'Bolivia'
  String get bolivia => 'Bolivia';

  /// en: 'Brazil'
  String get brazil => 'Brazil';

  /// en: 'British Virgin Islands'
  String get britishVirginIslands => 'British Virgin Islands';

  /// en: 'Canada'
  String get canada => 'Canada';

  /// en: 'Cayman Islands'
  String get caymanIslands => 'Cayman Islands';

  /// en: 'Chile'
  String get chile => 'Chile';

  /// en: 'Colombia'
  String get colombia => 'Colombia';

  /// en: 'Costa Rica'
  String get costaRica => 'Costa Rica';

  /// en: 'Dominica'
  String get dominica => 'Dominica';

  /// en: 'Dominican Republic'
  String get dominicanRepublic => 'Dominican Republic';

  /// en: 'Ecuador'
  String get ecuador => 'Ecuador';

  /// en: 'El Salvador'
  String get elSalvador => 'El Salvador';

  /// en: 'French Guiana'
  String get frenchGuiana => 'French Guiana';

  /// en: 'Grenada'
  String get grenada => 'Grenada';

  /// en: 'Guadeloupe'
  String get guadeloupe => 'Guadeloupe';

  /// en: 'Guatemala'
  String get guatemala => 'Guatemala';

  /// en: 'Guyana'
  String get guyana => 'Guyana';

  /// en: 'Haiti'
  String get haiti => 'Haiti';

  /// en: 'Honduras'
  String get honduras => 'Honduras';

  /// en: 'Jamaica'
  String get jamaica => 'Jamaica';

  /// en: 'Martinique'
  String get martinique => 'Martinique';

  /// en: 'Mexico'
  String get mexico => 'Mexico';

  /// en: 'Montserrat'
  String get montserrat => 'Montserrat';

  /// en: 'Netherlands Antilles'
  String get netherlandsAntilles => 'Netherlands Antilles';

  /// en: 'Nicaragua'
  String get nicaragua => 'Nicaragua';

  /// en: 'Panama'
  String get panama => 'Panama';

  /// en: 'Paraguay'
  String get paraguay => 'Paraguay';

  /// en: 'Peru'
  String get peru => 'Peru';

  /// en: 'Saint Kitts and Nevis'
  String get saintKittsAndNevis => 'Saint Kitts and Nevis';

  /// en: 'Saint Lucia'
  String get saintLucia => 'Saint Lucia';

  /// en: 'Saint Vincent and the Grenadines'
  String get saintVincentAndTheGrenadines => 'Saint Vincent and the Grenadines';

  /// en: 'Suriname'
  String get suriname => 'Suriname';

  /// en: 'Trinidad and Tobago'
  String get trinidadAndTobago => 'Trinidad and Tobago';

  /// en: 'Turks and Caicos Islands'
  String get turksAndCaicosIslands => 'Turks and Caicos Islands';

  /// en: 'United States'
  String get unitedStates => 'United States';

  /// en: 'Uruguay'
  String get uruguay => 'Uruguay';

  /// en: 'US Virgin Islands'
  String get usVirginIslands => 'US Virgin Islands';

  /// en: 'Venezuela'
  String get venezuela => 'Venezuela';

  /// en: 'Albania'
  String get albania => 'Albania';

  /// en: 'Australia'
  String get australia => 'Australia';

  /// en: 'Austria'
  String get austria => 'Austria';

  /// en: 'Belgium'
  String get belgium => 'Belgium';

  /// en: 'Bosnia and Herzegovina'
  String get bosniaAndHerzegovina => 'Bosnia and Herzegovina';

  /// en: 'Botswana'
  String get botswana => 'Botswana';

  /// en: 'Bulgaria'
  String get bulgaria => 'Bulgaria';

  /// en: 'Croatia'
  String get croatia => 'Croatia';

  /// en: 'Cyprus'
  String get cyprus => 'Cyprus';

  /// en: 'Czech Republic'
  String get czechRepublic => 'Czech Republic';

  /// en: 'Denmark'
  String get denmark => 'Denmark';

  /// en: 'Estonia'
  String get estonia => 'Estonia';

  /// en: 'Finland'
  String get finland => 'Finland';

  /// en: 'France'
  String get france => 'France';

  /// en: 'Germany'
  String get germany => 'Germany';

  /// en: 'Greece'
  String get greece => 'Greece';

  /// en: 'Hungary'
  String get hungary => 'Hungary';

  /// en: 'Iceland'
  String get iceland => 'Iceland';

  /// en: 'Ireland'
  String get ireland => 'Ireland';

  /// en: 'Italy'
  String get italy => 'Italy';

  /// en: 'Latvia'
  String get latvia => 'Latvia';

  /// en: 'Lesotho'
  String get lesotho => 'Lesotho';

  /// en: 'Liechtenstein'
  String get liechtenstein => 'Liechtenstein';

  /// en: 'Lithuania'
  String get lithuania => 'Lithuania';

  /// en: 'Luxembourg'
  String get luxembourg => 'Luxembourg';

  /// en: 'Macedonia'
  String get macedonia => 'Macedonia';

  /// en: 'Malta'
  String get malta => 'Malta';

  /// en: 'Montenegro'
  String get montenegro => 'Montenegro';

  /// en: 'Mozambique'
  String get mozambique => 'Mozambique';

  /// en: 'Namibia'
  String get namibia => 'Namibia';

  /// en: 'Netherlands'
  String get netherlands => 'Netherlands';

  /// en: 'New Zealand'
  String get newZealand => 'New Zealand';

  /// en: 'Norway'
  String get norway => 'Norway';

  /// en: 'Poland'
  String get poland => 'Poland';

  /// en: 'Portugal'
  String get portugal => 'Portugal';

  /// en: 'Romania'
  String get romania => 'Romania';

  /// en: 'Russia'
  String get russia => 'Russia';

  /// en: 'Serbia'
  String get serbia => 'Serbia';

  /// en: 'Slovakia'
  String get slovakia => 'Slovakia';

  /// en: 'Slovenia'
  String get slovenia => 'Slovenia';

  /// en: 'South Africa'
  String get southAfrica => 'South Africa';

  /// en: 'Spain'
  String get spain => 'Spain';

  /// en: 'Swaziland'
  String get swaziland => 'Swaziland';

  /// en: 'Sweden'
  String get sweden => 'Sweden';

  /// en: 'Switzerland'
  String get switzerland => 'Switzerland';

  /// en: 'Turkey'
  String get turkey => 'Turkey';

  /// en: 'United Kingdom'
  String get unitedKingdom => 'United Kingdom';

  /// en: 'Zambia'
  String get zambia => 'Zambia';

  /// en: 'Zimbabwe'
  String get zimbabwe => 'Zimbabwe';

  /// en: 'Azerbaijan'
  String get azerbaijan => 'Azerbaijan';

  /// en: 'Mauritania'
  String get mauritania => 'Mauritania';

  /// en: 'Mali'
  String get mali => 'Mali';

  /// en: 'Niger'
  String get niger => 'Niger';

  /// en: 'Chad'
  String get chad => 'Chad';

  /// en: 'Sudan'
  String get sudan => 'Sudan';

  /// en: 'Eritrea'
  String get eritrea => 'Eritrea';

  /// en: 'Djibouti'
  String get djibouti => 'Djibouti';

  /// en: 'Somalia'
  String get somalia => 'Somalia';

  /// en: 'Andorra'
  String get andorra => 'Andorra';

  /// en: 'Gibraltar'
  String get gibraltar => 'Gibraltar';

  /// en: 'Guernsey'
  String get guernsey => 'Guernsey';

  /// en: 'Isle of Man'
  String get isleOfMan => 'Isle of Man';

  /// en: 'Jersey'
  String get jersey => 'Jersey';

  /// en: 'Monaco'
  String get monaco => 'Monaco';

  /// en: 'Taiwan'
  String get taiwan => 'Taiwan';

  /// en: 'South Korea'
  String get southKorea => 'South Korea';

  /// en: 'Hong Kong'
  String get hongKong => 'Hong Kong';

  /// en: 'Macau'
  String get macau => 'Macau';

  /// en: 'Indonesia'
  String get indonesia => 'Indonesia';

  /// en: 'Singapore'
  String get singapore => 'Singapore';

  /// en: 'Thailand'
  String get thailand => 'Thailand';

  /// en: 'Philippines'
  String get philippines => 'Philippines';

  /// en: 'Malaysia'
  String get malaysia => 'Malaysia';

  /// en: 'China'
  String get china => 'China';

  /// en: 'United Arab Emirates'
  String get unitedArabEmirates => 'United Arab Emirates';

  /// en: 'India'
  String get india => 'India';

  /// en: 'Egypt'
  String get egypt => 'Egypt';

  /// en: 'Oman'
  String get oman => 'Oman';

  /// en: 'Qatar'
  String get qatar => 'Qatar';

  /// en: 'Kuwait'
  String get kuwait => 'Kuwait';

  /// en: 'Saudi Arabia'
  String get saudiArabia => 'Saudi Arabia';

  /// en: 'Syria'
  String get syria => 'Syria';

  /// en: 'Bahrain'
  String get bahrain => 'Bahrain';

  /// en: 'Jordan'
  String get jordan => 'Jordan';

  /// en: 'San Marino'
  String get sanMarino => 'San Marino';

  /// en: 'Vatican City'
  String get vaticanCity => 'Vatican City';

  /// en: 'Bermuda'
  String get bermuda => 'Bermuda';
}

// Path: settings.advanced.animationSpeed
class Translations$settings$advanced$animationSpeed$en {
  Translations$settings$advanced$animationSpeed$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Fast'
  String get fast => 'Fast';

  /// en: 'Normal'
  String get normal => 'Normal';

  /// en: 'Slow'
  String get slow => 'Slow';
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
          'common.cancel' => 'Cancel',
          'common.save' => 'Save',
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
          'setup.permissions.title' => 'Permissions',
          'setup.permissions.description' =>
            'Grant optional permissions to use specific features of the emulator',
          'setup.dataFolders.title' => 'Data Folders',
          'setup.dataFolders.description' =>
            'Select data folders\n(User folder is required)',
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
          'setup.userDirectory.movingData' => 'Moving Data',
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
          'setup.done.description' =>
            'You\'re all set.\nEnjoy using the emulator!',
          'setup.done.continueLabel' => 'Continue',
          'home.games' => 'Applications',
          'home.options' => 'Options',
          'games.searchHint' => 'Search Applications',
          'games.emptyGamelist' =>
            'No files were found or no game directory has been selected yet.',
          'games.properties' => 'Properties',
          'games.propertiesNotLoaded' =>
            'This application\'s properties are not yet available. Please wait for the application list to finish loading and try again.',
          'games.play' => 'Play',
          'games.openFolder' => 'Open Folder',
          'games.delete' => 'Delete',
          'games.shortcut' => 'Create Shortcut',
          'games.cheats' => 'Cheats',
          'games.cheatsUnavailable' =>
            'Cheats are not available yet in this version of the app.',
          'games.compress' => 'Compress',
          'games.titleIdLabel' => ({required Object id}) => 'ID: ${id}',
          'games.fileLabel' => ({required Object name}) => 'File: ${name}',
          'games.deleteShaderCache' => 'Delete Shader Cache',
          'games.deleteCacheSelectBackend' =>
            'Select the graphics API whose shader cache should be deleted',
          'games.vulkan' => 'Vulkan',
          'games.opengles' => 'OpenGLES',
          'games.shaderCacheDeleted' => 'Shader cache deleted',
          'games.createShortcut' => 'Create Shortcut',
          'games.shortcutName' => 'Shortcut Name',
          'games.shortcutNameEmpty' => 'The shortcut name cannot be empty',
          'games.shortcutImageStretchToggle' => 'Stretch image',
          'games.editIcon' => 'Edit icon',
          'games.openApp' => 'Application',
          'games.openSaveDir' => 'Save Data',
          'games.openUpdates' => 'Updates',
          'games.openDlc' => 'DLC',
          'games.openExtra' => 'Extra Data',
          'games.openTextures' => 'Textures',
          'games.openMods' => 'Mods',
          'games.uninstallCia' => 'Application',
          'games.uninstallUpdates' => 'Updates',
          'games.uninstallDlc' => 'DLC',
          'games.regionJapan' => 'Japan',
          'games.regionNorthAmerica' => 'North America',
          'games.regionEurope' => 'Europe',
          'games.regionAustralia' => 'Australia',
          'games.regionChina' => 'China',
          'games.regionKorea' => 'Korea',
          'games.regionTaiwan' => 'Taiwan',
          'games.regionFree' => 'Region free',
          'games.invalidRegion' => 'Invalid region',
          'emulation.loading' => 'Loading',
          'emulation.terminating' => 'Closing',
          'emulation.preparingShaders' => 'Preparing Shaders',
          'emulation.buildingShaders' => 'Building Shaders',
          'emulation.shaderProgress' =>
            ({required Object progress, required Object max}) =>
                '${progress}/${max}',
          'emulation.menuSectionEmulation' => 'Emulation',
          'emulation.pauseEmulation' => 'Pause Emulation',
          'emulation.resumeEmulation' => 'Resume Emulation',
          'emulation.advanceFrame' => 'Advance Frame',
          'emulation.menuSectionTools' => 'Tools',
          'emulation.cheats' => 'Cheats',
          'emulation.noCheats' => 'No cheats',
          'emulation.addCheat' => 'Add Cheat',
          'emulation.cheatName' => 'Name',
          'emulation.cheatNotes' => 'Notes',
          'emulation.cheatCode' => 'Code',
          'emulation.cheatNameEmpty' => 'Name can\'t be empty',
          'emulation.cheatCodeEmpty' => 'Code can\'t be empty',
          'emulation.cheatErrorOnLine' =>
            ({required Object line}) => 'Error on line ${line}',
          'emulation.menuSectionOther' => 'Other',
          'emulation.closeGame' => 'Close Game',
          'emulation.closeGameMessage' =>
            'Are you sure that you would like to close the current game?',
          'applets.softwareKeyboard' => 'Software Keyboard',
          'applets.iForgot' => 'I Forgot',
          'applets.standardMii' => 'Standard Mii',
          'options.emulatorSettings' => 'Settings',
          'options.emulatorSettingsDescription' =>
            'Configure emulator settings',
          'options.articBaseConnect' => 'Connect to Artic Base',
          'options.articBaseConnectDescription' =>
            'Connect to a real console that is running an Artic Base server',
          'options.installGameContent' => 'Install CIA file',
          'options.installGameContentDescription' =>
            'Install applications, updates or DLC',
          'options.installGameContentSuccessTitle' => 'CIA install complete',
          'options.installGameContentFailureTitle' => 'CIA install failed',
          'options.setupSystemFiles' => 'System Files',
          'options.setupSystemFilesDescription' =>
            'Perform system file operations such as installing system files or booting the Home Menu',
          'options.shareLog' => 'Share Log',
          'options.shareLogDescription' =>
            'Share Azahar\'s log file to debug issues',
          'options.shareLogNotFound' => 'No log file found',
          'options.gpuDriverManager' => 'GPU Driver Manager',
          'options.gpuDriverManagerDescription' =>
            'Install alternative drivers for potentially better performance or accuracy',
          'options.selectUserFolder' => 'Select User Folder',
          'options.selectUserFolderDescription' =>
            'Changes the files that Azahar uses to load applications',
          'options.selectGamesFolder' => 'Select Applications Folder',
          'options.selectGamesFolderDescription' =>
            'Allows Azahar to populate the application list',
          'options.themeAndColor' => 'Theme and Color',
          'options.themeAndColorDescription' => 'Modify the look of the app',
          'options.media' => 'Media',
          'options.mediaDescription' =>
            'Background playback and media session settings',
          'options.accessibility' => 'Accessibility',
          'options.accessibilityDescription' =>
            'Motion and other accessibility settings',
          'options.advanced' => 'Advanced Settings',
          'options.advancedDescription' => 'Configure more advanced options',
          'options.about' => 'About',
          'options.aboutDescription' => 'Build version, credits, and more',
          'options.general' => 'Profile',
          'options.generalDescription' => 'Profile and birthday settings',
          'options.useLegacySettingsUI' => 'Use Legacy Settings UI',
          'options.useLegacySettingsUIDescription' =>
            'Switch back to the previous Options screen design',
          'options.useLegacySettingsUIDialog.title' => 'Switch Settings UI?',
          'options.useLegacySettingsUIDialog.message' =>
            'This changes how the Options screen looks. You can switch back at any time.',
          'options.useLegacySettingsUIDialog.confirm' => 'Switch',
          'options.searchHint' => 'Search Options',
          'options.searchPrompt' => 'Type to search the settings',
          'options.searchNoResults' => 'No matching settings',
          'options.history' => 'History',
          'options.historyEmpty' =>
            'Settings you change or open will appear here.',
          'options.pinned' => 'Pinned',
          'options.pinnedEmpty' => 'Press and hold a setting to pin it here.',
          'options.clear' => 'Delete',
          'options.clearHistoryTitle' => 'Delete history?',
          'options.clearHistoryMessage' =>
            'This removes every item from the history. Your settings are not changed.',
          'options.clearPinnedTitle' => 'Unpin all items?',
          'options.clearPinnedMessage' =>
            'This removes every pinned item. Your settings are not changed.',
          'options.removeFromHistory' => 'Remove from history',
          'options.pin' => 'Pin',
          'options.unpin' => 'Unpin',
          'options.pinLimitReached' =>
            ({required Object count}) => 'You can pin up to ${count} items.',
          'options.groups.general' => 'General',
          'options.groups.emulation' => 'Emulation',
          'options.groups.clock' => 'Clock',
          'options.groups.graphics' => 'Graphics',
          'options.groups.networking' => 'Networking',
          'options.groups.controls' => 'Controls',
          'options.groups.tools' => 'Tools',
          'options.groups.folderSettings' => 'Folder Settings',
          'options.groups.other' => 'Other',
          'options.groups.accessibility' => 'Accessibility',
          'systemFiles.title' => 'System Files',
          'systemFiles.preamble' =>
            'Azahar needs console unique data and firmware files from a real console to be able to use some of its features. Such files and data can be set up with the Azahar Artic Setup Tool.\n\nNotes:\n• This operation will install console unique data to Azahar, do not share your user or nand folders after performing the setup process!\n• While doing the setup process, Azahar will link to the console running the setup tool. You can unlink the console later from the System Files tab in the emulator options menu.\n• Do not go online with both Azahar and your 3DS console at the same time after setting up system files, as this could cause issues.\n• Old 3DS setup is needed for the New 3DS setup to work (setting up both is recommended).\n• Both setup modes will work regardless of the model of the console running the setup tool.',
          'systemFiles.connectSetupTool' => 'Connect to Artic Setup Tool',
          'systemFiles.deleteSystemFiles' => 'Unlink Console Unique Data',
          'systemFiles.deleteSystemFilesDescription' =>
            'This action will unlink your real console from Azahar, with the following consequences:\n• Your OTP, SecureInfo and LocalFriendCodeSeed will be removed from Azahar.\n• Your friend list will reset and you will be logged out of your NNID/PNID account.\n• System files and eshop titles obtained through Azahar will become inaccessible until the same console is linked again using the setup tool (save data will not be lost).\n\nContinue?',
          'systemFiles.bootHomeMenu' => 'Boot the HOME Menu',
          'systemFiles.start' => 'Start',
          'systemFiles.runSystemSetup' =>
            'Run System Setup when the HOME Menu is launched',
          'systemFiles.showHomeApps' =>
            'Show HOME menu apps in Applications list',
          'systemFiles.detecting' =>
            'Fetching current system files status, please wait...',
          'systemFiles.preparing' => 'Preparing setup, please wait...',
          'systemFiles.enterAddress' => 'Enter Artic Setup Tool address',
          'systemFiles.old3ds' => 'Old 3DS Setup',
          'systemFiles.new3ds' => 'New 3DS Setup',
          'systemFiles.statusPossible' => 'Setup is possible.',
          'systemFiles.statusCompleted' => 'Setup already completed.',
          'systemFiles.statusOld3dsNeeded' =>
            'Old 3DS setup is required first.',
          'gpuDriverManager.title' => 'GPU Driver Manager',
          'gpuDriverManager.systemDriver' => 'System Driver',
          'gpuDriverManager.installDriver' => 'Install Driver',
          'gpuDriverManager.installDriverDescription' =>
            'Install a custom driver from a zip file',
          'gpuDriverManager.installFailed' => 'Failed to install the driver',
          'articBaseConnectDialog.title' => 'Enter Artic Base server address',
          'about.title' => 'About',
          'about.description' => 'An open-source 3DS emulator',
          'about.contributors' => 'Contributors',
          'about.contributorsDescription' =>
            'Contributors who made Azahar possible',
          'about.licenses' => 'Licenses',
          'about.licensesDescription' => 'Projects used by Azahar for Android',
          'about.build' => 'Build',
          'settings.title' => 'Settings',
          'settings.resetToDefault' => 'Reset to Default',
          'settings.resetToDefaultDialog.title' => 'Reset to Default?',
          'settings.resetToDefaultDialog.message' =>
            'This will reset all settings to their default values. This cannot be undone.',
          'settings.resetToDefaultDialog.confirm' => 'Reset',
          'settings.sliderDialog.kDefault' => 'Default',
          'settings.sliderDialog.invalidValue' =>
            ({
              required Object title,
              required Object min,
              required Object max,
            }) => '${title}: value must be between ${min} and ${max}.',
          'settings.inputBindingDialog.waitingForInput' =>
            'Press a button on your controller',
          'settings.general.title' => 'Profile',
          'settings.general.frameLimitEnable' => 'Limit Speed',
          'settings.general.frameLimitEnableDescription' =>
            'When enabled, emulation speed will be limited to a specified percentage of normal speed.',
          'settings.general.frameLimitSlider' => 'Limit Speed Percent',
          'settings.general.frameLimitSliderDescription' =>
            'Specifies the percentage to limit emulation speed. With the default of 100% emulation will be limited to normal speed. Values higher or lower will increase or decrease the speed limit.',
          'settings.emulation.title' => 'Emulation',
          'settings.emulation.useHighLevelEmulation' =>
            'Use High-Level Emulation',
          'settings.emulation.useHighLevelEmulationDescription' =>
            'Uses a reimplementation of the system applets instead of low level emulation. Turning this off may be required for some online features to work.',
          'settings.networking.title' => 'Networking',
          'settings.networking.accessNetwork' => 'Access Network',
          'settings.networking.accessNetworkDescription' =>
            'Allows the emulated console to access online features by using low level emulation for the system applets and the modules required for them.',
          'settings.networking.useWireless' => 'Use Wireless',
          'settings.networking.useWirelessDescription' =>
            'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.',
          'settings.networking.emulatedNetwork' => 'Emulated Network',
          'settings.networking.emulatedNetworkDescription' =>
            'Inspect the Wi-Fi access points the emulated console can see, and optionally replace them with virtual ones.',
          'settings.networking.realNetworkTab' => 'Real Network',
          'settings.networking.virtualNetworkTab' => 'Virtual Network',
          'settings.networking.hiddenNetwork' => '(Hidden Network)',
          'settings.networking.ssid' => 'SSID',
          'settings.networking.bssid' => 'BSSID',
          'settings.networking.frequency' => 'Frequency',
          'settings.networking.noAccessPointsFound' =>
            'No access points found.',
          'settings.networking.useVirtualNetwork' => 'Use Virtual Network',
          'settings.networking.useVirtualNetworkDescription' =>
            'Reports the access points below to the emulated console instead of the real ones.',
          'settings.networking.addAccessPoint' => 'Add Access Point',
          'settings.networking.editAccessPoint' => 'Edit Access Point',
          'settings.networking.ssidHint' => 'Leave blank for a hidden network',
          'settings.networking.bssidHint' => '00:00:00:00:00:00',
          'settings.networking.frequencyHint' => 'MHz, e.g. 2437',
          'settings.networking.levelHint' => 'Signal level in dBm, e.g. -50',
          'settings.networking.copySelected' => 'Copy selected',
          'settings.networking.pasteAccessPoints' => 'Paste',
          'settings.media.title' => 'Media',
          'settings.media.groupApp' => 'App',
          'settings.media.groupEmulator' => 'Emulator',
          'settings.media.masterVolume' => 'Master Volume',
          'settings.media.masterVolumeDescription' =>
            'Controls the app\'s overall output volume independently of the emulated game\'s own volume setting. Hardware volume buttons adjust this value.',
          'settings.media.masterVolumePercent' =>
            ({required Object value}) => '${value}%',
          'settings.media.treatAudioAsMediaSession' => 'Treat as Android Media',
          'settings.media.treatAudioAsMediaSessionDescription' =>
            'Shows playback controls on the lock screen and notification like a music app, and keeps audio playing when the app is in the background instead of pausing automatically.',
          'settings.graphics.title' => 'Graphics',
          'settings.graphics.renderer' => 'Renderer',
          'settings.graphics.graphicsApi' => 'Graphics API',
          'settings.graphics.graphicsApiOpengles' => 'OpenGLES',
          'settings.graphics.graphicsApiVulkan' => 'Vulkan',
          'settings.graphics.spirvShaderGen' =>
            'Enable SPIR-V shader generation',
          'settings.graphics.spirvShaderGenDescription' =>
            'Emits the fragment shader used to emulate PICA using SPIR-V instead of GLSL',
          'settings.graphics.asyncShaders' =>
            'Enable asynchronous shader compilation',
          'settings.graphics.asyncShadersDescription' =>
            'Compiles shaders in the background to reduce stuttering during gameplay. When enabled expect temporary graphical glitches',
          'settings.graphics.internalResolution' => 'Internal Resolution',
          'settings.graphics.internalResolutionDescription' =>
            'Specifies the resolution used to render at. A high resolution will improve visual quality a lot but is also quite heavy on performance and might cause glitches in certain applications.',
          'settings.graphics.internalResolutionNative' => 'Native (400x240)',
          'settings.graphics.internalResolution2x' => '2x Native (800x480)',
          'settings.graphics.internalResolution3x' => '3x Native (1200x720)',
          'settings.graphics.internalResolution4x' => '4x Native (1600x960)',
          'settings.graphics.internalResolution5x' => '5x Native (2000x1200)',
          'settings.graphics.internalResolution6x' => '6x Native (2400x1440)',
          'settings.graphics.internalResolution7x' => '7x Native (2800x1680)',
          'settings.graphics.internalResolution8x' => '8x Native (3200x1920)',
          'settings.graphics.internalResolution9x' => '9x Native (3600x2160)',
          'settings.graphics.internalResolution10x' => '10x Native (4000x2400)',
          'settings.graphics.linearFiltering' => 'Linear Filtering',
          'settings.graphics.linearFilteringDescription' =>
            'Enables linear filtering, which causes game visuals to appear smoother.',
          'settings.graphics.shadersAccurateMul' => 'Accurate Multiplication',
          'settings.graphics.shadersAccurateMulDescription' =>
            'Uses more accurate multiplication in hardware shaders, which may fix some graphical bugs. When enabled, performance will be reduced.',
          'settings.graphics.useDiskShaderCache' => 'Disk Shader Cache',
          'settings.graphics.useDiskShaderCacheDescription' =>
            'Reduce stuttering by storing and loading generated shaders to disk. It cannot be used without Enabling Hardware Shader.',
          'settings.graphics.textureFilterName' => 'Texture Filter',
          'settings.graphics.textureFilterDescription' =>
            'Enhances the visuals of applications by applying a filter to textures. The supported filters are Anime4K Ultrafast, Bicubic, ScaleForce, xBRZ freescale, and MMPX.',
          'settings.graphics.textureFilterNone' => 'None',
          'settings.graphics.textureFilterAnime4k' => 'Anime4K',
          'settings.graphics.textureFilterBicubic' => 'Bicubic',
          'settings.graphics.textureFilterScaleforce' => 'ScaleForce',
          'settings.graphics.textureFilterXbrz' => 'xBRZ',
          'settings.graphics.textureFilterMmpx' => 'MMPX',
          'settings.graphics.delayRenderThread' => 'Delay game render thread',
          'settings.graphics.delayRenderThreadDescription' =>
            'Delay the game render thread when it submits data to the GPU. Helps with performance issues in the (very few) applications with dynamic framerates.',
          'settings.graphics.stereoscopy' => 'Stereoscopy',
          'settings.graphics.render3d' => 'Stereoscopic 3D Mode',
          'settings.graphics.render3dOff' => 'Off',
          'settings.graphics.render3dSideBySide' => 'Side by Side',
          'settings.graphics.render3dReverseSideBySide' =>
            'Reverse Side by Side',
          'settings.graphics.render3dAnaglyph' => 'Anaglyph',
          'settings.graphics.render3dInterlaced' => 'Interlaced',
          'settings.graphics.render3dReverseInterlaced' => 'Reverse Interlaced',
          'settings.graphics.render3dCardboardVr' => 'Cardboard VR',
          'settings.graphics.factor3d' => 'Depth',
          'settings.graphics.factor3dDescription' =>
            'Specifies the value of the 3D slider. This should be set to higher than 0% when Stereoscopic 3D is enabled.',
          'settings.graphics.disableRightEyeRender' =>
            'Disable Right Eye Render',
          'settings.graphics.disableRightEyeRenderDescription' =>
            'Greatly improves performance in some applications, but can cause flickering in others.',
          'settings.graphics.cardboardVr' => 'Cardboard VR',
          'settings.graphics.cardboardScreenSize' => 'Cardboard Screen Size',
          'settings.graphics.cardboardScreenSizeDescription' =>
            'Scales the screen to a percentage of its original size.',
          'settings.graphics.cardboardXShift' => 'Horizontal Shift',
          'settings.graphics.cardboardXShiftDescription' =>
            'Specifies the percentage of empty space to shift the screens horizontally. Positive values move the two eyes closer to the middle, while negative values move them away.',
          'settings.graphics.cardboardYShift' => 'Vertical Shift',
          'settings.graphics.cardboardYShiftDescription' =>
            'Specifies the percentage of empty space to shift the screens vertically. Positive values move the two eyes towards the bottom, while negative values move them towards the top.',
          'settings.graphics.utility' => 'Utility',
          'settings.graphics.dumpTextures' => 'Dump Textures',
          'settings.graphics.dumpTexturesDescription' =>
            'Textures are dumped to dump/textures/[Title ID]/.',
          'settings.graphics.customTextures' => 'Custom Textures',
          'settings.graphics.customTexturesDescription' =>
            'Textures are loaded from load/textures/[Title ID]/.',
          'settings.graphics.asyncCustomLoading' =>
            'Async Custom Texture Loading',
          'settings.graphics.asyncCustomLoadingDescription' =>
            'Load custom textures asynchronously with background threads to reduce loading stutter.',
          'settings.graphics.advanced' => 'Advanced',
          'settings.graphics.textureSamplingName' => 'Texture Sampling',
          'settings.graphics.textureSamplingDescription' =>
            'Overrides the sampling filter used by games. This can be useful in certain cases with poorly behaved games when upscaling. If unsure, set this to Game Controlled.',
          'settings.graphics.textureSamplingGameControlled' =>
            'Game Controlled',
          'settings.graphics.textureSamplingNearestNeighbor' =>
            'Nearest Neighbor',
          'settings.graphics.textureSamplingLinear' => 'Linear',
          'settings.system.title' => 'System',
          'settings.system.emulationSettings' => 'Emulation Settings',
          'settings.system.new3ds' => 'New 3DS Mode',
          'settings.system.new3dsDescription' =>
            'Enables New 3DS exclusive features that are not present on the Old 3DS.',
          'settings.system.lleApplets' => 'LLE Applets',
          'settings.system.lleAppletsDescription' =>
            'Uses low level emulation of the system applets when available, instead of high level emulation.',
          'settings.system.requiredOnlineLleModules' =>
            'Enable Required Online LLE Modules',
          'settings.system.requiredOnlineLleModulesDescription' =>
            'Uses low level emulation for modules required for online features, even if LLE Applets is disabled.',
          'settings.system.profileSettings' => 'Profile Settings',
          'settings.system.emulatedRegion' => 'Emulated Region',
          'settings.system.regionAutoSelect' => 'Auto-Select',
          'settings.system.regionJapan' => 'JPN',
          'settings.system.regionUsa' => 'USA',
          'settings.system.regionEurope' => 'EUR',
          'settings.system.regionAustralia' => 'AUS',
          'settings.system.regionChina' => 'CHN',
          'settings.system.regionKorea' => 'KOR',
          'settings.system.regionTaiwan' => 'TWN',
          'settings.system.country' => 'Country',
          'settings.system.emulatedLanguage' => 'Emulated Language',
          'settings.system.languageJapanese' => 'Japanese (日本語)',
          'settings.system.languageEnglish' => 'English',
          'settings.system.languageFrench' => 'French (Français)',
          'settings.system.languageGerman' => 'German (Deutsch)',
          'settings.system.languageItalian' => 'Italian (Italiano)',
          'settings.system.languageSpanish' => 'Spanish (Español)',
          'settings.system.languageSimplifiedChinese' =>
            'Simplified Chinese (简体中文)',
          'settings.system.languageKorean' => 'Korean (한국어)',
          'settings.system.languageDutch' => 'Dutch (Nederlands)',
          'settings.system.languagePortuguese' => 'Portuguese (Português)',
          'settings.system.languageRussian' => 'Russian (Русский)',
          'settings.system.languageTraditionalChinese' =>
            'Traditional Chinese (正體中文)',
          'settings.system.username' => 'Username',
          'settings.system.playCoins' => 'Play Coins',
          'settings.system.stepsPerHour' => 'Steps per Hour',
          'settings.system.stepsPerHourDescription' =>
            'The average number of steps to be generated per hour, for pedometer-based features.',
          'settings.system.scanRealWifiNetworks' =>
            'Scan for Real Wi-Fi Networks',
          'settings.system.scanRealWifiNetworksDescription' =>
            'Reports real nearby Wi-Fi networks as 3DS StreetPass/SpotPass-compatible networks, instead of fake ones.',
          'settings.system.consoleId' => 'Console ID',
          'settings.system.consoleIdDescription' =>
            'Tap to regenerate the console ID. Some applications may use this as a form of parental lock.',
          'settings.system.macAddress' => 'MAC Address',
          'settings.system.macAddressDescription' =>
            'Tap to regenerate the network MAC address.',
          'settings.system.birthday' => 'Birthday',
          'settings.system.birthdayMonth' => 'Birthday Month',
          'settings.system.birthdayDay' => 'Birthday Day',
          'settings.system.monthJanuary' => 'January',
          'settings.system.monthFebruary' => 'February',
          'settings.system.monthMarch' => 'March',
          'settings.system.monthApril' => 'April',
          'settings.system.monthMay' => 'May',
          'settings.system.monthJune' => 'June',
          'settings.system.monthJuly' => 'July',
          'settings.system.monthAugust' => 'August',
          'settings.system.monthSeptember' => 'September',
          'settings.system.monthOctober' => 'October',
          'settings.system.monthNovember' => 'November',
          'settings.system.monthDecember' => 'December',
          'settings.system.clock' => 'Clock',
          'settings.system.initClock' => 'Initial Clock',
          'settings.system.initClockDeviceClock' => 'Device Clock',
          'settings.system.initClockSimulatedClock' => 'Simulated Clock',
          'settings.system.simulatedClock' => 'Simulated Clock',
          'settings.system.pluginLoader' => 'Plugin Loader',
          'settings.system.pluginLoaderEnable' => 'Plugin Loader',
          'settings.system.pluginLoaderEnableDescription' =>
            'Allows arbitrary plugins to be loaded into the emulated game.',
          'settings.system.allowPluginLoader' => 'Allow Plugin Loader',
          'settings.system.allowPluginLoaderDescription' =>
            'Allows the game itself to request plugins to be loaded.',
          'settings.system.countries.japan' => 'Japan',
          'settings.system.countries.anguilla' => 'Anguilla',
          'settings.system.countries.antiguaAndBarbuda' =>
            'Antigua and Barbuda',
          'settings.system.countries.argentina' => 'Argentina',
          'settings.system.countries.aruba' => 'Aruba',
          'settings.system.countries.bahamas' => 'Bahamas',
          'settings.system.countries.barbados' => 'Barbados',
          'settings.system.countries.belize' => 'Belize',
          'settings.system.countries.bolivia' => 'Bolivia',
          'settings.system.countries.brazil' => 'Brazil',
          'settings.system.countries.britishVirginIslands' =>
            'British Virgin Islands',
          'settings.system.countries.canada' => 'Canada',
          'settings.system.countries.caymanIslands' => 'Cayman Islands',
          'settings.system.countries.chile' => 'Chile',
          'settings.system.countries.colombia' => 'Colombia',
          'settings.system.countries.costaRica' => 'Costa Rica',
          'settings.system.countries.dominica' => 'Dominica',
          'settings.system.countries.dominicanRepublic' => 'Dominican Republic',
          'settings.system.countries.ecuador' => 'Ecuador',
          'settings.system.countries.elSalvador' => 'El Salvador',
          'settings.system.countries.frenchGuiana' => 'French Guiana',
          'settings.system.countries.grenada' => 'Grenada',
          'settings.system.countries.guadeloupe' => 'Guadeloupe',
          'settings.system.countries.guatemala' => 'Guatemala',
          'settings.system.countries.guyana' => 'Guyana',
          'settings.system.countries.haiti' => 'Haiti',
          'settings.system.countries.honduras' => 'Honduras',
          'settings.system.countries.jamaica' => 'Jamaica',
          'settings.system.countries.martinique' => 'Martinique',
          'settings.system.countries.mexico' => 'Mexico',
          'settings.system.countries.montserrat' => 'Montserrat',
          'settings.system.countries.netherlandsAntilles' =>
            'Netherlands Antilles',
          'settings.system.countries.nicaragua' => 'Nicaragua',
          'settings.system.countries.panama' => 'Panama',
          'settings.system.countries.paraguay' => 'Paraguay',
          'settings.system.countries.peru' => 'Peru',
          'settings.system.countries.saintKittsAndNevis' =>
            'Saint Kitts and Nevis',
          'settings.system.countries.saintLucia' => 'Saint Lucia',
          'settings.system.countries.saintVincentAndTheGrenadines' =>
            'Saint Vincent and the Grenadines',
          'settings.system.countries.suriname' => 'Suriname',
          'settings.system.countries.trinidadAndTobago' =>
            'Trinidad and Tobago',
          'settings.system.countries.turksAndCaicosIslands' =>
            'Turks and Caicos Islands',
          'settings.system.countries.unitedStates' => 'United States',
          'settings.system.countries.uruguay' => 'Uruguay',
          'settings.system.countries.usVirginIslands' => 'US Virgin Islands',
          'settings.system.countries.venezuela' => 'Venezuela',
          'settings.system.countries.albania' => 'Albania',
          'settings.system.countries.australia' => 'Australia',
          'settings.system.countries.austria' => 'Austria',
          'settings.system.countries.belgium' => 'Belgium',
          'settings.system.countries.bosniaAndHerzegovina' =>
            'Bosnia and Herzegovina',
          'settings.system.countries.botswana' => 'Botswana',
          'settings.system.countries.bulgaria' => 'Bulgaria',
          'settings.system.countries.croatia' => 'Croatia',
          'settings.system.countries.cyprus' => 'Cyprus',
          'settings.system.countries.czechRepublic' => 'Czech Republic',
          'settings.system.countries.denmark' => 'Denmark',
          'settings.system.countries.estonia' => 'Estonia',
          'settings.system.countries.finland' => 'Finland',
          'settings.system.countries.france' => 'France',
          'settings.system.countries.germany' => 'Germany',
          'settings.system.countries.greece' => 'Greece',
          'settings.system.countries.hungary' => 'Hungary',
          'settings.system.countries.iceland' => 'Iceland',
          'settings.system.countries.ireland' => 'Ireland',
          'settings.system.countries.italy' => 'Italy',
          'settings.system.countries.latvia' => 'Latvia',
          'settings.system.countries.lesotho' => 'Lesotho',
          'settings.system.countries.liechtenstein' => 'Liechtenstein',
          'settings.system.countries.lithuania' => 'Lithuania',
          'settings.system.countries.luxembourg' => 'Luxembourg',
          'settings.system.countries.macedonia' => 'Macedonia',
          'settings.system.countries.malta' => 'Malta',
          'settings.system.countries.montenegro' => 'Montenegro',
          'settings.system.countries.mozambique' => 'Mozambique',
          'settings.system.countries.namibia' => 'Namibia',
          'settings.system.countries.netherlands' => 'Netherlands',
          'settings.system.countries.newZealand' => 'New Zealand',
          'settings.system.countries.norway' => 'Norway',
          'settings.system.countries.poland' => 'Poland',
          'settings.system.countries.portugal' => 'Portugal',
          'settings.system.countries.romania' => 'Romania',
          'settings.system.countries.russia' => 'Russia',
          'settings.system.countries.serbia' => 'Serbia',
          'settings.system.countries.slovakia' => 'Slovakia',
          'settings.system.countries.slovenia' => 'Slovenia',
          'settings.system.countries.southAfrica' => 'South Africa',
          'settings.system.countries.spain' => 'Spain',
          'settings.system.countries.swaziland' => 'Swaziland',
          'settings.system.countries.sweden' => 'Sweden',
          'settings.system.countries.switzerland' => 'Switzerland',
          'settings.system.countries.turkey' => 'Turkey',
          'settings.system.countries.unitedKingdom' => 'United Kingdom',
          'settings.system.countries.zambia' => 'Zambia',
          'settings.system.countries.zimbabwe' => 'Zimbabwe',
          'settings.system.countries.azerbaijan' => 'Azerbaijan',
          'settings.system.countries.mauritania' => 'Mauritania',
          'settings.system.countries.mali' => 'Mali',
          'settings.system.countries.niger' => 'Niger',
          'settings.system.countries.chad' => 'Chad',
          'settings.system.countries.sudan' => 'Sudan',
          'settings.system.countries.eritrea' => 'Eritrea',
          'settings.system.countries.djibouti' => 'Djibouti',
          'settings.system.countries.somalia' => 'Somalia',
          'settings.system.countries.andorra' => 'Andorra',
          'settings.system.countries.gibraltar' => 'Gibraltar',
          'settings.system.countries.guernsey' => 'Guernsey',
          'settings.system.countries.isleOfMan' => 'Isle of Man',
          'settings.system.countries.jersey' => 'Jersey',
          'settings.system.countries.monaco' => 'Monaco',
          'settings.system.countries.taiwan' => 'Taiwan',
          'settings.system.countries.southKorea' => 'South Korea',
          'settings.system.countries.hongKong' => 'Hong Kong',
          'settings.system.countries.macau' => 'Macau',
          'settings.system.countries.indonesia' => 'Indonesia',
          'settings.system.countries.singapore' => 'Singapore',
          'settings.system.countries.thailand' => 'Thailand',
          'settings.system.countries.philippines' => 'Philippines',
          'settings.system.countries.malaysia' => 'Malaysia',
          'settings.system.countries.china' => 'China',
          'settings.system.countries.unitedArabEmirates' =>
            'United Arab Emirates',
          _ => null,
        } ??
        switch (path) {
          'settings.system.countries.india' => 'India',
          'settings.system.countries.egypt' => 'Egypt',
          'settings.system.countries.oman' => 'Oman',
          'settings.system.countries.qatar' => 'Qatar',
          'settings.system.countries.kuwait' => 'Kuwait',
          'settings.system.countries.saudiArabia' => 'Saudi Arabia',
          'settings.system.countries.syria' => 'Syria',
          'settings.system.countries.bahrain' => 'Bahrain',
          'settings.system.countries.jordan' => 'Jordan',
          'settings.system.countries.sanMarino' => 'San Marino',
          'settings.system.countries.vaticanCity' => 'Vatican City',
          'settings.system.countries.bermuda' => 'Bermuda',
          'settings.camera.title' => 'Camera',
          'settings.camera.innerCamera' => 'Inner Camera',
          'settings.camera.outerLeftCamera' => 'Outer Left Camera',
          'settings.camera.outerRightCamera' => 'Outer Right Camera',
          'settings.camera.imageSource' => 'Camera Image Source',
          'settings.camera.imageSourceDescription' =>
            'Sets the image source of the virtual camera. You can use an image file, or a device camera when supported.',
          'settings.camera.imageSourceBlank' => 'Blank',
          'settings.camera.imageSourceStillImage' => 'Still Image',
          'settings.camera.imageSourceDeviceCamera' => 'Device Camera',
          'settings.camera.cameraDevice' => 'Camera',
          'settings.camera.cameraDeviceDescription' =>
            'If the "Image Source" setting is set to "Device Camera", this sets the physical camera to use.',
          'settings.camera.cameraDeviceDefault' => 'Default',
          'settings.camera.cameraDeviceAnyFront' => 'Any Front Camera',
          'settings.camera.cameraDeviceAnyBack' => 'Any Back Camera',
          'settings.camera.imageFlip' => 'Flip',
          'settings.camera.imageFlipNone' => 'None',
          'settings.camera.imageFlipHorizontal' => 'Horizontal',
          'settings.camera.imageFlipVertical' => 'Vertical',
          'settings.camera.imageFlipReverse' => 'Reverse',
          'settings.gamepad.title' => 'Gamepad',
          'settings.gamepad.controllerInputMode' => 'Controller Input Mode',
          'settings.gamepad.controllerInputModeDescription' =>
            'Choose how physical game controllers are mapped to 3DS input.',
          'settings.gamepad.controllerInputModeManual' => 'Manual',
          'settings.gamepad.controllerInputModeAutoDetect' => 'Auto-Detect',
          'settings.gamepad.invertLeftStickYAxis' => 'Invert Left Stick Y Axis',
          'settings.gamepad.invertLeftStickYAxisDescription' =>
            'Invert the left stick\'s vertical axis when using auto-detected controllers.',
          'settings.gamepad.gyroSettings' => 'Gyro Settings',
          'settings.gamepad.gyroInputSource' => 'Gyro Input Source',
          'settings.gamepad.gyroInputSourceDescription' =>
            'Choose whether motion (gyro) controls come from this device or a connected controller\'s gyroscope. Falls back to this device if the controller has no gyroscope.',
          'settings.gamepad.gyroInputSourceDevice' => 'Device',
          'settings.gamepad.gyroInputSourceController' => 'Controller',
          'settings.gamepad.gyroSensitivityVertical' =>
            'Gyro Vertical Sensitivity',
          'settings.gamepad.gyroSensitivityVerticalDescription' =>
            'Adjust the gyroscope\'s vertical (pitch) sensitivity.',
          'settings.gamepad.invertGyroVertical' => 'Invert Gyro Vertical Axis',
          'settings.gamepad.invertGyroVerticalDescription' =>
            'Invert the gyroscope\'s vertical (pitch) axis.',
          'settings.gamepad.gyroSensitivityHorizontal' =>
            'Gyro Horizontal Sensitivity',
          'settings.gamepad.gyroSensitivityHorizontalDescription' =>
            'Adjust the gyroscope\'s horizontal (yaw) sensitivity.',
          'settings.gamepad.invertGyroHorizontal' =>
            'Invert Gyro Horizontal Axis',
          'settings.gamepad.invertGyroHorizontalDescription' =>
            'Invert the gyroscope\'s horizontal (yaw) axis.',
          'settings.gamepad.genericButtons' => 'Buttons',
          'settings.gamepad.buttonA' => 'A',
          'settings.gamepad.buttonB' => 'B',
          'settings.gamepad.buttonX' => 'X',
          'settings.gamepad.buttonY' => 'Y',
          'settings.gamepad.buttonSelect' => 'SELECT',
          'settings.gamepad.buttonStart' => 'START',
          'settings.gamepad.buttonHome' => 'HOME',
          'settings.gamepad.circlePad' => 'Circle Pad',
          'settings.gamepad.cStick' => 'C-Stick',
          'settings.gamepad.axisVertical' => 'Up/Down Axis',
          'settings.gamepad.axisHorizontal' => 'Left/Right Axis',
          'settings.gamepad.dpadAxis' => 'D-Pad (Axis)',
          'settings.gamepad.dpadAxisDescription' =>
            'Some controllers may not be able to map their D-pad as an axis. If that\'s the case, use the D-Pad (buttons) section.',
          'settings.gamepad.dpadButtons' => 'D-Pad (Button)',
          'settings.gamepad.dpadButtonsDescription' =>
            'Only map the D-pad to these if you\'re facing issues with the D-Pad (Axis) button mappings.',
          'settings.gamepad.buttonUp' => 'Up',
          'settings.gamepad.buttonDown' => 'Down',
          'settings.gamepad.buttonLeft' => 'Left',
          'settings.gamepad.buttonRight' => 'Right',
          'settings.gamepad.triggers' => 'Triggers',
          'settings.gamepad.buttonL' => 'L',
          'settings.gamepad.buttonR' => 'R',
          'settings.gamepad.buttonZl' => 'ZL',
          'settings.gamepad.buttonZr' => 'ZR',
          'settings.gamepad.hotkeys' => 'Hotkeys',
          'settings.gamepad.hotkeySwapScreens' => 'Swap Screens',
          'settings.gamepad.hotkeyCycleLayout' => 'Cycle Layouts',
          'settings.gamepad.hotkeyCloseGame' => 'Close Game',
          'settings.gamepad.hotkeyPauseOrResume' => 'Toggle Pause',
          'settings.gamepad.hotkeyQuicksave' => 'Quicksave',
          'settings.gamepad.hotkeyQuickload' => 'Quickload',
          'settings.gamepad.miscellaneous' => 'Miscellaneous',
          'settings.gamepad.useArticBaseController' =>
            'Use Artic Controller when connected to Artic Base Server',
          'settings.gamepad.useArticBaseControllerDescription' =>
            'Use the controls provided by Artic Base Server when connected to it instead of the configured input device.',
          'settings.layout.title' => 'Layout',
          'settings.layout.screenOrientation' => 'Screen Orientation',
          'settings.layout.screenOrientationAutoSensor' => 'Automatic',
          'settings.layout.screenOrientationLandscape' => 'Landscape',
          'settings.layout.screenOrientationLandscapeReverse' =>
            'Reverse Landscape',
          'settings.layout.screenOrientationPortrait' => 'Portrait',
          'settings.layout.screenOrientationPortraitReverse' =>
            'Reverse Portrait',
          'settings.layout.customLandscapeLayout' => 'Landscape Custom Layout',
          'settings.layout.customPortraitLayout' => 'Portrait Custom Layout',
          'settings.layout.topScreen' => 'Top Screen',
          'settings.layout.bottomScreen' => 'Bottom Screen',
          'settings.layout.positionX' => 'X-Position',
          'settings.layout.positionY' => 'Y-Position',
          'settings.layout.width' => 'Width',
          'settings.layout.height' => 'Height',
          'settings.audio.title' => 'Audio',
          'settings.audio.volume' => 'Volume',
          'settings.audio.volumeDescription' =>
            'The emulated 3DS console\'s own internal volume level, separate from the app\'s Master Volume.',
          'settings.audio.audioStretching' => 'Audio Stretching',
          'settings.audio.audioStretchingDescription' =>
            'Stretches audio to reduce stuttering. Increases audio latency and slightly reduces performance.',
          'settings.audio.realtimeAudio' => 'Realtime Audio',
          'settings.audio.realtimeAudioDescription' =>
            'Reduces audio latency, but may cause instability in some applications. Only takes effect when Audio Stretching is disabled.',
          'settings.audio.audioInputType' => 'Audio Input Type',
          'settings.audio.audioInputTypeAuto' => 'Auto',
          'settings.audio.audioInputTypeNone' => 'None',
          'settings.audio.audioInputTypeStaticNoise' => 'Static Noise',
          'settings.audio.audioInputTypeRealCubeb' => 'Real Device (Cubeb)',
          'settings.audio.audioInputTypeRealOpenal' => 'Real Device (OpenAL)',
          'settings.audio.soundOutputMode' => 'Sound Output Mode',
          'settings.audio.soundOutputModeMono' => 'Mono',
          'settings.audio.soundOutputModeStereo' => 'Stereo',
          'settings.audio.soundOutputModeSurround' => 'Surround',
          'settings.debug.title' => 'Debug',
          'settings.debug.warning' =>
            'These settings are for debugging purposes only. Changing them may cause instability.',
          'settings.debug.logToConsole' => 'Log to Standard Output',
          'settings.debug.logToConsoleDescription' =>
            'Also prints the native log to the standard output of Flutter.',
          'settings.debug.cpuClockSpeed' => 'CPU Clock Speed',
          'settings.debug.cpuClockSpeedDescription' =>
            'Over/Underclocks the emulated CPU. Not recommended.',
          'settings.debug.cpuJit' => 'CPU JIT',
          'settings.debug.cpuJitDescription' =>
            'Uses the Just-In-Time (JIT) compiler for CPU emulation. When disabled, a much slower interpreter is used instead.',
          'settings.debug.hwShaders' => 'Hardware Shaders',
          'settings.debug.hwShadersDescription' =>
            'Uses hardware shaders to emulate 3DS shaders, instead of the software renderer. Disabling this greatly reduces performance.',
          'settings.debug.vsync' => 'VSync',
          'settings.debug.vsyncDescription' =>
            'Synchronizes rendering with the host device\'s display refresh rate.',
          'settings.debug.rendererDebug' => 'Renderer Debug',
          'settings.debug.rendererDebugDescription' =>
            'Enables additional renderer debugging features. Reduces performance.',
          'settings.debug.instantDebugLog' => 'Instant Debug Log',
          'settings.debug.instantDebugLogDescription' =>
            'Writes to the debug log immediately instead of buffering. Reduces performance.',
          'settings.debug.delayStartLleModules' =>
            'Delay Start for LLE Modules',
          'settings.debug.delayStartLleModulesDescription' =>
            'Delays the start of LLE modules to work around race conditions.',
          'settings.debug.deterministicAsyncOperations' =>
            'Deterministic Async Operations',
          'settings.debug.deterministicAsyncOperationsDescription' =>
            'Forces asynchronous operations to run in a deterministic order. Reduces performance.',
          'settings.theme.title' => 'Theme and Color',
          'settings.theme.themeStyle' => 'Theme Style',
          'settings.theme.materialYou' => 'Material You',
          'settings.theme.materialYouDescription' =>
            'Uses colors extracted from your device\'s wallpaper.',
          'settings.theme.staticThemeColor' => 'Static Theme Color',
          'settings.theme.staticThemeColorDefault' => 'Default',
          'settings.theme.staticThemeColorBlue' => 'Blue',
          'settings.theme.staticThemeColorCyan' => 'Cyan',
          'settings.theme.staticThemeColorRed' => 'Red',
          'settings.theme.staticThemeColorGreen' => 'Green',
          'settings.theme.staticThemeColorYellow' => 'Yellow',
          'settings.theme.staticThemeColorOrange' => 'Orange',
          'settings.theme.staticThemeColorViolet' => 'Violet',
          'settings.theme.staticThemeColorPink' => 'Pink',
          'settings.theme.staticThemeColorGray' => 'Gray',
          'settings.theme.themeMode' => 'Theme Mode',
          'settings.theme.themeModeFollowSystem' => 'Follow System',
          'settings.theme.themeModeLight' => 'Light',
          'settings.theme.themeModeDark' => 'Dark',
          'settings.theme.useBlackBackgrounds' => 'Use Black Backgrounds',
          'settings.theme.useBlackBackgroundsDescription' =>
            'Uses black backgrounds when dark mode is enabled, instead of dark gray.',
          'settings.themes.azahar' => 'Azahar',
          'settings.themes.legacy' => 'Legacy',
          'settings.accessibility.title' => 'Accessibility',
          'settings.accessibility.reduceMotion' => 'Reduce Motion',
          'settings.accessibility.reduceMotionDescription' =>
            'Reduces animations and motion effects throughout the app.',
          'settings.advanced.title' => 'Advanced Settings',
          'settings.advanced.animationSpeedLabel' => 'Animation Speed',
          'settings.advanced.animationSpeedDescription' =>
            'Controls how fast UI transitions play.',
          'settings.advanced.animationSpeed.fast' => 'Fast',
          'settings.advanced.animationSpeed.normal' => 'Normal',
          'settings.advanced.animationSpeed.slow' => 'Slow',
          'settings.language.title' => 'Language',
          'settings.language.systemDefault' => 'System default',
          'settings.language.english' => 'English',
          'settings.language.japanese' => 'Japanese (日本語)',
          _ => null,
        };
  }
}
