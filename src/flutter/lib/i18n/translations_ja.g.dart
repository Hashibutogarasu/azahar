///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsJa extends Translations
    with BaseTranslations<AppLocale, Translations> {
  /// You can call this constructor and build your own translation instance of this locale.
  /// Constructing via the enum [AppLocale.build] is preferred.
  TranslationsJa({
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
             locale: AppLocale.ja,
             overrides: overrides ?? {},
             cardinalResolver: cardinalResolver,
             ordinalResolver: ordinalResolver,
           ),
       super(
         cardinalResolver: cardinalResolver,
         ordinalResolver: ordinalResolver,
       ) {
    _meta.setFlatMapFunction(_flatMapFunction);
  }

  /// Metadata for the translations of <ja>.
  final TranslationMetadata<AppLocale, Translations> _meta;
  @override
  TranslationMetadata<AppLocale, Translations> get $meta => _meta;

  /// Access flat map
  @override
  dynamic operator [](String key) => _meta.getTranslation(key) ?? super[key];

  late final TranslationsJa _root = this; // ignore: unused_field

  @override
  TranslationsJa $copyWith({
    TranslationMetadata<AppLocale, Translations>? meta,
  }) => TranslationsJa(meta: meta ?? this.$meta);

  // Translations
  @override
  String get appName => 'Azahar';
  @override
  late final _Translations$common$ja common = _Translations$common$ja._(_root);
  @override
  late final _Translations$setup$ja setup = _Translations$setup$ja._(_root);
  @override
  late final _Translations$home$ja home = _Translations$home$ja._(_root);
  @override
  late final _Translations$games$ja games = _Translations$games$ja._(_root);
  @override
  late final _Translations$emulation$ja emulation =
      _Translations$emulation$ja._(_root);
  @override
  late final _Translations$applets$ja applets = _Translations$applets$ja._(
    _root,
  );
  @override
  late final _Translations$options$ja options = _Translations$options$ja._(
    _root,
  );
  @override
  late final _Translations$systemFiles$ja systemFiles =
      _Translations$systemFiles$ja._(_root);
  @override
  late final _Translations$gpuDriverManager$ja gpuDriverManager =
      _Translations$gpuDriverManager$ja._(_root);
  @override
  late final _Translations$articBaseConnectDialog$ja articBaseConnectDialog =
      _Translations$articBaseConnectDialog$ja._(_root);
  @override
  late final _Translations$about$ja about = _Translations$about$ja._(_root);
  @override
  late final _Translations$settings$ja settings = _Translations$settings$ja._(
    _root,
  );
}

// Path: common
class _Translations$common$ja extends Translations$common$en {
  _Translations$common$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get cancel => 'キャンセル';
  @override
  String get save => '保存';
}

// Path: setup
class _Translations$setup$ja extends Translations$setup$en {
  _Translations$setup$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get next => '次へ';
  @override
  String get back => '戻る';
  @override
  String get stepComplete => '完了！';
  @override
  String get warningSkip => 'スキップ';
  @override
  String get warningCancel => 'キャンセル';
  @override
  String get warningHelp => 'ヘルプ';
  @override
  String get close => '閉じる';
  @override
  late final _Translations$setup$welcome$ja welcome =
      _Translations$setup$welcome$ja._(_root);
  @override
  late final _Translations$setup$permissions$ja permissions =
      _Translations$setup$permissions$ja._(_root);
  @override
  late final _Translations$setup$dataFolders$ja dataFolders =
      _Translations$setup$dataFolders$ja._(_root);
  @override
  late final _Translations$setup$notifications$ja notifications =
      _Translations$setup$notifications$ja._(_root);
  @override
  late final _Translations$setup$microphone$ja microphone =
      _Translations$setup$microphone$ja._(_root);
  @override
  late final _Translations$setup$camera$ja camera =
      _Translations$setup$camera$ja._(_root);
  @override
  late final _Translations$setup$userDirectory$ja userDirectory =
      _Translations$setup$userDirectory$ja._(_root);
  @override
  late final _Translations$setup$gamesDirectory$ja gamesDirectory =
      _Translations$setup$gamesDirectory$ja._(_root);
  @override
  late final _Translations$setup$done$ja done = _Translations$setup$done$ja._(
    _root,
  );
}

// Path: home
class _Translations$home$ja extends Translations$home$en {
  _Translations$home$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get games => 'アプリケーション';
  @override
  String get options => 'オプション';
}

// Path: games
class _Translations$games$ja extends Translations$games$en {
  _Translations$games$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get searchHint => 'アプリケーションを検索';
  @override
  String get emptyGamelist => 'ファイルが見つからないか、ゲームディレクトリがまだ選択されていません。';
  @override
  String get properties => 'プロパティ';
  @override
  String get propertiesNotLoaded =>
      'このアプリケーションのプロパティはまだ利用できません。アプリケーション一覧の読み込みが完了するまでお待ちください。';
  @override
  String get play => 'プレイ';
  @override
  String get openFolder => 'フォルダを開く';
  @override
  String get delete => '削除';
  @override
  String get shortcut => 'ショートカットを作成';
  @override
  String get cheats => 'チート';
  @override
  String get cheatsUnavailable => 'このバージョンのアプリではチートはまだ利用できません。';
  @override
  String get compress => '圧縮';
  @override
  String titleIdLabel({required Object id}) => 'ID: ${id}';
  @override
  String fileLabel({required Object name}) => 'ファイル: ${name}';
  @override
  String get deleteShaderCache => 'シェーダーキャッシュを削除';
  @override
  String get deleteCacheSelectBackend => 'シェーダーキャッシュを削除するグラフィックスAPIを選択してください';
  @override
  String get vulkan => 'Vulkan';
  @override
  String get opengles => 'OpenGLES';
  @override
  String get shaderCacheDeleted => 'シェーダーキャッシュを削除しました';
  @override
  String get createShortcut => 'ショートカットを作成';
  @override
  String get shortcutName => 'ショートカット名';
  @override
  String get shortcutNameEmpty => 'ショートカット名を空にすることはできません';
  @override
  String get shortcutImageStretchToggle => '画像を引き伸ばす';
  @override
  String get editIcon => 'アイコンを編集';
  @override
  String get openApp => 'アプリケーション';
  @override
  String get openSaveDir => 'セーブデータ';
  @override
  String get openUpdates => 'アップデート';
  @override
  String get openDlc => 'DLC';
  @override
  String get openExtra => '追加データ';
  @override
  String get openTextures => 'テクスチャ';
  @override
  String get openMods => 'MOD';
  @override
  String get uninstallCia => 'アプリケーション';
  @override
  String get uninstallUpdates => 'アップデート';
  @override
  String get uninstallDlc => 'DLC';
  @override
  String get regionJapan => '日本';
  @override
  String get regionNorthAmerica => '北米';
  @override
  String get regionEurope => '欧州';
  @override
  String get regionAustralia => 'オーストラリア';
  @override
  String get regionChina => '中国';
  @override
  String get regionKorea => '韓国';
  @override
  String get regionTaiwan => '台湾';
  @override
  String get regionFree => 'リージョンフリー';
  @override
  String get invalidRegion => '無効なリージョン';
}

// Path: emulation
class _Translations$emulation$ja extends Translations$emulation$en {
  _Translations$emulation$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get loading => '読み込み中';
  @override
  String get terminating => '終了しています';
  @override
  String get preparingShaders => 'シェーダーを準備中';
  @override
  String get buildingShaders => 'シェーダーをビルド中';
  @override
  String shaderProgress({required Object progress, required Object max}) =>
      '${progress}/${max}';
  @override
  String get menuSectionEmulation => 'エミュレーション';
  @override
  String get pauseEmulation => 'エミュレーションを一時停止';
  @override
  String get resumeEmulation => 'エミュレーションを再開';
  @override
  String get advanceFrame => 'フレーム送り';
  @override
  String get menuSectionTools => 'ツール';
  @override
  String get cheats => 'チート';
  @override
  String get noCheats => 'チートがありません';
  @override
  String get addCheat => 'チートを追加';
  @override
  String get cheatName => '名前';
  @override
  String get cheatNotes => 'メモ';
  @override
  String get cheatCode => 'コード';
  @override
  String get cheatNameEmpty => '名前を入力してください';
  @override
  String get cheatCodeEmpty => 'コードを入力してください';
  @override
  String cheatErrorOnLine({required Object line}) => '${line}行目にエラーがあります';
  @override
  String get menuSectionOther => 'その他';
  @override
  String get closeGame => 'ゲームを終了';
  @override
  String get closeGameMessage => '現在のゲームを終了してもよろしいですか？';
}

// Path: applets
class _Translations$applets$ja extends Translations$applets$en {
  _Translations$applets$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get softwareKeyboard => 'ソフトウェアキーボード';
  @override
  String get iForgot => '忘れました';
  @override
  String get standardMii => '標準のMii';
}

// Path: options
class _Translations$options$ja extends Translations$options$en {
  _Translations$options$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get emulatorSettings => '設定';
  @override
  String get emulatorSettingsDescription => 'エミュレータの設定を行います';
  @override
  String get articBaseConnect => 'Artic Baseに接続';
  @override
  String get articBaseConnectDescription => 'Artic Baseサーバーを実行している実機に接続します';
  @override
  String get installGameContent => 'CIAファイルをインストール';
  @override
  String get installGameContentDescription => 'アプリケーション、アップデート、DLCをインストールします';
  @override
  String get setupSystemFiles => 'システムファイル';
  @override
  String get setupSystemFilesDescription =>
      'システムファイルのインストールやHOMEメニューの起動など、システムファイルに関する操作を行います';
  @override
  String get shareLog => 'ログを共有';
  @override
  String get shareLogDescription => '問題のデバッグのためにAzaharのログファイルを共有します';
  @override
  String get shareLogNotFound => 'ログファイルが見つかりません';
  @override
  String get gpuDriverManager => 'GPUドライバーマネージャー';
  @override
  String get gpuDriverManagerDescription =>
      'パフォーマンスや精度の向上が期待できる代替ドライバーをインストールします';
  @override
  String get selectUserFolder => 'ユーザーフォルダを選択';
  @override
  String get selectUserFolderDescription =>
      'Azaharがアプリケーションの読み込みに使用するファイルを変更します';
  @override
  String get selectGamesFolder => 'アプリケーションフォルダを選択';
  @override
  String get selectGamesFolderDescription => 'Azaharがアプリケーション一覧を作成できるようにします';
  @override
  String get themeAndColor => 'テーマと色';
  @override
  String get themeAndColorDescription => 'アプリの見た目を変更します';
  @override
  String get media => 'メディア';
  @override
  String get mediaDescription => 'バックグラウンド再生とメディアセッションの設定';
  @override
  String get accessibility => 'アクセシビリティ';
  @override
  String get accessibilityDescription => 'モーションなどのアクセシビリティ設定';
  @override
  String get advanced => '詳細設定';
  @override
  String get advancedDescription => 'より詳細なオプションを設定します';
  @override
  String get about => 'このアプリについて';
  @override
  String get aboutDescription => 'ビルドバージョン、クレジットなど';
  @override
  String get general => 'プロフィール';
  @override
  String get generalDescription => 'プロフィール設定と誕生日設定';
  @override
  String get useLegacySettingsUI => '従来の設定UIを使用';
  @override
  String get useLegacySettingsUIDescription => '以前のオプション画面のデザインに戻します';
  @override
  late final _Translations$options$useLegacySettingsUIDialog$ja
  useLegacySettingsUIDialog =
      _Translations$options$useLegacySettingsUIDialog$ja._(_root);
  @override
  String get searchHint => 'オプションを検索';
  @override
  String get searchPrompt => '設定を検索するには入力してください';
  @override
  String get searchNoResults => '一致する設定がありません';
  @override
  String get history => '履歴';
  @override
  String get historyEmpty => '変更したり開いたりした設定がここに表示されます。';
  @override
  String get pinned => 'ピン留め';
  @override
  String get pinnedEmpty => '設定を長押しすると、ここにピン留めできます。';
  @override
  String get clear => '削除';
  @override
  String get clearHistoryTitle => '履歴を削除しますか？';
  @override
  String get clearHistoryMessage => '履歴のすべての項目を削除します。設定は変更されません。';
  @override
  String get clearPinnedTitle => 'すべてのピン留めを解除しますか？';
  @override
  String get clearPinnedMessage => 'ピン留めしたすべての項目を解除します。設定は変更されません。';
  @override
  String get removeFromHistory => '履歴から削除';
  @override
  String get pin => 'ピン留めする';
  @override
  String get unpin => 'ピン留めを解除';
  @override
  String pinLimitReached({required Object count}) => 'ピン留めは最大${count}件までです。';
  @override
  late final _Translations$options$groups$ja groups =
      _Translations$options$groups$ja._(_root);
}

// Path: systemFiles
class _Translations$systemFiles$ja extends Translations$systemFiles$en {
  _Translations$systemFiles$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'システムファイル';
  @override
  String get preamble =>
      'Azaharが一部の機能を利用するには、実機由来のコンソール固有データとファームウェアファイルが必要です。これらのファイルとデータは、Azahar Artic Setup Toolを使ってセットアップできます。\n\n注意事項:\n• この操作はコンソール固有データをAzaharにインストールします。セットアップ完了後は、userフォルダやnandフォルダを共有しないでください！\n• セットアップ中、Azaharはセットアップツールを実行しているコンソールにリンクされます。後でエミュレータのオプションメニューのシステムファイルタブからリンクを解除できます。\n• システムファイルをセットアップした後は、Azaharと実機の3DSを同時にオンラインにしないでください。問題が発生する可能性があります。\n• New 3DSのセットアップにはOld 3DSのセットアップが必要です（両方のセットアップを推奨します）。\n• どちらのセットアップモードも、セットアップツールを実行しているコンソールの機種に関わらず動作します。';
  @override
  String get connectSetupTool => 'Artic Setup Toolに接続';
  @override
  String get deleteSystemFiles => 'コンソール固有データのリンクを解除';
  @override
  String get deleteSystemFilesDescription =>
      'この操作を行うと、実機とAzaharのリンクが解除され、以下の影響があります:\n• OTP、SecureInfo、LocalFriendCodeSeedがAzaharから削除されます。\n• フレンドリストがリセットされ、NNID/PNIDアカウントからログアウトされます。\n• Azahar経由で取得したシステムファイルとeショップタイトルは、同じコンソールでセットアップツールを使って再度リンクするまでアクセスできなくなります（セーブデータは失われません）。\n\n続行しますか？';
  @override
  String get bootHomeMenu => 'HOMEメニューを起動';
  @override
  String get start => '開始';
  @override
  String get runSystemSetup => 'HOMEメニュー起動時にシステムセットアップを実行';
  @override
  String get showHomeApps => 'HOMEメニューのアプリをアプリケーション一覧に表示';
  @override
  String get detecting => '現在のシステムファイルの状態を取得しています。お待ちください...';
  @override
  String get preparing => 'セットアップを準備しています。お待ちください...';
  @override
  String get enterAddress => 'Artic Setup Toolのアドレスを入力';
  @override
  String get old3ds => 'Old 3DSセットアップ';
  @override
  String get new3ds => 'New 3DSセットアップ';
  @override
  String get statusPossible => 'セットアップ可能です。';
  @override
  String get statusCompleted => 'セットアップは既に完了しています。';
  @override
  String get statusOld3dsNeeded => '先にOld 3DSのセットアップが必要です。';
}

// Path: gpuDriverManager
class _Translations$gpuDriverManager$ja
    extends Translations$gpuDriverManager$en {
  _Translations$gpuDriverManager$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'GPUドライバーマネージャー';
  @override
  String get systemDriver => 'システムドライバー';
  @override
  String get installDriver => 'ドライバーをインストール';
  @override
  String get installDriverDescription => 'zipファイルからカスタムドライバーをインストールします';
  @override
  String get installFailed => 'ドライバーのインストールに失敗しました';
}

// Path: articBaseConnectDialog
class _Translations$articBaseConnectDialog$ja
    extends Translations$articBaseConnectDialog$en {
  _Translations$articBaseConnectDialog$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'Artic Baseサーバーのアドレスを入力';
}

// Path: about
class _Translations$about$ja extends Translations$about$en {
  _Translations$about$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'このアプリについて';
  @override
  String get description => 'オープンソースの3DSエミュレータ';
  @override
  String get contributors => '貢献者';
  @override
  String get contributorsDescription => 'Azaharを実現した貢献者の皆さん';
  @override
  String get licenses => 'ライセンス';
  @override
  String get licensesDescription => 'Android版Azaharで使用しているプロジェクト';
  @override
  String get build => 'ビルド';
}

// Path: settings
class _Translations$settings$ja extends Translations$settings$en {
  _Translations$settings$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '設定';
  @override
  String get resetToDefault => 'デフォルトに戻す';
  @override
  late final _Translations$settings$resetToDefaultDialog$ja
  resetToDefaultDialog = _Translations$settings$resetToDefaultDialog$ja._(
    _root,
  );
  @override
  late final _Translations$settings$sliderDialog$ja sliderDialog =
      _Translations$settings$sliderDialog$ja._(_root);
  @override
  late final _Translations$settings$inputBindingDialog$ja inputBindingDialog =
      _Translations$settings$inputBindingDialog$ja._(_root);
  @override
  late final _Translations$settings$general$ja general =
      _Translations$settings$general$ja._(_root);
  @override
  late final _Translations$settings$emulation$ja emulation =
      _Translations$settings$emulation$ja._(_root);
  @override
  late final _Translations$settings$networking$ja networking =
      _Translations$settings$networking$ja._(_root);
  @override
  late final _Translations$settings$media$ja media =
      _Translations$settings$media$ja._(_root);
  @override
  late final _Translations$settings$graphics$ja graphics =
      _Translations$settings$graphics$ja._(_root);
  @override
  late final _Translations$settings$system$ja system =
      _Translations$settings$system$ja._(_root);
  @override
  late final _Translations$settings$camera$ja camera =
      _Translations$settings$camera$ja._(_root);
  @override
  late final _Translations$settings$gamepad$ja gamepad =
      _Translations$settings$gamepad$ja._(_root);
  @override
  late final _Translations$settings$layout$ja layout =
      _Translations$settings$layout$ja._(_root);
  @override
  late final _Translations$settings$audio$ja audio =
      _Translations$settings$audio$ja._(_root);
  @override
  late final _Translations$settings$debug$ja debug =
      _Translations$settings$debug$ja._(_root);
  @override
  late final _Translations$settings$theme$ja theme =
      _Translations$settings$theme$ja._(_root);
  @override
  late final _Translations$settings$themes$ja themes =
      _Translations$settings$themes$ja._(_root);
  @override
  late final _Translations$settings$accessibility$ja accessibility =
      _Translations$settings$accessibility$ja._(_root);
  @override
  late final _Translations$settings$advanced$ja advanced =
      _Translations$settings$advanced$ja._(_root);
  @override
  late final _Translations$settings$language$ja language =
      _Translations$settings$language$ja._(_root);
}

// Path: setup.welcome
class _Translations$setup$welcome$ja extends Translations$setup$welcome$en {
  _Translations$setup$welcome$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ようこそ！';
  @override
  String get description => 'Azaharのセットアップ方法を学び、エミュレーションを始めましょう。';
  @override
  String get getStarted => 'はじめる';
}

// Path: setup.permissions
class _Translations$setup$permissions$ja
    extends Translations$setup$permissions$en {
  _Translations$setup$permissions$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '権限';
  @override
  String get description => 'エミュレータの特定の機能を使用するために、任意の権限を付与してください';
}

// Path: setup.dataFolders
class _Translations$setup$dataFolders$ja
    extends Translations$setup$dataFolders$en {
  _Translations$setup$dataFolders$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'データフォルダ';
  @override
  String get description => 'データフォルダを選択してください\n（ユーザーフォルダは必須です）';
}

// Path: setup.notifications
class _Translations$setup$notifications$ja
    extends Translations$setup$notifications$en {
  _Translations$setup$notifications$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '通知';
  @override
  String get description => '下のボタンから通知権限を付与してください。';
  @override
  String get givePermission => '権限を付与';
  @override
  String get warningTitle => '通知権限の付与をスキップしますか？';
  @override
  String get warningDescription => 'Azaharは重要な情報を通知できなくなります。';
}

// Path: setup.microphone
class _Translations$setup$microphone$ja
    extends Translations$setup$microphone$en {
  _Translations$setup$microphone$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'マイク';
  @override
  String get description => '3DSのマイクをエミュレートするために、下のマイク権限を付与してください。';
  @override
  String get givePermission => '権限を付与';
}

// Path: setup.camera
class _Translations$setup$camera$ja extends Translations$setup$camera$en {
  _Translations$setup$camera$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'カメラ';
  @override
  String get description => '3DSのカメラをエミュレートするために、下のカメラ権限を付与してください。';
  @override
  String get givePermission => '権限を付与';
}

// Path: setup.userDirectory
class _Translations$setup$userDirectory$ja
    extends Translations$setup$userDirectory$en {
  _Translations$setup$userDirectory$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ユーザーフォルダを選択';
  @override
  String get description => '下のボタンでユーザーデータディレクトリを選択してください。';
  @override
  String get select => '選択';
  @override
  String get warningTitle => 'この手順はスキップできません';
  @override
  String get warningDescription => 'この手順はAzaharの動作に必要です。ディレクトリを選択してから続行してください。';
  @override
  String get warningHelpUrl =>
      'https://web.archive.org/web/20240304193549/https://github.com/citra-emu/citra/wiki/Citra-Android-user-data-and-storage';
  @override
  String get moveData => 'データを移動';
  @override
  String get movingData => 'データを移動中';
}

// Path: setup.gamesDirectory
class _Translations$setup$gamesDirectory$ja
    extends Translations$setup$gamesDirectory$en {
  _Translations$setup$gamesDirectory$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'アプリケーション';
  @override
  String get description => '下のボタンでアプリケーションフォルダを選択してください。';
  @override
  String get select => '選択';
  @override
  String get warningTitle => 'アプリケーションフォルダの選択をスキップしますか？';
  @override
  String get warningDescription => 'フォルダが選択されていない場合、アプリケーション一覧にソフトウェアが表示されません。';
  @override
  String get warningHelpUrl =>
      'https://web.archive.org/web/20240304210021/https://citra-emu.org/wiki/dumping-game-cartridges/';
}

// Path: setup.done
class _Translations$setup$done$ja extends Translations$setup$done$en {
  _Translations$setup$done$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '完了';
  @override
  String get description => '準備が整いました。\nエミュレータをお楽しみください！';
  @override
  String get continueLabel => '続ける';
}

// Path: options.useLegacySettingsUIDialog
class _Translations$options$useLegacySettingsUIDialog$ja
    extends Translations$options$useLegacySettingsUIDialog$en {
  _Translations$options$useLegacySettingsUIDialog$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '設定UIを切り替えますか？';
  @override
  String get message => 'オプション画面の見た目が変わります。いつでも元に戻すことができます。';
  @override
  String get confirm => '切り替える';
}

// Path: options.groups
class _Translations$options$groups$ja extends Translations$options$groups$en {
  _Translations$options$groups$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get general => '一般';
  @override
  String get emulation => 'エミュレーション';
  @override
  String get clock => '時計';
  @override
  String get graphics => 'グラフィックス';
  @override
  String get networking => 'ネットワーキング';
  @override
  String get controls => 'コントロール';
  @override
  String get tools => 'ツール';
  @override
  String get folderSettings => 'フォルダ設定';
  @override
  String get other => 'その他';
  @override
  String get accessibility => 'アクセシビリティ';
}

// Path: settings.resetToDefaultDialog
class _Translations$settings$resetToDefaultDialog$ja
    extends Translations$settings$resetToDefaultDialog$en {
  _Translations$settings$resetToDefaultDialog$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'デフォルトに戻しますか？';
  @override
  String get message => 'すべての設定がデフォルト値にリセットされます。この操作は取り消せません。';
  @override
  String get confirm => 'リセット';
}

// Path: settings.sliderDialog
class _Translations$settings$sliderDialog$ja
    extends Translations$settings$sliderDialog$en {
  _Translations$settings$sliderDialog$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get kDefault => 'デフォルト';
  @override
  String invalidValue({
    required Object title,
    required Object min,
    required Object max,
  }) => '${title}: 値は${min}から${max}の間で指定してください。';
}

// Path: settings.inputBindingDialog
class _Translations$settings$inputBindingDialog$ja
    extends Translations$settings$inputBindingDialog$en {
  _Translations$settings$inputBindingDialog$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get waitingForInput => 'コントローラーのボタンを押してください';
}

// Path: settings.general
class _Translations$settings$general$ja
    extends Translations$settings$general$en {
  _Translations$settings$general$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'プロフィール';
  @override
  String get frameLimitEnable => '速度制限';
  @override
  String get frameLimitEnableDescription =>
      '有効にすると、エミュレーション速度が指定した通常速度に対する割合に制限されます。';
  @override
  String get frameLimitSlider => '速度制限のパーセンテージ';
  @override
  String get frameLimitSliderDescription =>
      'エミュレーション速度を制限する割合を指定します。デフォルトの100%では通常速度に制限されます。値を大きく/小さくすると速度制限が増減します。';
}

// Path: settings.emulation
class _Translations$settings$emulation$ja
    extends Translations$settings$emulation$en {
  _Translations$settings$emulation$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'エミュレーション';
  @override
  String get useHighLevelEmulation => '高レベルなエミュレーションを使う';
  @override
  String get useHighLevelEmulationDescription =>
      '低レベルエミュレーションの代わりに、システムアプレットの再実装を使用します。一部のオンライン機能を動作させるには、この設定をオフにする必要がある場合があります。';
}

// Path: settings.networking
class _Translations$settings$networking$ja
    extends Translations$settings$networking$en {
  _Translations$settings$networking$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ネットワーキング';
  @override
  String get accessNetwork => 'ネットワークにアクセスする';
  @override
  String get accessNetworkDescription =>
      'システムアプレットとそれに必要なモジュールに低レベルエミュレーションを使用することで、エミュレートされたコンソールがオンライン機能にアクセスできるようにします。';
  @override
  String get useWireless => '無線を使用する';
  @override
  String get useWirelessDescription =>
      '近くにある実際のWi-Fiネットワークを、偽のものではなく3DSのすれちがい通信/SpotPass対応ネットワークとして報告します。';
  @override
  String get emulatedNetwork => 'エミュレーションされたネットワーク';
  @override
  String get emulatedNetworkDescription =>
      'エミュレートされたコンソールから見えるWi-Fiアクセスポイントを確認し、必要に応じて仮想のものに置き換えます。';
  @override
  String get realNetworkTab => '実際のネットワーク';
  @override
  String get virtualNetworkTab => '仮想のネットワーク';
  @override
  String get hiddenNetwork => '（非公開ネットワーク）';
  @override
  String get ssid => 'SSID';
  @override
  String get bssid => 'BSSID';
  @override
  String get frequency => '周波数';
  @override
  String get noAccessPointsFound => 'アクセスポイントが見つかりませんでした。';
  @override
  String get useVirtualNetwork => '仮想ネットワークを使用する';
  @override
  String get useVirtualNetworkDescription =>
      '実際のアクセスポイントの代わりに、以下のアクセスポイントをエミュレートされたコンソールに報告します。';
  @override
  String get addAccessPoint => 'アクセスポイントを追加';
  @override
  String get editAccessPoint => 'アクセスポイントを編集';
  @override
  String get ssidHint => '空欄で非公開ネットワークになります';
  @override
  String get bssidHint => '00:00:00:00:00:00';
  @override
  String get frequencyHint => 'MHz、例: 2437';
  @override
  String get levelHint => '信号レベル（dBm）、例: -50';
  @override
  String get copySelected => '選択したものをコピー';
  @override
  String get pasteAccessPoints => '貼り付け';
}

// Path: settings.media
class _Translations$settings$media$ja extends Translations$settings$media$en {
  _Translations$settings$media$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'メディア';
  @override
  String get groupApp => 'アプリ';
  @override
  String get groupEmulator => 'エミュレータ';
  @override
  String get masterVolume => 'マスター音量';
  @override
  String get masterVolumeDescription =>
      'エミュレートされたゲーム自体の音量設定とは独立して、アプリ全体の出力音量を調整します。ハードウェアの音量ボタンはこの値を調整します。';
  @override
  String masterVolumePercent({required Object value}) => '${value}%';
  @override
  String get treatAudioAsMediaSession => 'Androidのメディアとして扱う';
  @override
  String get treatAudioAsMediaSessionDescription =>
      '音楽アプリのようにロック画面と通知に再生コントロールを表示し、アプリがバックグラウンドにある間も自動的に一時停止せず音声を再生し続けます。';
}

// Path: settings.graphics
class _Translations$settings$graphics$ja
    extends Translations$settings$graphics$en {
  _Translations$settings$graphics$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'グラフィックス';
  @override
  String get renderer => 'レンダラー';
  @override
  String get graphicsApi => 'グラフィックスAPI';
  @override
  String get graphicsApiOpengles => 'OpenGLES';
  @override
  String get graphicsApiVulkan => 'Vulkan';
  @override
  String get spirvShaderGen => 'SPIR-Vシェーダー生成を有効にする';
  @override
  String get spirvShaderGenDescription =>
      'PICAのエミュレートに使用するフラグメントシェーダーを、GLSLではなくSPIR-Vで出力します';
  @override
  String get asyncShaders => '非同期シェーダーコンパイルを有効にする';
  @override
  String get asyncShadersDescription =>
      'ゲームプレイ中のカクつきを減らすため、シェーダーをバックグラウンドでコンパイルします。有効にすると、一時的にグラフィックの乱れが発生することがあります';
  @override
  String get internalResolution => '内部解像度';
  @override
  String get internalResolutionDescription =>
      '描画に使用する解像度を指定します。高い解像度は見た目の品質を大きく向上させますが、パフォーマンスへの負荷が大きく、特定のアプリケーションで不具合が発生することがあります。';
  @override
  String get internalResolutionNative => 'ネイティブ (400x240)';
  @override
  String get internalResolution2x => '2倍 (800x480)';
  @override
  String get internalResolution3x => '3倍 (1200x720)';
  @override
  String get internalResolution4x => '4倍 (1600x960)';
  @override
  String get internalResolution5x => '5倍 (2000x1200)';
  @override
  String get internalResolution6x => '6倍 (2400x1440)';
  @override
  String get internalResolution7x => '7倍 (2800x1680)';
  @override
  String get internalResolution8x => '8倍 (3200x1920)';
  @override
  String get internalResolution9x => '9倍 (3600x2160)';
  @override
  String get internalResolution10x => '10倍 (4000x2400)';
  @override
  String get linearFiltering => '線形フィルタリング';
  @override
  String get linearFilteringDescription => '線形フィルタリングを有効にし、ゲームの映像をより滑らかに見せます。';
  @override
  String get shadersAccurateMul => '正確な乗算';
  @override
  String get shadersAccurateMulDescription =>
      'ハードウェアシェーダーでより正確な乗算を使用し、一部のグラフィックの不具合を修正できる場合があります。有効にするとパフォーマンスが低下します。';
  @override
  String get useDiskShaderCache => 'ディスクシェーダーキャッシュ';
  @override
  String get useDiskShaderCacheDescription =>
      '生成したシェーダーをディスクに保存・読み込みすることで、カクつきを軽減します。ハードウェアシェーダーが有効でないと使用できません。';
  @override
  String get textureFilterName => 'テクスチャフィルター';
  @override
  String get textureFilterDescription =>
      'テクスチャにフィルターを適用してアプリケーションの見た目を強化します。対応しているフィルターはAnime4K Ultrafast、Bicubic、ScaleForce、xBRZ freescale、MMPXです。';
  @override
  String get textureFilterNone => 'なし';
  @override
  String get textureFilterAnime4k => 'Anime4K';
  @override
  String get textureFilterBicubic => 'Bicubic';
  @override
  String get textureFilterScaleforce => 'ScaleForce';
  @override
  String get textureFilterXbrz => 'xBRZ';
  @override
  String get textureFilterMmpx => 'MMPX';
  @override
  String get delayRenderThread => 'ゲームの描画スレッドを遅延させる';
  @override
  String get delayRenderThreadDescription =>
      'ゲームの描画スレッドがGPUにデータを送信する際に遅延させます。フレームレートが動的な（ごく一部の）アプリケーションでのパフォーマンス問題に役立ちます。';
  @override
  String get stereoscopy => '立体視';
  @override
  String get render3d => '立体視3Dモード';
  @override
  String get render3dOff => 'オフ';
  @override
  String get render3dSideBySide => 'サイドバイサイド';
  @override
  String get render3dReverseSideBySide => '逆サイドバイサイド';
  @override
  String get render3dAnaglyph => 'アナグリフ';
  @override
  String get render3dInterlaced => 'インターレース';
  @override
  String get render3dReverseInterlaced => '逆インターレース';
  @override
  String get render3dCardboardVr => 'Cardboard VR';
  @override
  String get factor3d => '奥行き';
  @override
  String get factor3dDescription =>
      '3Dスライダーの値を指定します。立体視3Dが有効な場合は0%より高い値に設定してください。';
  @override
  String get disableRightEyeRender => '右目の描画を無効にする';
  @override
  String get disableRightEyeRenderDescription =>
      '一部のアプリケーションではパフォーマンスが大きく向上しますが、他のアプリケーションではちらつきが発生することがあります。';
  @override
  String get cardboardVr => 'Cardboard VR';
  @override
  String get cardboardScreenSize => 'Cardboardの画面サイズ';
  @override
  String get cardboardScreenSizeDescription => '画面を元のサイズに対する割合で拡大縮小します。';
  @override
  String get cardboardXShift => '水平シフト';
  @override
  String get cardboardXShiftDescription =>
      '画面を水平方向にシフトする余白の割合を指定します。正の値は両目を中央に近づけ、負の値は遠ざけます。';
  @override
  String get cardboardYShift => '垂直シフト';
  @override
  String get cardboardYShiftDescription =>
      '画面を垂直方向にシフトする余白の割合を指定します。正の値は両目を下方向に、負の値は上方向にシフトします。';
  @override
  String get utility => 'ユーティリティ';
  @override
  String get dumpTextures => 'テクスチャをダンプ';
  @override
  String get dumpTexturesDescription => 'テクスチャはdump/textures/[タイトルID]/に出力されます。';
  @override
  String get customTextures => 'カスタムテクスチャ';
  @override
  String get customTexturesDescription =>
      'テクスチャはload/textures/[タイトルID]/から読み込まれます。';
  @override
  String get asyncCustomLoading => 'カスタムテクスチャの非同期読み込み';
  @override
  String get asyncCustomLoadingDescription =>
      '読み込み時のカクつきを軽減するため、バックグラウンドスレッドでカスタムテクスチャを非同期に読み込みます。';
  @override
  String get advanced => '詳細設定';
  @override
  String get textureSamplingName => 'テクスチャサンプリング';
  @override
  String get textureSamplingDescription =>
      'ゲームが使用するサンプリングフィルターを上書きします。アップスケーリング時に一部の相性が悪いゲームで役立つことがあります。不明な場合は「ゲームに従う」に設定してください。';
  @override
  String get textureSamplingGameControlled => 'ゲームに従う';
  @override
  String get textureSamplingNearestNeighbor => 'ニアレストネイバー';
  @override
  String get textureSamplingLinear => 'リニア';
}

// Path: settings.system
class _Translations$settings$system$ja extends Translations$settings$system$en {
  _Translations$settings$system$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'システム';
  @override
  String get emulationSettings => 'エミュレーション設定';
  @override
  String get new3ds => 'New 3DSモード';
  @override
  String get new3dsDescription => 'Old 3DSには存在しない、New 3DS専用の機能を有効にします。';
  @override
  String get lleApplets => 'LLEアプレット';
  @override
  String get lleAppletsDescription =>
      '可能な場合、高レベルエミュレーションの代わりにシステムアプレットの低レベルエミュレーションを使用します。';
  @override
  String get requiredOnlineLleModules => 'オンラインに必要なLLEモジュールを有効にする';
  @override
  String get requiredOnlineLleModulesDescription =>
      'LLEアプレットが無効な場合でも、オンライン機能に必要なモジュールに低レベルエミュレーションを使用します。';
  @override
  String get profileSettings => 'プロフィール設定';
  @override
  String get emulatedRegion => 'エミュレートするリージョン';
  @override
  String get regionAutoSelect => '自動選択';
  @override
  String get regionJapan => '日本';
  @override
  String get regionUsa => '米国';
  @override
  String get regionEurope => '欧州';
  @override
  String get regionAustralia => 'オーストラリア';
  @override
  String get regionChina => '中国';
  @override
  String get regionKorea => '韓国';
  @override
  String get regionTaiwan => '台湾';
  @override
  String get country => '国';
  @override
  String get emulatedLanguage => 'エミュレートする言語';
  @override
  String get languageJapanese => '日本語';
  @override
  String get languageEnglish => '英語 (English)';
  @override
  String get languageFrench => 'フランス語 (Français)';
  @override
  String get languageGerman => 'ドイツ語 (Deutsch)';
  @override
  String get languageItalian => 'イタリア語 (Italiano)';
  @override
  String get languageSpanish => 'スペイン語 (Español)';
  @override
  String get languageSimplifiedChinese => '簡体字中国語 (简体中文)';
  @override
  String get languageKorean => '韓国語 (한국어)';
  @override
  String get languageDutch => 'オランダ語 (Nederlands)';
  @override
  String get languagePortuguese => 'ポルトガル語 (Português)';
  @override
  String get languageRussian => 'ロシア語 (Русский)';
  @override
  String get languageTraditionalChinese => '繁体字中国語 (正體中文)';
  @override
  String get username => 'ユーザー名';
  @override
  String get playCoins => 'プレイコイン';
  @override
  String get stepsPerHour => '1時間あたりの歩数';
  @override
  String get stepsPerHourDescription => '歩数計に基づく機能のために、1時間あたりに生成される平均歩数です。';
  @override
  String get scanRealWifiNetworks => '実際のWi-Fiネットワークをスキャンする';
  @override
  String get scanRealWifiNetworksDescription =>
      '近くにある実際のWi-Fiネットワークを、偽のものではなく3DSのすれちがい通信/SpotPass対応ネットワークとして報告します。';
  @override
  String get consoleId => 'コンソールID';
  @override
  String get consoleIdDescription =>
      'タップするとコンソールIDが再生成されます。一部のアプリケーションはこれをペアレンタルロックの一種として使用することがあります。';
  @override
  String get macAddress => 'MACアドレス';
  @override
  String get macAddressDescription => 'タップするとネットワークMACアドレスが再生成されます。';
  @override
  String get birthday => '誕生日';
  @override
  String get birthdayMonth => '誕生月';
  @override
  String get birthdayDay => '誕生日';
  @override
  String get monthJanuary => '1月';
  @override
  String get monthFebruary => '2月';
  @override
  String get monthMarch => '3月';
  @override
  String get monthApril => '4月';
  @override
  String get monthMay => '5月';
  @override
  String get monthJune => '6月';
  @override
  String get monthJuly => '7月';
  @override
  String get monthAugust => '8月';
  @override
  String get monthSeptember => '9月';
  @override
  String get monthOctober => '10月';
  @override
  String get monthNovember => '11月';
  @override
  String get monthDecember => '12月';
  @override
  String get clock => '時計';
  @override
  String get initClock => '初期時刻';
  @override
  String get initClockDeviceClock => 'デバイスの時計';
  @override
  String get initClockSimulatedClock => 'シミュレートされた時計';
  @override
  String get simulatedClock => 'シミュレートされた時計';
  @override
  String get pluginLoader => 'プラグインローダー';
  @override
  String get pluginLoaderEnable => 'プラグインローダー';
  @override
  String get pluginLoaderEnableDescription =>
      'エミュレートされたゲームへの任意のプラグインの読み込みを許可します。';
  @override
  String get allowPluginLoader => 'プラグインローダーを許可する';
  @override
  String get allowPluginLoaderDescription => 'ゲーム自身がプラグインの読み込みを要求できるようにします。';
  @override
  late final _Translations$settings$system$countries$ja countries =
      _Translations$settings$system$countries$ja._(_root);
}

// Path: settings.camera
class _Translations$settings$camera$ja extends Translations$settings$camera$en {
  _Translations$settings$camera$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'カメラ';
  @override
  String get innerCamera => '内側カメラ';
  @override
  String get outerLeftCamera => '外側左カメラ';
  @override
  String get outerRightCamera => '外側右カメラ';
  @override
  String get imageSource => 'カメラの画像ソース';
  @override
  String get imageSourceDescription =>
      '仮想カメラの画像ソースを設定します。画像ファイル、または対応している場合はデバイスのカメラを使用できます。';
  @override
  String get imageSourceBlank => 'なし';
  @override
  String get imageSourceStillImage => '静止画';
  @override
  String get imageSourceDeviceCamera => 'デバイスのカメラ';
  @override
  String get cameraDevice => 'カメラ';
  @override
  String get cameraDeviceDescription =>
      '「画像ソース」設定が「デバイスのカメラ」の場合、使用する物理カメラを設定します。';
  @override
  String get cameraDeviceDefault => 'デフォルト';
  @override
  String get cameraDeviceAnyFront => '任意のインカメラ';
  @override
  String get cameraDeviceAnyBack => '任意のアウトカメラ';
  @override
  String get imageFlip => '反転';
  @override
  String get imageFlipNone => 'なし';
  @override
  String get imageFlipHorizontal => '水平';
  @override
  String get imageFlipVertical => '垂直';
  @override
  String get imageFlipReverse => '反転';
}

// Path: settings.gamepad
class _Translations$settings$gamepad$ja
    extends Translations$settings$gamepad$en {
  _Translations$settings$gamepad$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'ゲームパッド';
  @override
  String get controllerInputMode => 'コントローラー入力モード';
  @override
  String get controllerInputModeDescription =>
      '物理ゲームコントローラーを3DSの入力にどのようにマッピングするかを選択します。';
  @override
  String get controllerInputModeManual => '手動';
  @override
  String get controllerInputModeAutoDetect => '自動検出';
  @override
  String get invertLeftStickYAxis => '左スティックのY軸を反転';
  @override
  String get invertLeftStickYAxisDescription =>
      '自動検出されたコントローラー使用時に、左スティックの垂直軸を反転します。';
  @override
  String get gyroSettings => 'ジャイロ設定';
  @override
  String get gyroInputSource => 'ジャイロ入力ソース';
  @override
  String get gyroInputSourceDescription =>
      'モーション（ジャイロ）操作の入力元を、この端末か接続したコントローラーのジャイロスコープかを選択します。コントローラーにジャイロスコープがない場合はこの端末が使用されます。';
  @override
  String get gyroInputSourceDevice => '端末';
  @override
  String get gyroInputSourceController => 'コントローラー';
  @override
  String get gyroSensitivityVertical => 'ジャイロの垂直感度';
  @override
  String get gyroSensitivityVerticalDescription =>
      'ジャイロスコープの垂直方向（ピッチ）の感度を調整します。';
  @override
  String get invertGyroVertical => 'ジャイロの垂直軸を反転';
  @override
  String get invertGyroVerticalDescription => 'ジャイロスコープの垂直方向（ピッチ）の軸を反転します。';
  @override
  String get gyroSensitivityHorizontal => 'ジャイロの水平感度';
  @override
  String get gyroSensitivityHorizontalDescription =>
      'ジャイロスコープの水平方向（ヨー）の感度を調整します。';
  @override
  String get invertGyroHorizontal => 'ジャイロの水平軸を反転';
  @override
  String get invertGyroHorizontalDescription => 'ジャイロスコープの水平方向（ヨー）の軸を反転します。';
  @override
  String get genericButtons => 'ボタン';
  @override
  String get buttonA => 'A';
  @override
  String get buttonB => 'B';
  @override
  String get buttonX => 'X';
  @override
  String get buttonY => 'Y';
  @override
  String get buttonSelect => 'SELECT';
  @override
  String get buttonStart => 'START';
  @override
  String get buttonHome => 'HOME';
  @override
  String get circlePad => 'サークルパッド';
  @override
  String get cStick => 'Cスティック';
  @override
  String get axisVertical => '上下軸';
  @override
  String get axisHorizontal => '左右軸';
  @override
  String get dpadAxis => '十字キー（軸）';
  @override
  String get dpadAxisDescription =>
      'コントローラーによっては十字キーを軸としてマッピングできない場合があります。その場合は十字キー（ボタン）のセクションを使用してください。';
  @override
  String get dpadButtons => '十字キー（ボタン）';
  @override
  String get dpadButtonsDescription =>
      '十字キー（軸）のボタンマッピングで問題がある場合のみ、こちらに十字キーをマッピングしてください。';
  @override
  String get buttonUp => '上';
  @override
  String get buttonDown => '下';
  @override
  String get buttonLeft => '左';
  @override
  String get buttonRight => '右';
  @override
  String get triggers => 'トリガー';
  @override
  String get buttonL => 'L';
  @override
  String get buttonR => 'R';
  @override
  String get buttonZl => 'ZL';
  @override
  String get buttonZr => 'ZR';
  @override
  String get hotkeys => 'ホットキー';
  @override
  String get hotkeySwapScreens => '画面を入れ替え';
  @override
  String get hotkeyCycleLayout => 'レイアウトを切り替え';
  @override
  String get hotkeyCloseGame => 'ゲームを終了';
  @override
  String get hotkeyPauseOrResume => '一時停止を切り替え';
  @override
  String get hotkeyQuicksave => 'クイックセーブ';
  @override
  String get hotkeyQuickload => 'クイックロード';
  @override
  String get miscellaneous => 'その他';
  @override
  String get useArticBaseController => 'Artic Baseサーバー接続時にArticコントローラーを使用';
  @override
  String get useArticBaseControllerDescription =>
      'Artic Baseサーバーに接続している間、設定した入力デバイスの代わりにサーバーが提供するコントロールを使用します。';
}

// Path: settings.layout
class _Translations$settings$layout$ja extends Translations$settings$layout$en {
  _Translations$settings$layout$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'レイアウト';
  @override
  String get screenOrientation => '画面の向き';
  @override
  String get screenOrientationAutoSensor => '自動';
  @override
  String get screenOrientationLandscape => '横向き';
  @override
  String get screenOrientationLandscapeReverse => '横向き（反転）';
  @override
  String get screenOrientationPortrait => '縦向き';
  @override
  String get screenOrientationPortraitReverse => '縦向き（反転）';
  @override
  String get customLandscapeLayout => '横向きカスタムレイアウト';
  @override
  String get customPortraitLayout => '縦向きカスタムレイアウト';
  @override
  String get topScreen => '上画面';
  @override
  String get bottomScreen => '下画面';
  @override
  String get positionX => 'X座標';
  @override
  String get positionY => 'Y座標';
  @override
  String get width => '幅';
  @override
  String get height => '高さ';
}

// Path: settings.audio
class _Translations$settings$audio$ja extends Translations$settings$audio$en {
  _Translations$settings$audio$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'オーディオ';
  @override
  String get volume => '音量';
  @override
  String get volumeDescription => 'アプリの「マスター音量」とは別の、エミュレートされた3DS本体自体が持つ内部音量です。';
  @override
  String get audioStretching => 'オーディオストレッチング';
  @override
  String get audioStretchingDescription =>
      'カクつきを減らすために音声を引き伸ばします。オーディオの遅延が増加し、パフォーマンスがわずかに低下します。';
  @override
  String get realtimeAudio => 'リアルタイムオーディオ';
  @override
  String get realtimeAudioDescription =>
      'オーディオの遅延を減らしますが、一部のアプリケーションで不安定になることがあります。オーディオストレッチングが無効な場合のみ有効になります。';
  @override
  String get audioInputType => 'オーディオ入力タイプ';
  @override
  String get audioInputTypeAuto => '自動';
  @override
  String get audioInputTypeNone => 'なし';
  @override
  String get audioInputTypeStaticNoise => 'ホワイトノイズ';
  @override
  String get audioInputTypeRealCubeb => '実デバイス (Cubeb)';
  @override
  String get audioInputTypeRealOpenal => '実デバイス (OpenAL)';
  @override
  String get soundOutputMode => 'サウンド出力モード';
  @override
  String get soundOutputModeMono => 'モノラル';
  @override
  String get soundOutputModeStereo => 'ステレオ';
  @override
  String get soundOutputModeSurround => 'サラウンド';
}

// Path: settings.debug
class _Translations$settings$debug$ja extends Translations$settings$debug$en {
  _Translations$settings$debug$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'デバッグ';
  @override
  String get warning => 'これらの設定はデバッグ用途のみです。変更すると動作が不安定になる場合があります。';
  @override
  String get logToConsole => '標準出力にログを出力';
  @override
  String get logToConsoleDescription => 'ネイティブのログをFlutterの標準出力にも出力します。';
  @override
  String get cpuClockSpeed => 'CPUクロック速度';
  @override
  String get cpuClockSpeedDescription =>
      'エミュレートされたCPUをオーバークロック/アンダークロックします。推奨しません。';
  @override
  String get cpuJit => 'CPU JIT';
  @override
  String get cpuJitDescription =>
      'CPUエミュレーションにJIT（Just-In-Time）コンパイラを使用します。無効にすると、代わりにはるかに低速なインタプリタが使用されます。';
  @override
  String get hwShaders => 'ハードウェアシェーダー';
  @override
  String get hwShadersDescription =>
      'ソフトウェアレンダラーの代わりに、ハードウェアシェーダーで3DSのシェーダーをエミュレートします。無効にするとパフォーマンスが大きく低下します。';
  @override
  String get vsync => '垂直同期';
  @override
  String get vsyncDescription => '描画をホストデバイスのディスプレイのリフレッシュレートと同期させます。';
  @override
  String get rendererDebug => 'レンダラーデバッグ';
  @override
  String get rendererDebugDescription => '追加のレンダラーデバッグ機能を有効にします。パフォーマンスが低下します。';
  @override
  String get instantDebugLog => '即時デバッグログ';
  @override
  String get instantDebugLogDescription =>
      'バッファリングせず、即座にデバッグログへ書き込みます。パフォーマンスが低下します。';
  @override
  String get delayStartLleModules => 'LLEモジュールの開始を遅延させる';
  @override
  String get delayStartLleModulesDescription =>
      '競合状態を回避するため、LLEモジュールの開始を遅延させます。';
  @override
  String get deterministicAsyncOperations => '決定論的な非同期処理';
  @override
  String get deterministicAsyncOperationsDescription =>
      '非同期処理を決定論的な順序で実行するように強制します。パフォーマンスが低下します。';
}

// Path: settings.theme
class _Translations$settings$theme$ja extends Translations$settings$theme$en {
  _Translations$settings$theme$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'テーマと色';
  @override
  String get themeStyle => 'テーマスタイル';
  @override
  String get materialYou => 'Material You';
  @override
  String get materialYouDescription => '端末の壁紙から抽出した色を使用します。';
  @override
  String get staticThemeColor => '固定テーマカラー';
  @override
  String get staticThemeColorDefault => 'デフォルト';
  @override
  String get staticThemeColorBlue => '青';
  @override
  String get staticThemeColorCyan => 'シアン';
  @override
  String get staticThemeColorRed => '赤';
  @override
  String get staticThemeColorGreen => '緑';
  @override
  String get staticThemeColorYellow => '黄';
  @override
  String get staticThemeColorOrange => 'オレンジ';
  @override
  String get staticThemeColorViolet => '紫';
  @override
  String get staticThemeColorPink => 'ピンク';
  @override
  String get staticThemeColorGray => 'グレー';
  @override
  String get themeMode => 'テーマモード';
  @override
  String get themeModeFollowSystem => 'システムに従う';
  @override
  String get themeModeLight => 'ライト';
  @override
  String get themeModeDark => 'ダーク';
  @override
  String get useBlackBackgrounds => '黒背景を使用';
  @override
  String get useBlackBackgroundsDescription =>
      'ダークモード有効時に、ダークグレーの代わりに黒背景を使用します。';
}

// Path: settings.themes
class _Translations$settings$themes$ja extends Translations$settings$themes$en {
  _Translations$settings$themes$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get azahar => 'Azahar';
  @override
  String get legacy => 'Legacy';
}

// Path: settings.accessibility
class _Translations$settings$accessibility$ja
    extends Translations$settings$accessibility$en {
  _Translations$settings$accessibility$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => 'アクセシビリティ';
  @override
  String get reduceMotion => '視差効果を減らす';
  @override
  String get reduceMotionDescription => 'アプリ内のアニメーションや動きの効果を減らします。';
}

// Path: settings.advanced
class _Translations$settings$advanced$ja
    extends Translations$settings$advanced$en {
  _Translations$settings$advanced$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '詳細設定';
  @override
  String get animationSpeedLabel => 'アニメーション速度';
  @override
  String get animationSpeedDescription => '画面遷移などのアニメーションの速さを調整します。';
  @override
  late final _Translations$settings$advanced$animationSpeed$ja animationSpeed =
      _Translations$settings$advanced$animationSpeed$ja._(_root);
}

// Path: settings.language
class _Translations$settings$language$ja
    extends Translations$settings$language$en {
  _Translations$settings$language$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get title => '言語';
  @override
  String get systemDefault => 'システムのデフォルト';
  @override
  String get english => '英語 (English)';
  @override
  String get japanese => '日本語';
}

// Path: settings.system.countries
class _Translations$settings$system$countries$ja
    extends Translations$settings$system$countries$en {
  _Translations$settings$system$countries$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get japan => '日本';
  @override
  String get anguilla => 'アンギラ';
  @override
  String get antiguaAndBarbuda => 'アンティグア・バーブーダ';
  @override
  String get argentina => 'アルゼンチン';
  @override
  String get aruba => 'アルバ';
  @override
  String get bahamas => 'バハマ';
  @override
  String get barbados => 'バルバドス';
  @override
  String get belize => 'ベリーズ';
  @override
  String get bolivia => 'ボリビア';
  @override
  String get brazil => 'ブラジル';
  @override
  String get britishVirginIslands => '英領ヴァージン諸島';
  @override
  String get canada => 'カナダ';
  @override
  String get caymanIslands => 'ケイマン諸島';
  @override
  String get chile => 'チリ';
  @override
  String get colombia => 'コロンビア';
  @override
  String get costaRica => 'コスタリカ';
  @override
  String get dominica => 'ドミニカ国';
  @override
  String get dominicanRepublic => 'ドミニカ共和国';
  @override
  String get ecuador => 'エクアドル';
  @override
  String get elSalvador => 'エルサルバドル';
  @override
  String get frenchGuiana => 'フランス領ギアナ';
  @override
  String get grenada => 'グレナダ';
  @override
  String get guadeloupe => 'グアドループ';
  @override
  String get guatemala => 'グアテマラ';
  @override
  String get guyana => 'ガイアナ';
  @override
  String get haiti => 'ハイチ';
  @override
  String get honduras => 'ホンジュラス';
  @override
  String get jamaica => 'ジャマイカ';
  @override
  String get martinique => 'マルティニーク';
  @override
  String get mexico => 'メキシコ';
  @override
  String get montserrat => 'モントセラト';
  @override
  String get netherlandsAntilles => 'オランダ領アンティル';
  @override
  String get nicaragua => 'ニカラグア';
  @override
  String get panama => 'パナマ';
  @override
  String get paraguay => 'パラグアイ';
  @override
  String get peru => 'ペルー';
  @override
  String get saintKittsAndNevis => 'セントクリストファー・ネイビス';
  @override
  String get saintLucia => 'セントルシア';
  @override
  String get saintVincentAndTheGrenadines => 'セントビンセント・グレナディーン';
  @override
  String get suriname => 'スリナム';
  @override
  String get trinidadAndTobago => 'トリニダード・トバゴ';
  @override
  String get turksAndCaicosIslands => 'タークス・カイコス諸島';
  @override
  String get unitedStates => 'アメリカ合衆国';
  @override
  String get uruguay => 'ウルグアイ';
  @override
  String get usVirginIslands => '米領ヴァージン諸島';
  @override
  String get venezuela => 'ベネズエラ';
  @override
  String get albania => 'アルバニア';
  @override
  String get australia => 'オーストラリア';
  @override
  String get austria => 'オーストリア';
  @override
  String get belgium => 'ベルギー';
  @override
  String get bosniaAndHerzegovina => 'ボスニア・ヘルツェゴビナ';
  @override
  String get botswana => 'ボツワナ';
  @override
  String get bulgaria => 'ブルガリア';
  @override
  String get croatia => 'クロアチア';
  @override
  String get cyprus => 'キプロス';
  @override
  String get czechRepublic => 'チェコ';
  @override
  String get denmark => 'デンマーク';
  @override
  String get estonia => 'エストニア';
  @override
  String get finland => 'フィンランド';
  @override
  String get france => 'フランス';
  @override
  String get germany => 'ドイツ';
  @override
  String get greece => 'ギリシャ';
  @override
  String get hungary => 'ハンガリー';
  @override
  String get iceland => 'アイスランド';
  @override
  String get ireland => 'アイルランド';
  @override
  String get italy => 'イタリア';
  @override
  String get latvia => 'ラトビア';
  @override
  String get lesotho => 'レソト';
  @override
  String get liechtenstein => 'リヒテンシュタイン';
  @override
  String get lithuania => 'リトアニア';
  @override
  String get luxembourg => 'ルクセンブルク';
  @override
  String get macedonia => 'マケドニア';
  @override
  String get malta => 'マルタ';
  @override
  String get montenegro => 'モンテネグロ';
  @override
  String get mozambique => 'モザンビーク';
  @override
  String get namibia => 'ナミビア';
  @override
  String get netherlands => 'オランダ';
  @override
  String get newZealand => 'ニュージーランド';
  @override
  String get norway => 'ノルウェー';
  @override
  String get poland => 'ポーランド';
  @override
  String get portugal => 'ポルトガル';
  @override
  String get romania => 'ルーマニア';
  @override
  String get russia => 'ロシア';
  @override
  String get serbia => 'セルビア';
  @override
  String get slovakia => 'スロバキア';
  @override
  String get slovenia => 'スロベニア';
  @override
  String get southAfrica => '南アフリカ';
  @override
  String get spain => 'スペイン';
  @override
  String get swaziland => 'スワジランド';
  @override
  String get sweden => 'スウェーデン';
  @override
  String get switzerland => 'スイス';
  @override
  String get turkey => 'トルコ';
  @override
  String get unitedKingdom => 'イギリス';
  @override
  String get zambia => 'ザンビア';
  @override
  String get zimbabwe => 'ジンバブエ';
  @override
  String get azerbaijan => 'アゼルバイジャン';
  @override
  String get mauritania => 'モーリタニア';
  @override
  String get mali => 'マリ';
  @override
  String get niger => 'ニジェール';
  @override
  String get chad => 'チャド';
  @override
  String get sudan => 'スーダン';
  @override
  String get eritrea => 'エリトリア';
  @override
  String get djibouti => 'ジブチ';
  @override
  String get somalia => 'ソマリア';
  @override
  String get andorra => 'アンドラ';
  @override
  String get gibraltar => 'ジブラルタル';
  @override
  String get guernsey => 'ガーンジー';
  @override
  String get isleOfMan => 'マン島';
  @override
  String get jersey => 'ジャージー';
  @override
  String get monaco => 'モナコ';
  @override
  String get taiwan => '台湾';
  @override
  String get southKorea => '韓国';
  @override
  String get hongKong => '香港';
  @override
  String get macau => 'マカオ';
  @override
  String get indonesia => 'インドネシア';
  @override
  String get singapore => 'シンガポール';
  @override
  String get thailand => 'タイ';
  @override
  String get philippines => 'フィリピン';
  @override
  String get malaysia => 'マレーシア';
  @override
  String get china => '中国';
  @override
  String get unitedArabEmirates => 'アラブ首長国連邦';
  @override
  String get india => 'インド';
  @override
  String get egypt => 'エジプト';
  @override
  String get oman => 'オマーン';
  @override
  String get qatar => 'カタール';
  @override
  String get kuwait => 'クウェート';
  @override
  String get saudiArabia => 'サウジアラビア';
  @override
  String get syria => 'シリア';
  @override
  String get bahrain => 'バーレーン';
  @override
  String get jordan => 'ヨルダン';
  @override
  String get sanMarino => 'サンマリノ';
  @override
  String get vaticanCity => 'バチカン市国';
  @override
  String get bermuda => 'バミューダ';
}

// Path: settings.advanced.animationSpeed
class _Translations$settings$advanced$animationSpeed$ja
    extends Translations$settings$advanced$animationSpeed$en {
  _Translations$settings$advanced$animationSpeed$ja._(TranslationsJa root)
    : this._root = root,
      super.internal(root);

  final TranslationsJa _root; // ignore: unused_field

  // Translations
  @override
  String get fast => '速い';
  @override
  String get normal => '普通';
  @override
  String get slow => '遅い';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsJa {
  dynamic _flatMapFunction(String path) {
    return switch (path) {
          'appName' => 'Azahar',
          'common.cancel' => 'キャンセル',
          'common.save' => '保存',
          'setup.next' => '次へ',
          'setup.back' => '戻る',
          'setup.stepComplete' => '完了！',
          'setup.warningSkip' => 'スキップ',
          'setup.warningCancel' => 'キャンセル',
          'setup.warningHelp' => 'ヘルプ',
          'setup.close' => '閉じる',
          'setup.welcome.title' => 'ようこそ！',
          'setup.welcome.description' => 'Azaharのセットアップ方法を学び、エミュレーションを始めましょう。',
          'setup.welcome.getStarted' => 'はじめる',
          'setup.permissions.title' => '権限',
          'setup.permissions.description' =>
            'エミュレータの特定の機能を使用するために、任意の権限を付与してください',
          'setup.dataFolders.title' => 'データフォルダ',
          'setup.dataFolders.description' =>
            'データフォルダを選択してください\n（ユーザーフォルダは必須です）',
          'setup.notifications.title' => '通知',
          'setup.notifications.description' => '下のボタンから通知権限を付与してください。',
          'setup.notifications.givePermission' => '権限を付与',
          'setup.notifications.warningTitle' => '通知権限の付与をスキップしますか？',
          'setup.notifications.warningDescription' =>
            'Azaharは重要な情報を通知できなくなります。',
          'setup.microphone.title' => 'マイク',
          'setup.microphone.description' =>
            '3DSのマイクをエミュレートするために、下のマイク権限を付与してください。',
          'setup.microphone.givePermission' => '権限を付与',
          'setup.camera.title' => 'カメラ',
          'setup.camera.description' => '3DSのカメラをエミュレートするために、下のカメラ権限を付与してください。',
          'setup.camera.givePermission' => '権限を付与',
          'setup.userDirectory.title' => 'ユーザーフォルダを選択',
          'setup.userDirectory.description' => '下のボタンでユーザーデータディレクトリを選択してください。',
          'setup.userDirectory.select' => '選択',
          'setup.userDirectory.warningTitle' => 'この手順はスキップできません',
          'setup.userDirectory.warningDescription' =>
            'この手順はAzaharの動作に必要です。ディレクトリを選択してから続行してください。',
          'setup.userDirectory.warningHelpUrl' =>
            'https://web.archive.org/web/20240304193549/https://github.com/citra-emu/citra/wiki/Citra-Android-user-data-and-storage',
          'setup.userDirectory.moveData' => 'データを移動',
          'setup.userDirectory.movingData' => 'データを移動中',
          'setup.gamesDirectory.title' => 'アプリケーション',
          'setup.gamesDirectory.description' => '下のボタンでアプリケーションフォルダを選択してください。',
          'setup.gamesDirectory.select' => '選択',
          'setup.gamesDirectory.warningTitle' => 'アプリケーションフォルダの選択をスキップしますか？',
          'setup.gamesDirectory.warningDescription' =>
            'フォルダが選択されていない場合、アプリケーション一覧にソフトウェアが表示されません。',
          'setup.gamesDirectory.warningHelpUrl' =>
            'https://web.archive.org/web/20240304210021/https://citra-emu.org/wiki/dumping-game-cartridges/',
          'setup.done.title' => '完了',
          'setup.done.description' => '準備が整いました。\nエミュレータをお楽しみください！',
          'setup.done.continueLabel' => '続ける',
          'home.games' => 'アプリケーション',
          'home.options' => 'オプション',
          'games.searchHint' => 'アプリケーションを検索',
          'games.emptyGamelist' => 'ファイルが見つからないか、ゲームディレクトリがまだ選択されていません。',
          'games.properties' => 'プロパティ',
          'games.propertiesNotLoaded' =>
            'このアプリケーションのプロパティはまだ利用できません。アプリケーション一覧の読み込みが完了するまでお待ちください。',
          'games.play' => 'プレイ',
          'games.openFolder' => 'フォルダを開く',
          'games.delete' => '削除',
          'games.shortcut' => 'ショートカットを作成',
          'games.cheats' => 'チート',
          'games.cheatsUnavailable' => 'このバージョンのアプリではチートはまだ利用できません。',
          'games.compress' => '圧縮',
          'games.titleIdLabel' => ({required Object id}) => 'ID: ${id}',
          'games.fileLabel' => ({required Object name}) => 'ファイル: ${name}',
          'games.deleteShaderCache' => 'シェーダーキャッシュを削除',
          'games.deleteCacheSelectBackend' =>
            'シェーダーキャッシュを削除するグラフィックスAPIを選択してください',
          'games.vulkan' => 'Vulkan',
          'games.opengles' => 'OpenGLES',
          'games.shaderCacheDeleted' => 'シェーダーキャッシュを削除しました',
          'games.createShortcut' => 'ショートカットを作成',
          'games.shortcutName' => 'ショートカット名',
          'games.shortcutNameEmpty' => 'ショートカット名を空にすることはできません',
          'games.shortcutImageStretchToggle' => '画像を引き伸ばす',
          'games.editIcon' => 'アイコンを編集',
          'games.openApp' => 'アプリケーション',
          'games.openSaveDir' => 'セーブデータ',
          'games.openUpdates' => 'アップデート',
          'games.openDlc' => 'DLC',
          'games.openExtra' => '追加データ',
          'games.openTextures' => 'テクスチャ',
          'games.openMods' => 'MOD',
          'games.uninstallCia' => 'アプリケーション',
          'games.uninstallUpdates' => 'アップデート',
          'games.uninstallDlc' => 'DLC',
          'games.regionJapan' => '日本',
          'games.regionNorthAmerica' => '北米',
          'games.regionEurope' => '欧州',
          'games.regionAustralia' => 'オーストラリア',
          'games.regionChina' => '中国',
          'games.regionKorea' => '韓国',
          'games.regionTaiwan' => '台湾',
          'games.regionFree' => 'リージョンフリー',
          'games.invalidRegion' => '無効なリージョン',
          'emulation.loading' => '読み込み中',
          'emulation.terminating' => '終了しています',
          'emulation.preparingShaders' => 'シェーダーを準備中',
          'emulation.buildingShaders' => 'シェーダーをビルド中',
          'emulation.shaderProgress' =>
            ({required Object progress, required Object max}) =>
                '${progress}/${max}',
          'emulation.menuSectionEmulation' => 'エミュレーション',
          'emulation.pauseEmulation' => 'エミュレーションを一時停止',
          'emulation.resumeEmulation' => 'エミュレーションを再開',
          'emulation.advanceFrame' => 'フレーム送り',
          'emulation.menuSectionTools' => 'ツール',
          'emulation.cheats' => 'チート',
          'emulation.noCheats' => 'チートがありません',
          'emulation.addCheat' => 'チートを追加',
          'emulation.cheatName' => '名前',
          'emulation.cheatNotes' => 'メモ',
          'emulation.cheatCode' => 'コード',
          'emulation.cheatNameEmpty' => '名前を入力してください',
          'emulation.cheatCodeEmpty' => 'コードを入力してください',
          'emulation.cheatErrorOnLine' =>
            ({required Object line}) => '${line}行目にエラーがあります',
          'emulation.menuSectionOther' => 'その他',
          'emulation.closeGame' => 'ゲームを終了',
          'emulation.closeGameMessage' => '現在のゲームを終了してもよろしいですか？',
          'applets.softwareKeyboard' => 'ソフトウェアキーボード',
          'applets.iForgot' => '忘れました',
          'applets.standardMii' => '標準のMii',
          'options.emulatorSettings' => '設定',
          'options.emulatorSettingsDescription' => 'エミュレータの設定を行います',
          'options.articBaseConnect' => 'Artic Baseに接続',
          'options.articBaseConnectDescription' =>
            'Artic Baseサーバーを実行している実機に接続します',
          'options.installGameContent' => 'CIAファイルをインストール',
          'options.installGameContentDescription' =>
            'アプリケーション、アップデート、DLCをインストールします',
          'options.setupSystemFiles' => 'システムファイル',
          'options.setupSystemFilesDescription' =>
            'システムファイルのインストールやHOMEメニューの起動など、システムファイルに関する操作を行います',
          'options.shareLog' => 'ログを共有',
          'options.shareLogDescription' => '問題のデバッグのためにAzaharのログファイルを共有します',
          'options.shareLogNotFound' => 'ログファイルが見つかりません',
          'options.gpuDriverManager' => 'GPUドライバーマネージャー',
          'options.gpuDriverManagerDescription' =>
            'パフォーマンスや精度の向上が期待できる代替ドライバーをインストールします',
          'options.selectUserFolder' => 'ユーザーフォルダを選択',
          'options.selectUserFolderDescription' =>
            'Azaharがアプリケーションの読み込みに使用するファイルを変更します',
          'options.selectGamesFolder' => 'アプリケーションフォルダを選択',
          'options.selectGamesFolderDescription' =>
            'Azaharがアプリケーション一覧を作成できるようにします',
          'options.themeAndColor' => 'テーマと色',
          'options.themeAndColorDescription' => 'アプリの見た目を変更します',
          'options.media' => 'メディア',
          'options.mediaDescription' => 'バックグラウンド再生とメディアセッションの設定',
          'options.accessibility' => 'アクセシビリティ',
          'options.accessibilityDescription' => 'モーションなどのアクセシビリティ設定',
          'options.advanced' => '詳細設定',
          'options.advancedDescription' => 'より詳細なオプションを設定します',
          'options.about' => 'このアプリについて',
          'options.aboutDescription' => 'ビルドバージョン、クレジットなど',
          'options.general' => 'プロフィール',
          'options.generalDescription' => 'プロフィール設定と誕生日設定',
          'options.useLegacySettingsUI' => '従来の設定UIを使用',
          'options.useLegacySettingsUIDescription' => '以前のオプション画面のデザインに戻します',
          'options.useLegacySettingsUIDialog.title' => '設定UIを切り替えますか？',
          'options.useLegacySettingsUIDialog.message' =>
            'オプション画面の見た目が変わります。いつでも元に戻すことができます。',
          'options.useLegacySettingsUIDialog.confirm' => '切り替える',
          'options.searchHint' => 'オプションを検索',
          'options.searchPrompt' => '設定を検索するには入力してください',
          'options.searchNoResults' => '一致する設定がありません',
          'options.history' => '履歴',
          'options.historyEmpty' => '変更したり開いたりした設定がここに表示されます。',
          'options.pinned' => 'ピン留め',
          'options.pinnedEmpty' => '設定を長押しすると、ここにピン留めできます。',
          'options.clear' => '削除',
          'options.clearHistoryTitle' => '履歴を削除しますか？',
          'options.clearHistoryMessage' => '履歴のすべての項目を削除します。設定は変更されません。',
          'options.clearPinnedTitle' => 'すべてのピン留めを解除しますか？',
          'options.clearPinnedMessage' => 'ピン留めしたすべての項目を解除します。設定は変更されません。',
          'options.removeFromHistory' => '履歴から削除',
          'options.pin' => 'ピン留めする',
          'options.unpin' => 'ピン留めを解除',
          'options.pinLimitReached' =>
            ({required Object count}) => 'ピン留めは最大${count}件までです。',
          'options.groups.general' => '一般',
          'options.groups.emulation' => 'エミュレーション',
          'options.groups.clock' => '時計',
          'options.groups.graphics' => 'グラフィックス',
          'options.groups.networking' => 'ネットワーキング',
          'options.groups.controls' => 'コントロール',
          'options.groups.tools' => 'ツール',
          'options.groups.folderSettings' => 'フォルダ設定',
          'options.groups.other' => 'その他',
          'options.groups.accessibility' => 'アクセシビリティ',
          'systemFiles.title' => 'システムファイル',
          'systemFiles.preamble' =>
            'Azaharが一部の機能を利用するには、実機由来のコンソール固有データとファームウェアファイルが必要です。これらのファイルとデータは、Azahar Artic Setup Toolを使ってセットアップできます。\n\n注意事項:\n• この操作はコンソール固有データをAzaharにインストールします。セットアップ完了後は、userフォルダやnandフォルダを共有しないでください！\n• セットアップ中、Azaharはセットアップツールを実行しているコンソールにリンクされます。後でエミュレータのオプションメニューのシステムファイルタブからリンクを解除できます。\n• システムファイルをセットアップした後は、Azaharと実機の3DSを同時にオンラインにしないでください。問題が発生する可能性があります。\n• New 3DSのセットアップにはOld 3DSのセットアップが必要です（両方のセットアップを推奨します）。\n• どちらのセットアップモードも、セットアップツールを実行しているコンソールの機種に関わらず動作します。',
          'systemFiles.connectSetupTool' => 'Artic Setup Toolに接続',
          'systemFiles.deleteSystemFiles' => 'コンソール固有データのリンクを解除',
          'systemFiles.deleteSystemFilesDescription' =>
            'この操作を行うと、実機とAzaharのリンクが解除され、以下の影響があります:\n• OTP、SecureInfo、LocalFriendCodeSeedがAzaharから削除されます。\n• フレンドリストがリセットされ、NNID/PNIDアカウントからログアウトされます。\n• Azahar経由で取得したシステムファイルとeショップタイトルは、同じコンソールでセットアップツールを使って再度リンクするまでアクセスできなくなります（セーブデータは失われません）。\n\n続行しますか？',
          'systemFiles.bootHomeMenu' => 'HOMEメニューを起動',
          'systemFiles.start' => '開始',
          'systemFiles.runSystemSetup' => 'HOMEメニュー起動時にシステムセットアップを実行',
          'systemFiles.showHomeApps' => 'HOMEメニューのアプリをアプリケーション一覧に表示',
          'systemFiles.detecting' => '現在のシステムファイルの状態を取得しています。お待ちください...',
          'systemFiles.preparing' => 'セットアップを準備しています。お待ちください...',
          'systemFiles.enterAddress' => 'Artic Setup Toolのアドレスを入力',
          'systemFiles.old3ds' => 'Old 3DSセットアップ',
          'systemFiles.new3ds' => 'New 3DSセットアップ',
          'systemFiles.statusPossible' => 'セットアップ可能です。',
          'systemFiles.statusCompleted' => 'セットアップは既に完了しています。',
          'systemFiles.statusOld3dsNeeded' => '先にOld 3DSのセットアップが必要です。',
          'gpuDriverManager.title' => 'GPUドライバーマネージャー',
          'gpuDriverManager.systemDriver' => 'システムドライバー',
          'gpuDriverManager.installDriver' => 'ドライバーをインストール',
          'gpuDriverManager.installDriverDescription' =>
            'zipファイルからカスタムドライバーをインストールします',
          'gpuDriverManager.installFailed' => 'ドライバーのインストールに失敗しました',
          'articBaseConnectDialog.title' => 'Artic Baseサーバーのアドレスを入力',
          'about.title' => 'このアプリについて',
          'about.description' => 'オープンソースの3DSエミュレータ',
          'about.contributors' => '貢献者',
          'about.contributorsDescription' => 'Azaharを実現した貢献者の皆さん',
          'about.licenses' => 'ライセンス',
          'about.licensesDescription' => 'Android版Azaharで使用しているプロジェクト',
          'about.build' => 'ビルド',
          'settings.title' => '設定',
          'settings.resetToDefault' => 'デフォルトに戻す',
          'settings.resetToDefaultDialog.title' => 'デフォルトに戻しますか？',
          'settings.resetToDefaultDialog.message' =>
            'すべての設定がデフォルト値にリセットされます。この操作は取り消せません。',
          'settings.resetToDefaultDialog.confirm' => 'リセット',
          'settings.sliderDialog.kDefault' => 'デフォルト',
          'settings.sliderDialog.invalidValue' =>
            ({
              required Object title,
              required Object min,
              required Object max,
            }) => '${title}: 値は${min}から${max}の間で指定してください。',
          'settings.inputBindingDialog.waitingForInput' =>
            'コントローラーのボタンを押してください',
          'settings.general.title' => 'プロフィール',
          'settings.general.frameLimitEnable' => '速度制限',
          'settings.general.frameLimitEnableDescription' =>
            '有効にすると、エミュレーション速度が指定した通常速度に対する割合に制限されます。',
          'settings.general.frameLimitSlider' => '速度制限のパーセンテージ',
          'settings.general.frameLimitSliderDescription' =>
            'エミュレーション速度を制限する割合を指定します。デフォルトの100%では通常速度に制限されます。値を大きく/小さくすると速度制限が増減します。',
          'settings.emulation.title' => 'エミュレーション',
          'settings.emulation.useHighLevelEmulation' => '高レベルなエミュレーションを使う',
          'settings.emulation.useHighLevelEmulationDescription' =>
            '低レベルエミュレーションの代わりに、システムアプレットの再実装を使用します。一部のオンライン機能を動作させるには、この設定をオフにする必要がある場合があります。',
          'settings.networking.title' => 'ネットワーキング',
          'settings.networking.accessNetwork' => 'ネットワークにアクセスする',
          'settings.networking.accessNetworkDescription' =>
            'システムアプレットとそれに必要なモジュールに低レベルエミュレーションを使用することで、エミュレートされたコンソールがオンライン機能にアクセスできるようにします。',
          'settings.networking.useWireless' => '無線を使用する',
          'settings.networking.useWirelessDescription' =>
            '近くにある実際のWi-Fiネットワークを、偽のものではなく3DSのすれちがい通信/SpotPass対応ネットワークとして報告します。',
          'settings.networking.emulatedNetwork' => 'エミュレーションされたネットワーク',
          'settings.networking.emulatedNetworkDescription' =>
            'エミュレートされたコンソールから見えるWi-Fiアクセスポイントを確認し、必要に応じて仮想のものに置き換えます。',
          'settings.networking.realNetworkTab' => '実際のネットワーク',
          'settings.networking.virtualNetworkTab' => '仮想のネットワーク',
          'settings.networking.hiddenNetwork' => '（非公開ネットワーク）',
          'settings.networking.ssid' => 'SSID',
          'settings.networking.bssid' => 'BSSID',
          'settings.networking.frequency' => '周波数',
          'settings.networking.noAccessPointsFound' => 'アクセスポイントが見つかりませんでした。',
          'settings.networking.useVirtualNetwork' => '仮想ネットワークを使用する',
          'settings.networking.useVirtualNetworkDescription' =>
            '実際のアクセスポイントの代わりに、以下のアクセスポイントをエミュレートされたコンソールに報告します。',
          'settings.networking.addAccessPoint' => 'アクセスポイントを追加',
          'settings.networking.editAccessPoint' => 'アクセスポイントを編集',
          'settings.networking.ssidHint' => '空欄で非公開ネットワークになります',
          'settings.networking.bssidHint' => '00:00:00:00:00:00',
          'settings.networking.frequencyHint' => 'MHz、例: 2437',
          'settings.networking.levelHint' => '信号レベル（dBm）、例: -50',
          'settings.networking.copySelected' => '選択したものをコピー',
          'settings.networking.pasteAccessPoints' => '貼り付け',
          'settings.media.title' => 'メディア',
          'settings.media.groupApp' => 'アプリ',
          'settings.media.groupEmulator' => 'エミュレータ',
          'settings.media.masterVolume' => 'マスター音量',
          'settings.media.masterVolumeDescription' =>
            'エミュレートされたゲーム自体の音量設定とは独立して、アプリ全体の出力音量を調整します。ハードウェアの音量ボタンはこの値を調整します。',
          'settings.media.masterVolumePercent' =>
            ({required Object value}) => '${value}%',
          'settings.media.treatAudioAsMediaSession' => 'Androidのメディアとして扱う',
          'settings.media.treatAudioAsMediaSessionDescription' =>
            '音楽アプリのようにロック画面と通知に再生コントロールを表示し、アプリがバックグラウンドにある間も自動的に一時停止せず音声を再生し続けます。',
          'settings.graphics.title' => 'グラフィックス',
          'settings.graphics.renderer' => 'レンダラー',
          'settings.graphics.graphicsApi' => 'グラフィックスAPI',
          'settings.graphics.graphicsApiOpengles' => 'OpenGLES',
          'settings.graphics.graphicsApiVulkan' => 'Vulkan',
          'settings.graphics.spirvShaderGen' => 'SPIR-Vシェーダー生成を有効にする',
          'settings.graphics.spirvShaderGenDescription' =>
            'PICAのエミュレートに使用するフラグメントシェーダーを、GLSLではなくSPIR-Vで出力します',
          'settings.graphics.asyncShaders' => '非同期シェーダーコンパイルを有効にする',
          'settings.graphics.asyncShadersDescription' =>
            'ゲームプレイ中のカクつきを減らすため、シェーダーをバックグラウンドでコンパイルします。有効にすると、一時的にグラフィックの乱れが発生することがあります',
          'settings.graphics.internalResolution' => '内部解像度',
          'settings.graphics.internalResolutionDescription' =>
            '描画に使用する解像度を指定します。高い解像度は見た目の品質を大きく向上させますが、パフォーマンスへの負荷が大きく、特定のアプリケーションで不具合が発生することがあります。',
          'settings.graphics.internalResolutionNative' => 'ネイティブ (400x240)',
          'settings.graphics.internalResolution2x' => '2倍 (800x480)',
          'settings.graphics.internalResolution3x' => '3倍 (1200x720)',
          'settings.graphics.internalResolution4x' => '4倍 (1600x960)',
          'settings.graphics.internalResolution5x' => '5倍 (2000x1200)',
          'settings.graphics.internalResolution6x' => '6倍 (2400x1440)',
          'settings.graphics.internalResolution7x' => '7倍 (2800x1680)',
          'settings.graphics.internalResolution8x' => '8倍 (3200x1920)',
          'settings.graphics.internalResolution9x' => '9倍 (3600x2160)',
          'settings.graphics.internalResolution10x' => '10倍 (4000x2400)',
          'settings.graphics.linearFiltering' => '線形フィルタリング',
          'settings.graphics.linearFilteringDescription' =>
            '線形フィルタリングを有効にし、ゲームの映像をより滑らかに見せます。',
          'settings.graphics.shadersAccurateMul' => '正確な乗算',
          'settings.graphics.shadersAccurateMulDescription' =>
            'ハードウェアシェーダーでより正確な乗算を使用し、一部のグラフィックの不具合を修正できる場合があります。有効にするとパフォーマンスが低下します。',
          'settings.graphics.useDiskShaderCache' => 'ディスクシェーダーキャッシュ',
          'settings.graphics.useDiskShaderCacheDescription' =>
            '生成したシェーダーをディスクに保存・読み込みすることで、カクつきを軽減します。ハードウェアシェーダーが有効でないと使用できません。',
          'settings.graphics.textureFilterName' => 'テクスチャフィルター',
          'settings.graphics.textureFilterDescription' =>
            'テクスチャにフィルターを適用してアプリケーションの見た目を強化します。対応しているフィルターはAnime4K Ultrafast、Bicubic、ScaleForce、xBRZ freescale、MMPXです。',
          'settings.graphics.textureFilterNone' => 'なし',
          'settings.graphics.textureFilterAnime4k' => 'Anime4K',
          'settings.graphics.textureFilterBicubic' => 'Bicubic',
          'settings.graphics.textureFilterScaleforce' => 'ScaleForce',
          'settings.graphics.textureFilterXbrz' => 'xBRZ',
          'settings.graphics.textureFilterMmpx' => 'MMPX',
          'settings.graphics.delayRenderThread' => 'ゲームの描画スレッドを遅延させる',
          'settings.graphics.delayRenderThreadDescription' =>
            'ゲームの描画スレッドがGPUにデータを送信する際に遅延させます。フレームレートが動的な（ごく一部の）アプリケーションでのパフォーマンス問題に役立ちます。',
          'settings.graphics.stereoscopy' => '立体視',
          'settings.graphics.render3d' => '立体視3Dモード',
          'settings.graphics.render3dOff' => 'オフ',
          'settings.graphics.render3dSideBySide' => 'サイドバイサイド',
          'settings.graphics.render3dReverseSideBySide' => '逆サイドバイサイド',
          'settings.graphics.render3dAnaglyph' => 'アナグリフ',
          'settings.graphics.render3dInterlaced' => 'インターレース',
          'settings.graphics.render3dReverseInterlaced' => '逆インターレース',
          'settings.graphics.render3dCardboardVr' => 'Cardboard VR',
          'settings.graphics.factor3d' => '奥行き',
          'settings.graphics.factor3dDescription' =>
            '3Dスライダーの値を指定します。立体視3Dが有効な場合は0%より高い値に設定してください。',
          'settings.graphics.disableRightEyeRender' => '右目の描画を無効にする',
          'settings.graphics.disableRightEyeRenderDescription' =>
            '一部のアプリケーションではパフォーマンスが大きく向上しますが、他のアプリケーションではちらつきが発生することがあります。',
          'settings.graphics.cardboardVr' => 'Cardboard VR',
          'settings.graphics.cardboardScreenSize' => 'Cardboardの画面サイズ',
          'settings.graphics.cardboardScreenSizeDescription' =>
            '画面を元のサイズに対する割合で拡大縮小します。',
          'settings.graphics.cardboardXShift' => '水平シフト',
          'settings.graphics.cardboardXShiftDescription' =>
            '画面を水平方向にシフトする余白の割合を指定します。正の値は両目を中央に近づけ、負の値は遠ざけます。',
          'settings.graphics.cardboardYShift' => '垂直シフト',
          'settings.graphics.cardboardYShiftDescription' =>
            '画面を垂直方向にシフトする余白の割合を指定します。正の値は両目を下方向に、負の値は上方向にシフトします。',
          'settings.graphics.utility' => 'ユーティリティ',
          'settings.graphics.dumpTextures' => 'テクスチャをダンプ',
          'settings.graphics.dumpTexturesDescription' =>
            'テクスチャはdump/textures/[タイトルID]/に出力されます。',
          'settings.graphics.customTextures' => 'カスタムテクスチャ',
          'settings.graphics.customTexturesDescription' =>
            'テクスチャはload/textures/[タイトルID]/から読み込まれます。',
          'settings.graphics.asyncCustomLoading' => 'カスタムテクスチャの非同期読み込み',
          'settings.graphics.asyncCustomLoadingDescription' =>
            '読み込み時のカクつきを軽減するため、バックグラウンドスレッドでカスタムテクスチャを非同期に読み込みます。',
          'settings.graphics.advanced' => '詳細設定',
          'settings.graphics.textureSamplingName' => 'テクスチャサンプリング',
          'settings.graphics.textureSamplingDescription' =>
            'ゲームが使用するサンプリングフィルターを上書きします。アップスケーリング時に一部の相性が悪いゲームで役立つことがあります。不明な場合は「ゲームに従う」に設定してください。',
          'settings.graphics.textureSamplingGameControlled' => 'ゲームに従う',
          'settings.graphics.textureSamplingNearestNeighbor' => 'ニアレストネイバー',
          'settings.graphics.textureSamplingLinear' => 'リニア',
          'settings.system.title' => 'システム',
          'settings.system.emulationSettings' => 'エミュレーション設定',
          'settings.system.new3ds' => 'New 3DSモード',
          'settings.system.new3dsDescription' =>
            'Old 3DSには存在しない、New 3DS専用の機能を有効にします。',
          'settings.system.lleApplets' => 'LLEアプレット',
          'settings.system.lleAppletsDescription' =>
            '可能な場合、高レベルエミュレーションの代わりにシステムアプレットの低レベルエミュレーションを使用します。',
          'settings.system.requiredOnlineLleModules' =>
            'オンラインに必要なLLEモジュールを有効にする',
          'settings.system.requiredOnlineLleModulesDescription' =>
            'LLEアプレットが無効な場合でも、オンライン機能に必要なモジュールに低レベルエミュレーションを使用します。',
          'settings.system.profileSettings' => 'プロフィール設定',
          'settings.system.emulatedRegion' => 'エミュレートするリージョン',
          'settings.system.regionAutoSelect' => '自動選択',
          'settings.system.regionJapan' => '日本',
          'settings.system.regionUsa' => '米国',
          'settings.system.regionEurope' => '欧州',
          'settings.system.regionAustralia' => 'オーストラリア',
          'settings.system.regionChina' => '中国',
          'settings.system.regionKorea' => '韓国',
          'settings.system.regionTaiwan' => '台湾',
          'settings.system.country' => '国',
          'settings.system.emulatedLanguage' => 'エミュレートする言語',
          'settings.system.languageJapanese' => '日本語',
          'settings.system.languageEnglish' => '英語 (English)',
          'settings.system.languageFrench' => 'フランス語 (Français)',
          'settings.system.languageGerman' => 'ドイツ語 (Deutsch)',
          'settings.system.languageItalian' => 'イタリア語 (Italiano)',
          'settings.system.languageSpanish' => 'スペイン語 (Español)',
          'settings.system.languageSimplifiedChinese' => '簡体字中国語 (简体中文)',
          'settings.system.languageKorean' => '韓国語 (한국어)',
          'settings.system.languageDutch' => 'オランダ語 (Nederlands)',
          'settings.system.languagePortuguese' => 'ポルトガル語 (Português)',
          'settings.system.languageRussian' => 'ロシア語 (Русский)',
          'settings.system.languageTraditionalChinese' => '繁体字中国語 (正體中文)',
          'settings.system.username' => 'ユーザー名',
          'settings.system.playCoins' => 'プレイコイン',
          'settings.system.stepsPerHour' => '1時間あたりの歩数',
          'settings.system.stepsPerHourDescription' =>
            '歩数計に基づく機能のために、1時間あたりに生成される平均歩数です。',
          'settings.system.scanRealWifiNetworks' => '実際のWi-Fiネットワークをスキャンする',
          'settings.system.scanRealWifiNetworksDescription' =>
            '近くにある実際のWi-Fiネットワークを、偽のものではなく3DSのすれちがい通信/SpotPass対応ネットワークとして報告します。',
          'settings.system.consoleId' => 'コンソールID',
          'settings.system.consoleIdDescription' =>
            'タップするとコンソールIDが再生成されます。一部のアプリケーションはこれをペアレンタルロックの一種として使用することがあります。',
          'settings.system.macAddress' => 'MACアドレス',
          'settings.system.macAddressDescription' =>
            'タップするとネットワークMACアドレスが再生成されます。',
          'settings.system.birthday' => '誕生日',
          'settings.system.birthdayMonth' => '誕生月',
          'settings.system.birthdayDay' => '誕生日',
          'settings.system.monthJanuary' => '1月',
          'settings.system.monthFebruary' => '2月',
          'settings.system.monthMarch' => '3月',
          'settings.system.monthApril' => '4月',
          'settings.system.monthMay' => '5月',
          'settings.system.monthJune' => '6月',
          'settings.system.monthJuly' => '7月',
          'settings.system.monthAugust' => '8月',
          'settings.system.monthSeptember' => '9月',
          'settings.system.monthOctober' => '10月',
          'settings.system.monthNovember' => '11月',
          'settings.system.monthDecember' => '12月',
          'settings.system.clock' => '時計',
          'settings.system.initClock' => '初期時刻',
          'settings.system.initClockDeviceClock' => 'デバイスの時計',
          'settings.system.initClockSimulatedClock' => 'シミュレートされた時計',
          'settings.system.simulatedClock' => 'シミュレートされた時計',
          'settings.system.pluginLoader' => 'プラグインローダー',
          'settings.system.pluginLoaderEnable' => 'プラグインローダー',
          'settings.system.pluginLoaderEnableDescription' =>
            'エミュレートされたゲームへの任意のプラグインの読み込みを許可します。',
          'settings.system.allowPluginLoader' => 'プラグインローダーを許可する',
          'settings.system.allowPluginLoaderDescription' =>
            'ゲーム自身がプラグインの読み込みを要求できるようにします。',
          'settings.system.countries.japan' => '日本',
          'settings.system.countries.anguilla' => 'アンギラ',
          'settings.system.countries.antiguaAndBarbuda' => 'アンティグア・バーブーダ',
          'settings.system.countries.argentina' => 'アルゼンチン',
          'settings.system.countries.aruba' => 'アルバ',
          'settings.system.countries.bahamas' => 'バハマ',
          'settings.system.countries.barbados' => 'バルバドス',
          'settings.system.countries.belize' => 'ベリーズ',
          'settings.system.countries.bolivia' => 'ボリビア',
          'settings.system.countries.brazil' => 'ブラジル',
          'settings.system.countries.britishVirginIslands' => '英領ヴァージン諸島',
          'settings.system.countries.canada' => 'カナダ',
          'settings.system.countries.caymanIslands' => 'ケイマン諸島',
          'settings.system.countries.chile' => 'チリ',
          'settings.system.countries.colombia' => 'コロンビア',
          'settings.system.countries.costaRica' => 'コスタリカ',
          'settings.system.countries.dominica' => 'ドミニカ国',
          'settings.system.countries.dominicanRepublic' => 'ドミニカ共和国',
          'settings.system.countries.ecuador' => 'エクアドル',
          'settings.system.countries.elSalvador' => 'エルサルバドル',
          'settings.system.countries.frenchGuiana' => 'フランス領ギアナ',
          'settings.system.countries.grenada' => 'グレナダ',
          'settings.system.countries.guadeloupe' => 'グアドループ',
          'settings.system.countries.guatemala' => 'グアテマラ',
          'settings.system.countries.guyana' => 'ガイアナ',
          'settings.system.countries.haiti' => 'ハイチ',
          'settings.system.countries.honduras' => 'ホンジュラス',
          'settings.system.countries.jamaica' => 'ジャマイカ',
          'settings.system.countries.martinique' => 'マルティニーク',
          'settings.system.countries.mexico' => 'メキシコ',
          'settings.system.countries.montserrat' => 'モントセラト',
          'settings.system.countries.netherlandsAntilles' => 'オランダ領アンティル',
          'settings.system.countries.nicaragua' => 'ニカラグア',
          'settings.system.countries.panama' => 'パナマ',
          'settings.system.countries.paraguay' => 'パラグアイ',
          'settings.system.countries.peru' => 'ペルー',
          'settings.system.countries.saintKittsAndNevis' => 'セントクリストファー・ネイビス',
          'settings.system.countries.saintLucia' => 'セントルシア',
          'settings.system.countries.saintVincentAndTheGrenadines' =>
            'セントビンセント・グレナディーン',
          'settings.system.countries.suriname' => 'スリナム',
          'settings.system.countries.trinidadAndTobago' => 'トリニダード・トバゴ',
          'settings.system.countries.turksAndCaicosIslands' => 'タークス・カイコス諸島',
          'settings.system.countries.unitedStates' => 'アメリカ合衆国',
          'settings.system.countries.uruguay' => 'ウルグアイ',
          'settings.system.countries.usVirginIslands' => '米領ヴァージン諸島',
          'settings.system.countries.venezuela' => 'ベネズエラ',
          'settings.system.countries.albania' => 'アルバニア',
          'settings.system.countries.australia' => 'オーストラリア',
          'settings.system.countries.austria' => 'オーストリア',
          'settings.system.countries.belgium' => 'ベルギー',
          'settings.system.countries.bosniaAndHerzegovina' => 'ボスニア・ヘルツェゴビナ',
          'settings.system.countries.botswana' => 'ボツワナ',
          'settings.system.countries.bulgaria' => 'ブルガリア',
          'settings.system.countries.croatia' => 'クロアチア',
          'settings.system.countries.cyprus' => 'キプロス',
          'settings.system.countries.czechRepublic' => 'チェコ',
          'settings.system.countries.denmark' => 'デンマーク',
          'settings.system.countries.estonia' => 'エストニア',
          'settings.system.countries.finland' => 'フィンランド',
          'settings.system.countries.france' => 'フランス',
          'settings.system.countries.germany' => 'ドイツ',
          'settings.system.countries.greece' => 'ギリシャ',
          'settings.system.countries.hungary' => 'ハンガリー',
          'settings.system.countries.iceland' => 'アイスランド',
          'settings.system.countries.ireland' => 'アイルランド',
          'settings.system.countries.italy' => 'イタリア',
          'settings.system.countries.latvia' => 'ラトビア',
          'settings.system.countries.lesotho' => 'レソト',
          'settings.system.countries.liechtenstein' => 'リヒテンシュタイン',
          'settings.system.countries.lithuania' => 'リトアニア',
          'settings.system.countries.luxembourg' => 'ルクセンブルク',
          'settings.system.countries.macedonia' => 'マケドニア',
          'settings.system.countries.malta' => 'マルタ',
          'settings.system.countries.montenegro' => 'モンテネグロ',
          'settings.system.countries.mozambique' => 'モザンビーク',
          'settings.system.countries.namibia' => 'ナミビア',
          'settings.system.countries.netherlands' => 'オランダ',
          'settings.system.countries.newZealand' => 'ニュージーランド',
          'settings.system.countries.norway' => 'ノルウェー',
          'settings.system.countries.poland' => 'ポーランド',
          'settings.system.countries.portugal' => 'ポルトガル',
          'settings.system.countries.romania' => 'ルーマニア',
          'settings.system.countries.russia' => 'ロシア',
          'settings.system.countries.serbia' => 'セルビア',
          'settings.system.countries.slovakia' => 'スロバキア',
          'settings.system.countries.slovenia' => 'スロベニア',
          'settings.system.countries.southAfrica' => '南アフリカ',
          'settings.system.countries.spain' => 'スペイン',
          'settings.system.countries.swaziland' => 'スワジランド',
          'settings.system.countries.sweden' => 'スウェーデン',
          'settings.system.countries.switzerland' => 'スイス',
          'settings.system.countries.turkey' => 'トルコ',
          'settings.system.countries.unitedKingdom' => 'イギリス',
          'settings.system.countries.zambia' => 'ザンビア',
          'settings.system.countries.zimbabwe' => 'ジンバブエ',
          'settings.system.countries.azerbaijan' => 'アゼルバイジャン',
          'settings.system.countries.mauritania' => 'モーリタニア',
          'settings.system.countries.mali' => 'マリ',
          'settings.system.countries.niger' => 'ニジェール',
          'settings.system.countries.chad' => 'チャド',
          'settings.system.countries.sudan' => 'スーダン',
          'settings.system.countries.eritrea' => 'エリトリア',
          'settings.system.countries.djibouti' => 'ジブチ',
          'settings.system.countries.somalia' => 'ソマリア',
          'settings.system.countries.andorra' => 'アンドラ',
          'settings.system.countries.gibraltar' => 'ジブラルタル',
          'settings.system.countries.guernsey' => 'ガーンジー',
          'settings.system.countries.isleOfMan' => 'マン島',
          'settings.system.countries.jersey' => 'ジャージー',
          'settings.system.countries.monaco' => 'モナコ',
          'settings.system.countries.taiwan' => '台湾',
          'settings.system.countries.southKorea' => '韓国',
          'settings.system.countries.hongKong' => '香港',
          'settings.system.countries.macau' => 'マカオ',
          'settings.system.countries.indonesia' => 'インドネシア',
          'settings.system.countries.singapore' => 'シンガポール',
          'settings.system.countries.thailand' => 'タイ',
          'settings.system.countries.philippines' => 'フィリピン',
          'settings.system.countries.malaysia' => 'マレーシア',
          'settings.system.countries.china' => '中国',
          'settings.system.countries.unitedArabEmirates' => 'アラブ首長国連邦',
          'settings.system.countries.india' => 'インド',
          'settings.system.countries.egypt' => 'エジプト',
          _ => null,
        } ??
        switch (path) {
          'settings.system.countries.oman' => 'オマーン',
          'settings.system.countries.qatar' => 'カタール',
          'settings.system.countries.kuwait' => 'クウェート',
          'settings.system.countries.saudiArabia' => 'サウジアラビア',
          'settings.system.countries.syria' => 'シリア',
          'settings.system.countries.bahrain' => 'バーレーン',
          'settings.system.countries.jordan' => 'ヨルダン',
          'settings.system.countries.sanMarino' => 'サンマリノ',
          'settings.system.countries.vaticanCity' => 'バチカン市国',
          'settings.system.countries.bermuda' => 'バミューダ',
          'settings.camera.title' => 'カメラ',
          'settings.camera.innerCamera' => '内側カメラ',
          'settings.camera.outerLeftCamera' => '外側左カメラ',
          'settings.camera.outerRightCamera' => '外側右カメラ',
          'settings.camera.imageSource' => 'カメラの画像ソース',
          'settings.camera.imageSourceDescription' =>
            '仮想カメラの画像ソースを設定します。画像ファイル、または対応している場合はデバイスのカメラを使用できます。',
          'settings.camera.imageSourceBlank' => 'なし',
          'settings.camera.imageSourceStillImage' => '静止画',
          'settings.camera.imageSourceDeviceCamera' => 'デバイスのカメラ',
          'settings.camera.cameraDevice' => 'カメラ',
          'settings.camera.cameraDeviceDescription' =>
            '「画像ソース」設定が「デバイスのカメラ」の場合、使用する物理カメラを設定します。',
          'settings.camera.cameraDeviceDefault' => 'デフォルト',
          'settings.camera.cameraDeviceAnyFront' => '任意のインカメラ',
          'settings.camera.cameraDeviceAnyBack' => '任意のアウトカメラ',
          'settings.camera.imageFlip' => '反転',
          'settings.camera.imageFlipNone' => 'なし',
          'settings.camera.imageFlipHorizontal' => '水平',
          'settings.camera.imageFlipVertical' => '垂直',
          'settings.camera.imageFlipReverse' => '反転',
          'settings.gamepad.title' => 'ゲームパッド',
          'settings.gamepad.controllerInputMode' => 'コントローラー入力モード',
          'settings.gamepad.controllerInputModeDescription' =>
            '物理ゲームコントローラーを3DSの入力にどのようにマッピングするかを選択します。',
          'settings.gamepad.controllerInputModeManual' => '手動',
          'settings.gamepad.controllerInputModeAutoDetect' => '自動検出',
          'settings.gamepad.invertLeftStickYAxis' => '左スティックのY軸を反転',
          'settings.gamepad.invertLeftStickYAxisDescription' =>
            '自動検出されたコントローラー使用時に、左スティックの垂直軸を反転します。',
          'settings.gamepad.gyroSettings' => 'ジャイロ設定',
          'settings.gamepad.gyroInputSource' => 'ジャイロ入力ソース',
          'settings.gamepad.gyroInputSourceDescription' =>
            'モーション（ジャイロ）操作の入力元を、この端末か接続したコントローラーのジャイロスコープかを選択します。コントローラーにジャイロスコープがない場合はこの端末が使用されます。',
          'settings.gamepad.gyroInputSourceDevice' => '端末',
          'settings.gamepad.gyroInputSourceController' => 'コントローラー',
          'settings.gamepad.gyroSensitivityVertical' => 'ジャイロの垂直感度',
          'settings.gamepad.gyroSensitivityVerticalDescription' =>
            'ジャイロスコープの垂直方向（ピッチ）の感度を調整します。',
          'settings.gamepad.invertGyroVertical' => 'ジャイロの垂直軸を反転',
          'settings.gamepad.invertGyroVerticalDescription' =>
            'ジャイロスコープの垂直方向（ピッチ）の軸を反転します。',
          'settings.gamepad.gyroSensitivityHorizontal' => 'ジャイロの水平感度',
          'settings.gamepad.gyroSensitivityHorizontalDescription' =>
            'ジャイロスコープの水平方向（ヨー）の感度を調整します。',
          'settings.gamepad.invertGyroHorizontal' => 'ジャイロの水平軸を反転',
          'settings.gamepad.invertGyroHorizontalDescription' =>
            'ジャイロスコープの水平方向（ヨー）の軸を反転します。',
          'settings.gamepad.genericButtons' => 'ボタン',
          'settings.gamepad.buttonA' => 'A',
          'settings.gamepad.buttonB' => 'B',
          'settings.gamepad.buttonX' => 'X',
          'settings.gamepad.buttonY' => 'Y',
          'settings.gamepad.buttonSelect' => 'SELECT',
          'settings.gamepad.buttonStart' => 'START',
          'settings.gamepad.buttonHome' => 'HOME',
          'settings.gamepad.circlePad' => 'サークルパッド',
          'settings.gamepad.cStick' => 'Cスティック',
          'settings.gamepad.axisVertical' => '上下軸',
          'settings.gamepad.axisHorizontal' => '左右軸',
          'settings.gamepad.dpadAxis' => '十字キー（軸）',
          'settings.gamepad.dpadAxisDescription' =>
            'コントローラーによっては十字キーを軸としてマッピングできない場合があります。その場合は十字キー（ボタン）のセクションを使用してください。',
          'settings.gamepad.dpadButtons' => '十字キー（ボタン）',
          'settings.gamepad.dpadButtonsDescription' =>
            '十字キー（軸）のボタンマッピングで問題がある場合のみ、こちらに十字キーをマッピングしてください。',
          'settings.gamepad.buttonUp' => '上',
          'settings.gamepad.buttonDown' => '下',
          'settings.gamepad.buttonLeft' => '左',
          'settings.gamepad.buttonRight' => '右',
          'settings.gamepad.triggers' => 'トリガー',
          'settings.gamepad.buttonL' => 'L',
          'settings.gamepad.buttonR' => 'R',
          'settings.gamepad.buttonZl' => 'ZL',
          'settings.gamepad.buttonZr' => 'ZR',
          'settings.gamepad.hotkeys' => 'ホットキー',
          'settings.gamepad.hotkeySwapScreens' => '画面を入れ替え',
          'settings.gamepad.hotkeyCycleLayout' => 'レイアウトを切り替え',
          'settings.gamepad.hotkeyCloseGame' => 'ゲームを終了',
          'settings.gamepad.hotkeyPauseOrResume' => '一時停止を切り替え',
          'settings.gamepad.hotkeyQuicksave' => 'クイックセーブ',
          'settings.gamepad.hotkeyQuickload' => 'クイックロード',
          'settings.gamepad.miscellaneous' => 'その他',
          'settings.gamepad.useArticBaseController' =>
            'Artic Baseサーバー接続時にArticコントローラーを使用',
          'settings.gamepad.useArticBaseControllerDescription' =>
            'Artic Baseサーバーに接続している間、設定した入力デバイスの代わりにサーバーが提供するコントロールを使用します。',
          'settings.layout.title' => 'レイアウト',
          'settings.layout.screenOrientation' => '画面の向き',
          'settings.layout.screenOrientationAutoSensor' => '自動',
          'settings.layout.screenOrientationLandscape' => '横向き',
          'settings.layout.screenOrientationLandscapeReverse' => '横向き（反転）',
          'settings.layout.screenOrientationPortrait' => '縦向き',
          'settings.layout.screenOrientationPortraitReverse' => '縦向き（反転）',
          'settings.layout.customLandscapeLayout' => '横向きカスタムレイアウト',
          'settings.layout.customPortraitLayout' => '縦向きカスタムレイアウト',
          'settings.layout.topScreen' => '上画面',
          'settings.layout.bottomScreen' => '下画面',
          'settings.layout.positionX' => 'X座標',
          'settings.layout.positionY' => 'Y座標',
          'settings.layout.width' => '幅',
          'settings.layout.height' => '高さ',
          'settings.audio.title' => 'オーディオ',
          'settings.audio.volume' => '音量',
          'settings.audio.volumeDescription' =>
            'アプリの「マスター音量」とは別の、エミュレートされた3DS本体自体が持つ内部音量です。',
          'settings.audio.audioStretching' => 'オーディオストレッチング',
          'settings.audio.audioStretchingDescription' =>
            'カクつきを減らすために音声を引き伸ばします。オーディオの遅延が増加し、パフォーマンスがわずかに低下します。',
          'settings.audio.realtimeAudio' => 'リアルタイムオーディオ',
          'settings.audio.realtimeAudioDescription' =>
            'オーディオの遅延を減らしますが、一部のアプリケーションで不安定になることがあります。オーディオストレッチングが無効な場合のみ有効になります。',
          'settings.audio.audioInputType' => 'オーディオ入力タイプ',
          'settings.audio.audioInputTypeAuto' => '自動',
          'settings.audio.audioInputTypeNone' => 'なし',
          'settings.audio.audioInputTypeStaticNoise' => 'ホワイトノイズ',
          'settings.audio.audioInputTypeRealCubeb' => '実デバイス (Cubeb)',
          'settings.audio.audioInputTypeRealOpenal' => '実デバイス (OpenAL)',
          'settings.audio.soundOutputMode' => 'サウンド出力モード',
          'settings.audio.soundOutputModeMono' => 'モノラル',
          'settings.audio.soundOutputModeStereo' => 'ステレオ',
          'settings.audio.soundOutputModeSurround' => 'サラウンド',
          'settings.debug.title' => 'デバッグ',
          'settings.debug.warning' =>
            'これらの設定はデバッグ用途のみです。変更すると動作が不安定になる場合があります。',
          'settings.debug.logToConsole' => '標準出力にログを出力',
          'settings.debug.logToConsoleDescription' =>
            'ネイティブのログをFlutterの標準出力にも出力します。',
          'settings.debug.cpuClockSpeed' => 'CPUクロック速度',
          'settings.debug.cpuClockSpeedDescription' =>
            'エミュレートされたCPUをオーバークロック/アンダークロックします。推奨しません。',
          'settings.debug.cpuJit' => 'CPU JIT',
          'settings.debug.cpuJitDescription' =>
            'CPUエミュレーションにJIT（Just-In-Time）コンパイラを使用します。無効にすると、代わりにはるかに低速なインタプリタが使用されます。',
          'settings.debug.hwShaders' => 'ハードウェアシェーダー',
          'settings.debug.hwShadersDescription' =>
            'ソフトウェアレンダラーの代わりに、ハードウェアシェーダーで3DSのシェーダーをエミュレートします。無効にするとパフォーマンスが大きく低下します。',
          'settings.debug.vsync' => '垂直同期',
          'settings.debug.vsyncDescription' =>
            '描画をホストデバイスのディスプレイのリフレッシュレートと同期させます。',
          'settings.debug.rendererDebug' => 'レンダラーデバッグ',
          'settings.debug.rendererDebugDescription' =>
            '追加のレンダラーデバッグ機能を有効にします。パフォーマンスが低下します。',
          'settings.debug.instantDebugLog' => '即時デバッグログ',
          'settings.debug.instantDebugLogDescription' =>
            'バッファリングせず、即座にデバッグログへ書き込みます。パフォーマンスが低下します。',
          'settings.debug.delayStartLleModules' => 'LLEモジュールの開始を遅延させる',
          'settings.debug.delayStartLleModulesDescription' =>
            '競合状態を回避するため、LLEモジュールの開始を遅延させます。',
          'settings.debug.deterministicAsyncOperations' => '決定論的な非同期処理',
          'settings.debug.deterministicAsyncOperationsDescription' =>
            '非同期処理を決定論的な順序で実行するように強制します。パフォーマンスが低下します。',
          'settings.theme.title' => 'テーマと色',
          'settings.theme.themeStyle' => 'テーマスタイル',
          'settings.theme.materialYou' => 'Material You',
          'settings.theme.materialYouDescription' => '端末の壁紙から抽出した色を使用します。',
          'settings.theme.staticThemeColor' => '固定テーマカラー',
          'settings.theme.staticThemeColorDefault' => 'デフォルト',
          'settings.theme.staticThemeColorBlue' => '青',
          'settings.theme.staticThemeColorCyan' => 'シアン',
          'settings.theme.staticThemeColorRed' => '赤',
          'settings.theme.staticThemeColorGreen' => '緑',
          'settings.theme.staticThemeColorYellow' => '黄',
          'settings.theme.staticThemeColorOrange' => 'オレンジ',
          'settings.theme.staticThemeColorViolet' => '紫',
          'settings.theme.staticThemeColorPink' => 'ピンク',
          'settings.theme.staticThemeColorGray' => 'グレー',
          'settings.theme.themeMode' => 'テーマモード',
          'settings.theme.themeModeFollowSystem' => 'システムに従う',
          'settings.theme.themeModeLight' => 'ライト',
          'settings.theme.themeModeDark' => 'ダーク',
          'settings.theme.useBlackBackgrounds' => '黒背景を使用',
          'settings.theme.useBlackBackgroundsDescription' =>
            'ダークモード有効時に、ダークグレーの代わりに黒背景を使用します。',
          'settings.themes.azahar' => 'Azahar',
          'settings.themes.legacy' => 'Legacy',
          'settings.accessibility.title' => 'アクセシビリティ',
          'settings.accessibility.reduceMotion' => '視差効果を減らす',
          'settings.accessibility.reduceMotionDescription' =>
            'アプリ内のアニメーションや動きの効果を減らします。',
          'settings.advanced.title' => '詳細設定',
          'settings.advanced.animationSpeedLabel' => 'アニメーション速度',
          'settings.advanced.animationSpeedDescription' =>
            '画面遷移などのアニメーションの速さを調整します。',
          'settings.advanced.animationSpeed.fast' => '速い',
          'settings.advanced.animationSpeed.normal' => '普通',
          'settings.advanced.animationSpeed.slow' => '遅い',
          'settings.language.title' => '言語',
          'settings.language.systemDefault' => 'システムのデフォルト',
          'settings.language.english' => '英語 (English)',
          'settings.language.japanese' => '日本語',
          _ => null,
        };
  }
}
