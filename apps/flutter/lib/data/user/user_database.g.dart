// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_database.dart';

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
  late final GeneratedColumnWithTypeConverter<ThemeStyle, int> themeStyle =
      GeneratedColumn<int>(
        'theme_style',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(ThemeStyle.azahar.index),
      ).withConverter<ThemeStyle>($ThemeSettingsTable.$converterthemeStyle);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    staticThemeColor,
    blackBackgrounds,
    materialYou,
    themeStyle,
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
      themeStyle: $ThemeSettingsTable.$converterthemeStyle.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_style'],
        )!,
      ),
    );
  }

  @override
  $ThemeSettingsTable createAlias(String alias) {
    return $ThemeSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ThemeStyle, int, int> $converterthemeStyle =
      const EnumIndexConverter<ThemeStyle>(ThemeStyle.values);
}

class ThemeSetting extends DataClass implements Insertable<ThemeSetting> {
  final int id;
  final String themeMode;
  final int staticThemeColor;
  final bool blackBackgrounds;
  final bool materialYou;
  final ThemeStyle themeStyle;
  const ThemeSetting({
    required this.id,
    required this.themeMode,
    required this.staticThemeColor,
    required this.blackBackgrounds,
    required this.materialYou,
    required this.themeStyle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['theme_mode'] = Variable<String>(themeMode);
    map['static_theme_color'] = Variable<int>(staticThemeColor);
    map['black_backgrounds'] = Variable<bool>(blackBackgrounds);
    map['material_you'] = Variable<bool>(materialYou);
    {
      map['theme_style'] = Variable<int>(
        $ThemeSettingsTable.$converterthemeStyle.toSql(themeStyle),
      );
    }
    return map;
  }

  ThemeSettingsCompanion toCompanion(bool nullToAbsent) {
    return ThemeSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      staticThemeColor: Value(staticThemeColor),
      blackBackgrounds: Value(blackBackgrounds),
      materialYou: Value(materialYou),
      themeStyle: Value(themeStyle),
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
      themeStyle: $ThemeSettingsTable.$converterthemeStyle.fromJson(
        serializer.fromJson<int>(json['themeStyle']),
      ),
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
      'themeStyle': serializer.toJson<int>(
        $ThemeSettingsTable.$converterthemeStyle.toJson(themeStyle),
      ),
    };
  }

  ThemeSetting copyWith({
    int? id,
    String? themeMode,
    int? staticThemeColor,
    bool? blackBackgrounds,
    bool? materialYou,
    ThemeStyle? themeStyle,
  }) => ThemeSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    staticThemeColor: staticThemeColor ?? this.staticThemeColor,
    blackBackgrounds: blackBackgrounds ?? this.blackBackgrounds,
    materialYou: materialYou ?? this.materialYou,
    themeStyle: themeStyle ?? this.themeStyle,
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
      themeStyle: data.themeStyle.present
          ? data.themeStyle.value
          : this.themeStyle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('staticThemeColor: $staticThemeColor, ')
          ..write('blackBackgrounds: $blackBackgrounds, ')
          ..write('materialYou: $materialYou, ')
          ..write('themeStyle: $themeStyle')
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
    themeStyle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.staticThemeColor == this.staticThemeColor &&
          other.blackBackgrounds == this.blackBackgrounds &&
          other.materialYou == this.materialYou &&
          other.themeStyle == this.themeStyle);
}

class ThemeSettingsCompanion extends UpdateCompanion<ThemeSetting> {
  final Value<int> id;
  final Value<String> themeMode;
  final Value<int> staticThemeColor;
  final Value<bool> blackBackgrounds;
  final Value<bool> materialYou;
  final Value<ThemeStyle> themeStyle;
  const ThemeSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.staticThemeColor = const Value.absent(),
    this.blackBackgrounds = const Value.absent(),
    this.materialYou = const Value.absent(),
    this.themeStyle = const Value.absent(),
  });
  ThemeSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.staticThemeColor = const Value.absent(),
    this.blackBackgrounds = const Value.absent(),
    this.materialYou = const Value.absent(),
    this.themeStyle = const Value.absent(),
  });
  static Insertable<ThemeSetting> custom({
    Expression<int>? id,
    Expression<String>? themeMode,
    Expression<int>? staticThemeColor,
    Expression<bool>? blackBackgrounds,
    Expression<bool>? materialYou,
    Expression<int>? themeStyle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (staticThemeColor != null) 'static_theme_color': staticThemeColor,
      if (blackBackgrounds != null) 'black_backgrounds': blackBackgrounds,
      if (materialYou != null) 'material_you': materialYou,
      if (themeStyle != null) 'theme_style': themeStyle,
    });
  }

  ThemeSettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? themeMode,
    Value<int>? staticThemeColor,
    Value<bool>? blackBackgrounds,
    Value<bool>? materialYou,
    Value<ThemeStyle>? themeStyle,
  }) {
    return ThemeSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      staticThemeColor: staticThemeColor ?? this.staticThemeColor,
      blackBackgrounds: blackBackgrounds ?? this.blackBackgrounds,
      materialYou: materialYou ?? this.materialYou,
      themeStyle: themeStyle ?? this.themeStyle,
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
    if (themeStyle.present) {
      map['theme_style'] = Variable<int>(
        $ThemeSettingsTable.$converterthemeStyle.toSql(themeStyle.value),
      );
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
          ..write('materialYou: $materialYou, ')
          ..write('themeStyle: $themeStyle')
          ..write(')'))
        .toString();
  }
}

class $AccessibilitySettingsTable extends AccessibilitySettings
    with TableInfo<$AccessibilitySettingsTable, AccessibilitySetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccessibilitySettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PageTransitionStyle, int>
  pageTransition =
      GeneratedColumn<int>(
        'page_transition',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(PageTransitionStyle.slide.index),
      ).withConverter<PageTransitionStyle>(
        $AccessibilitySettingsTable.$converterpageTransition,
      );
  @override
  List<GeneratedColumn> get $columns => [id, reduceMotion, pageTransition];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accessibility_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccessibilitySetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccessibilitySetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccessibilitySetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      pageTransition: $AccessibilitySettingsTable.$converterpageTransition
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}page_transition'],
            )!,
          ),
    );
  }

  @override
  $AccessibilitySettingsTable createAlias(String alias) {
    return $AccessibilitySettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PageTransitionStyle, int, int>
  $converterpageTransition = const EnumIndexConverter<PageTransitionStyle>(
    PageTransitionStyle.values,
  );
}

class AccessibilitySetting extends DataClass
    implements Insertable<AccessibilitySetting> {
  final int id;
  final bool reduceMotion;
  final PageTransitionStyle pageTransition;
  const AccessibilitySetting({
    required this.id,
    required this.reduceMotion,
    required this.pageTransition,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    {
      map['page_transition'] = Variable<int>(
        $AccessibilitySettingsTable.$converterpageTransition.toSql(
          pageTransition,
        ),
      );
    }
    return map;
  }

  AccessibilitySettingsCompanion toCompanion(bool nullToAbsent) {
    return AccessibilitySettingsCompanion(
      id: Value(id),
      reduceMotion: Value(reduceMotion),
      pageTransition: Value(pageTransition),
    );
  }

  factory AccessibilitySetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccessibilitySetting(
      id: serializer.fromJson<int>(json['id']),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      pageTransition: $AccessibilitySettingsTable.$converterpageTransition
          .fromJson(serializer.fromJson<int>(json['pageTransition'])),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'pageTransition': serializer.toJson<int>(
        $AccessibilitySettingsTable.$converterpageTransition.toJson(
          pageTransition,
        ),
      ),
    };
  }

  AccessibilitySetting copyWith({
    int? id,
    bool? reduceMotion,
    PageTransitionStyle? pageTransition,
  }) => AccessibilitySetting(
    id: id ?? this.id,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    pageTransition: pageTransition ?? this.pageTransition,
  );
  AccessibilitySetting copyWithCompanion(AccessibilitySettingsCompanion data) {
    return AccessibilitySetting(
      id: data.id.present ? data.id.value : this.id,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      pageTransition: data.pageTransition.present
          ? data.pageTransition.value
          : this.pageTransition,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccessibilitySetting(')
          ..write('id: $id, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('pageTransition: $pageTransition')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, reduceMotion, pageTransition);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccessibilitySetting &&
          other.id == this.id &&
          other.reduceMotion == this.reduceMotion &&
          other.pageTransition == this.pageTransition);
}

class AccessibilitySettingsCompanion
    extends UpdateCompanion<AccessibilitySetting> {
  final Value<int> id;
  final Value<bool> reduceMotion;
  final Value<PageTransitionStyle> pageTransition;
  const AccessibilitySettingsCompanion({
    this.id = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.pageTransition = const Value.absent(),
  });
  AccessibilitySettingsCompanion.insert({
    this.id = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.pageTransition = const Value.absent(),
  });
  static Insertable<AccessibilitySetting> custom({
    Expression<int>? id,
    Expression<bool>? reduceMotion,
    Expression<int>? pageTransition,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (pageTransition != null) 'page_transition': pageTransition,
    });
  }

  AccessibilitySettingsCompanion copyWith({
    Value<int>? id,
    Value<bool>? reduceMotion,
    Value<PageTransitionStyle>? pageTransition,
  }) {
    return AccessibilitySettingsCompanion(
      id: id ?? this.id,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      pageTransition: pageTransition ?? this.pageTransition,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (pageTransition.present) {
      map['page_transition'] = Variable<int>(
        $AccessibilitySettingsTable.$converterpageTransition.toSql(
          pageTransition.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccessibilitySettingsCompanion(')
          ..write('id: $id, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('pageTransition: $pageTransition')
          ..write(')'))
        .toString();
  }
}

class $AdvancedSettingsTable extends AdvancedSettings
    with TableInfo<$AdvancedSettingsTable, AdvancedSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AdvancedSettingsTable(this.attachedDatabase, [this._alias]);
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
  @override
  late final GeneratedColumnWithTypeConverter<AnimationSpeed, int>
  animationSpeed =
      GeneratedColumn<int>(
        'animation_speed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: Constant(AnimationSpeed.normal.index),
      ).withConverter<AnimationSpeed>(
        $AdvancedSettingsTable.$converteranimationSpeed,
      );
  @override
  List<GeneratedColumn> get $columns => [id, animationSpeed];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'advanced_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AdvancedSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AdvancedSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AdvancedSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      animationSpeed: $AdvancedSettingsTable.$converteranimationSpeed.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}animation_speed'],
        )!,
      ),
    );
  }

  @override
  $AdvancedSettingsTable createAlias(String alias) {
    return $AdvancedSettingsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AnimationSpeed, int, int> $converteranimationSpeed =
      const EnumIndexConverter<AnimationSpeed>(AnimationSpeed.values);
}

class AdvancedSetting extends DataClass implements Insertable<AdvancedSetting> {
  final int id;
  final AnimationSpeed animationSpeed;
  const AdvancedSetting({required this.id, required this.animationSpeed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['animation_speed'] = Variable<int>(
        $AdvancedSettingsTable.$converteranimationSpeed.toSql(animationSpeed),
      );
    }
    return map;
  }

  AdvancedSettingsCompanion toCompanion(bool nullToAbsent) {
    return AdvancedSettingsCompanion(
      id: Value(id),
      animationSpeed: Value(animationSpeed),
    );
  }

  factory AdvancedSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AdvancedSetting(
      id: serializer.fromJson<int>(json['id']),
      animationSpeed: $AdvancedSettingsTable.$converteranimationSpeed.fromJson(
        serializer.fromJson<int>(json['animationSpeed']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'animationSpeed': serializer.toJson<int>(
        $AdvancedSettingsTable.$converteranimationSpeed.toJson(animationSpeed),
      ),
    };
  }

  AdvancedSetting copyWith({int? id, AnimationSpeed? animationSpeed}) =>
      AdvancedSetting(
        id: id ?? this.id,
        animationSpeed: animationSpeed ?? this.animationSpeed,
      );
  AdvancedSetting copyWithCompanion(AdvancedSettingsCompanion data) {
    return AdvancedSetting(
      id: data.id.present ? data.id.value : this.id,
      animationSpeed: data.animationSpeed.present
          ? data.animationSpeed.value
          : this.animationSpeed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedSetting(')
          ..write('id: $id, ')
          ..write('animationSpeed: $animationSpeed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, animationSpeed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AdvancedSetting &&
          other.id == this.id &&
          other.animationSpeed == this.animationSpeed);
}

class AdvancedSettingsCompanion extends UpdateCompanion<AdvancedSetting> {
  final Value<int> id;
  final Value<AnimationSpeed> animationSpeed;
  const AdvancedSettingsCompanion({
    this.id = const Value.absent(),
    this.animationSpeed = const Value.absent(),
  });
  AdvancedSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.animationSpeed = const Value.absent(),
  });
  static Insertable<AdvancedSetting> custom({
    Expression<int>? id,
    Expression<int>? animationSpeed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animationSpeed != null) 'animation_speed': animationSpeed,
    });
  }

  AdvancedSettingsCompanion copyWith({
    Value<int>? id,
    Value<AnimationSpeed>? animationSpeed,
  }) {
    return AdvancedSettingsCompanion(
      id: id ?? this.id,
      animationSpeed: animationSpeed ?? this.animationSpeed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (animationSpeed.present) {
      map['animation_speed'] = Variable<int>(
        $AdvancedSettingsTable.$converteranimationSpeed.toSql(
          animationSpeed.value,
        ),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AdvancedSettingsCompanion(')
          ..write('id: $id, ')
          ..write('animationSpeed: $animationSpeed')
          ..write(')'))
        .toString();
  }
}

class $MediaSettingsTable extends MediaSettings
    with TableInfo<$MediaSettingsTable, MediaSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MediaSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _masterVolumeMeta = const VerificationMeta(
    'masterVolume',
  );
  @override
  late final GeneratedColumn<double> masterVolume = GeneratedColumn<double>(
    'master_volume',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(100.0),
  );
  static const VerificationMeta _audioEngineMeta = const VerificationMeta(
    'audioEngine',
  );
  @override
  late final GeneratedColumn<String> audioEngine = GeneratedColumn<String>(
    'audio_engine',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, masterVolume, audioEngine];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'media_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MediaSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('master_volume')) {
      context.handle(
        _masterVolumeMeta,
        masterVolume.isAcceptableOrUnknown(
          data['master_volume']!,
          _masterVolumeMeta,
        ),
      );
    }
    if (data.containsKey('audio_engine')) {
      context.handle(
        _audioEngineMeta,
        audioEngine.isAcceptableOrUnknown(
          data['audio_engine']!,
          _audioEngineMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MediaSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MediaSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      masterVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}master_volume'],
      )!,
      audioEngine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_engine'],
      ),
    );
  }

  @override
  $MediaSettingsTable createAlias(String alias) {
    return $MediaSettingsTable(attachedDatabase, alias);
  }
}

class MediaSetting extends DataClass implements Insertable<MediaSetting> {
  final int id;
  final double masterVolume;

  /// Name of the chosen `AudioEngine`, or null while none has been chosen.
  final String? audioEngine;
  const MediaSetting({
    required this.id,
    required this.masterVolume,
    this.audioEngine,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['master_volume'] = Variable<double>(masterVolume);
    if (!nullToAbsent || audioEngine != null) {
      map['audio_engine'] = Variable<String>(audioEngine);
    }
    return map;
  }

  MediaSettingsCompanion toCompanion(bool nullToAbsent) {
    return MediaSettingsCompanion(
      id: Value(id),
      masterVolume: Value(masterVolume),
      audioEngine: audioEngine == null && nullToAbsent
          ? const Value.absent()
          : Value(audioEngine),
    );
  }

  factory MediaSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MediaSetting(
      id: serializer.fromJson<int>(json['id']),
      masterVolume: serializer.fromJson<double>(json['masterVolume']),
      audioEngine: serializer.fromJson<String?>(json['audioEngine']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'masterVolume': serializer.toJson<double>(masterVolume),
      'audioEngine': serializer.toJson<String?>(audioEngine),
    };
  }

  MediaSetting copyWith({
    int? id,
    double? masterVolume,
    Value<String?> audioEngine = const Value.absent(),
  }) => MediaSetting(
    id: id ?? this.id,
    masterVolume: masterVolume ?? this.masterVolume,
    audioEngine: audioEngine.present ? audioEngine.value : this.audioEngine,
  );
  MediaSetting copyWithCompanion(MediaSettingsCompanion data) {
    return MediaSetting(
      id: data.id.present ? data.id.value : this.id,
      masterVolume: data.masterVolume.present
          ? data.masterVolume.value
          : this.masterVolume,
      audioEngine: data.audioEngine.present
          ? data.audioEngine.value
          : this.audioEngine,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MediaSetting(')
          ..write('id: $id, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('audioEngine: $audioEngine')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, masterVolume, audioEngine);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MediaSetting &&
          other.id == this.id &&
          other.masterVolume == this.masterVolume &&
          other.audioEngine == this.audioEngine);
}

class MediaSettingsCompanion extends UpdateCompanion<MediaSetting> {
  final Value<int> id;
  final Value<double> masterVolume;
  final Value<String?> audioEngine;
  const MediaSettingsCompanion({
    this.id = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.audioEngine = const Value.absent(),
  });
  MediaSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.masterVolume = const Value.absent(),
    this.audioEngine = const Value.absent(),
  });
  static Insertable<MediaSetting> custom({
    Expression<int>? id,
    Expression<double>? masterVolume,
    Expression<String>? audioEngine,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (masterVolume != null) 'master_volume': masterVolume,
      if (audioEngine != null) 'audio_engine': audioEngine,
    });
  }

  MediaSettingsCompanion copyWith({
    Value<int>? id,
    Value<double>? masterVolume,
    Value<String?>? audioEngine,
  }) {
    return MediaSettingsCompanion(
      id: id ?? this.id,
      masterVolume: masterVolume ?? this.masterVolume,
      audioEngine: audioEngine ?? this.audioEngine,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (masterVolume.present) {
      map['master_volume'] = Variable<double>(masterVolume.value);
    }
    if (audioEngine.present) {
      map['audio_engine'] = Variable<String>(audioEngine.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MediaSettingsCompanion(')
          ..write('id: $id, ')
          ..write('masterVolume: $masterVolume, ')
          ..write('audioEngine: $audioEngine')
          ..write(')'))
        .toString();
  }
}

class $DebugSettingsTable extends DebugSettings
    with TableInfo<$DebugSettingsTable, DebugSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebugSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _logToConsoleMeta = const VerificationMeta(
    'logToConsole',
  );
  @override
  late final GeneratedColumn<bool> logToConsole = GeneratedColumn<bool>(
    'log_to_console',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("log_to_console" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [id, logToConsole];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debug_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebugSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('log_to_console')) {
      context.handle(
        _logToConsoleMeta,
        logToConsole.isAcceptableOrUnknown(
          data['log_to_console']!,
          _logToConsoleMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DebugSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebugSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      logToConsole: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}log_to_console'],
      )!,
    );
  }

  @override
  $DebugSettingsTable createAlias(String alias) {
    return $DebugSettingsTable(attachedDatabase, alias);
  }
}

class DebugSetting extends DataClass implements Insertable<DebugSetting> {
  final int id;
  final bool logToConsole;
  const DebugSetting({required this.id, required this.logToConsole});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['log_to_console'] = Variable<bool>(logToConsole);
    return map;
  }

  DebugSettingsCompanion toCompanion(bool nullToAbsent) {
    return DebugSettingsCompanion(
      id: Value(id),
      logToConsole: Value(logToConsole),
    );
  }

  factory DebugSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebugSetting(
      id: serializer.fromJson<int>(json['id']),
      logToConsole: serializer.fromJson<bool>(json['logToConsole']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'logToConsole': serializer.toJson<bool>(logToConsole),
    };
  }

  DebugSetting copyWith({int? id, bool? logToConsole}) => DebugSetting(
    id: id ?? this.id,
    logToConsole: logToConsole ?? this.logToConsole,
  );
  DebugSetting copyWithCompanion(DebugSettingsCompanion data) {
    return DebugSetting(
      id: data.id.present ? data.id.value : this.id,
      logToConsole: data.logToConsole.present
          ? data.logToConsole.value
          : this.logToConsole,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebugSetting(')
          ..write('id: $id, ')
          ..write('logToConsole: $logToConsole')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, logToConsole);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebugSetting &&
          other.id == this.id &&
          other.logToConsole == this.logToConsole);
}

class DebugSettingsCompanion extends UpdateCompanion<DebugSetting> {
  final Value<int> id;
  final Value<bool> logToConsole;
  const DebugSettingsCompanion({
    this.id = const Value.absent(),
    this.logToConsole = const Value.absent(),
  });
  DebugSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.logToConsole = const Value.absent(),
  });
  static Insertable<DebugSetting> custom({
    Expression<int>? id,
    Expression<bool>? logToConsole,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (logToConsole != null) 'log_to_console': logToConsole,
    });
  }

  DebugSettingsCompanion copyWith({Value<int>? id, Value<bool>? logToConsole}) {
    return DebugSettingsCompanion(
      id: id ?? this.id,
      logToConsole: logToConsole ?? this.logToConsole,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (logToConsole.present) {
      map['log_to_console'] = Variable<bool>(logToConsole.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebugSettingsCompanion(')
          ..write('id: $id, ')
          ..write('logToConsole: $logToConsole')
          ..write(')'))
        .toString();
  }
}

class $VirtualAccessPointsTable extends VirtualAccessPoints
    with TableInfo<$VirtualAccessPointsTable, VirtualAccessPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VirtualAccessPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ssidMeta = const VerificationMeta('ssid');
  @override
  late final GeneratedColumn<String> ssid = GeneratedColumn<String>(
    'ssid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bssidMeta = const VerificationMeta('bssid');
  @override
  late final GeneratedColumn<String> bssid = GeneratedColumn<String>(
    'bssid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<int> frequency = GeneratedColumn<int>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<int> level = GeneratedColumn<int>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sortIndex,
    ssid,
    bssid,
    frequency,
    level,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'virtual_access_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<VirtualAccessPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    }
    if (data.containsKey('ssid')) {
      context.handle(
        _ssidMeta,
        ssid.isAcceptableOrUnknown(data['ssid']!, _ssidMeta),
      );
    } else if (isInserting) {
      context.missing(_ssidMeta);
    }
    if (data.containsKey('bssid')) {
      context.handle(
        _bssidMeta,
        bssid.isAcceptableOrUnknown(data['bssid']!, _bssidMeta),
      );
    } else if (isInserting) {
      context.missing(_bssidMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sortIndex};
  @override
  VirtualAccessPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VirtualAccessPoint(
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
      ssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ssid'],
      )!,
      bssid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bssid'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}frequency'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}level'],
      )!,
    );
  }

  @override
  $VirtualAccessPointsTable createAlias(String alias) {
    return $VirtualAccessPointsTable(attachedDatabase, alias);
  }
}

class VirtualAccessPoint extends DataClass
    implements Insertable<VirtualAccessPoint> {
  final int sortIndex;
  final String ssid;
  final String bssid;
  final int frequency;
  final int level;
  const VirtualAccessPoint({
    required this.sortIndex,
    required this.ssid,
    required this.bssid,
    required this.frequency,
    required this.level,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sort_index'] = Variable<int>(sortIndex);
    map['ssid'] = Variable<String>(ssid);
    map['bssid'] = Variable<String>(bssid);
    map['frequency'] = Variable<int>(frequency);
    map['level'] = Variable<int>(level);
    return map;
  }

  VirtualAccessPointsCompanion toCompanion(bool nullToAbsent) {
    return VirtualAccessPointsCompanion(
      sortIndex: Value(sortIndex),
      ssid: Value(ssid),
      bssid: Value(bssid),
      frequency: Value(frequency),
      level: Value(level),
    );
  }

  factory VirtualAccessPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VirtualAccessPoint(
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      ssid: serializer.fromJson<String>(json['ssid']),
      bssid: serializer.fromJson<String>(json['bssid']),
      frequency: serializer.fromJson<int>(json['frequency']),
      level: serializer.fromJson<int>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sortIndex': serializer.toJson<int>(sortIndex),
      'ssid': serializer.toJson<String>(ssid),
      'bssid': serializer.toJson<String>(bssid),
      'frequency': serializer.toJson<int>(frequency),
      'level': serializer.toJson<int>(level),
    };
  }

  VirtualAccessPoint copyWith({
    int? sortIndex,
    String? ssid,
    String? bssid,
    int? frequency,
    int? level,
  }) => VirtualAccessPoint(
    sortIndex: sortIndex ?? this.sortIndex,
    ssid: ssid ?? this.ssid,
    bssid: bssid ?? this.bssid,
    frequency: frequency ?? this.frequency,
    level: level ?? this.level,
  );
  VirtualAccessPoint copyWithCompanion(VirtualAccessPointsCompanion data) {
    return VirtualAccessPoint(
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      ssid: data.ssid.present ? data.ssid.value : this.ssid,
      bssid: data.bssid.present ? data.bssid.value : this.bssid,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      level: data.level.present ? data.level.value : this.level,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VirtualAccessPoint(')
          ..write('sortIndex: $sortIndex, ')
          ..write('ssid: $ssid, ')
          ..write('bssid: $bssid, ')
          ..write('frequency: $frequency, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(sortIndex, ssid, bssid, frequency, level);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VirtualAccessPoint &&
          other.sortIndex == this.sortIndex &&
          other.ssid == this.ssid &&
          other.bssid == this.bssid &&
          other.frequency == this.frequency &&
          other.level == this.level);
}

class VirtualAccessPointsCompanion extends UpdateCompanion<VirtualAccessPoint> {
  final Value<int> sortIndex;
  final Value<String> ssid;
  final Value<String> bssid;
  final Value<int> frequency;
  final Value<int> level;
  const VirtualAccessPointsCompanion({
    this.sortIndex = const Value.absent(),
    this.ssid = const Value.absent(),
    this.bssid = const Value.absent(),
    this.frequency = const Value.absent(),
    this.level = const Value.absent(),
  });
  VirtualAccessPointsCompanion.insert({
    this.sortIndex = const Value.absent(),
    required String ssid,
    required String bssid,
    required int frequency,
    required int level,
  }) : ssid = Value(ssid),
       bssid = Value(bssid),
       frequency = Value(frequency),
       level = Value(level);
  static Insertable<VirtualAccessPoint> custom({
    Expression<int>? sortIndex,
    Expression<String>? ssid,
    Expression<String>? bssid,
    Expression<int>? frequency,
    Expression<int>? level,
  }) {
    return RawValuesInsertable({
      if (sortIndex != null) 'sort_index': sortIndex,
      if (ssid != null) 'ssid': ssid,
      if (bssid != null) 'bssid': bssid,
      if (frequency != null) 'frequency': frequency,
      if (level != null) 'level': level,
    });
  }

  VirtualAccessPointsCompanion copyWith({
    Value<int>? sortIndex,
    Value<String>? ssid,
    Value<String>? bssid,
    Value<int>? frequency,
    Value<int>? level,
  }) {
    return VirtualAccessPointsCompanion(
      sortIndex: sortIndex ?? this.sortIndex,
      ssid: ssid ?? this.ssid,
      bssid: bssid ?? this.bssid,
      frequency: frequency ?? this.frequency,
      level: level ?? this.level,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (ssid.present) {
      map['ssid'] = Variable<String>(ssid.value);
    }
    if (bssid.present) {
      map['bssid'] = Variable<String>(bssid.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<int>(frequency.value);
    }
    if (level.present) {
      map['level'] = Variable<int>(level.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VirtualAccessPointsCompanion(')
          ..write('sortIndex: $sortIndex, ')
          ..write('ssid: $ssid, ')
          ..write('bssid: $bssid, ')
          ..write('frequency: $frequency, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }
}

class $PinnedOptionsTable extends PinnedOptions
    with TableInfo<$PinnedOptionsTable, PinnedOption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PinnedOptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _optionIdMeta = const VerificationMeta(
    'optionId',
  );
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
    'option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [optionId, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pinned_options';
  @override
  VerificationContext validateIntegrity(
    Insertable<PinnedOption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('option_id')) {
      context.handle(
        _optionIdMeta,
        optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {optionId};
  @override
  PinnedOption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PinnedOption(
      optionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_id'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $PinnedOptionsTable createAlias(String alias) {
    return $PinnedOptionsTable(attachedDatabase, alias);
  }
}

class PinnedOption extends DataClass implements Insertable<PinnedOption> {
  final String optionId;
  final int sortIndex;
  const PinnedOption({required this.optionId, required this.sortIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['option_id'] = Variable<String>(optionId);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  PinnedOptionsCompanion toCompanion(bool nullToAbsent) {
    return PinnedOptionsCompanion(
      optionId: Value(optionId),
      sortIndex: Value(sortIndex),
    );
  }

  factory PinnedOption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PinnedOption(
      optionId: serializer.fromJson<String>(json['optionId']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'optionId': serializer.toJson<String>(optionId),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  PinnedOption copyWith({String? optionId, int? sortIndex}) => PinnedOption(
    optionId: optionId ?? this.optionId,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  PinnedOption copyWithCompanion(PinnedOptionsCompanion data) {
    return PinnedOption(
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PinnedOption(')
          ..write('optionId: $optionId, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(optionId, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PinnedOption &&
          other.optionId == this.optionId &&
          other.sortIndex == this.sortIndex);
}

class PinnedOptionsCompanion extends UpdateCompanion<PinnedOption> {
  final Value<String> optionId;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const PinnedOptionsCompanion({
    this.optionId = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PinnedOptionsCompanion.insert({
    required String optionId,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : optionId = Value(optionId),
       sortIndex = Value(sortIndex);
  static Insertable<PinnedOption> custom({
    Expression<String>? optionId,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (optionId != null) 'option_id': optionId,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PinnedOptionsCompanion copyWith({
    Value<String>? optionId,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return PinnedOptionsCompanion(
      optionId: optionId ?? this.optionId,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PinnedOptionsCompanion(')
          ..write('optionId: $optionId, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OptionHistoryEntriesTable extends OptionHistoryEntries
    with TableInfo<$OptionHistoryEntriesTable, OptionHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OptionHistoryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _optionIdMeta = const VerificationMeta(
    'optionId',
  );
  @override
  late final GeneratedColumn<String> optionId = GeneratedColumn<String>(
    'option_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accessOrderMeta = const VerificationMeta(
    'accessOrder',
  );
  @override
  late final GeneratedColumn<int> accessOrder = GeneratedColumn<int>(
    'access_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [optionId, accessOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'option_history_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<OptionHistoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('option_id')) {
      context.handle(
        _optionIdMeta,
        optionId.isAcceptableOrUnknown(data['option_id']!, _optionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_optionIdMeta);
    }
    if (data.containsKey('access_order')) {
      context.handle(
        _accessOrderMeta,
        accessOrder.isAcceptableOrUnknown(
          data['access_order']!,
          _accessOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accessOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {optionId};
  @override
  OptionHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OptionHistoryEntry(
      optionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}option_id'],
      )!,
      accessOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}access_order'],
      )!,
    );
  }

  @override
  $OptionHistoryEntriesTable createAlias(String alias) {
    return $OptionHistoryEntriesTable(attachedDatabase, alias);
  }
}

class OptionHistoryEntry extends DataClass
    implements Insertable<OptionHistoryEntry> {
  final String optionId;
  final int accessOrder;
  const OptionHistoryEntry({required this.optionId, required this.accessOrder});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['option_id'] = Variable<String>(optionId);
    map['access_order'] = Variable<int>(accessOrder);
    return map;
  }

  OptionHistoryEntriesCompanion toCompanion(bool nullToAbsent) {
    return OptionHistoryEntriesCompanion(
      optionId: Value(optionId),
      accessOrder: Value(accessOrder),
    );
  }

  factory OptionHistoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OptionHistoryEntry(
      optionId: serializer.fromJson<String>(json['optionId']),
      accessOrder: serializer.fromJson<int>(json['accessOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'optionId': serializer.toJson<String>(optionId),
      'accessOrder': serializer.toJson<int>(accessOrder),
    };
  }

  OptionHistoryEntry copyWith({String? optionId, int? accessOrder}) =>
      OptionHistoryEntry(
        optionId: optionId ?? this.optionId,
        accessOrder: accessOrder ?? this.accessOrder,
      );
  OptionHistoryEntry copyWithCompanion(OptionHistoryEntriesCompanion data) {
    return OptionHistoryEntry(
      optionId: data.optionId.present ? data.optionId.value : this.optionId,
      accessOrder: data.accessOrder.present
          ? data.accessOrder.value
          : this.accessOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OptionHistoryEntry(')
          ..write('optionId: $optionId, ')
          ..write('accessOrder: $accessOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(optionId, accessOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OptionHistoryEntry &&
          other.optionId == this.optionId &&
          other.accessOrder == this.accessOrder);
}

class OptionHistoryEntriesCompanion
    extends UpdateCompanion<OptionHistoryEntry> {
  final Value<String> optionId;
  final Value<int> accessOrder;
  final Value<int> rowid;
  const OptionHistoryEntriesCompanion({
    this.optionId = const Value.absent(),
    this.accessOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OptionHistoryEntriesCompanion.insert({
    required String optionId,
    required int accessOrder,
    this.rowid = const Value.absent(),
  }) : optionId = Value(optionId),
       accessOrder = Value(accessOrder);
  static Insertable<OptionHistoryEntry> custom({
    Expression<String>? optionId,
    Expression<int>? accessOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (optionId != null) 'option_id': optionId,
      if (accessOrder != null) 'access_order': accessOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OptionHistoryEntriesCompanion copyWith({
    Value<String>? optionId,
    Value<int>? accessOrder,
    Value<int>? rowid,
  }) {
    return OptionHistoryEntriesCompanion(
      optionId: optionId ?? this.optionId,
      accessOrder: accessOrder ?? this.accessOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (optionId.present) {
      map['option_id'] = Variable<String>(optionId.value);
    }
    if (accessOrder.present) {
      map['access_order'] = Variable<int>(accessOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OptionHistoryEntriesCompanion(')
          ..write('optionId: $optionId, ')
          ..write('accessOrder: $accessOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, TagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => cuid(),
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, sortIndex];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class TagRow extends DataClass implements Insertable<TagRow> {
  final String id;
  final String kind;
  final int sortIndex;
  const TagRow({required this.id, required this.kind, required this.sortIndex});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['kind'] = Variable<String>(kind);
    map['sort_index'] = Variable<int>(sortIndex);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      kind: Value(kind),
      sortIndex: Value(sortIndex),
    );
  }

  factory TagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagRow(
      id: serializer.fromJson<String>(json['id']),
      kind: serializer.fromJson<String>(json['kind']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'kind': serializer.toJson<String>(kind),
      'sortIndex': serializer.toJson<int>(sortIndex),
    };
  }

  TagRow copyWith({String? id, String? kind, int? sortIndex}) => TagRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    sortIndex: sortIndex ?? this.sortIndex,
  );
  TagRow copyWithCompanion(TagsCompanion data) {
    return TagRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sortIndex: $sortIndex')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, sortIndex);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.sortIndex == this.sortIndex);
}

class TagsCompanion extends UpdateCompanion<TagRow> {
  final Value<String> id;
  final Value<String> kind;
  final Value<int> sortIndex;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    this.id = const Value.absent(),
    required String kind,
    required int sortIndex,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       sortIndex = Value(sortIndex);
  static Insertable<TagRow> custom({
    Expression<String>? id,
    Expression<String>? kind,
    Expression<int>? sortIndex,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? kind,
    Value<int>? sortIndex,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      sortIndex: sortIndex ?? this.sortIndex,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GameTagsTable extends GameTags
    with TableInfo<$GameTagsTable, GameTagRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GameTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gamePathMeta = const VerificationMeta(
    'gamePath',
  );
  @override
  late final GeneratedColumn<String> gamePath = GeneratedColumn<String>(
    'game_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tags (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [gamePath, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'game_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<GameTagRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_path')) {
      context.handle(
        _gamePathMeta,
        gamePath.isAcceptableOrUnknown(data['game_path']!, _gamePathMeta),
      );
    } else if (isInserting) {
      context.missing(_gamePathMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gamePath, tagId};
  @override
  GameTagRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GameTagRow(
      gamePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_path'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $GameTagsTable createAlias(String alias) {
    return $GameTagsTable(attachedDatabase, alias);
  }
}

class GameTagRow extends DataClass implements Insertable<GameTagRow> {
  final String gamePath;
  final String tagId;
  const GameTagRow({required this.gamePath, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_path'] = Variable<String>(gamePath);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  GameTagsCompanion toCompanion(bool nullToAbsent) {
    return GameTagsCompanion(gamePath: Value(gamePath), tagId: Value(tagId));
  }

  factory GameTagRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GameTagRow(
      gamePath: serializer.fromJson<String>(json['gamePath']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gamePath': serializer.toJson<String>(gamePath),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  GameTagRow copyWith({String? gamePath, String? tagId}) => GameTagRow(
    gamePath: gamePath ?? this.gamePath,
    tagId: tagId ?? this.tagId,
  );
  GameTagRow copyWithCompanion(GameTagsCompanion data) {
    return GameTagRow(
      gamePath: data.gamePath.present ? data.gamePath.value : this.gamePath,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GameTagRow(')
          ..write('gamePath: $gamePath, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gamePath, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GameTagRow &&
          other.gamePath == this.gamePath &&
          other.tagId == this.tagId);
}

class GameTagsCompanion extends UpdateCompanion<GameTagRow> {
  final Value<String> gamePath;
  final Value<String> tagId;
  final Value<int> rowid;
  const GameTagsCompanion({
    this.gamePath = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GameTagsCompanion.insert({
    required String gamePath,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : gamePath = Value(gamePath),
       tagId = Value(tagId);
  static Insertable<GameTagRow> custom({
    Expression<String>? gamePath,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gamePath != null) 'game_path': gamePath,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GameTagsCompanion copyWith({
    Value<String>? gamePath,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return GameTagsCompanion(
      gamePath: gamePath ?? this.gamePath,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gamePath.present) {
      map['game_path'] = Variable<String>(gamePath.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GameTagsCompanion(')
          ..write('gamePath: $gamePath, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserGameInfosTable extends UserGameInfos
    with TableInfo<$UserGameInfosTable, UserGameInfoRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserGameInfosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _gameIdMeta = const VerificationMeta('gameId');
  @override
  late final GeneratedColumn<String> gameId = GeneratedColumn<String>(
    'game_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [gameId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_game_infos';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserGameInfoRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('game_id')) {
      context.handle(
        _gameIdMeta,
        gameId.isAcceptableOrUnknown(data['game_id']!, _gameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_gameIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {gameId};
  @override
  UserGameInfoRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserGameInfoRow(
      gameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}game_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
    );
  }

  @override
  $UserGameInfosTable createAlias(String alias) {
    return $UserGameInfosTable(attachedDatabase, alias);
  }
}

class UserGameInfoRow extends DataClass implements Insertable<UserGameInfoRow> {
  final String gameId;
  final String? name;
  const UserGameInfoRow({required this.gameId, this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['game_id'] = Variable<String>(gameId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    return map;
  }

  UserGameInfosCompanion toCompanion(bool nullToAbsent) {
    return UserGameInfosCompanion(
      gameId: Value(gameId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
    );
  }

  factory UserGameInfoRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserGameInfoRow(
      gameId: serializer.fromJson<String>(json['gameId']),
      name: serializer.fromJson<String?>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'gameId': serializer.toJson<String>(gameId),
      'name': serializer.toJson<String?>(name),
    };
  }

  UserGameInfoRow copyWith({
    String? gameId,
    Value<String?> name = const Value.absent(),
  }) => UserGameInfoRow(
    gameId: gameId ?? this.gameId,
    name: name.present ? name.value : this.name,
  );
  UserGameInfoRow copyWithCompanion(UserGameInfosCompanion data) {
    return UserGameInfoRow(
      gameId: data.gameId.present ? data.gameId.value : this.gameId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserGameInfoRow(')
          ..write('gameId: $gameId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(gameId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserGameInfoRow &&
          other.gameId == this.gameId &&
          other.name == this.name);
}

class UserGameInfosCompanion extends UpdateCompanion<UserGameInfoRow> {
  final Value<String> gameId;
  final Value<String?> name;
  final Value<int> rowid;
  const UserGameInfosCompanion({
    this.gameId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserGameInfosCompanion.insert({
    required String gameId,
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : gameId = Value(gameId);
  static Insertable<UserGameInfoRow> custom({
    Expression<String>? gameId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (gameId != null) 'game_id': gameId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserGameInfosCompanion copyWith({
    Value<String>? gameId,
    Value<String?>? name,
    Value<int>? rowid,
  }) {
    return UserGameInfosCompanion(
      gameId: gameId ?? this.gameId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (gameId.present) {
      map['game_id'] = Variable<String>(gameId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserGameInfosCompanion(')
          ..write('gameId: $gameId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatureFlagsTable extends FeatureFlags
    with TableInfo<$FeatureFlagsTable, FeatureFlagSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<bool> value = GeneratedColumn<bool>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("value" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureFlagSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureFlagSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureFlagSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $FeatureFlagsTable createAlias(String alias) {
    return $FeatureFlagsTable(attachedDatabase, alias);
  }
}

class FeatureFlagSetting extends DataClass
    implements Insertable<FeatureFlagSetting> {
  final String id;
  final bool value;
  const FeatureFlagSetting({required this.id, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['value'] = Variable<bool>(value);
    return map;
  }

  FeatureFlagsCompanion toCompanion(bool nullToAbsent) {
    return FeatureFlagsCompanion(id: Value(id), value: Value(value));
  }

  factory FeatureFlagSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureFlagSetting(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<bool>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<bool>(value),
    };
  }

  FeatureFlagSetting copyWith({String? id, bool? value}) =>
      FeatureFlagSetting(id: id ?? this.id, value: value ?? this.value);
  FeatureFlagSetting copyWithCompanion(FeatureFlagsCompanion data) {
    return FeatureFlagSetting(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlagSetting(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureFlagSetting &&
          other.id == this.id &&
          other.value == this.value);
}

class FeatureFlagsCompanion extends UpdateCompanion<FeatureFlagSetting> {
  final Value<String> id;
  final Value<bool> value;
  final Value<int> rowid;
  const FeatureFlagsCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatureFlagsCompanion.insert({
    required String id,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<FeatureFlagSetting> custom({
    Expression<String>? id,
    Expression<bool>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatureFlagsCompanion copyWith({
    Value<String>? id,
    Value<bool>? value,
    Value<int>? rowid,
  }) {
    return FeatureFlagsCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<bool>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlagsCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppKeyBindingsTable extends AppKeyBindings
    with TableInfo<$AppKeyBindingsTable, AppKeyBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppKeyBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comboMeta = const VerificationMeta('combo');
  @override
  late final GeneratedColumn<String> combo = GeneratedColumn<String>(
    'combo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, actionId, combo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_key_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppKeyBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('combo')) {
      context.handle(
        _comboMeta,
        combo.isAcceptableOrUnknown(data['combo']!, _comboMeta),
      );
    } else if (isInserting) {
      context.missing(_comboMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, actionId};
  @override
  AppKeyBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppKeyBinding(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      )!,
      combo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}combo'],
      )!,
    );
  }

  @override
  $AppKeyBindingsTable createAlias(String alias) {
    return $AppKeyBindingsTable(attachedDatabase, alias);
  }
}

class AppKeyBinding extends DataClass implements Insertable<AppKeyBinding> {
  final String profileId;
  final String actionId;
  final String combo;
  const AppKeyBinding({
    required this.profileId,
    required this.actionId,
    required this.combo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['action_id'] = Variable<String>(actionId);
    map['combo'] = Variable<String>(combo);
    return map;
  }

  AppKeyBindingsCompanion toCompanion(bool nullToAbsent) {
    return AppKeyBindingsCompanion(
      profileId: Value(profileId),
      actionId: Value(actionId),
      combo: Value(combo),
    );
  }

  factory AppKeyBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppKeyBinding(
      profileId: serializer.fromJson<String>(json['profileId']),
      actionId: serializer.fromJson<String>(json['actionId']),
      combo: serializer.fromJson<String>(json['combo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'actionId': serializer.toJson<String>(actionId),
      'combo': serializer.toJson<String>(combo),
    };
  }

  AppKeyBinding copyWith({
    String? profileId,
    String? actionId,
    String? combo,
  }) => AppKeyBinding(
    profileId: profileId ?? this.profileId,
    actionId: actionId ?? this.actionId,
    combo: combo ?? this.combo,
  );
  AppKeyBinding copyWithCompanion(AppKeyBindingsCompanion data) {
    return AppKeyBinding(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      combo: data.combo.present ? data.combo.value : this.combo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppKeyBinding(')
          ..write('profileId: $profileId, ')
          ..write('actionId: $actionId, ')
          ..write('combo: $combo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, actionId, combo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppKeyBinding &&
          other.profileId == this.profileId &&
          other.actionId == this.actionId &&
          other.combo == this.combo);
}

class AppKeyBindingsCompanion extends UpdateCompanion<AppKeyBinding> {
  final Value<String> profileId;
  final Value<String> actionId;
  final Value<String> combo;
  final Value<int> rowid;
  const AppKeyBindingsCompanion({
    this.profileId = const Value.absent(),
    this.actionId = const Value.absent(),
    this.combo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppKeyBindingsCompanion.insert({
    required String profileId,
    required String actionId,
    required String combo,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       actionId = Value(actionId),
       combo = Value(combo);
  static Insertable<AppKeyBinding> custom({
    Expression<String>? profileId,
    Expression<String>? actionId,
    Expression<String>? combo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (actionId != null) 'action_id': actionId,
      if (combo != null) 'combo': combo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppKeyBindingsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? actionId,
    Value<String>? combo,
    Value<int>? rowid,
  }) {
    return AppKeyBindingsCompanion(
      profileId: profileId ?? this.profileId,
      actionId: actionId ?? this.actionId,
      combo: combo ?? this.combo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (combo.present) {
      map['combo'] = Variable<String>(combo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppKeyBindingsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('actionId: $actionId, ')
          ..write('combo: $combo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmulationKeyBindingsTable extends EmulationKeyBindings
    with TableInfo<$EmulationKeyBindingsTable, EmulationKeyBinding> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmulationKeyBindingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta(
    'profileId',
  );
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionIdMeta = const VerificationMeta(
    'actionId',
  );
  @override
  late final GeneratedColumn<String> actionId = GeneratedColumn<String>(
    'action_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _comboMeta = const VerificationMeta('combo');
  @override
  late final GeneratedColumn<String> combo = GeneratedColumn<String>(
    'combo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [profileId, actionId, combo];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'emulation_key_bindings';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmulationKeyBinding> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(
        _profileIdMeta,
        profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta),
      );
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('action_id')) {
      context.handle(
        _actionIdMeta,
        actionId.isAcceptableOrUnknown(data['action_id']!, _actionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_actionIdMeta);
    }
    if (data.containsKey('combo')) {
      context.handle(
        _comboMeta,
        combo.isAcceptableOrUnknown(data['combo']!, _comboMeta),
      );
    } else if (isInserting) {
      context.missing(_comboMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, actionId};
  @override
  EmulationKeyBinding map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmulationKeyBinding(
      profileId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_id'],
      )!,
      actionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action_id'],
      )!,
      combo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}combo'],
      )!,
    );
  }

  @override
  $EmulationKeyBindingsTable createAlias(String alias) {
    return $EmulationKeyBindingsTable(attachedDatabase, alias);
  }
}

class EmulationKeyBinding extends DataClass
    implements Insertable<EmulationKeyBinding> {
  final String profileId;
  final String actionId;
  final String combo;
  const EmulationKeyBinding({
    required this.profileId,
    required this.actionId,
    required this.combo,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['action_id'] = Variable<String>(actionId);
    map['combo'] = Variable<String>(combo);
    return map;
  }

  EmulationKeyBindingsCompanion toCompanion(bool nullToAbsent) {
    return EmulationKeyBindingsCompanion(
      profileId: Value(profileId),
      actionId: Value(actionId),
      combo: Value(combo),
    );
  }

  factory EmulationKeyBinding.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmulationKeyBinding(
      profileId: serializer.fromJson<String>(json['profileId']),
      actionId: serializer.fromJson<String>(json['actionId']),
      combo: serializer.fromJson<String>(json['combo']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'actionId': serializer.toJson<String>(actionId),
      'combo': serializer.toJson<String>(combo),
    };
  }

  EmulationKeyBinding copyWith({
    String? profileId,
    String? actionId,
    String? combo,
  }) => EmulationKeyBinding(
    profileId: profileId ?? this.profileId,
    actionId: actionId ?? this.actionId,
    combo: combo ?? this.combo,
  );
  EmulationKeyBinding copyWithCompanion(EmulationKeyBindingsCompanion data) {
    return EmulationKeyBinding(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      actionId: data.actionId.present ? data.actionId.value : this.actionId,
      combo: data.combo.present ? data.combo.value : this.combo,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmulationKeyBinding(')
          ..write('profileId: $profileId, ')
          ..write('actionId: $actionId, ')
          ..write('combo: $combo')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(profileId, actionId, combo);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmulationKeyBinding &&
          other.profileId == this.profileId &&
          other.actionId == this.actionId &&
          other.combo == this.combo);
}

class EmulationKeyBindingsCompanion
    extends UpdateCompanion<EmulationKeyBinding> {
  final Value<String> profileId;
  final Value<String> actionId;
  final Value<String> combo;
  final Value<int> rowid;
  const EmulationKeyBindingsCompanion({
    this.profileId = const Value.absent(),
    this.actionId = const Value.absent(),
    this.combo = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmulationKeyBindingsCompanion.insert({
    required String profileId,
    required String actionId,
    required String combo,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       actionId = Value(actionId),
       combo = Value(combo);
  static Insertable<EmulationKeyBinding> custom({
    Expression<String>? profileId,
    Expression<String>? actionId,
    Expression<String>? combo,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (actionId != null) 'action_id': actionId,
      if (combo != null) 'combo': combo,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmulationKeyBindingsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? actionId,
    Value<String>? combo,
    Value<int>? rowid,
  }) {
    return EmulationKeyBindingsCompanion(
      profileId: profileId ?? this.profileId,
      actionId: actionId ?? this.actionId,
      combo: combo ?? this.combo,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (actionId.present) {
      map['action_id'] = Variable<String>(actionId.value);
    }
    if (combo.present) {
      map['combo'] = Variable<String>(combo.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmulationKeyBindingsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('actionId: $actionId, ')
          ..write('combo: $combo, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ControllerProfilesTable extends ControllerProfiles
    with TableInfo<$ControllerProfilesTable, ControllerProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ControllerProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cuidMeta = const VerificationMeta('cuid');
  @override
  late final GeneratedColumn<String> cuid = GeneratedColumn<String>(
    'cuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: _newControllerProfileCuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBuiltInMeta = const VerificationMeta(
    'isBuiltIn',
  );
  @override
  late final GeneratedColumn<bool> isBuiltIn = GeneratedColumn<bool>(
    'is_built_in',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_built_in" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [cuid, name, isBuiltIn, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'controller_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ControllerProfileRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cuid')) {
      context.handle(
        _cuidMeta,
        cuid.isAcceptableOrUnknown(data['cuid']!, _cuidMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('is_built_in')) {
      context.handle(
        _isBuiltInMeta,
        isBuiltIn.isAcceptableOrUnknown(data['is_built_in']!, _isBuiltInMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cuid};
  @override
  ControllerProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ControllerProfileRow(
      cuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      isBuiltIn: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_built_in'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ControllerProfilesTable createAlias(String alias) {
    return $ControllerProfilesTable(attachedDatabase, alias);
  }
}

class ControllerProfileRow extends DataClass
    implements Insertable<ControllerProfileRow> {
  final String cuid;
  final String name;
  final bool isBuiltIn;
  final DateTime createdAt;
  const ControllerProfileRow({
    required this.cuid,
    required this.name,
    required this.isBuiltIn,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cuid'] = Variable<String>(cuid);
    map['name'] = Variable<String>(name);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ControllerProfilesCompanion toCompanion(bool nullToAbsent) {
    return ControllerProfilesCompanion(
      cuid: Value(cuid),
      name: Value(name),
      isBuiltIn: Value(isBuiltIn),
      createdAt: Value(createdAt),
    );
  }

  factory ControllerProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ControllerProfileRow(
      cuid: serializer.fromJson<String>(json['cuid']),
      name: serializer.fromJson<String>(json['name']),
      isBuiltIn: serializer.fromJson<bool>(json['isBuiltIn']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cuid': serializer.toJson<String>(cuid),
      'name': serializer.toJson<String>(name),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ControllerProfileRow copyWith({
    String? cuid,
    String? name,
    bool? isBuiltIn,
    DateTime? createdAt,
  }) => ControllerProfileRow(
    cuid: cuid ?? this.cuid,
    name: name ?? this.name,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    createdAt: createdAt ?? this.createdAt,
  );
  ControllerProfileRow copyWithCompanion(ControllerProfilesCompanion data) {
    return ControllerProfileRow(
      cuid: data.cuid.present ? data.cuid.value : this.cuid,
      name: data.name.present ? data.name.value : this.name,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ControllerProfileRow(')
          ..write('cuid: $cuid, ')
          ..write('name: $name, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cuid, name, isBuiltIn, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ControllerProfileRow &&
          other.cuid == this.cuid &&
          other.name == this.name &&
          other.isBuiltIn == this.isBuiltIn &&
          other.createdAt == this.createdAt);
}

class ControllerProfilesCompanion
    extends UpdateCompanion<ControllerProfileRow> {
  final Value<String> cuid;
  final Value<String> name;
  final Value<bool> isBuiltIn;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ControllerProfilesCompanion({
    this.cuid = const Value.absent(),
    this.name = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ControllerProfilesCompanion.insert({
    this.cuid = const Value.absent(),
    required String name,
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name);
  static Insertable<ControllerProfileRow> custom({
    Expression<String>? cuid,
    Expression<String>? name,
    Expression<bool>? isBuiltIn,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cuid != null) 'cuid': cuid,
      if (name != null) 'name': name,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ControllerProfilesCompanion copyWith({
    Value<String>? cuid,
    Value<String>? name,
    Value<bool>? isBuiltIn,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ControllerProfilesCompanion(
      cuid: cuid ?? this.cuid,
      name: name ?? this.name,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cuid.present) {
      map['cuid'] = Variable<String>(cuid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (isBuiltIn.present) {
      map['is_built_in'] = Variable<bool>(isBuiltIn.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ControllerProfilesCompanion(')
          ..write('cuid: $cuid, ')
          ..write('name: $name, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$UserDatabase extends GeneratedDatabase {
  _$UserDatabase(QueryExecutor e) : super(e);
  $UserDatabaseManager get managers => $UserDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ControlBindingsTable controlBindings = $ControlBindingsTable(
    this,
  );
  late final $InputLayoutElementsTable inputLayoutElements =
      $InputLayoutElementsTable(this);
  late final $ThemeSettingsTable themeSettings = $ThemeSettingsTable(this);
  late final $AccessibilitySettingsTable accessibilitySettings =
      $AccessibilitySettingsTable(this);
  late final $AdvancedSettingsTable advancedSettings = $AdvancedSettingsTable(
    this,
  );
  late final $MediaSettingsTable mediaSettings = $MediaSettingsTable(this);
  late final $DebugSettingsTable debugSettings = $DebugSettingsTable(this);
  late final $VirtualAccessPointsTable virtualAccessPoints =
      $VirtualAccessPointsTable(this);
  late final $PinnedOptionsTable pinnedOptions = $PinnedOptionsTable(this);
  late final $OptionHistoryEntriesTable optionHistoryEntries =
      $OptionHistoryEntriesTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $GameTagsTable gameTags = $GameTagsTable(this);
  late final $UserGameInfosTable userGameInfos = $UserGameInfosTable(this);
  late final $FeatureFlagsTable featureFlags = $FeatureFlagsTable(this);
  late final $AppKeyBindingsTable appKeyBindings = $AppKeyBindingsTable(this);
  late final $EmulationKeyBindingsTable emulationKeyBindings =
      $EmulationKeyBindingsTable(this);
  late final $ControllerProfilesTable controllerProfiles =
      $ControllerProfilesTable(this);
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
    accessibilitySettings,
    advancedSettings,
    mediaSettings,
    debugSettings,
    virtualAccessPoints,
    pinnedOptions,
    optionHistoryEntries,
    tags,
    gameTags,
    userGameInfos,
    featureFlags,
    appKeyBindings,
    emulationKeyBindings,
    controllerProfiles,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tags',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('game_tags', kind: UpdateKind.delete)],
    ),
  ]);
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

class $$GamesTableFilterComposer extends Composer<_$UserDatabase, $GamesTable> {
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
    extends Composer<_$UserDatabase, $GamesTable> {
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
    extends Composer<_$UserDatabase, $GamesTable> {
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
          _$UserDatabase,
          $GamesTable,
          GameRow,
          $$GamesTableFilterComposer,
          $$GamesTableOrderingComposer,
          $$GamesTableAnnotationComposer,
          $$GamesTableCreateCompanionBuilder,
          $$GamesTableUpdateCompanionBuilder,
          (GameRow, BaseReferences<_$UserDatabase, $GamesTable, GameRow>),
          GameRow,
          PrefetchHooks Function()
        > {
  $$GamesTableTableManager(_$UserDatabase db, $GamesTable table)
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
                  BaseReferences<_$UserDatabase, $GamesTable, GameRow>(
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
      _$UserDatabase,
      $GamesTable,
      GameRow,
      $$GamesTableFilterComposer,
      $$GamesTableOrderingComposer,
      $$GamesTableAnnotationComposer,
      $$GamesTableCreateCompanionBuilder,
      $$GamesTableUpdateCompanionBuilder,
      (GameRow, BaseReferences<_$UserDatabase, $GamesTable, GameRow>),
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
    extends Composer<_$UserDatabase, $AppSettingsTable> {
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
    extends Composer<_$UserDatabase, $AppSettingsTable> {
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
    extends Composer<_$UserDatabase, $AppSettingsTable> {
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
          _$UserDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$UserDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$UserDatabase db, $AppSettingsTable table)
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
                  BaseReferences<_$UserDatabase, $AppSettingsTable, AppSetting>(
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
      _$UserDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$UserDatabase, $AppSettingsTable, AppSetting>,
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
    extends Composer<_$UserDatabase, $ControlBindingsTable> {
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
    extends Composer<_$UserDatabase, $ControlBindingsTable> {
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
    extends Composer<_$UserDatabase, $ControlBindingsTable> {
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
          _$UserDatabase,
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
              _$UserDatabase,
              $ControlBindingsTable,
              ControlBinding
            >,
          ),
          ControlBinding,
          PrefetchHooks Function()
        > {
  $$ControlBindingsTableTableManager(
    _$UserDatabase db,
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
                    _$UserDatabase,
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
      _$UserDatabase,
      $ControlBindingsTable,
      ControlBinding,
      $$ControlBindingsTableFilterComposer,
      $$ControlBindingsTableOrderingComposer,
      $$ControlBindingsTableAnnotationComposer,
      $$ControlBindingsTableCreateCompanionBuilder,
      $$ControlBindingsTableUpdateCompanionBuilder,
      (
        ControlBinding,
        BaseReferences<_$UserDatabase, $ControlBindingsTable, ControlBinding>,
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
    extends Composer<_$UserDatabase, $InputLayoutElementsTable> {
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
    extends Composer<_$UserDatabase, $InputLayoutElementsTable> {
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
    extends Composer<_$UserDatabase, $InputLayoutElementsTable> {
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
          _$UserDatabase,
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
              _$UserDatabase,
              $InputLayoutElementsTable,
              InputLayoutElement
            >,
          ),
          InputLayoutElement,
          PrefetchHooks Function()
        > {
  $$InputLayoutElementsTableTableManager(
    _$UserDatabase db,
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
                    _$UserDatabase,
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
      _$UserDatabase,
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
          _$UserDatabase,
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
      Value<ThemeStyle> themeStyle,
    });
typedef $$ThemeSettingsTableUpdateCompanionBuilder =
    ThemeSettingsCompanion Function({
      Value<int> id,
      Value<String> themeMode,
      Value<int> staticThemeColor,
      Value<bool> blackBackgrounds,
      Value<bool> materialYou,
      Value<ThemeStyle> themeStyle,
    });

class $$ThemeSettingsTableFilterComposer
    extends Composer<_$UserDatabase, $ThemeSettingsTable> {
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

  ColumnWithTypeConverterFilters<ThemeStyle, ThemeStyle, int> get themeStyle =>
      $composableBuilder(
        column: $table.themeStyle,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );
}

class $$ThemeSettingsTableOrderingComposer
    extends Composer<_$UserDatabase, $ThemeSettingsTable> {
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

  ColumnOrderings<int> get themeStyle => $composableBuilder(
    column: $table.themeStyle,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemeSettingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $ThemeSettingsTable> {
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

  GeneratedColumnWithTypeConverter<ThemeStyle, int> get themeStyle =>
      $composableBuilder(
        column: $table.themeStyle,
        builder: (column) => column,
      );
}

class $$ThemeSettingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $ThemeSettingsTable,
          ThemeSetting,
          $$ThemeSettingsTableFilterComposer,
          $$ThemeSettingsTableOrderingComposer,
          $$ThemeSettingsTableAnnotationComposer,
          $$ThemeSettingsTableCreateCompanionBuilder,
          $$ThemeSettingsTableUpdateCompanionBuilder,
          (
            ThemeSetting,
            BaseReferences<_$UserDatabase, $ThemeSettingsTable, ThemeSetting>,
          ),
          ThemeSetting,
          PrefetchHooks Function()
        > {
  $$ThemeSettingsTableTableManager(_$UserDatabase db, $ThemeSettingsTable table)
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
                Value<ThemeStyle> themeStyle = const Value.absent(),
              }) => ThemeSettingsCompanion(
                id: id,
                themeMode: themeMode,
                staticThemeColor: staticThemeColor,
                blackBackgrounds: blackBackgrounds,
                materialYou: materialYou,
                themeStyle: themeStyle,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<int> staticThemeColor = const Value.absent(),
                Value<bool> blackBackgrounds = const Value.absent(),
                Value<bool> materialYou = const Value.absent(),
                Value<ThemeStyle> themeStyle = const Value.absent(),
              }) => ThemeSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                staticThemeColor: staticThemeColor,
                blackBackgrounds: blackBackgrounds,
                materialYou: materialYou,
                themeStyle: themeStyle,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ThemeSettingsTable, ThemeSetting>(table),
                  BaseReferences<
                    _$UserDatabase,
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
      _$UserDatabase,
      $ThemeSettingsTable,
      ThemeSetting,
      $$ThemeSettingsTableFilterComposer,
      $$ThemeSettingsTableOrderingComposer,
      $$ThemeSettingsTableAnnotationComposer,
      $$ThemeSettingsTableCreateCompanionBuilder,
      $$ThemeSettingsTableUpdateCompanionBuilder,
      (
        ThemeSetting,
        BaseReferences<_$UserDatabase, $ThemeSettingsTable, ThemeSetting>,
      ),
      ThemeSetting,
      PrefetchHooks Function()
    >;
typedef $$AccessibilitySettingsTableCreateCompanionBuilder =
    AccessibilitySettingsCompanion Function({
      Value<int> id,
      Value<bool> reduceMotion,
      Value<PageTransitionStyle> pageTransition,
    });
typedef $$AccessibilitySettingsTableUpdateCompanionBuilder =
    AccessibilitySettingsCompanion Function({
      Value<int> id,
      Value<bool> reduceMotion,
      Value<PageTransitionStyle> pageTransition,
    });

class $$AccessibilitySettingsTableFilterComposer
    extends Composer<_$UserDatabase, $AccessibilitySettingsTable> {
  $$AccessibilitySettingsTableFilterComposer({
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

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PageTransitionStyle, PageTransitionStyle, int>
  get pageTransition => $composableBuilder(
    column: $table.pageTransition,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AccessibilitySettingsTableOrderingComposer
    extends Composer<_$UserDatabase, $AccessibilitySettingsTable> {
  $$AccessibilitySettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageTransition => $composableBuilder(
    column: $table.pageTransition,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccessibilitySettingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $AccessibilitySettingsTable> {
  $$AccessibilitySettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<PageTransitionStyle, int>
  get pageTransition => $composableBuilder(
    column: $table.pageTransition,
    builder: (column) => column,
  );
}

class $$AccessibilitySettingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $AccessibilitySettingsTable,
          AccessibilitySetting,
          $$AccessibilitySettingsTableFilterComposer,
          $$AccessibilitySettingsTableOrderingComposer,
          $$AccessibilitySettingsTableAnnotationComposer,
          $$AccessibilitySettingsTableCreateCompanionBuilder,
          $$AccessibilitySettingsTableUpdateCompanionBuilder,
          (
            AccessibilitySetting,
            BaseReferences<
              _$UserDatabase,
              $AccessibilitySettingsTable,
              AccessibilitySetting
            >,
          ),
          AccessibilitySetting,
          PrefetchHooks Function()
        > {
  $$AccessibilitySettingsTableTableManager(
    _$UserDatabase db,
    $AccessibilitySettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccessibilitySettingsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AccessibilitySettingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AccessibilitySettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<PageTransitionStyle> pageTransition =
                    const Value.absent(),
              }) => AccessibilitySettingsCompanion(
                id: id,
                reduceMotion: reduceMotion,
                pageTransition: pageTransition,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<PageTransitionStyle> pageTransition =
                    const Value.absent(),
              }) => AccessibilitySettingsCompanion.insert(
                id: id,
                reduceMotion: reduceMotion,
                pageTransition: pageTransition,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $AccessibilitySettingsTable,
                    AccessibilitySetting
                  >(table),
                  BaseReferences<
                    _$UserDatabase,
                    $AccessibilitySettingsTable,
                    AccessibilitySetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccessibilitySettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $AccessibilitySettingsTable,
      AccessibilitySetting,
      $$AccessibilitySettingsTableFilterComposer,
      $$AccessibilitySettingsTableOrderingComposer,
      $$AccessibilitySettingsTableAnnotationComposer,
      $$AccessibilitySettingsTableCreateCompanionBuilder,
      $$AccessibilitySettingsTableUpdateCompanionBuilder,
      (
        AccessibilitySetting,
        BaseReferences<
          _$UserDatabase,
          $AccessibilitySettingsTable,
          AccessibilitySetting
        >,
      ),
      AccessibilitySetting,
      PrefetchHooks Function()
    >;
typedef $$AdvancedSettingsTableCreateCompanionBuilder =
    AdvancedSettingsCompanion Function({
      Value<int> id,
      Value<AnimationSpeed> animationSpeed,
    });
typedef $$AdvancedSettingsTableUpdateCompanionBuilder =
    AdvancedSettingsCompanion Function({
      Value<int> id,
      Value<AnimationSpeed> animationSpeed,
    });

class $$AdvancedSettingsTableFilterComposer
    extends Composer<_$UserDatabase, $AdvancedSettingsTable> {
  $$AdvancedSettingsTableFilterComposer({
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

  ColumnWithTypeConverterFilters<AnimationSpeed, AnimationSpeed, int>
  get animationSpeed => $composableBuilder(
    column: $table.animationSpeed,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AdvancedSettingsTableOrderingComposer
    extends Composer<_$UserDatabase, $AdvancedSettingsTable> {
  $$AdvancedSettingsTableOrderingComposer({
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

  ColumnOrderings<int> get animationSpeed => $composableBuilder(
    column: $table.animationSpeed,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AdvancedSettingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $AdvancedSettingsTable> {
  $$AdvancedSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AnimationSpeed, int> get animationSpeed =>
      $composableBuilder(
        column: $table.animationSpeed,
        builder: (column) => column,
      );
}

class $$AdvancedSettingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $AdvancedSettingsTable,
          AdvancedSetting,
          $$AdvancedSettingsTableFilterComposer,
          $$AdvancedSettingsTableOrderingComposer,
          $$AdvancedSettingsTableAnnotationComposer,
          $$AdvancedSettingsTableCreateCompanionBuilder,
          $$AdvancedSettingsTableUpdateCompanionBuilder,
          (
            AdvancedSetting,
            BaseReferences<
              _$UserDatabase,
              $AdvancedSettingsTable,
              AdvancedSetting
            >,
          ),
          AdvancedSetting,
          PrefetchHooks Function()
        > {
  $$AdvancedSettingsTableTableManager(
    _$UserDatabase db,
    $AdvancedSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AdvancedSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AdvancedSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AdvancedSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AnimationSpeed> animationSpeed = const Value.absent(),
              }) => AdvancedSettingsCompanion(
                id: id,
                animationSpeed: animationSpeed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<AnimationSpeed> animationSpeed = const Value.absent(),
              }) => AdvancedSettingsCompanion.insert(
                id: id,
                animationSpeed: animationSpeed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AdvancedSettingsTable, AdvancedSetting>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $AdvancedSettingsTable,
                    AdvancedSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AdvancedSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $AdvancedSettingsTable,
      AdvancedSetting,
      $$AdvancedSettingsTableFilterComposer,
      $$AdvancedSettingsTableOrderingComposer,
      $$AdvancedSettingsTableAnnotationComposer,
      $$AdvancedSettingsTableCreateCompanionBuilder,
      $$AdvancedSettingsTableUpdateCompanionBuilder,
      (
        AdvancedSetting,
        BaseReferences<_$UserDatabase, $AdvancedSettingsTable, AdvancedSetting>,
      ),
      AdvancedSetting,
      PrefetchHooks Function()
    >;
typedef $$MediaSettingsTableCreateCompanionBuilder =
    MediaSettingsCompanion Function({
      Value<int> id,
      Value<double> masterVolume,
      Value<String?> audioEngine,
    });
typedef $$MediaSettingsTableUpdateCompanionBuilder =
    MediaSettingsCompanion Function({
      Value<int> id,
      Value<double> masterVolume,
      Value<String?> audioEngine,
    });

class $$MediaSettingsTableFilterComposer
    extends Composer<_$UserDatabase, $MediaSettingsTable> {
  $$MediaSettingsTableFilterComposer({
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

  ColumnFilters<double> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioEngine => $composableBuilder(
    column: $table.audioEngine,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MediaSettingsTableOrderingComposer
    extends Composer<_$UserDatabase, $MediaSettingsTable> {
  $$MediaSettingsTableOrderingComposer({
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

  ColumnOrderings<double> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioEngine => $composableBuilder(
    column: $table.audioEngine,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MediaSettingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $MediaSettingsTable> {
  $$MediaSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get masterVolume => $composableBuilder(
    column: $table.masterVolume,
    builder: (column) => column,
  );

  GeneratedColumn<String> get audioEngine => $composableBuilder(
    column: $table.audioEngine,
    builder: (column) => column,
  );
}

class $$MediaSettingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $MediaSettingsTable,
          MediaSetting,
          $$MediaSettingsTableFilterComposer,
          $$MediaSettingsTableOrderingComposer,
          $$MediaSettingsTableAnnotationComposer,
          $$MediaSettingsTableCreateCompanionBuilder,
          $$MediaSettingsTableUpdateCompanionBuilder,
          (
            MediaSetting,
            BaseReferences<_$UserDatabase, $MediaSettingsTable, MediaSetting>,
          ),
          MediaSetting,
          PrefetchHooks Function()
        > {
  $$MediaSettingsTableTableManager(_$UserDatabase db, $MediaSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MediaSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MediaSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MediaSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> masterVolume = const Value.absent(),
                Value<String?> audioEngine = const Value.absent(),
              }) => MediaSettingsCompanion(
                id: id,
                masterVolume: masterVolume,
                audioEngine: audioEngine,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> masterVolume = const Value.absent(),
                Value<String?> audioEngine = const Value.absent(),
              }) => MediaSettingsCompanion.insert(
                id: id,
                masterVolume: masterVolume,
                audioEngine: audioEngine,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MediaSettingsTable, MediaSetting>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $MediaSettingsTable,
                    MediaSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MediaSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $MediaSettingsTable,
      MediaSetting,
      $$MediaSettingsTableFilterComposer,
      $$MediaSettingsTableOrderingComposer,
      $$MediaSettingsTableAnnotationComposer,
      $$MediaSettingsTableCreateCompanionBuilder,
      $$MediaSettingsTableUpdateCompanionBuilder,
      (
        MediaSetting,
        BaseReferences<_$UserDatabase, $MediaSettingsTable, MediaSetting>,
      ),
      MediaSetting,
      PrefetchHooks Function()
    >;
typedef $$DebugSettingsTableCreateCompanionBuilder =
    DebugSettingsCompanion Function({Value<int> id, Value<bool> logToConsole});
typedef $$DebugSettingsTableUpdateCompanionBuilder =
    DebugSettingsCompanion Function({Value<int> id, Value<bool> logToConsole});

class $$DebugSettingsTableFilterComposer
    extends Composer<_$UserDatabase, $DebugSettingsTable> {
  $$DebugSettingsTableFilterComposer({
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

  ColumnFilters<bool> get logToConsole => $composableBuilder(
    column: $table.logToConsole,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebugSettingsTableOrderingComposer
    extends Composer<_$UserDatabase, $DebugSettingsTable> {
  $$DebugSettingsTableOrderingComposer({
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

  ColumnOrderings<bool> get logToConsole => $composableBuilder(
    column: $table.logToConsole,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebugSettingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $DebugSettingsTable> {
  $$DebugSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get logToConsole => $composableBuilder(
    column: $table.logToConsole,
    builder: (column) => column,
  );
}

class $$DebugSettingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $DebugSettingsTable,
          DebugSetting,
          $$DebugSettingsTableFilterComposer,
          $$DebugSettingsTableOrderingComposer,
          $$DebugSettingsTableAnnotationComposer,
          $$DebugSettingsTableCreateCompanionBuilder,
          $$DebugSettingsTableUpdateCompanionBuilder,
          (
            DebugSetting,
            BaseReferences<_$UserDatabase, $DebugSettingsTable, DebugSetting>,
          ),
          DebugSetting,
          PrefetchHooks Function()
        > {
  $$DebugSettingsTableTableManager(_$UserDatabase db, $DebugSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebugSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebugSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebugSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> logToConsole = const Value.absent(),
              }) => DebugSettingsCompanion(id: id, logToConsole: logToConsole),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> logToConsole = const Value.absent(),
              }) => DebugSettingsCompanion.insert(
                id: id,
                logToConsole: logToConsole,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DebugSettingsTable, DebugSetting>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $DebugSettingsTable,
                    DebugSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebugSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $DebugSettingsTable,
      DebugSetting,
      $$DebugSettingsTableFilterComposer,
      $$DebugSettingsTableOrderingComposer,
      $$DebugSettingsTableAnnotationComposer,
      $$DebugSettingsTableCreateCompanionBuilder,
      $$DebugSettingsTableUpdateCompanionBuilder,
      (
        DebugSetting,
        BaseReferences<_$UserDatabase, $DebugSettingsTable, DebugSetting>,
      ),
      DebugSetting,
      PrefetchHooks Function()
    >;
typedef $$VirtualAccessPointsTableCreateCompanionBuilder =
    VirtualAccessPointsCompanion Function({
      Value<int> sortIndex,
      required String ssid,
      required String bssid,
      required int frequency,
      required int level,
    });
typedef $$VirtualAccessPointsTableUpdateCompanionBuilder =
    VirtualAccessPointsCompanion Function({
      Value<int> sortIndex,
      Value<String> ssid,
      Value<String> bssid,
      Value<int> frequency,
      Value<int> level,
    });

class $$VirtualAccessPointsTableFilterComposer
    extends Composer<_$UserDatabase, $VirtualAccessPointsTable> {
  $$VirtualAccessPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VirtualAccessPointsTableOrderingComposer
    extends Composer<_$UserDatabase, $VirtualAccessPointsTable> {
  $$VirtualAccessPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ssid => $composableBuilder(
    column: $table.ssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bssid => $composableBuilder(
    column: $table.bssid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VirtualAccessPointsTableAnnotationComposer
    extends Composer<_$UserDatabase, $VirtualAccessPointsTable> {
  $$VirtualAccessPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<String> get ssid =>
      $composableBuilder(column: $table.ssid, builder: (column) => column);

  GeneratedColumn<String> get bssid =>
      $composableBuilder(column: $table.bssid, builder: (column) => column);

  GeneratedColumn<int> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);
}

class $$VirtualAccessPointsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $VirtualAccessPointsTable,
          VirtualAccessPoint,
          $$VirtualAccessPointsTableFilterComposer,
          $$VirtualAccessPointsTableOrderingComposer,
          $$VirtualAccessPointsTableAnnotationComposer,
          $$VirtualAccessPointsTableCreateCompanionBuilder,
          $$VirtualAccessPointsTableUpdateCompanionBuilder,
          (
            VirtualAccessPoint,
            BaseReferences<
              _$UserDatabase,
              $VirtualAccessPointsTable,
              VirtualAccessPoint
            >,
          ),
          VirtualAccessPoint,
          PrefetchHooks Function()
        > {
  $$VirtualAccessPointsTableTableManager(
    _$UserDatabase db,
    $VirtualAccessPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VirtualAccessPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VirtualAccessPointsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$VirtualAccessPointsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> sortIndex = const Value.absent(),
                Value<String> ssid = const Value.absent(),
                Value<String> bssid = const Value.absent(),
                Value<int> frequency = const Value.absent(),
                Value<int> level = const Value.absent(),
              }) => VirtualAccessPointsCompanion(
                sortIndex: sortIndex,
                ssid: ssid,
                bssid: bssid,
                frequency: frequency,
                level: level,
              ),
          createCompanionCallback:
              ({
                Value<int> sortIndex = const Value.absent(),
                required String ssid,
                required String bssid,
                required int frequency,
                required int level,
              }) => VirtualAccessPointsCompanion.insert(
                sortIndex: sortIndex,
                ssid: ssid,
                bssid: bssid,
                frequency: frequency,
                level: level,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VirtualAccessPointsTable, VirtualAccessPoint>(
                    table,
                  ),
                  BaseReferences<
                    _$UserDatabase,
                    $VirtualAccessPointsTable,
                    VirtualAccessPoint
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VirtualAccessPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $VirtualAccessPointsTable,
      VirtualAccessPoint,
      $$VirtualAccessPointsTableFilterComposer,
      $$VirtualAccessPointsTableOrderingComposer,
      $$VirtualAccessPointsTableAnnotationComposer,
      $$VirtualAccessPointsTableCreateCompanionBuilder,
      $$VirtualAccessPointsTableUpdateCompanionBuilder,
      (
        VirtualAccessPoint,
        BaseReferences<
          _$UserDatabase,
          $VirtualAccessPointsTable,
          VirtualAccessPoint
        >,
      ),
      VirtualAccessPoint,
      PrefetchHooks Function()
    >;
typedef $$PinnedOptionsTableCreateCompanionBuilder =
    PinnedOptionsCompanion Function({
      required String optionId,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$PinnedOptionsTableUpdateCompanionBuilder =
    PinnedOptionsCompanion Function({
      Value<String> optionId,
      Value<int> sortIndex,
      Value<int> rowid,
    });

class $$PinnedOptionsTableFilterComposer
    extends Composer<_$UserDatabase, $PinnedOptionsTable> {
  $$PinnedOptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PinnedOptionsTableOrderingComposer
    extends Composer<_$UserDatabase, $PinnedOptionsTable> {
  $$PinnedOptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PinnedOptionsTableAnnotationComposer
    extends Composer<_$UserDatabase, $PinnedOptionsTable> {
  $$PinnedOptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);
}

class $$PinnedOptionsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $PinnedOptionsTable,
          PinnedOption,
          $$PinnedOptionsTableFilterComposer,
          $$PinnedOptionsTableOrderingComposer,
          $$PinnedOptionsTableAnnotationComposer,
          $$PinnedOptionsTableCreateCompanionBuilder,
          $$PinnedOptionsTableUpdateCompanionBuilder,
          (
            PinnedOption,
            BaseReferences<_$UserDatabase, $PinnedOptionsTable, PinnedOption>,
          ),
          PinnedOption,
          PrefetchHooks Function()
        > {
  $$PinnedOptionsTableTableManager(_$UserDatabase db, $PinnedOptionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PinnedOptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PinnedOptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PinnedOptionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> optionId = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PinnedOptionsCompanion(
                optionId: optionId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String optionId,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => PinnedOptionsCompanion.insert(
                optionId: optionId,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PinnedOptionsTable, PinnedOption>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $PinnedOptionsTable,
                    PinnedOption
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PinnedOptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $PinnedOptionsTable,
      PinnedOption,
      $$PinnedOptionsTableFilterComposer,
      $$PinnedOptionsTableOrderingComposer,
      $$PinnedOptionsTableAnnotationComposer,
      $$PinnedOptionsTableCreateCompanionBuilder,
      $$PinnedOptionsTableUpdateCompanionBuilder,
      (
        PinnedOption,
        BaseReferences<_$UserDatabase, $PinnedOptionsTable, PinnedOption>,
      ),
      PinnedOption,
      PrefetchHooks Function()
    >;
typedef $$OptionHistoryEntriesTableCreateCompanionBuilder =
    OptionHistoryEntriesCompanion Function({
      required String optionId,
      required int accessOrder,
      Value<int> rowid,
    });
typedef $$OptionHistoryEntriesTableUpdateCompanionBuilder =
    OptionHistoryEntriesCompanion Function({
      Value<String> optionId,
      Value<int> accessOrder,
      Value<int> rowid,
    });

class $$OptionHistoryEntriesTableFilterComposer
    extends Composer<_$UserDatabase, $OptionHistoryEntriesTable> {
  $$OptionHistoryEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accessOrder => $composableBuilder(
    column: $table.accessOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OptionHistoryEntriesTableOrderingComposer
    extends Composer<_$UserDatabase, $OptionHistoryEntriesTable> {
  $$OptionHistoryEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get optionId => $composableBuilder(
    column: $table.optionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accessOrder => $composableBuilder(
    column: $table.accessOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OptionHistoryEntriesTableAnnotationComposer
    extends Composer<_$UserDatabase, $OptionHistoryEntriesTable> {
  $$OptionHistoryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get optionId =>
      $composableBuilder(column: $table.optionId, builder: (column) => column);

  GeneratedColumn<int> get accessOrder => $composableBuilder(
    column: $table.accessOrder,
    builder: (column) => column,
  );
}

class $$OptionHistoryEntriesTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $OptionHistoryEntriesTable,
          OptionHistoryEntry,
          $$OptionHistoryEntriesTableFilterComposer,
          $$OptionHistoryEntriesTableOrderingComposer,
          $$OptionHistoryEntriesTableAnnotationComposer,
          $$OptionHistoryEntriesTableCreateCompanionBuilder,
          $$OptionHistoryEntriesTableUpdateCompanionBuilder,
          (
            OptionHistoryEntry,
            BaseReferences<
              _$UserDatabase,
              $OptionHistoryEntriesTable,
              OptionHistoryEntry
            >,
          ),
          OptionHistoryEntry,
          PrefetchHooks Function()
        > {
  $$OptionHistoryEntriesTableTableManager(
    _$UserDatabase db,
    $OptionHistoryEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OptionHistoryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OptionHistoryEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OptionHistoryEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> optionId = const Value.absent(),
                Value<int> accessOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OptionHistoryEntriesCompanion(
                optionId: optionId,
                accessOrder: accessOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String optionId,
                required int accessOrder,
                Value<int> rowid = const Value.absent(),
              }) => OptionHistoryEntriesCompanion.insert(
                optionId: optionId,
                accessOrder: accessOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OptionHistoryEntriesTable, OptionHistoryEntry>(
                    table,
                  ),
                  BaseReferences<
                    _$UserDatabase,
                    $OptionHistoryEntriesTable,
                    OptionHistoryEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OptionHistoryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $OptionHistoryEntriesTable,
      OptionHistoryEntry,
      $$OptionHistoryEntriesTableFilterComposer,
      $$OptionHistoryEntriesTableOrderingComposer,
      $$OptionHistoryEntriesTableAnnotationComposer,
      $$OptionHistoryEntriesTableCreateCompanionBuilder,
      $$OptionHistoryEntriesTableUpdateCompanionBuilder,
      (
        OptionHistoryEntry,
        BaseReferences<
          _$UserDatabase,
          $OptionHistoryEntriesTable,
          OptionHistoryEntry
        >,
      ),
      OptionHistoryEntry,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      required String kind,
      required int sortIndex,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> kind,
      Value<int> sortIndex,
      Value<int> rowid,
    });

final class $$TagsTableReferences
    extends BaseReferences<_$UserDatabase, $TagsTable, TagRow> {
  $$TagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$GameTagsTable, List<GameTagRow>>
  _gameTagsRefsTable(_$UserDatabase db) => MultiTypedResultKey.fromTable(
    db.gameTags,
    aliasName: 'tags__id__game_tags__tag_id',
  );

  $$GameTagsTableProcessedTableManager get gameTagsRefs {
    final manager = $$GameTagsTableTableManager(
      $_db,
      $_db.gameTags,
    ).filter((f) => f.tagId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gameTagsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TagsTableFilterComposer extends Composer<_$UserDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gameTagsRefs(
    Expression<bool> Function($$GameTagsTableFilterComposer f) f,
  ) {
    final $$GameTagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTagsTableFilterComposer(
            $db: $db,
            $table: $db.gameTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableOrderingComposer extends Composer<_$UserDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$UserDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  Expression<T> gameTagsRefs<T extends Object>(
    Expression<T> Function($$GameTagsTableAnnotationComposer a) f,
  ) {
    final $$GameTagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gameTags,
      getReferencedColumn: (t) => t.tagId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GameTagsTableAnnotationComposer(
            $db: $db,
            $table: $db.gameTags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $TagsTable,
          TagRow,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (TagRow, $$TagsTableReferences),
          TagRow,
          PrefetchHooks Function({bool gameTagsRefs})
        > {
  $$TagsTableTableManager(_$UserDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                kind: kind,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                required String kind,
                required int sortIndex,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                kind: kind,
                sortIndex: sortIndex,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TagsTable, TagRow>(table),
                  $$TagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({gameTagsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (gameTagsRefs) db.gameTags],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (gameTagsRefs)
                    await $_getPrefetchedData<TagRow, $TagsTable, GameTagRow>(
                      currentTable: table,
                      referencedTable: $$TagsTableReferences._gameTagsRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$TagsTableReferences(db, table, p0).gameTagsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tagId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $TagsTable,
      TagRow,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (TagRow, $$TagsTableReferences),
      TagRow,
      PrefetchHooks Function({bool gameTagsRefs})
    >;
typedef $$GameTagsTableCreateCompanionBuilder =
    GameTagsCompanion Function({
      required String gamePath,
      required String tagId,
      Value<int> rowid,
    });
typedef $$GameTagsTableUpdateCompanionBuilder =
    GameTagsCompanion Function({
      Value<String> gamePath,
      Value<String> tagId,
      Value<int> rowid,
    });

final class $$GameTagsTableReferences
    extends BaseReferences<_$UserDatabase, $GameTagsTable, GameTagRow> {
  $$GameTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TagsTable _tagIdTable(_$UserDatabase db) =>
      db.tags.createAlias('game_tags__tag_id__tags__id');

  $$TagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<String>('tag_id')!;

    final manager = $$TagsTableTableManager(
      $_db,
      $_db.tags,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GameTagsTableFilterComposer
    extends Composer<_$UserDatabase, $GameTagsTable> {
  $$GameTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gamePath => $composableBuilder(
    column: $table.gamePath,
    builder: (column) => ColumnFilters(column),
  );

  $$TagsTableFilterComposer get tagId {
    final $$TagsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableFilterComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameTagsTableOrderingComposer
    extends Composer<_$UserDatabase, $GameTagsTable> {
  $$GameTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gamePath => $composableBuilder(
    column: $table.gamePath,
    builder: (column) => ColumnOrderings(column),
  );

  $$TagsTableOrderingComposer get tagId {
    final $$TagsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableOrderingComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameTagsTableAnnotationComposer
    extends Composer<_$UserDatabase, $GameTagsTable> {
  $$GameTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gamePath =>
      $composableBuilder(column: $table.gamePath, builder: (column) => column);

  $$TagsTableAnnotationComposer get tagId {
    final $$TagsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tagId,
      referencedTable: $db.tags,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TagsTableAnnotationComposer(
            $db: $db,
            $table: $db.tags,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GameTagsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $GameTagsTable,
          GameTagRow,
          $$GameTagsTableFilterComposer,
          $$GameTagsTableOrderingComposer,
          $$GameTagsTableAnnotationComposer,
          $$GameTagsTableCreateCompanionBuilder,
          $$GameTagsTableUpdateCompanionBuilder,
          (GameTagRow, $$GameTagsTableReferences),
          GameTagRow,
          PrefetchHooks Function({bool tagId})
        > {
  $$GameTagsTableTableManager(_$UserDatabase db, $GameTagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GameTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GameTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GameTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gamePath = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GameTagsCompanion(
                gamePath: gamePath,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gamePath,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => GameTagsCompanion.insert(
                gamePath: gamePath,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GameTagsTable, GameTagRow>(table),
                  $$GameTagsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (tagId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.tagId,
                                referencedTable: $$GameTagsTableReferences
                                    ._tagIdTable(db),
                                referencedColumn: $$GameTagsTableReferences
                                    ._tagIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GameTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $GameTagsTable,
      GameTagRow,
      $$GameTagsTableFilterComposer,
      $$GameTagsTableOrderingComposer,
      $$GameTagsTableAnnotationComposer,
      $$GameTagsTableCreateCompanionBuilder,
      $$GameTagsTableUpdateCompanionBuilder,
      (GameTagRow, $$GameTagsTableReferences),
      GameTagRow,
      PrefetchHooks Function({bool tagId})
    >;
typedef $$UserGameInfosTableCreateCompanionBuilder =
    UserGameInfosCompanion Function({
      required String gameId,
      Value<String?> name,
      Value<int> rowid,
    });
typedef $$UserGameInfosTableUpdateCompanionBuilder =
    UserGameInfosCompanion Function({
      Value<String> gameId,
      Value<String?> name,
      Value<int> rowid,
    });

class $$UserGameInfosTableFilterComposer
    extends Composer<_$UserDatabase, $UserGameInfosTable> {
  $$UserGameInfosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserGameInfosTableOrderingComposer
    extends Composer<_$UserDatabase, $UserGameInfosTable> {
  $$UserGameInfosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get gameId => $composableBuilder(
    column: $table.gameId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserGameInfosTableAnnotationComposer
    extends Composer<_$UserDatabase, $UserGameInfosTable> {
  $$UserGameInfosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get gameId =>
      $composableBuilder(column: $table.gameId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$UserGameInfosTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $UserGameInfosTable,
          UserGameInfoRow,
          $$UserGameInfosTableFilterComposer,
          $$UserGameInfosTableOrderingComposer,
          $$UserGameInfosTableAnnotationComposer,
          $$UserGameInfosTableCreateCompanionBuilder,
          $$UserGameInfosTableUpdateCompanionBuilder,
          (
            UserGameInfoRow,
            BaseReferences<
              _$UserDatabase,
              $UserGameInfosTable,
              UserGameInfoRow
            >,
          ),
          UserGameInfoRow,
          PrefetchHooks Function()
        > {
  $$UserGameInfosTableTableManager(_$UserDatabase db, $UserGameInfosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserGameInfosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserGameInfosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserGameInfosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> gameId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserGameInfosCompanion(
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String gameId,
                Value<String?> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserGameInfosCompanion.insert(
                gameId: gameId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserGameInfosTable, UserGameInfoRow>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $UserGameInfosTable,
                    UserGameInfoRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserGameInfosTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $UserGameInfosTable,
      UserGameInfoRow,
      $$UserGameInfosTableFilterComposer,
      $$UserGameInfosTableOrderingComposer,
      $$UserGameInfosTableAnnotationComposer,
      $$UserGameInfosTableCreateCompanionBuilder,
      $$UserGameInfosTableUpdateCompanionBuilder,
      (
        UserGameInfoRow,
        BaseReferences<_$UserDatabase, $UserGameInfosTable, UserGameInfoRow>,
      ),
      UserGameInfoRow,
      PrefetchHooks Function()
    >;
typedef $$FeatureFlagsTableCreateCompanionBuilder =
    FeatureFlagsCompanion Function({
      required String id,
      Value<bool> value,
      Value<int> rowid,
    });
typedef $$FeatureFlagsTableUpdateCompanionBuilder =
    FeatureFlagsCompanion Function({
      Value<String> id,
      Value<bool> value,
      Value<int> rowid,
    });

class $$FeatureFlagsTableFilterComposer
    extends Composer<_$UserDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureFlagsTableOrderingComposer
    extends Composer<_$UserDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureFlagsTableAnnotationComposer
    extends Composer<_$UserDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$FeatureFlagsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $FeatureFlagsTable,
          FeatureFlagSetting,
          $$FeatureFlagsTableFilterComposer,
          $$FeatureFlagsTableOrderingComposer,
          $$FeatureFlagsTableAnnotationComposer,
          $$FeatureFlagsTableCreateCompanionBuilder,
          $$FeatureFlagsTableUpdateCompanionBuilder,
          (
            FeatureFlagSetting,
            BaseReferences<
              _$UserDatabase,
              $FeatureFlagsTable,
              FeatureFlagSetting
            >,
          ),
          FeatureFlagSetting,
          PrefetchHooks Function()
        > {
  $$FeatureFlagsTableTableManager(_$UserDatabase db, $FeatureFlagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatureFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<bool> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureFlagsCompanion(id: id, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                Value<bool> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureFlagsCompanion.insert(
                id: id,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FeatureFlagsTable, FeatureFlagSetting>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $FeatureFlagsTable,
                    FeatureFlagSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeatureFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $FeatureFlagsTable,
      FeatureFlagSetting,
      $$FeatureFlagsTableFilterComposer,
      $$FeatureFlagsTableOrderingComposer,
      $$FeatureFlagsTableAnnotationComposer,
      $$FeatureFlagsTableCreateCompanionBuilder,
      $$FeatureFlagsTableUpdateCompanionBuilder,
      (
        FeatureFlagSetting,
        BaseReferences<_$UserDatabase, $FeatureFlagsTable, FeatureFlagSetting>,
      ),
      FeatureFlagSetting,
      PrefetchHooks Function()
    >;
typedef $$AppKeyBindingsTableCreateCompanionBuilder =
    AppKeyBindingsCompanion Function({
      required String profileId,
      required String actionId,
      required String combo,
      Value<int> rowid,
    });
typedef $$AppKeyBindingsTableUpdateCompanionBuilder =
    AppKeyBindingsCompanion Function({
      Value<String> profileId,
      Value<String> actionId,
      Value<String> combo,
      Value<int> rowid,
    });

class $$AppKeyBindingsTableFilterComposer
    extends Composer<_$UserDatabase, $AppKeyBindingsTable> {
  $$AppKeyBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionId => $composableBuilder(
    column: $table.actionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get combo => $composableBuilder(
    column: $table.combo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppKeyBindingsTableOrderingComposer
    extends Composer<_$UserDatabase, $AppKeyBindingsTable> {
  $$AppKeyBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionId => $composableBuilder(
    column: $table.actionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get combo => $composableBuilder(
    column: $table.combo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppKeyBindingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $AppKeyBindingsTable> {
  $$AppKeyBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get actionId =>
      $composableBuilder(column: $table.actionId, builder: (column) => column);

  GeneratedColumn<String> get combo =>
      $composableBuilder(column: $table.combo, builder: (column) => column);
}

class $$AppKeyBindingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $AppKeyBindingsTable,
          AppKeyBinding,
          $$AppKeyBindingsTableFilterComposer,
          $$AppKeyBindingsTableOrderingComposer,
          $$AppKeyBindingsTableAnnotationComposer,
          $$AppKeyBindingsTableCreateCompanionBuilder,
          $$AppKeyBindingsTableUpdateCompanionBuilder,
          (
            AppKeyBinding,
            BaseReferences<_$UserDatabase, $AppKeyBindingsTable, AppKeyBinding>,
          ),
          AppKeyBinding,
          PrefetchHooks Function()
        > {
  $$AppKeyBindingsTableTableManager(
    _$UserDatabase db,
    $AppKeyBindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppKeyBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppKeyBindingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppKeyBindingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> actionId = const Value.absent(),
                Value<String> combo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppKeyBindingsCompanion(
                profileId: profileId,
                actionId: actionId,
                combo: combo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String actionId,
                required String combo,
                Value<int> rowid = const Value.absent(),
              }) => AppKeyBindingsCompanion.insert(
                profileId: profileId,
                actionId: actionId,
                combo: combo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppKeyBindingsTable, AppKeyBinding>(table),
                  BaseReferences<
                    _$UserDatabase,
                    $AppKeyBindingsTable,
                    AppKeyBinding
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppKeyBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $AppKeyBindingsTable,
      AppKeyBinding,
      $$AppKeyBindingsTableFilterComposer,
      $$AppKeyBindingsTableOrderingComposer,
      $$AppKeyBindingsTableAnnotationComposer,
      $$AppKeyBindingsTableCreateCompanionBuilder,
      $$AppKeyBindingsTableUpdateCompanionBuilder,
      (
        AppKeyBinding,
        BaseReferences<_$UserDatabase, $AppKeyBindingsTable, AppKeyBinding>,
      ),
      AppKeyBinding,
      PrefetchHooks Function()
    >;
typedef $$EmulationKeyBindingsTableCreateCompanionBuilder =
    EmulationKeyBindingsCompanion Function({
      required String profileId,
      required String actionId,
      required String combo,
      Value<int> rowid,
    });
typedef $$EmulationKeyBindingsTableUpdateCompanionBuilder =
    EmulationKeyBindingsCompanion Function({
      Value<String> profileId,
      Value<String> actionId,
      Value<String> combo,
      Value<int> rowid,
    });

class $$EmulationKeyBindingsTableFilterComposer
    extends Composer<_$UserDatabase, $EmulationKeyBindingsTable> {
  $$EmulationKeyBindingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actionId => $composableBuilder(
    column: $table.actionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get combo => $composableBuilder(
    column: $table.combo,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmulationKeyBindingsTableOrderingComposer
    extends Composer<_$UserDatabase, $EmulationKeyBindingsTable> {
  $$EmulationKeyBindingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId => $composableBuilder(
    column: $table.profileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actionId => $composableBuilder(
    column: $table.actionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get combo => $composableBuilder(
    column: $table.combo,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmulationKeyBindingsTableAnnotationComposer
    extends Composer<_$UserDatabase, $EmulationKeyBindingsTable> {
  $$EmulationKeyBindingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get actionId =>
      $composableBuilder(column: $table.actionId, builder: (column) => column);

  GeneratedColumn<String> get combo =>
      $composableBuilder(column: $table.combo, builder: (column) => column);
}

class $$EmulationKeyBindingsTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $EmulationKeyBindingsTable,
          EmulationKeyBinding,
          $$EmulationKeyBindingsTableFilterComposer,
          $$EmulationKeyBindingsTableOrderingComposer,
          $$EmulationKeyBindingsTableAnnotationComposer,
          $$EmulationKeyBindingsTableCreateCompanionBuilder,
          $$EmulationKeyBindingsTableUpdateCompanionBuilder,
          (
            EmulationKeyBinding,
            BaseReferences<
              _$UserDatabase,
              $EmulationKeyBindingsTable,
              EmulationKeyBinding
            >,
          ),
          EmulationKeyBinding,
          PrefetchHooks Function()
        > {
  $$EmulationKeyBindingsTableTableManager(
    _$UserDatabase db,
    $EmulationKeyBindingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmulationKeyBindingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmulationKeyBindingsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EmulationKeyBindingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> actionId = const Value.absent(),
                Value<String> combo = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmulationKeyBindingsCompanion(
                profileId: profileId,
                actionId: actionId,
                combo: combo,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String actionId,
                required String combo,
                Value<int> rowid = const Value.absent(),
              }) => EmulationKeyBindingsCompanion.insert(
                profileId: profileId,
                actionId: actionId,
                combo: combo,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$EmulationKeyBindingsTable, EmulationKeyBinding>(
                    table,
                  ),
                  BaseReferences<
                    _$UserDatabase,
                    $EmulationKeyBindingsTable,
                    EmulationKeyBinding
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EmulationKeyBindingsTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $EmulationKeyBindingsTable,
      EmulationKeyBinding,
      $$EmulationKeyBindingsTableFilterComposer,
      $$EmulationKeyBindingsTableOrderingComposer,
      $$EmulationKeyBindingsTableAnnotationComposer,
      $$EmulationKeyBindingsTableCreateCompanionBuilder,
      $$EmulationKeyBindingsTableUpdateCompanionBuilder,
      (
        EmulationKeyBinding,
        BaseReferences<
          _$UserDatabase,
          $EmulationKeyBindingsTable,
          EmulationKeyBinding
        >,
      ),
      EmulationKeyBinding,
      PrefetchHooks Function()
    >;
typedef $$ControllerProfilesTableCreateCompanionBuilder =
    ControllerProfilesCompanion Function({
      Value<String> cuid,
      required String name,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ControllerProfilesTableUpdateCompanionBuilder =
    ControllerProfilesCompanion Function({
      Value<String> cuid,
      Value<String> name,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ControllerProfilesTableFilterComposer
    extends Composer<_$UserDatabase, $ControllerProfilesTable> {
  $$ControllerProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cuid => $composableBuilder(
    column: $table.cuid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ControllerProfilesTableOrderingComposer
    extends Composer<_$UserDatabase, $ControllerProfilesTable> {
  $$ControllerProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cuid => $composableBuilder(
    column: $table.cuid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBuiltIn => $composableBuilder(
    column: $table.isBuiltIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ControllerProfilesTableAnnotationComposer
    extends Composer<_$UserDatabase, $ControllerProfilesTable> {
  $$ControllerProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cuid =>
      $composableBuilder(column: $table.cuid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ControllerProfilesTableTableManager
    extends
        RootTableManager<
          _$UserDatabase,
          $ControllerProfilesTable,
          ControllerProfileRow,
          $$ControllerProfilesTableFilterComposer,
          $$ControllerProfilesTableOrderingComposer,
          $$ControllerProfilesTableAnnotationComposer,
          $$ControllerProfilesTableCreateCompanionBuilder,
          $$ControllerProfilesTableUpdateCompanionBuilder,
          (
            ControllerProfileRow,
            BaseReferences<
              _$UserDatabase,
              $ControllerProfilesTable,
              ControllerProfileRow
            >,
          ),
          ControllerProfileRow,
          PrefetchHooks Function()
        > {
  $$ControllerProfilesTableTableManager(
    _$UserDatabase db,
    $ControllerProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ControllerProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ControllerProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ControllerProfilesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ControllerProfilesCompanion(
                cuid: cuid,
                name: name,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> cuid = const Value.absent(),
                required String name,
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ControllerProfilesCompanion.insert(
                cuid: cuid,
                name: name,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ControllerProfilesTable, ControllerProfileRow>(
                    table,
                  ),
                  BaseReferences<
                    _$UserDatabase,
                    $ControllerProfilesTable,
                    ControllerProfileRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ControllerProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$UserDatabase,
      $ControllerProfilesTable,
      ControllerProfileRow,
      $$ControllerProfilesTableFilterComposer,
      $$ControllerProfilesTableOrderingComposer,
      $$ControllerProfilesTableAnnotationComposer,
      $$ControllerProfilesTableCreateCompanionBuilder,
      $$ControllerProfilesTableUpdateCompanionBuilder,
      (
        ControllerProfileRow,
        BaseReferences<
          _$UserDatabase,
          $ControllerProfilesTable,
          ControllerProfileRow
        >,
      ),
      ControllerProfileRow,
      PrefetchHooks Function()
    >;

class $UserDatabaseManager {
  final _$UserDatabase _db;
  $UserDatabaseManager(this._db);
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
  $$AccessibilitySettingsTableTableManager get accessibilitySettings =>
      $$AccessibilitySettingsTableTableManager(_db, _db.accessibilitySettings);
  $$AdvancedSettingsTableTableManager get advancedSettings =>
      $$AdvancedSettingsTableTableManager(_db, _db.advancedSettings);
  $$MediaSettingsTableTableManager get mediaSettings =>
      $$MediaSettingsTableTableManager(_db, _db.mediaSettings);
  $$DebugSettingsTableTableManager get debugSettings =>
      $$DebugSettingsTableTableManager(_db, _db.debugSettings);
  $$VirtualAccessPointsTableTableManager get virtualAccessPoints =>
      $$VirtualAccessPointsTableTableManager(_db, _db.virtualAccessPoints);
  $$PinnedOptionsTableTableManager get pinnedOptions =>
      $$PinnedOptionsTableTableManager(_db, _db.pinnedOptions);
  $$OptionHistoryEntriesTableTableManager get optionHistoryEntries =>
      $$OptionHistoryEntriesTableTableManager(_db, _db.optionHistoryEntries);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$GameTagsTableTableManager get gameTags =>
      $$GameTagsTableTableManager(_db, _db.gameTags);
  $$UserGameInfosTableTableManager get userGameInfos =>
      $$UserGameInfosTableTableManager(_db, _db.userGameInfos);
  $$FeatureFlagsTableTableManager get featureFlags =>
      $$FeatureFlagsTableTableManager(_db, _db.featureFlags);
  $$AppKeyBindingsTableTableManager get appKeyBindings =>
      $$AppKeyBindingsTableTableManager(_db, _db.appKeyBindings);
  $$EmulationKeyBindingsTableTableManager get emulationKeyBindings =>
      $$EmulationKeyBindingsTableTableManager(_db, _db.emulationKeyBindings);
  $$ControllerProfilesTableTableManager get controllerProfiles =>
      $$ControllerProfilesTableTableManager(_db, _db.controllerProfiles);
}
