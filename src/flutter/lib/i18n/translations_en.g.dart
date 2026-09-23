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
  late final Translations$settings$en settings =
      Translations$settings$en.internal(_root);
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
}

// Path: settings
class Translations$settings$en {
  Translations$settings$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'Settings'
  String get title => 'Settings';

  late final Translations$settings$sliderDialog$en sliderDialog =
      Translations$settings$sliderDialog$en.internal(_root);
  late final Translations$settings$general$en general =
      Translations$settings$general$en.internal(_root);
  late final Translations$settings$graphics$en graphics =
      Translations$settings$graphics$en.internal(_root);
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

// Path: settings.general
class Translations$settings$general$en {
  Translations$settings$general$en.internal(this._root);

  final Translations _root; // ignore: unused_field

  // Translations

  /// en: 'General'
  String get title => 'General';

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
      'home.games' => 'Applications',
      'home.options' => 'Options',
      'games.searchHint' => 'Search Applications',
      'games.emptyGamelist' =>
        'No files were found or no game directory has been selected yet.',
      'emulation.loading' => 'Loading…',
      'emulation.preparingShaders' => 'Preparing Shaders',
      'emulation.buildingShaders' => 'Building Shaders',
      'emulation.shaderProgress' =>
        ({required Object progress, required Object max}) =>
            '${progress}/${max}',
      'emulation.menuSectionOther' => 'Other',
      'emulation.closeGame' => 'Close Game',
      'emulation.closeGameMessage' =>
        'Are you sure that you would like to close the current game?',
      'applets.softwareKeyboard' => 'Software Keyboard',
      'applets.iForgot' => 'I Forgot',
      'applets.standardMii' => 'Standard Mii',
      'options.emulatorSettings' => 'Settings',
      'options.emulatorSettingsDescription' => 'Configure emulator settings',
      'settings.title' => 'Settings',
      'settings.sliderDialog.kDefault' => 'Default',
      'settings.sliderDialog.invalidValue' =>
        ({required Object title, required Object min, required Object max}) =>
            '${title}: value must be between ${min} and ${max}.',
      'settings.general.title' => 'General',
      'settings.general.frameLimitEnable' => 'Limit Speed',
      'settings.general.frameLimitEnableDescription' =>
        'When enabled, emulation speed will be limited to a specified percentage of normal speed.',
      'settings.general.frameLimitSlider' => 'Limit Speed Percent',
      'settings.general.frameLimitSliderDescription' =>
        'Specifies the percentage to limit emulation speed. With the default of 100% emulation will be limited to normal speed. Values higher or lower will increase or decrease the speed limit.',
      'settings.graphics.title' => 'Graphics',
      'settings.graphics.renderer' => 'Renderer',
      'settings.graphics.graphicsApi' => 'Graphics API',
      'settings.graphics.graphicsApiOpengles' => 'OpenGLES',
      'settings.graphics.graphicsApiVulkan' => 'Vulkan',
      'settings.graphics.spirvShaderGen' => 'Enable SPIR-V shader generation',
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
      'settings.graphics.render3dReverseSideBySide' => 'Reverse Side by Side',
      'settings.graphics.render3dAnaglyph' => 'Anaglyph',
      'settings.graphics.render3dInterlaced' => 'Interlaced',
      'settings.graphics.render3dReverseInterlaced' => 'Reverse Interlaced',
      'settings.graphics.render3dCardboardVr' => 'Cardboard VR',
      'settings.graphics.factor3d' => 'Depth',
      'settings.graphics.factor3dDescription' =>
        'Specifies the value of the 3D slider. This should be set to higher than 0% when Stereoscopic 3D is enabled.',
      'settings.graphics.disableRightEyeRender' => 'Disable Right Eye Render',
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
      'settings.graphics.asyncCustomLoading' => 'Async Custom Texture Loading',
      'settings.graphics.asyncCustomLoadingDescription' =>
        'Load custom textures asynchronously with background threads to reduce loading stutter.',
      'settings.graphics.advanced' => 'Advanced',
      'settings.graphics.textureSamplingName' => 'Texture Sampling',
      'settings.graphics.textureSamplingDescription' =>
        'Overrides the sampling filter used by games. This can be useful in certain cases with poorly behaved games when upscaling. If unsure, set this to Game Controlled.',
      'settings.graphics.textureSamplingGameControlled' => 'Game Controlled',
      'settings.graphics.textureSamplingNearestNeighbor' => 'Nearest Neighbor',
      'settings.graphics.textureSamplingLinear' => 'Linear',
      _ => null,
    };
  }
}
