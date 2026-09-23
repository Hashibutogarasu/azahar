// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GamesTable extends Games with TableInfo<$GamesTable, GameRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filenameMeta = const VerificationMeta(
    'filename',
  );
  @override
  late final GeneratedColumn<String> filename = GeneratedColumn<String>(
    'filename',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleIdMeta = const VerificationMeta(
    'titleId',
  );
  @override
  late final GeneratedColumn<int> titleId = GeneratedColumn<int>(
    'title_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionsMeta = const VerificationMeta(
    'regions',
  );
  @override
  late final GeneratedColumn<String> regions = GeneratedColumn<String>(
    'regions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInstalledMeta = const VerificationMeta(
    'isInstalled',
  );
  @override
  late final GeneratedColumn<bool> isInstalled = GeneratedColumn<bool>(
    'is_installed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_installed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isSystemTitleMeta = const VerificationMeta(
    'isSystemTitle',
  );
  @override
  late final GeneratedColumn<bool> isSystemTitle = GeneratedColumn<bool>(
    'is_system_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_title" IN (0, 1))',
    ),
  );
  static const VerificationMeta _isVisibleSystemTitleMeta =
      const VerificationMeta('isVisibleSystemTitle');
  @override
  late final GeneratedColumn<bool> isVisibleSystemTitle = GeneratedColumn<bool>(
    'is_visible_system_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_visible_system_title" IN (0, 1))',
    ),
  );
  static const VerificationMeta _iconPathMeta = const VerificationMeta(
    'iconPath',
  );
  @override
  late final GeneratedColumn<String> iconPath = GeneratedColumn<String>(
    'icon_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedToLibraryTimeMeta =
      const VerificationMeta('addedToLibraryTime');
  @override
  late final GeneratedColumn<DateTime> addedToLibraryTime =
      GeneratedColumn<DateTime>(
        'added_to_library_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastPlayedTimeMeta = const VerificationMeta(
    'lastPlayedTime',
  );
  @override
  late final GeneratedColumn<DateTime> lastPlayedTime =
      GeneratedColumn<DateTime>(
        'last_played_time',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    path,
    filename,
    title,
    description,
    titleId,
    company,
    regions,
    isInstalled,
    isSystemTitle,
    isVisibleSystemTitle,
    iconPath,
    addedToLibraryTime,
    lastPlayedTime,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'games';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(
        _filenameMeta,
        filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta),
      );
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('title_id')) {
      context.handle(
        _titleIdMeta,
        titleId.isAcceptableOrUnknown(data['title_id']!, _titleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_titleIdMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('regions')) {
      context.handle(
        _regionsMeta,
        regions.isAcceptableOrUnknown(data['regions']!, _regionsMeta),
      );
    } else if (isInserting) {
      context.missing(_regionsMeta);
    }
    if (data.containsKey('is_installed')) {
      context.handle(
        _isInstalledMeta,
        isInstalled.isAcceptableOrUnknown(
          data['is_installed']!,
          _isInstalledMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isInstalledMeta);
    }
    if (data.containsKey('is_system_title')) {
      context.handle(
        _isSystemTitleMeta,
        isSystemTitle.isAcceptableOrUnknown(
          data['is_system_title']!,
          _isSystemTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isSystemTitleMeta);
    }
    if (data.containsKey('is_visible_system_title')) {
      context.handle(
        _isVisibleSystemTitleMeta,
        isVisibleSystemTitle.isAcceptableOrUnknown(
          data['is_visible_system_title']!,
          _isVisibleSystemTitleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isVisibleSystemTitleMeta);
    }
    if (data.containsKey('icon_path')) {
      context.handle(
        _iconPathMeta,
        iconPath.isAcceptableOrUnknown(data['icon_path']!, _iconPathMeta),
      );
    }
    if (data.containsKey('added_to_library_time')) {
      context.handle(
        _addedToLibraryTimeMeta,
        addedToLibraryTime.isAcceptableOrUnknown(
          data['added_to_library_time']!,
          _addedToLibraryTimeMeta,
        ),
      );
    }
    if (data.containsKey('last_played_time')) {
      context.handle(
        _lastPlayedTimeMeta,
        lastPlayedTime.isAcceptableOrUnknown(
          data['last_played_time']!,
          _lastPlayedTimeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {path};
  @override
  GameRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameRow(
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      filename: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}filename'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      titleId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}title_id'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      regions: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}regions'],
      )!,
      isInstalled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_installed'],
      )!,
      isSystemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_title'],
      )!,
      isVisibleSystemTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_visible_system_title'],
      )!,
      iconPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_path'],
      ),
      addedToLibraryTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_to_library_time'],
      ),
      lastPlayedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_played_time'],
      ),
    );
  }

  @override
  $GamesTable createAlias(String alias) {
    return $GamesTable(attachedDatabase, alias);
  }
}

class GameRow extends DataClass implements Insertable<GameRow> {
  final String path;
  final String filename;
  final String title;
  final String description;
  final int titleId;
  final String company;
  final String regions;
  final bool isInstalled;
  final bool isSystemTitle;
  final bool isVisibleSystemTitle;
  final String? iconPath;
  final DateTime? addedToLibraryTime;
  final DateTime? lastPlayedTime;
  const GameRow({
    required this.path,
    required this.filename,
    required this.title,
    required this.description,
    required this.titleId,
    required this.company,
    required this.regions,
    required this.isInstalled,
    required this.isSystemTitle,
    required this.isVisibleSystemTitle,
    this.iconPath,
    this.addedToLibraryTime,
    this.lastPlayedTime,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['path'] = Variable<String>(path);
    map['filename'] = Variable<String>(filename);
    map['title'] = Variable<String>(title);
    map['description'] = Variable<String>(description);
    map['title_id'] = Variable<int>(titleId);
    map['company'] = Variable<String>(company);
    map['regions'] = Variable<String>(regions);
    map['is_installed'] = Variable<bool>(isInstalled);
    map['is_system_title'] = Variable<bool>(isSystemTitle);
    map['is_visible_system_title'] = Variable<bool>(isVisibleSystemTitle);
    if (!nullToAbsent || iconPath != null) {
      map['icon_path'] = Variable<String>(iconPath);
    }
    if (!nullToAbsent || addedToLibraryTime != null) {
      map['added_to_library_time'] = Variable<DateTime>(addedToLibraryTime);
    }
    if (!nullToAbsent || lastPlayedTime != null) {
      map['last_played_time'] = Variable<DateTime>(lastPlayedTime);
    }
    return map;
  }

  GamesCompanion toCompanion(bool nullToAbsent) {
    return GamesCompanion(
      path: Value(path),
      filename: Value(filename),
      title: Value(title),
      description: Value(description),
      titleId: Value(titleId),
      company: Value(company),
      regions: Value(regions),
      isInstalled: Value(isInstalled),
      isSystemTitle: Value(isSystemTitle),
      isVisibleSystemTitle: Value(isVisibleSystemTitle),
      iconPath: iconPath == null && nullToAbsent
          ? const Value.absent()
          : Value(iconPath),
      addedToLibraryTime: addedToLibraryTime == null && nullToAbsent
          ? const Value.absent()
          : Value(addedToLibraryTime),
      lastPlayedTime: lastPlayedTime == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPlayedTime),
    );
  }

  factory GameRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameRow(
      path: serializer.fromJson<String>(json['path']),
      filename: serializer.fromJson<String>(json['filename']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String>(json['description']),
      titleId: serializer.fromJson<int>(json['titleId']),
      company: serializer.fromJson<String>(json['company']),
      regions: serializer.fromJson<String>(json['regions']),
      isInstalled: serializer.fromJson<bool>(json['isInstalled']),
      isSystemTitle: serializer.fromJson<bool>(json['isSystemTitle']),
      isVisibleSystemTitle: serializer.fromJson<bool>(
        json['isVisibleSystemTitle'],
      ),
      iconPath: serializer.fromJson<String?>(json['iconPath']),
      addedToLibraryTime: serializer.fromJson<DateTime?>(
        json['addedToLibraryTime'],
      ),
      lastPlayedTime: serializer.fromJson<DateTime?>(json['lastPlayedTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'path': serializer.toJson<String>(path),
      'filename': serializer.toJson<String>(filename),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String>(description),
      'titleId': serializer.toJson<int>(titleId),
      'company': serializer.toJson<String>(company),
      'regions': serializer.toJson<String>(regions),
      'isInstalled': serializer.toJson<bool>(isInstalled),
      'isSystemTitle': serializer.toJson<bool>(isSystemTitle),
      'isVisibleSystemTitle': serializer.toJson<bool>(isVisibleSystemTitle),
      'iconPath': serializer.toJson<String?>(iconPath),
      'addedToLibraryTime': serializer.toJson<DateTime?>(addedToLibraryTime),
      'lastPlayedTime': serializer.toJson<DateTime?>(lastPlayedTime),
    };
  }

  GameRow copyWith({
    String? path,
    String? filename,
    String? title,
    String? description,
    int? titleId,
    String? company,
    String? regions,
    bool? isInstalled,
    bool? isSystemTitle,
    bool? isVisibleSystemTitle,
    Value<String?> iconPath = const Value.absent(),
    Value<DateTime?> addedToLibraryTime = const Value.absent(),
    Value<DateTime?> lastPlayedTime = const Value.absent(),
  }) => GameRow(
    path: path ?? this.path,
    filename: filename ?? this.filename,
    title: title ?? this.title,
    description: description ?? this.description,
    titleId: titleId ?? this.titleId,
    company: company ?? this.company,
    regions: regions ?? this.regions,
    isInstalled: isInstalled ?? this.isInstalled,
    isSystemTitle: isSystemTitle ?? this.isSystemTitle,
    isVisibleSystemTitle: isVisibleSystemTitle ?? this.isVisibleSystemTitle,
    iconPath: iconPath.present ? iconPath.value : this.iconPath,
    addedToLibraryTime: addedToLibraryTime.present
        ? addedToLibraryTime.value
        : this.addedToLibraryTime,
    lastPlayedTime: lastPlayedTime.present
        ? lastPlayedTime.value
        : this.lastPlayedTime,
  );
  GameRow copyWithCompanion(GamesCompanion data) {
    return GameRow(
      path: data.path.present ? data.path.value : this.path,
      filename: data.filename.present ? data.filename.value : this.filename,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      titleId: data.titleId.present ? data.titleId.value : this.titleId,
      company: data.company.present ? data.company.value : this.company,
      regions: data.regions.present ? data.regions.value : this.regions,
      isInstalled: data.isInstalled.present
          ? data.isInstalled.value
          : this.isInstalled,
      isSystemTitle: data.isSystemTitle.present
          ? data.isSystemTitle.value
          : this.isSystemTitle,
      isVisibleSystemTitle: data.isVisibleSystemTitle.present
          ? data.isVisibleSystemTitle.value
          : this.isVisibleSystemTitle,
      iconPath: data.iconPath.present ? data.iconPath.value : this.iconPath,
      addedToLibraryTime: data.addedToLibraryTime.present
          ? data.addedToLibraryTime.value
          : this.addedToLibraryTime,
      lastPlayedTime: data.lastPlayedTime.present
          ? data.lastPlayedTime.value
          : this.lastPlayedTime,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameRow(')
          ..write('path: $path, ')
          ..write('filename: $filename, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('titleId: $titleId, ')
          ..write('company: $company, ')
          ..write('regions: $regions, ')
          ..write('isInstalled: $isInstalled, ')
          ..write('isSystemTitle: $isSystemTitle, ')
          ..write('isVisibleSystemTitle: $isVisibleSystemTitle, ')
          ..write('iconPath: $iconPath, ')
          ..write('addedToLibraryTime: $addedToLibraryTime, ')
          ..write('lastPlayedTime: $lastPlayedTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    path,
    filename,
    title,
    description,
    titleId,
    company,
    regions,
    isInstalled,
    isSystemTitle,
    isVisibleSystemTitle,
    iconPath,
    addedToLibraryTime,
    lastPlayedTime,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameRow &&
          other.path == this.path &&
          other.filename == this.filename &&
          other.title == this.title &&
          other.description == this.description &&
          other.titleId == this.titleId &&
          other.company == this.company &&
          other.regions == this.regions &&
          other.isInstalled == this.isInstalled &&
          other.isSystemTitle == this.isSystemTitle &&
          other.isVisibleSystemTitle == this.isVisibleSystemTitle &&
          other.iconPath == this.iconPath &&
          other.addedToLibraryTime == this.addedToLibraryTime &&
          other.lastPlayedTime == this.lastPlayedTime);
}

class GamesCompanion extends UpdateCompanion<GameRow> {
  final Value<String> path;
  final Value<String> filename;
  final Value<String> title;
  final Value<String> description;
  final Value<int> titleId;
  final Value<String> company;
  final Value<String> regions;
  final Value<bool> isInstalled;
  final Value<bool> isSystemTitle;
  final Value<bool> isVisibleSystemTitle;
  final Value<String?> iconPath;
  final Value<DateTime?> addedToLibraryTime;
  final Value<DateTime?> lastPlayedTime;
  final Value<int> rowid;
  const GamesCompanion({
    this.path = const Value.absent(),
    this.filename = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.titleId = const Value.absent(),
    this.company = const Value.absent(),
    this.regions = const Value.absent(),
    this.isInstalled = const Value.absent(),
    this.isSystemTitle = const Value.absent(),
    this.isVisibleSystemTitle = const Value.absent(),
    this.iconPath = const Value.absent(),
    this.addedToLibraryTime = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GamesCompanion.insert({
    required String path,
    required String filename,
    required String title,
    required String description,
    required int titleId,
    required String company,
    required String regions,
    required bool isInstalled,
    required bool isSystemTitle,
    required bool isVisibleSystemTitle,
    this.iconPath = const Value.absent(),
    this.addedToLibraryTime = const Value.absent(),
    this.lastPlayedTime = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : path = Value(path),
       filename = Value(filename),
       title = Value(title),
       description = Value(description),
       titleId = Value(titleId),
       company = Value(company),
       regions = Value(regions),
       isInstalled = Value(isInstalled),
       isSystemTitle = Value(isSystemTitle),
       isVisibleSystemTitle = Value(isVisibleSystemTitle);
  static Insertable<GameRow> custom({
    Expression<String>? path,
    Expression<String>? filename,
    Expression<String>? title,
    Expression<String>? description,
    Expression<int>? titleId,
    Expression<String>? company,
    Expression<String>? regions,
    Expression<bool>? isInstalled,
    Expression<bool>? isSystemTitle,
    Expression<bool>? isVisibleSystemTitle,
    Expression<String>? iconPath,
    Expression<DateTime>? addedToLibraryTime,
    Expression<DateTime>? lastPlayedTime,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (path != null) 'path': path,
      if (filename != null) 'filename': filename,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (titleId != null) 'title_id': titleId,
      if (company != null) 'company': company,
      if (regions != null) 'regions': regions,
      if (isInstalled != null) 'is_installed': isInstalled,
      if (isSystemTitle != null) 'is_system_title': isSystemTitle,
      if (isVisibleSystemTitle != null)
        'is_visible_system_title': isVisibleSystemTitle,
      if (iconPath != null) 'icon_path': iconPath,
      if (addedToLibraryTime != null)
        'added_to_library_time': addedToLibraryTime,
      if (lastPlayedTime != null) 'last_played_time': lastPlayedTime,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GamesCompanion copyWith({
    Value<String>? path,
    Value<String>? filename,
    Value<String>? title,
    Value<String>? description,
    Value<int>? titleId,
    Value<String>? company,
    Value<String>? regions,
    Value<bool>? isInstalled,
    Value<bool>? isSystemTitle,
    Value<bool>? isVisibleSystemTitle,
    Value<String?>? iconPath,
    Value<DateTime?>? addedToLibraryTime,
    Value<DateTime?>? lastPlayedTime,
    Value<int>? rowid,
  }) {
    return GamesCompanion(
      path: path ?? this.path,
      filename: filename ?? this.filename,
      title: title ?? this.title,
      description: description ?? this.description,
      titleId: titleId ?? this.titleId,
      company: company ?? this.company,
      regions: regions ?? this.regions,
      isInstalled: isInstalled ?? this.isInstalled,
      isSystemTitle: isSystemTitle ?? this.isSystemTitle,
      isVisibleSystemTitle: isVisibleSystemTitle ?? this.isVisibleSystemTitle,
      iconPath: iconPath ?? this.iconPath,
      addedToLibraryTime: addedToLibraryTime ?? this.addedToLibraryTime,
      lastPlayedTime: lastPlayedTime ?? this.lastPlayedTime,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (titleId.present) {
      map['title_id'] = Variable<int>(titleId.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (regions.present) {
      map['regions'] = Variable<String>(regions.value);
    }
    if (isInstalled.present) {
      map['is_installed'] = Variable<bool>(isInstalled.value);
    }
    if (isSystemTitle.present) {
      map['is_system_title'] = Variable<bool>(isSystemTitle.value);
    }
    if (isVisibleSystemTitle.present) {
      map['is_visible_system_title'] = Variable<bool>(
        isVisibleSystemTitle.value,
      );
    }
    if (iconPath.present) {
      map['icon_path'] = Variable<String>(iconPath.value);
    }
    if (addedToLibraryTime.present) {
      map['added_to_library_time'] = Variable<DateTime>(
        addedToLibraryTime.value,
      );
    }
    if (lastPlayedTime.present) {
      map['last_played_time'] = Variable<DateTime>(lastPlayedTime.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GamesCompanion(')
          ..write('path: $path, ')
          ..write('filename: $filename, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('titleId: $titleId, ')
          ..write('company: $company, ')
          ..write('regions: $regions, ')
          ..write('isInstalled: $isInstalled, ')
          ..write('isSystemTitle: $isSystemTitle, ')
          ..write('isVisibleSystemTitle: $isVisibleSystemTitle, ')
          ..write('iconPath: $iconPath, ')
          ..write('addedToLibraryTime: $addedToLibraryTime, ')
          ..write('lastPlayedTime: $lastPlayedTime, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ControlBindingsTable extends ControlBindings
    with TableInfo<$ControlBindingsTable, ControlBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ControlBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'control_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ControlBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  ControlBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ControlBinding(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $ControlBindingsTable createAlias(String alias) {
    return $ControlBindingsTable(attachedDatabase, alias);
  }
}

class ControlBinding extends DataClass implements Insertable<ControlBinding> {
  final String key;
  final String value;
  const ControlBinding({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  ControlBindingsCompanion toCompanion(bool nullToAbsent) {
    return ControlBindingsCompanion(key: Value(key), value: Value(value));
  }

  factory ControlBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ControlBinding(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  ControlBinding copyWith({String? key, String? value}) =>
      ControlBinding(key: key ?? this.key, value: value ?? this.value);
  ControlBinding copyWithCompanion(ControlBindingsCompanion data) {
    return ControlBinding(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ControlBinding(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ControlBinding &&
          other.key == this.key &&
          other.value == this.value);
}

class ControlBindingsCompanion extends UpdateCompanion<ControlBinding> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const ControlBindingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ControlBindingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<ControlBinding> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ControlBindingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return ControlBindingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ControlBindingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InputLayoutElementsTable extends InputLayoutElements
    with TableInfo<$InputLayoutElementsTable, InputLayoutElement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InputLayoutElementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _orientationMeta = const VerificationMeta(
    'orientation',
  );
  @override
  late final GeneratedColumn<String> orientation = GeneratedColumn<String>(
    'orientation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _elementIdMeta = const VerificationMeta(
    'elementId',
  );
  @override
  late final GeneratedColumn<String> elementId = GeneratedColumn<String>(
    'element_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _xMeta = const VerificationMeta('x');
  @override
  late final GeneratedColumn<int> x = GeneratedColumn<int>(
    'x',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yMeta = const VerificationMeta('y');
  @override
  late final GeneratedColumn<int> y = GeneratedColumn<int>(
    'y',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _widthMeta = const VerificationMeta('width');
  @override
  late final GeneratedColumn<int> width = GeneratedColumn<int>(
    'width',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightMeta = const VerificationMeta('height');
  @override
  late final GeneratedColumn<int> height = GeneratedColumn<int>(
    'height',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    orientation,
    elementId,
    x,
    y,
    width,
    height,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'input_layout_elements';
  @override
  VerificationContext validateIntegrity(
    Insertable<InputLayoutElement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('orientation')) {
      context.handle(
        _orientationMeta,
        orientation.isAcceptableOrUnknown(
          data['orientation']!,
          _orientationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_orientationMeta);
    }
    if (data.containsKey('element_id')) {
      context.handle(
        _elementIdMeta,
        elementId.isAcceptableOrUnknown(data['element_id']!, _elementIdMeta),
      );
    } else if (isInserting) {
      context.missing(_elementIdMeta);
    }
    if (data.containsKey('x')) {
      context.handle(_xMeta, x.isAcceptableOrUnknown(data['x']!, _xMeta));
    } else if (isInserting) {
      context.missing(_xMeta);
    }
    if (data.containsKey('y')) {
      context.handle(_yMeta, y.isAcceptableOrUnknown(data['y']!, _yMeta));
    } else if (isInserting) {
      context.missing(_yMeta);
    }
    if (data.containsKey('width')) {
      context.handle(
        _widthMeta,
        width.isAcceptableOrUnknown(data['width']!, _widthMeta),
      );
    } else if (isInserting) {
      context.missing(_widthMeta);
    }
    if (data.containsKey('height')) {
      context.handle(
        _heightMeta,
        height.isAcceptableOrUnknown(data['height']!, _heightMeta),
      );
    } else if (isInserting) {
      context.missing(_heightMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {orientation, elementId};
  @override
  InputLayoutElement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InputLayoutElement(
      orientation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}orientation'],
      )!,
      elementId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}element_id'],
      )!,
      x: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}x'],
      )!,
      y: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}y'],
      )!,
      width: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}width'],
      )!,
      height: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height'],
      )!,
    );
  }

  @override
  $InputLayoutElementsTable createAlias(String alias) {
    return $InputLayoutElementsTable(attachedDatabase, alias);
  }
}

class InputLayoutElement extends DataClass
    implements Insertable<InputLayoutElement> {
  final String orientation;
  final String elementId;
  final int x;
  final int y;
  final int width;
  final int height;
  const InputLayoutElement({
    required this.orientation,
    required this.elementId,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['orientation'] = Variable<String>(orientation);
    map['element_id'] = Variable<String>(elementId);
    map['x'] = Variable<int>(x);
    map['y'] = Variable<int>(y);
    map['width'] = Variable<int>(width);
    map['height'] = Variable<int>(height);
    return map;
  }

  InputLayoutElementsCompanion toCompanion(bool nullToAbsent) {
    return InputLayoutElementsCompanion(
      orientation: Value(orientation),
      elementId: Value(elementId),
      x: Value(x),
      y: Value(y),
      width: Value(width),
      height: Value(height),
    );
  }

  factory InputLayoutElement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InputLayoutElement(
      orientation: serializer.fromJson<String>(json['orientation']),
      elementId: serializer.fromJson<String>(json['elementId']),
      x: serializer.fromJson<int>(json['x']),
      y: serializer.fromJson<int>(json['y']),
      width: serializer.fromJson<int>(json['width']),
      height: serializer.fromJson<int>(json['height']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'orientation': serializer.toJson<String>(orientation),
      'elementId': serializer.toJson<String>(elementId),
      'x': serializer.toJson<int>(x),
      'y': serializer.toJson<int>(y),
      'width': serializer.toJson<int>(width),
      'height': serializer.toJson<int>(height),
    };
  }

  InputLayoutElement copyWith({
    String? orientation,
    String? elementId,
    int? x,
    int? y,
    int? width,
    int? height,
  }) => InputLayoutElement(
    orientation: orientation ?? this.orientation,
    elementId: elementId ?? this.elementId,
    x: x ?? this.x,
    y: y ?? this.y,
    width: width ?? this.width,
    height: height ?? this.height,
  );
  InputLayoutElement copyWithCompanion(InputLayoutElementsCompanion data) {
    return InputLayoutElement(
      orientation: data.orientation.present
          ? data.orientation.value
          : this.orientation,
      elementId: data.elementId.present ? data.elementId.value : this.elementId,
      x: data.x.present ? data.x.value : this.x,
      y: data.y.present ? data.y.value : this.y,
      width: data.width.present ? data.width.value : this.width,
      height: data.height.present ? data.height.value : this.height,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InputLayoutElement(')
          ..write('orientation: $orientation, ')
          ..write('elementId: $elementId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(orientation, elementId, x, y, width, height);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InputLayoutElement &&
          other.orientation == this.orientation &&
          other.elementId == this.elementId &&
          other.x == this.x &&
          other.y == this.y &&
          other.width == this.width &&
          other.height == this.height);
}

class InputLayoutElementsCompanion extends UpdateCompanion<InputLayoutElement> {
  final Value<String> orientation;
  final Value<String> elementId;
  final Value<int> x;
  final Value<int> y;
  final Value<int> width;
  final Value<int> height;
  final Value<int> rowid;
  const InputLayoutElementsCompanion({
    this.orientation = const Value.absent(),
    this.elementId = const Value.absent(),
    this.x = const Value.absent(),
    this.y = const Value.absent(),
    this.width = const Value.absent(),
    this.height = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InputLayoutElementsCompanion.insert({
    required String orientation,
    required String elementId,
    required int x,
    required int y,
    required int width,
    required int height,
    this.rowid = const Value.absent(),
  }) : orientation = Value(orientation),
       elementId = Value(elementId),
       x = Value(x),
       y = Value(y),
       width = Value(width),
       height = Value(height);
  static Insertable<InputLayoutElement> custom({
    Expression<String>? orientation,
    Expression<String>? elementId,
    Expression<int>? x,
    Expression<int>? y,
    Expression<int>? width,
    Expression<int>? height,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (orientation != null) 'orientation': orientation,
      if (elementId != null) 'element_id': elementId,
      if (x != null) 'x': x,
      if (y != null) 'y': y,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InputLayoutElementsCompanion copyWith({
    Value<String>? orientation,
    Value<String>? elementId,
    Value<int>? x,
    Value<int>? y,
    Value<int>? width,
    Value<int>? height,
    Value<int>? rowid,
  }) {
    return InputLayoutElementsCompanion(
      orientation: orientation ?? this.orientation,
      elementId: elementId ?? this.elementId,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (orientation.present) {
      map['orientation'] = Variable<String>(orientation.value);
    }
    if (elementId.present) {
      map['element_id'] = Variable<String>(elementId.value);
    }
    if (x.present) {
      map['x'] = Variable<int>(x.value);
    }
    if (y.present) {
      map['y'] = Variable<int>(y.value);
    }
    if (width.present) {
      map['width'] = Variable<int>(width.value);
    }
    if (height.present) {
      map['height'] = Variable<int>(height.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InputLayoutElementsCompanion(')
          ..write('orientation: $orientation, ')
          ..write('elementId: $elementId, ')
          ..write('x: $x, ')
          ..write('y: $y, ')
          ..write('width: $width, ')
          ..write('height: $height, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ThemeSettingsTable extends ThemeSettings
    with TableInfo<$ThemeSettingsTable, ThemeSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemeSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _staticThemeColorMeta = const VerificationMeta(
    'staticThemeColor',
  );
  @override
  late final GeneratedColumn<int> staticThemeColor = GeneratedColumn<int>(
    'static_theme_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _blackBackgroundsMeta = const VerificationMeta(
    'blackBackgrounds',
  );
  @override
  late final GeneratedColumn<bool> blackBackgrounds = GeneratedColumn<bool>(
    'black_backgrounds',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("black_backgrounds" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _materialYouMeta = const VerificationMeta(
    'materialYou',
  );
  @override
  late final GeneratedColumn<bool> materialYou = GeneratedColumn<bool>(
    'material_you',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("material_you" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    staticThemeColor,
    blackBackgrounds,
    materialYou,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theme_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThemeSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('static_theme_color')) {
      context.handle(
        _staticThemeColorMeta,
        staticThemeColor.isAcceptableOrUnknown(
          data['static_theme_color']!,
          _staticThemeColorMeta,
        ),
      );
    }
    if (data.containsKey('black_backgrounds')) {
      context.handle(
        _blackBackgroundsMeta,
        blackBackgrounds.isAcceptableOrUnknown(
          data['black_backgrounds']!,
          _blackBackgroundsMeta,
        ),
      );
    }
    if (data.containsKey('material_you')) {
      context.handle(
        _materialYouMeta,
        materialYou.isAcceptableOrUnknown(
          data['material_you']!,
          _materialYouMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThemeSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThemeSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      staticThemeColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}static_theme_color'],
      )!,
      blackBackgrounds: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}black_backgrounds'],
      )!,
      materialYou: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}material_you'],
      )!,
    );
  }

  @override
  $ThemeSettingsTable createAlias(String alias) {
    return $ThemeSettingsTable(attachedDatabase, alias);
  }
}

class ThemeSetting extends DataClass implements Insertable<ThemeSetting> {
  final int id;
  final String themeMode;
  final int staticThemeColor;
  final bool blackBackgrounds;
  final bool materialYou;
  const ThemeSetting({
    required this.id,
    required this.themeMode,
    required this.staticThemeColor,
    required this.blackBackgrounds,
    required this.materialYou,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['static_theme_color'] = Variable<int>(staticThemeColor);
    map['black_backgrounds'] = Variable<bool>(blackBackgrounds);
    map['material_you'] = Variable<bool>(materialYou);
    return map;
  }

  ThemeSettingsCompanion toCompanion(bool nullToAbsent) {
    return ThemeSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      staticThemeColor: Value(staticThemeColor),
      blackBackgrounds: Value(blackBackgrounds),
      materialYou: Value(materialYou),
    );
  }

  factory ThemeSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThemeSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      staticThemeColor: serializer.fromJson<int>(json['staticThemeColor']),
      blackBackgrounds: serializer.fromJson<bool>(json['blackBackgrounds']),
      materialYou: serializer.fromJson<bool>(json['materialYou']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<String>(themeMode),
      'staticThemeColor': serializer.toJson<int>(staticThemeColor),
      'blackBackgrounds': serializer.toJson<bool>(blackBackgrounds),
      'materialYou': serializer.toJson<bool>(materialYou),
    };
  }

  ThemeSetting copyWith({
    int? id,
    String? themeMode,
    int? staticThemeColor,
    bool? blackBackgrounds,
    bool? materialYou,
  }) => ThemeSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    staticThemeColor: staticThemeColor ?? this.staticThemeColor,
    blackBackgrounds: blackBackgrounds ?? this.blackBackgrounds,
    materialYou: materialYou ?? this.materialYou,
  );
  ThemeSetting copyWithCompanion(ThemeSettingsCompanion data) {
    return ThemeSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      staticThemeColor: data.staticThemeColor.present
          ? data.staticThemeColor.value
          : this.staticThemeColor,
      blackBackgrounds: data.blackBackgrounds.present
          ? data.blackBackgrounds.value
          : this.blackBackgrounds,
      materialYou: data.materialYou.present
          ? data.materialYou.value
          : this.materialYou,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('staticThemeColor: $staticThemeColor, ')
          ..write('blackBackgrounds: $blackBackgrounds, ')
          ..write('materialYou: $materialYou')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    staticThemeColor,
    blackBackgrounds,
    materialYou,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.staticThemeColor == this.staticThemeColor &&
          other.blackBackgrounds == this.blackBackgrounds &&
          other.materialYou == this.materialYou);
}

class ThemeSettingsCompanion extends UpdateCompanion<ThemeSetting> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<int> staticThemeColor;
  final Value<bool> blackBackgrounds;
  final Value<bool> materialYou;
  const ThemeSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.staticThemeColor = const Value.absent(),
    this.blackBackgrounds = const Value.absent(),
    this.materialYou = const Value.absent(),
  });
  ThemeSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.staticThemeColor = const Value.absent(),
    this.blackBackgrounds = const Value.absent(),
    this.materialYou = const Value.absent(),
  });
  static Insertable<ThemeSetting> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<int>? staticThemeColor,
    Expression<bool>? blackBackgrounds,
    Expression<bool>? materialYou,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (staticThemeColor != null) 'static_theme_color': staticThemeColor,
      if (blackBackgrounds != null) 'black_backgrounds': blackBackgrounds,
      if (materialYou != null) 'material_you': materialYou,
    });
  }

  ThemeSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<int>? staticThemeColor,
    Value<bool>? blackBackgrounds,
    Value<bool>? materialYou,
  }) {
    return ThemeSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      staticThemeColor: staticThemeColor ?? this.staticThemeColor,
      blackBackgrounds: blackBackgrounds ?? this.blackBackgrounds,
      materialYou: materialYou ?? this.materialYou,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (staticThemeColor.present) {
      map['static_theme_color'] = Variable<int>(staticThemeColor.value);
    }
    if (blackBackgrounds.present) {
      map['black_backgrounds'] = Variable<bool>(blackBackgrounds.value);
    }
    if (materialYou.present) {
      map['material_you'] = Variable<bool>(materialYou.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('staticThemeColor: $staticThemeColor, ')
          ..write('blackBackgrounds: $blackBackgrounds, ')
          ..write('materialYou: $materialYou')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ControlBindingsTable controlBindings = $ControlBindingsTable(
    this,
  );
  late final $InputLayoutElementsTable inputLayoutElements =
      $InputLayoutElementsTable(this);
  late final $ThemeSettingsTable themeSettings = $ThemeSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    games,
    appSettings,
    controlBindings,
    inputLayoutElements,
    themeSettings,
  ];
}

typedef $$GamesTableCreateCompanionBuilder =
    GamesCompanion Function({
      required String path,
      required String filename,
      required String title,
      required String description,
      required int titleId,
      required String company,
      required String regions,
      required bool isInstalled,
      required bool isSystemTitle,
      required bool isVisibleSystemTitle,
      Value<String?> iconPath,
      Value<DateTime?> addedToLibraryTime,
      Value<DateTime?> lastPlayedTime,
      Value<int> rowid,
    });
typedef $$GamesTableUpdateCompanionBuilder =
    GamesCompanion Function({
      Value<String> path,
      Value<String> filename,
      Value<String> title,
      Value<String> description,
      Value<int> titleId,
      Value<String> company,
      Value<String> regions,
      Value<bool> isInstalled,
      Value<bool> isSystemTitle,
      Value<bool> isVisibleSystemTitle,
      Value<String?> iconPath,
      Value<DateTime?> addedToLibraryTime,
      Value<DateTime?> lastPlayedTime,
      Value<int> rowid,
    });

class $$GamesTableFilterComposer extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get titleId => $composableBuilder(
    column: $table.titleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get regions => $composableBuilder(
    column: $table.regions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemTitle => $composableBuilder(
    column: $table.isSystemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVisibleSystemTitle => $composableBuilder(
    column: $table.isVisibleSystemTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedToLibraryTime => $composableBuilder(
    column: $table.addedToLibraryTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastPlayedTime => $composableBuilder(
    column: $table.lastPlayedTime,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GamesTableOrderingComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filename => $composableBuilder(
    column: $table.filename,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get titleId => $composableBuilder(
    column: $table.titleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get regions => $composableBuilder(
    column: $table.regions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemTitle => $composableBuilder(
    column: $table.isSystemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVisibleSystemTitle => $composableBuilder(
    column: $table.isVisibleSystemTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconPath => $composableBuilder(
    column: $table.iconPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedToLibraryTime => $composableBuilder(
    column: $table.addedToLibraryTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastPlayedTime => $composableBuilder(
    column: $table.lastPlayedTime,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GamesTable> {
  $$GamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get filename =>
      $composableBuilder(column: $table.filename, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get titleId =>
      $composableBuilder(column: $table.titleId, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get regions =>
      $composableBuilder(column: $table.regions, builder: (column) => column);

  GeneratedColumn<bool> get isInstalled => $composableBuilder(
    column: $table.isInstalled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isSystemTitle => $composableBuilder(
    column: $table.isSystemTitle,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVisibleSystemTitle => $composableBuilder(
    column: $table.isVisibleSystemTitle,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconPath =>
      $composableBuilder(column: $table.iconPath, builder: (column) => column);

  GeneratedColumn<DateTime> get addedToLibraryTime => $composableBuilder(
    column: $table.addedToLibraryTime,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastPlayedTime => $composableBuilder(
    column: $table.lastPlayedTime,
    builder: (column) => column,
  );
}

class $$GamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GamesTable,
          GameRow,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (GameRow, BaseReferences<_$AppDatabase, $GamesTable, GameRow>),
          GameRow,
          PrefetchHooks Function()
        > {
  $$GamesTableTableManager(_$AppDatabase db, $GamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> path = const Value.absent(),
                Value<String> filename = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> titleId = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> regions = const Value.absent(),
                Value<bool> isInstalled = const Value.absent(),
                Value<bool> isSystemTitle = const Value.absent(),
                Value<bool> isVisibleSystemTitle = const Value.absent(),
                Value<String?> iconPath = const Value.absent(),
                Value<DateTime?> addedToLibraryTime = const Value.absent(),
                Value<DateTime?> lastPlayedTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion(
                path: path,
                filename: filename,
                title: title,
                description: description,
                titleId: titleId,
                company: company,
                regions: regions,
                isInstalled: isInstalled,
                isSystemTitle: isSystemTitle,
                isVisibleSystemTitle: isVisibleSystemTitle,
                iconPath: iconPath,
                addedToLibraryTime: addedToLibraryTime,
                lastPlayedTime: lastPlayedTime,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String path,
                required String filename,
                required String title,
                required String description,
                required int titleId,
                required String company,
                required String regions,
                required bool isInstalled,
                required bool isSystemTitle,
                required bool isVisibleSystemTitle,
                Value<String?> iconPath = const Value.absent(),
                Value<DateTime?> addedToLibraryTime = const Value.absent(),
                Value<DateTime?> lastPlayedTime = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GamesCompanion.insert(
                path: path,
                filename: filename,
                title: title,
                description: description,
                titleId: titleId,
                company: company,
                regions: regions,
                isInstalled: isInstalled,
                isSystemTitle: isSystemTitle,
                isVisibleSystemTitle: isVisibleSystemTitle,
                iconPath: iconPath,
                addedToLibraryTime: addedToLibraryTime,
                lastPlayedTime: lastPlayedTime,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GamesTable, GameRow>(table),
                  BaseReferences<_$AppDatabase, $GamesTable, GameRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GamesTable,
      GameRow,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (GameRow, BaseReferences<_$AppDatabase, $GamesTable, GameRow>),
      GameRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ControlBindingsTableCreateCompanionBuilder =
    ControlBindingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$ControlBindingsTableUpdateCompanionBuilder =
    ControlBindingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$ControlBindingsTableFilterComposer
    extends Composer<_$AppDatabase, $ControlBindingsTable> {
  $$ControlBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ControlBindingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ControlBindingsTable> {
  $$ControlBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ControlBindingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ControlBindingsTable> {
  $$ControlBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$ControlBindingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ControlBindingsTable,
          ControlBinding,
          $$ControlBindingsTableFilterComposer,
          $$ControlBindingsTableOrderingComposer,
          $$ControlBindingsTableAnnotationComposer,
          $$ControlBindingsTableCreateCompanionBuilder,
          $$ControlBindingsTableUpdateCompanionBuilder,
          (
            ControlBinding,
            BaseReferences<
              _$AppDatabase,
              $ControlBindingsTable,
              ControlBinding
            >,
          ),
          ControlBinding,
          PrefetchHooks Function()
        > {
  $$ControlBindingsTableTableManager(
    _$AppDatabase db,
    $ControlBindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ControlBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ControlBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ControlBindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ControlBindingsCompanion(
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => ControlBindingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ControlBindingsTable, ControlBinding>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ControlBindingsTable,
                    ControlBinding
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ControlBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ControlBindingsTable,
      ControlBinding,
      $$ControlBindingsTableFilterComposer,
      $$ControlBindingsTableOrderingComposer,
      $$ControlBindingsTableAnnotationComposer,
      $$ControlBindingsTableCreateCompanionBuilder,
      $$ControlBindingsTableUpdateCompanionBuilder,
      (
        ControlBinding,
        BaseReferences<_$AppDatabase, $ControlBindingsTable, ControlBinding>,
      ),
      ControlBinding,
      PrefetchHooks Function()
    >;
typedef $$InputLayoutElementsTableCreateCompanionBuilder =
    InputLayoutElementsCompanion Function({
      required String orientation,
      required String elementId,
      required int x,
      required int y,
      required int width,
      required int height,
      Value<int> rowid,
    });
typedef $$InputLayoutElementsTableUpdateCompanionBuilder =
    InputLayoutElementsCompanion Function({
      Value<String> orientation,
      Value<String> elementId,
      Value<int> x,
      Value<int> y,
      Value<int> width,
      Value<int> height,
      Value<int> rowid,
    });

class $$InputLayoutElementsTableFilterComposer
    extends Composer<_$AppDatabase, $InputLayoutElementsTable> {
  $$InputLayoutElementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get elementId => $composableBuilder(
    column: $table.elementId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InputLayoutElementsTableOrderingComposer
    extends Composer<_$AppDatabase, $InputLayoutElementsTable> {
  $$InputLayoutElementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get elementId => $composableBuilder(
    column: $table.elementId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get x => $composableBuilder(
    column: $table.x,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get y => $composableBuilder(
    column: $table.y,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get width => $composableBuilder(
    column: $table.width,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get height => $composableBuilder(
    column: $table.height,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InputLayoutElementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InputLayoutElementsTable> {
  $$InputLayoutElementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get orientation => $composableBuilder(
    column: $table.orientation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get elementId =>
      $composableBuilder(column: $table.elementId, builder: (column) => column);

  GeneratedColumn<int> get x =>
      $composableBuilder(column: $table.x, builder: (column) => column);

  GeneratedColumn<int> get y =>
      $composableBuilder(column: $table.y, builder: (column) => column);

  GeneratedColumn<int> get width =>
      $composableBuilder(column: $table.width, builder: (column) => column);

  GeneratedColumn<int> get height =>
      $composableBuilder(column: $table.height, builder: (column) => column);
}

class $$InputLayoutElementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InputLayoutElementsTable,
          InputLayoutElement,
          $$InputLayoutElementsTableFilterComposer,
          $$InputLayoutElementsTableOrderingComposer,
          $$InputLayoutElementsTableAnnotationComposer,
          $$InputLayoutElementsTableCreateCompanionBuilder,
          $$InputLayoutElementsTableUpdateCompanionBuilder,
          (
            InputLayoutElement,
            BaseReferences<
              _$AppDatabase,
              $InputLayoutElementsTable,
              InputLayoutElement
            >,
          ),
          InputLayoutElement,
          PrefetchHooks Function()
        > {
  $$InputLayoutElementsTableTableManager(
    _$AppDatabase db,
    $InputLayoutElementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InputLayoutElementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InputLayoutElementsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InputLayoutElementsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> orientation = const Value.absent(),
                Value<String> elementId = const Value.absent(),
                Value<int> x = const Value.absent(),
                Value<int> y = const Value.absent(),
                Value<int> width = const Value.absent(),
                Value<int> height = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InputLayoutElementsCompanion(
                orientation: orientation,
                elementId: elementId,
                x: x,
                y: y,
                width: width,
                height: height,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String orientation,
                required String elementId,
                required int x,
                required int y,
                required int width,
                required int height,
                Value<int> rowid = const Value.absent(),
              }) => InputLayoutElementsCompanion.insert(
                orientation: orientation,
                elementId: elementId,
                x: x,
                y: y,
                width: width,
                height: height,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InputLayoutElementsTable, InputLayoutElement>(
                    table,
                  ),
                  BaseReferences<
                    _$AppDatabase,
                    $InputLayoutElementsTable,
                    InputLayoutElement
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InputLayoutElementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InputLayoutElementsTable,
      InputLayoutElement,
      $$InputLayoutElementsTableFilterComposer,
      $$InputLayoutElementsTableOrderingComposer,
      $$InputLayoutElementsTableAnnotationComposer,
      $$InputLayoutElementsTableCreateCompanionBuilder,
      $$InputLayoutElementsTableUpdateCompanionBuilder,
      (
        InputLayoutElement,
        BaseReferences<
          _$AppDatabase,
          $InputLayoutElementsTable,
          InputLayoutElement
        >,
      ),
      InputLayoutElement,
      PrefetchHooks Function()
    >;
typedef $$ThemeSettingsTableCreateCompanionBuilder =
    ThemeSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<int> staticThemeColor,
      Value<bool> blackBackgrounds,
      Value<bool> materialYou,
    });
typedef $$ThemeSettingsTableUpdateCompanionBuilder =
    ThemeSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<int> staticThemeColor,
      Value<bool> blackBackgrounds,
      Value<bool> materialYou,
    });

class $$ThemeSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get staticThemeColor => $composableBuilder(
    column: $table.staticThemeColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blackBackgrounds => $composableBuilder(
    column: $table.blackBackgrounds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get materialYou => $composableBuilder(
    column: $table.materialYou,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThemeSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get staticThemeColor => $composableBuilder(
    column: $table.staticThemeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blackBackgrounds => $composableBuilder(
    column: $table.blackBackgrounds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get materialYou => $composableBuilder(
    column: $table.materialYou,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemeSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<int> get staticThemeColor => $composableBuilder(
    column: $table.staticThemeColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get blackBackgrounds => $composableBuilder(
    column: $table.blackBackgrounds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get materialYou => $composableBuilder(
    column: $table.materialYou,
    builder: (column) => column,
  );
}

class $$ThemeSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemeSettingsTable,
          ThemeSetting,
          $$ThemeSettingsTableFilterComposer,
          $$ThemeSettingsTableOrderingComposer,
          $$ThemeSettingsTableAnnotationComposer,
          $$ThemeSettingsTableCreateCompanionBuilder,
          $$ThemeSettingsTableUpdateCompanionBuilder,
          (
            ThemeSetting,
            BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
          ),
          ThemeSetting,
          PrefetchHooks Function()
        > {
  $$ThemeSettingsTableTableManager(_$AppDatabase db, $ThemeSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemeSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemeSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemeSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> staticThemeColor = const Value.absent(),
                Value<bool> blackBackgrounds = const Value.absent(),
                Value<bool> materialYou = const Value.absent(),
              }) => ThemeSettingsCompanion(
                id: id,
                themeMode: themeMode,
                staticThemeColor: staticThemeColor,
                blackBackgrounds: blackBackgrounds,
                materialYou: materialYou,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> staticThemeColor = const Value.absent(),
                Value<bool> blackBackgrounds = const Value.absent(),
                Value<bool> materialYou = const Value.absent(),
              }) => ThemeSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                staticThemeColor: staticThemeColor,
                blackBackgrounds: blackBackgrounds,
                materialYou: materialYou,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ThemeSettingsTable, ThemeSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ThemeSettingsTable,
                    ThemeSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThemeSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemeSettingsTable,
      ThemeSetting,
      $$ThemeSettingsTableFilterComposer,
      $$ThemeSettingsTableOrderingComposer,
      $$ThemeSettingsTableAnnotationComposer,
      $$ThemeSettingsTableCreateCompanionBuilder,
      $$ThemeSettingsTableUpdateCompanionBuilder,
      (
        ThemeSetting,
        BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
      ),
      ThemeSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ControlBindingsTableTableManager get controlBindings =>
      $$ControlBindingsTableTableManager(_db, _db.controlBindings);
  $$InputLayoutElementsTableTableManager get inputLayoutElements =>
      $$InputLayoutElementsTableTableManager(_db, _db.inputLayoutElements);
  $$ThemeSettingsTableTableManager get themeSettings =>
      $$ThemeSettingsTableTableManager(_db, _db.themeSettings);
}
