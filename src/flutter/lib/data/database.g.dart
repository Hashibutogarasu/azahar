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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GamesTable games = $GamesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [games, appSettings];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GamesTableTableManager get games =>
      $$GamesTableTableManager(_db, _db.games);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
