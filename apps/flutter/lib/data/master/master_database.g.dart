// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_database.dart';

// ignore_for_file: type=lint
class $MasterSettingsTable extends MasterSettings
    with TableInfo<$MasterSettingsTable, MasterSettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MasterSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'master_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<MasterSettingRow> instance, {
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
  MasterSettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MasterSettingRow(
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
  $MasterSettingsTable createAlias(String alias) {
    return $MasterSettingsTable(attachedDatabase, alias);
  }
}

class MasterSettingRow extends DataClass
    implements Insertable<MasterSettingRow> {
  final String key;
  final String value;
  const MasterSettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MasterSettingsCompanion toCompanion(bool nullToAbsent) {
    return MasterSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory MasterSettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MasterSettingRow(
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

  MasterSettingRow copyWith({String? key, String? value}) =>
      MasterSettingRow(key: key ?? this.key, value: value ?? this.value);
  MasterSettingRow copyWithCompanion(MasterSettingsCompanion data) {
    return MasterSettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MasterSettingRow(')
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
      (other is MasterSettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class MasterSettingsCompanion extends UpdateCompanion<MasterSettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MasterSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MasterSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MasterSettingRow> custom({
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

  MasterSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MasterSettingsCompanion(
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
    return (StringBuffer('MasterSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, LocationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [kind, path];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'locations';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {kind};
  @override
  LocationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationRow(
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
    );
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(attachedDatabase, alias);
  }
}

class LocationRow extends DataClass implements Insertable<LocationRow> {
  final String kind;
  final String path;
  const LocationRow({required this.kind, required this.path});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['kind'] = Variable<String>(kind);
    map['path'] = Variable<String>(path);
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(kind: Value(kind), path: Value(path));
  }

  factory LocationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationRow(
      kind: serializer.fromJson<String>(json['kind']),
      path: serializer.fromJson<String>(json['path']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'kind': serializer.toJson<String>(kind),
      'path': serializer.toJson<String>(path),
    };
  }

  LocationRow copyWith({String? kind, String? path}) =>
      LocationRow(kind: kind ?? this.kind, path: path ?? this.path);
  LocationRow copyWithCompanion(LocationsCompanion data) {
    return LocationRow(
      kind: data.kind.present ? data.kind.value : this.kind,
      path: data.path.present ? data.path.value : this.path,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationRow(')
          ..write('kind: $kind, ')
          ..write('path: $path')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(kind, path);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationRow &&
          other.kind == this.kind &&
          other.path == this.path);
}

class LocationsCompanion extends UpdateCompanion<LocationRow> {
  final Value<String> kind;
  final Value<String> path;
  final Value<int> rowid;
  const LocationsCompanion({
    this.kind = const Value.absent(),
    this.path = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocationsCompanion.insert({
    required String kind,
    required String path,
    this.rowid = const Value.absent(),
  }) : kind = Value(kind),
       path = Value(path);
  static Insertable<LocationRow> custom({
    Expression<String>? kind,
    Expression<String>? path,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (kind != null) 'kind': kind,
      if (path != null) 'path': path,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocationsCompanion copyWith({
    Value<String>? kind,
    Value<String>? path,
    Value<int>? rowid,
  }) {
    return LocationsCompanion(
      kind: kind ?? this.kind,
      path: path ?? this.path,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('kind: $kind, ')
          ..write('path: $path, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles
    with TableInfo<$ProfilesTable, ProfileRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cuidMeta = const VerificationMeta('cuid');
  @override
  late final GeneratedColumn<String> cuid = GeneratedColumn<String>(
    'cuid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: _newProfileCuid,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _userDirectoryMeta = const VerificationMeta(
    'userDirectory',
  );
  @override
  late final GeneratedColumn<String> userDirectory = GeneratedColumn<String>(
    'user_directory',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gamesDirectoryMeta = const VerificationMeta(
    'gamesDirectory',
  );
  @override
  late final GeneratedColumn<String> gamesDirectory = GeneratedColumn<String>(
    'games_directory',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _databaseFileMeta = const VerificationMeta(
    'databaseFile',
  );
  @override
  late final GeneratedColumn<String> databaseFile = GeneratedColumn<String>(
    'database_file',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
  List<GeneratedColumn> get $columns => [
    cuid,
    name,
    userDirectory,
    gamesDirectory,
    databaseFile,
    isBuiltIn,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProfileRow> instance, {
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
    if (data.containsKey('user_directory')) {
      context.handle(
        _userDirectoryMeta,
        userDirectory.isAcceptableOrUnknown(
          data['user_directory']!,
          _userDirectoryMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_userDirectoryMeta);
    }
    if (data.containsKey('games_directory')) {
      context.handle(
        _gamesDirectoryMeta,
        gamesDirectory.isAcceptableOrUnknown(
          data['games_directory']!,
          _gamesDirectoryMeta,
        ),
      );
    }
    if (data.containsKey('database_file')) {
      context.handle(
        _databaseFileMeta,
        databaseFile.isAcceptableOrUnknown(
          data['database_file']!,
          _databaseFileMeta,
        ),
      );
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
  ProfileRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProfileRow(
      cuid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      userDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_directory'],
      )!,
      gamesDirectory: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}games_directory'],
      ),
      databaseFile: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}database_file'],
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
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class ProfileRow extends DataClass implements Insertable<ProfileRow> {
  final String cuid;
  final String name;
  final String userDirectory;
  final String? gamesDirectory;
  final String databaseFile;
  final bool isBuiltIn;
  final DateTime createdAt;
  const ProfileRow({
    required this.cuid,
    required this.name,
    required this.userDirectory,
    this.gamesDirectory,
    required this.databaseFile,
    required this.isBuiltIn,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cuid'] = Variable<String>(cuid);
    map['name'] = Variable<String>(name);
    map['user_directory'] = Variable<String>(userDirectory);
    if (!nullToAbsent || gamesDirectory != null) {
      map['games_directory'] = Variable<String>(gamesDirectory);
    }
    map['database_file'] = Variable<String>(databaseFile);
    map['is_built_in'] = Variable<bool>(isBuiltIn);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      cuid: Value(cuid),
      name: Value(name),
      userDirectory: Value(userDirectory),
      gamesDirectory: gamesDirectory == null && nullToAbsent
          ? const Value.absent()
          : Value(gamesDirectory),
      databaseFile: Value(databaseFile),
      isBuiltIn: Value(isBuiltIn),
      createdAt: Value(createdAt),
    );
  }

  factory ProfileRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProfileRow(
      cuid: serializer.fromJson<String>(json['cuid']),
      name: serializer.fromJson<String>(json['name']),
      userDirectory: serializer.fromJson<String>(json['userDirectory']),
      gamesDirectory: serializer.fromJson<String?>(json['gamesDirectory']),
      databaseFile: serializer.fromJson<String>(json['databaseFile']),
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
      'userDirectory': serializer.toJson<String>(userDirectory),
      'gamesDirectory': serializer.toJson<String?>(gamesDirectory),
      'databaseFile': serializer.toJson<String>(databaseFile),
      'isBuiltIn': serializer.toJson<bool>(isBuiltIn),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ProfileRow copyWith({
    String? cuid,
    String? name,
    String? userDirectory,
    Value<String?> gamesDirectory = const Value.absent(),
    String? databaseFile,
    bool? isBuiltIn,
    DateTime? createdAt,
  }) => ProfileRow(
    cuid: cuid ?? this.cuid,
    name: name ?? this.name,
    userDirectory: userDirectory ?? this.userDirectory,
    gamesDirectory: gamesDirectory.present
        ? gamesDirectory.value
        : this.gamesDirectory,
    databaseFile: databaseFile ?? this.databaseFile,
    isBuiltIn: isBuiltIn ?? this.isBuiltIn,
    createdAt: createdAt ?? this.createdAt,
  );
  ProfileRow copyWithCompanion(ProfilesCompanion data) {
    return ProfileRow(
      cuid: data.cuid.present ? data.cuid.value : this.cuid,
      name: data.name.present ? data.name.value : this.name,
      userDirectory: data.userDirectory.present
          ? data.userDirectory.value
          : this.userDirectory,
      gamesDirectory: data.gamesDirectory.present
          ? data.gamesDirectory.value
          : this.gamesDirectory,
      databaseFile: data.databaseFile.present
          ? data.databaseFile.value
          : this.databaseFile,
      isBuiltIn: data.isBuiltIn.present ? data.isBuiltIn.value : this.isBuiltIn,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProfileRow(')
          ..write('cuid: $cuid, ')
          ..write('name: $name, ')
          ..write('userDirectory: $userDirectory, ')
          ..write('gamesDirectory: $gamesDirectory, ')
          ..write('databaseFile: $databaseFile, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cuid,
    name,
    userDirectory,
    gamesDirectory,
    databaseFile,
    isBuiltIn,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProfileRow &&
          other.cuid == this.cuid &&
          other.name == this.name &&
          other.userDirectory == this.userDirectory &&
          other.gamesDirectory == this.gamesDirectory &&
          other.databaseFile == this.databaseFile &&
          other.isBuiltIn == this.isBuiltIn &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<ProfileRow> {
  final Value<String> cuid;
  final Value<String> name;
  final Value<String> userDirectory;
  final Value<String?> gamesDirectory;
  final Value<String> databaseFile;
  final Value<bool> isBuiltIn;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.cuid = const Value.absent(),
    this.name = const Value.absent(),
    this.userDirectory = const Value.absent(),
    this.gamesDirectory = const Value.absent(),
    this.databaseFile = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.cuid = const Value.absent(),
    required String name,
    required String userDirectory,
    this.gamesDirectory = const Value.absent(),
    this.databaseFile = const Value.absent(),
    this.isBuiltIn = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : name = Value(name),
       userDirectory = Value(userDirectory);
  static Insertable<ProfileRow> custom({
    Expression<String>? cuid,
    Expression<String>? name,
    Expression<String>? userDirectory,
    Expression<String>? gamesDirectory,
    Expression<String>? databaseFile,
    Expression<bool>? isBuiltIn,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cuid != null) 'cuid': cuid,
      if (name != null) 'name': name,
      if (userDirectory != null) 'user_directory': userDirectory,
      if (gamesDirectory != null) 'games_directory': gamesDirectory,
      if (databaseFile != null) 'database_file': databaseFile,
      if (isBuiltIn != null) 'is_built_in': isBuiltIn,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? cuid,
    Value<String>? name,
    Value<String>? userDirectory,
    Value<String?>? gamesDirectory,
    Value<String>? databaseFile,
    Value<bool>? isBuiltIn,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      cuid: cuid ?? this.cuid,
      name: name ?? this.name,
      userDirectory: userDirectory ?? this.userDirectory,
      gamesDirectory: gamesDirectory ?? this.gamesDirectory,
      databaseFile: databaseFile ?? this.databaseFile,
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
    if (userDirectory.present) {
      map['user_directory'] = Variable<String>(userDirectory.value);
    }
    if (gamesDirectory.present) {
      map['games_directory'] = Variable<String>(gamesDirectory.value);
    }
    if (databaseFile.present) {
      map['database_file'] = Variable<String>(databaseFile.value);
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
    return (StringBuffer('ProfilesCompanion(')
          ..write('cuid: $cuid, ')
          ..write('name: $name, ')
          ..write('userDirectory: $userDirectory, ')
          ..write('gamesDirectory: $gamesDirectory, ')
          ..write('databaseFile: $databaseFile, ')
          ..write('isBuiltIn: $isBuiltIn, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$MasterDatabase extends GeneratedDatabase {
  _$MasterDatabase(QueryExecutor e) : super(e);
  $MasterDatabaseManager get managers => $MasterDatabaseManager(this);
  late final $MasterSettingsTable masterSettings = $MasterSettingsTable(this);
  late final $LocationsTable locations = $LocationsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    masterSettings,
    locations,
    profiles,
  ];
}

typedef $$MasterSettingsTableCreateCompanionBuilder =
    MasterSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$MasterSettingsTableUpdateCompanionBuilder =
    MasterSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$MasterSettingsTableFilterComposer
    extends Composer<_$MasterDatabase, $MasterSettingsTable> {
  $$MasterSettingsTableFilterComposer({
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

class $$MasterSettingsTableOrderingComposer
    extends Composer<_$MasterDatabase, $MasterSettingsTable> {
  $$MasterSettingsTableOrderingComposer({
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

class $$MasterSettingsTableAnnotationComposer
    extends Composer<_$MasterDatabase, $MasterSettingsTable> {
  $$MasterSettingsTableAnnotationComposer({
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

class $$MasterSettingsTableTableManager
    extends
        RootTableManager<
          _$MasterDatabase,
          $MasterSettingsTable,
          MasterSettingRow,
          $$MasterSettingsTableFilterComposer,
          $$MasterSettingsTableOrderingComposer,
          $$MasterSettingsTableAnnotationComposer,
          $$MasterSettingsTableCreateCompanionBuilder,
          $$MasterSettingsTableUpdateCompanionBuilder,
          (
            MasterSettingRow,
            BaseReferences<
              _$MasterDatabase,
              $MasterSettingsTable,
              MasterSettingRow
            >,
          ),
          MasterSettingRow,
          PrefetchHooks Function()
        > {
  $$MasterSettingsTableTableManager(
    _$MasterDatabase db,
    $MasterSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MasterSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MasterSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MasterSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  MasterSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => MasterSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MasterSettingsTable, MasterSettingRow>(table),
                  BaseReferences<
                    _$MasterDatabase,
                    $MasterSettingsTable,
                    MasterSettingRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MasterSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$MasterDatabase,
      $MasterSettingsTable,
      MasterSettingRow,
      $$MasterSettingsTableFilterComposer,
      $$MasterSettingsTableOrderingComposer,
      $$MasterSettingsTableAnnotationComposer,
      $$MasterSettingsTableCreateCompanionBuilder,
      $$MasterSettingsTableUpdateCompanionBuilder,
      (
        MasterSettingRow,
        BaseReferences<
          _$MasterDatabase,
          $MasterSettingsTable,
          MasterSettingRow
        >,
      ),
      MasterSettingRow,
      PrefetchHooks Function()
    >;
typedef $$LocationsTableCreateCompanionBuilder =
    LocationsCompanion Function({
      required String kind,
      required String path,
      Value<int> rowid,
    });
typedef $$LocationsTableUpdateCompanionBuilder =
    LocationsCompanion Function({
      Value<String> kind,
      Value<String> path,
      Value<int> rowid,
    });

class $$LocationsTableFilterComposer
    extends Composer<_$MasterDatabase, $LocationsTable> {
  $$LocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocationsTableOrderingComposer
    extends Composer<_$MasterDatabase, $LocationsTable> {
  $$LocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationsTableAnnotationComposer
    extends Composer<_$MasterDatabase, $LocationsTable> {
  $$LocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);
}

class $$LocationsTableTableManager
    extends
        RootTableManager<
          _$MasterDatabase,
          $LocationsTable,
          LocationRow,
          $$LocationsTableFilterComposer,
          $$LocationsTableOrderingComposer,
          $$LocationsTableAnnotationComposer,
          $$LocationsTableCreateCompanionBuilder,
          $$LocationsTableUpdateCompanionBuilder,
          (
            LocationRow,
            BaseReferences<_$MasterDatabase, $LocationsTable, LocationRow>,
          ),
          LocationRow,
          PrefetchHooks Function()
        > {
  $$LocationsTableTableManager(_$MasterDatabase db, $LocationsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> kind = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion(kind: kind, path: path, rowid: rowid),
          createCompanionCallback:
              ({
                required String kind,
                required String path,
                Value<int> rowid = const Value.absent(),
              }) => LocationsCompanion.insert(
                kind: kind,
                path: path,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocationsTable, LocationRow>(table),
                  BaseReferences<
                    _$MasterDatabase,
                    $LocationsTable,
                    LocationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$MasterDatabase,
      $LocationsTable,
      LocationRow,
      $$LocationsTableFilterComposer,
      $$LocationsTableOrderingComposer,
      $$LocationsTableAnnotationComposer,
      $$LocationsTableCreateCompanionBuilder,
      $$LocationsTableUpdateCompanionBuilder,
      (
        LocationRow,
        BaseReferences<_$MasterDatabase, $LocationsTable, LocationRow>,
      ),
      LocationRow,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> cuid,
      required String name,
      required String userDirectory,
      Value<String?> gamesDirectory,
      Value<String> databaseFile,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<String> cuid,
      Value<String> name,
      Value<String> userDirectory,
      Value<String?> gamesDirectory,
      Value<String> databaseFile,
      Value<bool> isBuiltIn,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ProfilesTableFilterComposer
    extends Composer<_$MasterDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
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

  ColumnFilters<String> get userDirectory => $composableBuilder(
    column: $table.userDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gamesDirectory => $composableBuilder(
    column: $table.gamesDirectory,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get databaseFile => $composableBuilder(
    column: $table.databaseFile,
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

class $$ProfilesTableOrderingComposer
    extends Composer<_$MasterDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
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

  ColumnOrderings<String> get userDirectory => $composableBuilder(
    column: $table.userDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gamesDirectory => $composableBuilder(
    column: $table.gamesDirectory,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get databaseFile => $composableBuilder(
    column: $table.databaseFile,
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

class $$ProfilesTableAnnotationComposer
    extends Composer<_$MasterDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
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

  GeneratedColumn<String> get userDirectory => $composableBuilder(
    column: $table.userDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gamesDirectory => $composableBuilder(
    column: $table.gamesDirectory,
    builder: (column) => column,
  );

  GeneratedColumn<String> get databaseFile => $composableBuilder(
    column: $table.databaseFile,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBuiltIn =>
      $composableBuilder(column: $table.isBuiltIn, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$MasterDatabase,
          $ProfilesTable,
          ProfileRow,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (
            ProfileRow,
            BaseReferences<_$MasterDatabase, $ProfilesTable, ProfileRow>,
          ),
          ProfileRow,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$MasterDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cuid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> userDirectory = const Value.absent(),
                Value<String?> gamesDirectory = const Value.absent(),
                Value<String> databaseFile = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                cuid: cuid,
                name: name,
                userDirectory: userDirectory,
                gamesDirectory: gamesDirectory,
                databaseFile: databaseFile,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> cuid = const Value.absent(),
                required String name,
                required String userDirectory,
                Value<String?> gamesDirectory = const Value.absent(),
                Value<String> databaseFile = const Value.absent(),
                Value<bool> isBuiltIn = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                cuid: cuid,
                name: name,
                userDirectory: userDirectory,
                gamesDirectory: gamesDirectory,
                databaseFile: databaseFile,
                isBuiltIn: isBuiltIn,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, ProfileRow>(table),
                  BaseReferences<_$MasterDatabase, $ProfilesTable, ProfileRow>(
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

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$MasterDatabase,
      $ProfilesTable,
      ProfileRow,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (
        ProfileRow,
        BaseReferences<_$MasterDatabase, $ProfilesTable, ProfileRow>,
      ),
      ProfileRow,
      PrefetchHooks Function()
    >;

class $MasterDatabaseManager {
  final _$MasterDatabase _db;
  $MasterDatabaseManager(this._db);
  $$MasterSettingsTableTableManager get masterSettings =>
      $$MasterSettingsTableTableManager(_db, _db.masterSettings);
  $$LocationsTableTableManager get locations =>
      $$LocationsTableTableManager(_db, _db.locations);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
}
