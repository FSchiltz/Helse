// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $GroupTable extends Group with TableInfo<$GroupTable, GroupData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GroupTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _showOnDashboardMeta = const VerificationMeta(
    'showOnDashboard',
  );
  @override
  late final GeneratedColumn<bool> showOnDashboard = GeneratedColumn<bool>(
    'show_on_dashboard',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_on_dashboard" IN (0, 1))',
    ),
  );
  static const VerificationMeta _showTitleMeta = const VerificationMeta(
    'showTitle',
  );
  @override
  late final GeneratedColumn<bool> showTitle = GeneratedColumn<bool>(
    'show_title',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_title" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    showOnDashboard,
    showTitle,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'group';
  @override
  VerificationContext validateIntegrity(
    Insertable<GroupData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
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
    if (data.containsKey('show_on_dashboard')) {
      context.handle(
        _showOnDashboardMeta,
        showOnDashboard.isAcceptableOrUnknown(
          data['show_on_dashboard']!,
          _showOnDashboardMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_showOnDashboardMeta);
    }
    if (data.containsKey('show_title')) {
      context.handle(
        _showTitleMeta,
        showTitle.isAcceptableOrUnknown(data['show_title']!, _showTitleMeta),
      );
    } else if (isInserting) {
      context.missing(_showTitleMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GroupData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GroupData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      showOnDashboard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_on_dashboard'],
      )!,
      showTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_title'],
      )!,
    );
  }

  @override
  $GroupTable createAlias(String alias) {
    return $GroupTable(attachedDatabase, alias);
  }
}

class GroupData extends DataClass implements Insertable<GroupData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String name;
  final String description;
  final bool showOnDashboard;
  final bool showTitle;
  const GroupData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.name,
    required this.description,
    required this.showOnDashboard,
    required this.showTitle,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['show_on_dashboard'] = Variable<bool>(showOnDashboard);
    map['show_title'] = Variable<bool>(showTitle);
    return map;
  }

  GroupCompanion toCompanion(bool nullToAbsent) {
    return GroupCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      name: Value(name),
      description: Value(description),
      showOnDashboard: Value(showOnDashboard),
      showTitle: Value(showTitle),
    );
  }

  factory GroupData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GroupData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      showOnDashboard: serializer.fromJson<bool>(json['showOnDashboard']),
      showTitle: serializer.fromJson<bool>(json['showTitle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'showOnDashboard': serializer.toJson<bool>(showOnDashboard),
      'showTitle': serializer.toJson<bool>(showTitle),
    };
  }

  GroupData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? name,
    String? description,
    bool? showOnDashboard,
    bool? showTitle,
  }) => GroupData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    name: name ?? this.name,
    description: description ?? this.description,
    showOnDashboard: showOnDashboard ?? this.showOnDashboard,
    showTitle: showTitle ?? this.showTitle,
  );
  GroupData copyWithCompanion(GroupCompanion data) {
    return GroupData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      showOnDashboard: data.showOnDashboard.present
          ? data.showOnDashboard.value
          : this.showOnDashboard,
      showTitle: data.showTitle.present ? data.showTitle.value : this.showTitle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GroupData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('showOnDashboard: $showOnDashboard, ')
          ..write('showTitle: $showTitle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    showOnDashboard,
    showTitle,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GroupData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.name == this.name &&
          other.description == this.description &&
          other.showOnDashboard == this.showOnDashboard &&
          other.showTitle == this.showTitle);
}

class GroupCompanion extends UpdateCompanion<GroupData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> name;
  final Value<String> description;
  final Value<bool> showOnDashboard;
  final Value<bool> showTitle;
  const GroupCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.showOnDashboard = const Value.absent(),
    this.showTitle = const Value.absent(),
  });
  GroupCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String name,
    required String description,
    required bool showOnDashboard,
    required bool showTitle,
  }) : created = Value(created),
       name = Value(name),
       description = Value(description),
       showOnDashboard = Value(showOnDashboard),
       showTitle = Value(showTitle);
  static Insertable<GroupData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? showOnDashboard,
    Expression<bool>? showTitle,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (showOnDashboard != null) 'show_on_dashboard': showOnDashboard,
      if (showTitle != null) 'show_title': showTitle,
    });
  }

  GroupCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? name,
    Value<String>? description,
    Value<bool>? showOnDashboard,
    Value<bool>? showTitle,
  }) {
    return GroupCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      name: name ?? this.name,
      description: description ?? this.description,
      showOnDashboard: showOnDashboard ?? this.showOnDashboard,
      showTitle: showTitle ?? this.showTitle,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (showOnDashboard.present) {
      map['show_on_dashboard'] = Variable<bool>(showOnDashboard.value);
    }
    if (showTitle.present) {
      map['show_title'] = Variable<bool>(showTitle.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GroupCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('showOnDashboard: $showOnDashboard, ')
          ..write('showTitle: $showTitle')
          ..write(')'))
        .toString();
  }
}

class $MetricTypeTable extends MetricType
    with TableInfo<$MetricTypeTable, MetricTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "group" (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    groupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metric_type';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetricTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetricTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricTypeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
    );
  }

  @override
  $MetricTypeTable createAlias(String alias) {
    return $MetricTypeTable(attachedDatabase, alias);
  }
}

class MetricTypeData extends DataClass implements Insertable<MetricTypeData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String name;
  final String? description;
  final int groupId;
  const MetricTypeData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.name,
    this.description,
    required this.groupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  MetricTypeCompanion toCompanion(bool nullToAbsent) {
    return MetricTypeCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      groupId: Value(groupId),
    );
  }

  factory MetricTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricTypeData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  MetricTypeData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? name,
    Value<String?> description = const Value.absent(),
    int? groupId,
  }) => MetricTypeData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    groupId: groupId ?? this.groupId,
  );
  MetricTypeData copyWithCompanion(MetricTypeCompanion data) {
    return MetricTypeData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricTypeData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    groupId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricTypeData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.name == this.name &&
          other.description == this.description &&
          other.groupId == this.groupId);
}

class MetricTypeCompanion extends UpdateCompanion<MetricTypeData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> groupId;
  const MetricTypeCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  MetricTypeCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String name,
    this.description = const Value.absent(),
    required int groupId,
  }) : created = Value(created),
       name = Value(name),
       groupId = Value(groupId);
  static Insertable<MetricTypeData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (groupId != null) 'group_id': groupId,
    });
  }

  MetricTypeCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? groupId,
  }) {
    return MetricTypeCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      name: name ?? this.name,
      description: description ?? this.description,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricTypeCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

class $MetricTable extends Metric with TableInfo<$MetricTable, MetricData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetricTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<int> person = GeneratedColumn<int>(
    'person',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES metric_type (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    value,
    date,
    person,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'metric';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetricData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MetricData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetricData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $MetricTable createAlias(String alias) {
    return $MetricTable(attachedDatabase, alias);
  }
}

class MetricData extends DataClass implements Insertable<MetricData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String value;
  final DateTime date;
  final int? person;
  final int type;
  const MetricData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.value,
    required this.date,
    this.person,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['value'] = Variable<String>(value);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<int>(person);
    }
    map['type'] = Variable<int>(type);
    return map;
  }

  MetricCompanion toCompanion(bool nullToAbsent) {
    return MetricCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      value: Value(value),
      date: Value(date),
      person: person == null && nullToAbsent
          ? const Value.absent()
          : Value(person),
      type: Value(type),
    );
  }

  factory MetricData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetricData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      value: serializer.fromJson<String>(json['value']),
      date: serializer.fromJson<DateTime>(json['date']),
      person: serializer.fromJson<int?>(json['person']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'value': serializer.toJson<String>(value),
      'date': serializer.toJson<DateTime>(date),
      'person': serializer.toJson<int?>(person),
      'type': serializer.toJson<int>(type),
    };
  }

  MetricData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? value,
    DateTime? date,
    Value<int?> person = const Value.absent(),
    int? type,
  }) => MetricData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    value: value ?? this.value,
    date: date ?? this.date,
    person: person.present ? person.value : this.person,
    type: type ?? this.type,
  );
  MetricData copyWithCompanion(MetricCompanion data) {
    return MetricData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      value: data.value.present ? data.value.value : this.value,
      date: data.date.present ? data.date.value : this.date,
      person: data.person.present ? data.person.value : this.person,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetricData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('person: $person, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    value,
    date,
    person,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetricData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.value == this.value &&
          other.date == this.date &&
          other.person == this.person &&
          other.type == this.type);
}

class MetricCompanion extends UpdateCompanion<MetricData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> value;
  final Value<DateTime> date;
  final Value<int?> person;
  final Value<int> type;
  const MetricCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.person = const Value.absent(),
    this.type = const Value.absent(),
  });
  MetricCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String value,
    required DateTime date,
    this.person = const Value.absent(),
    required int type,
  }) : created = Value(created),
       value = Value(value),
       date = Value(date),
       type = Value(type);
  static Insertable<MetricData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? value,
    Expression<DateTime>? date,
    Expression<int>? person,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (person != null) 'person': person,
      if (type != null) 'type': type,
    });
  }

  MetricCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? value,
    Value<DateTime>? date,
    Value<int?>? person,
    Value<int>? type,
  }) {
    return MetricCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      value: value ?? this.value,
      date: date ?? this.date,
      person: person ?? this.person,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (person.present) {
      map['person'] = Variable<int>(person.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetricCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('person: $person, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $EventTypeTable extends EventType
    with TableInfo<$EventTypeTable, EventTypeData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventTypeTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
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
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _standAloneMeta = const VerificationMeta(
    'standAlone',
  );
  @override
  late final GeneratedColumn<bool> standAlone = GeneratedColumn<bool>(
    'stand_alone',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("stand_alone" IN (0, 1))',
    ),
  );
  static const VerificationMeta _visibleMeta = const VerificationMeta(
    'visible',
  );
  @override
  late final GeneratedColumn<bool> visible = GeneratedColumn<bool>(
    'visible',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("visible" IN (0, 1))',
    ),
  );
  static const VerificationMeta _timeDifferenceMeta = const VerificationMeta(
    'timeDifference',
  );
  @override
  late final GeneratedColumn<String> timeDifference = GeneratedColumn<String>(
    'time_difference',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<int> groupId = GeneratedColumn<int>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES "group" (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    standAlone,
    visible,
    timeDifference,
    groupId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event_type';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventTypeData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('stand_alone')) {
      context.handle(
        _standAloneMeta,
        standAlone.isAcceptableOrUnknown(data['stand_alone']!, _standAloneMeta),
      );
    } else if (isInserting) {
      context.missing(_standAloneMeta);
    }
    if (data.containsKey('visible')) {
      context.handle(
        _visibleMeta,
        visible.isAcceptableOrUnknown(data['visible']!, _visibleMeta),
      );
    } else if (isInserting) {
      context.missing(_visibleMeta);
    }
    if (data.containsKey('time_difference')) {
      context.handle(
        _timeDifferenceMeta,
        timeDifference.isAcceptableOrUnknown(
          data['time_difference']!,
          _timeDifferenceMeta,
        ),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventTypeData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventTypeData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      standAlone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}stand_alone'],
      )!,
      visible: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}visible'],
      )!,
      timeDifference: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_difference'],
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}group_id'],
      )!,
    );
  }

  @override
  $EventTypeTable createAlias(String alias) {
    return $EventTypeTable(attachedDatabase, alias);
  }
}

class EventTypeData extends DataClass implements Insertable<EventTypeData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String name;
  final String? description;
  final bool standAlone;
  final bool visible;
  final String? timeDifference;
  final int groupId;
  const EventTypeData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.name,
    this.description,
    required this.standAlone,
    required this.visible,
    this.timeDifference,
    required this.groupId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['stand_alone'] = Variable<bool>(standAlone);
    map['visible'] = Variable<bool>(visible);
    if (!nullToAbsent || timeDifference != null) {
      map['time_difference'] = Variable<String>(timeDifference);
    }
    map['group_id'] = Variable<int>(groupId);
    return map;
  }

  EventTypeCompanion toCompanion(bool nullToAbsent) {
    return EventTypeCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      standAlone: Value(standAlone),
      visible: Value(visible),
      timeDifference: timeDifference == null && nullToAbsent
          ? const Value.absent()
          : Value(timeDifference),
      groupId: Value(groupId),
    );
  }

  factory EventTypeData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventTypeData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      standAlone: serializer.fromJson<bool>(json['standAlone']),
      visible: serializer.fromJson<bool>(json['visible']),
      timeDifference: serializer.fromJson<String?>(json['timeDifference']),
      groupId: serializer.fromJson<int>(json['groupId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'standAlone': serializer.toJson<bool>(standAlone),
      'visible': serializer.toJson<bool>(visible),
      'timeDifference': serializer.toJson<String?>(timeDifference),
      'groupId': serializer.toJson<int>(groupId),
    };
  }

  EventTypeData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? standAlone,
    bool? visible,
    Value<String?> timeDifference = const Value.absent(),
    int? groupId,
  }) => EventTypeData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    standAlone: standAlone ?? this.standAlone,
    visible: visible ?? this.visible,
    timeDifference: timeDifference.present
        ? timeDifference.value
        : this.timeDifference,
    groupId: groupId ?? this.groupId,
  );
  EventTypeData copyWithCompanion(EventTypeCompanion data) {
    return EventTypeData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      standAlone: data.standAlone.present
          ? data.standAlone.value
          : this.standAlone,
      visible: data.visible.present ? data.visible.value : this.visible,
      timeDifference: data.timeDifference.present
          ? data.timeDifference.value
          : this.timeDifference,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventTypeData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('standAlone: $standAlone, ')
          ..write('visible: $visible, ')
          ..write('timeDifference: $timeDifference, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    name,
    description,
    standAlone,
    visible,
    timeDifference,
    groupId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventTypeData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.name == this.name &&
          other.description == this.description &&
          other.standAlone == this.standAlone &&
          other.visible == this.visible &&
          other.timeDifference == this.timeDifference &&
          other.groupId == this.groupId);
}

class EventTypeCompanion extends UpdateCompanion<EventTypeData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> standAlone;
  final Value<bool> visible;
  final Value<String?> timeDifference;
  final Value<int> groupId;
  const EventTypeCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.standAlone = const Value.absent(),
    this.visible = const Value.absent(),
    this.timeDifference = const Value.absent(),
    this.groupId = const Value.absent(),
  });
  EventTypeCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String name,
    this.description = const Value.absent(),
    required bool standAlone,
    required bool visible,
    this.timeDifference = const Value.absent(),
    required int groupId,
  }) : created = Value(created),
       name = Value(name),
       standAlone = Value(standAlone),
       visible = Value(visible),
       groupId = Value(groupId);
  static Insertable<EventTypeData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? standAlone,
    Expression<bool>? visible,
    Expression<String>? timeDifference,
    Expression<int>? groupId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (standAlone != null) 'stand_alone': standAlone,
      if (visible != null) 'visible': visible,
      if (timeDifference != null) 'time_difference': timeDifference,
      if (groupId != null) 'group_id': groupId,
    });
  }

  EventTypeCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? standAlone,
    Value<bool>? visible,
    Value<String?>? timeDifference,
    Value<int>? groupId,
  }) {
    return EventTypeCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      name: name ?? this.name,
      description: description ?? this.description,
      standAlone: standAlone ?? this.standAlone,
      visible: visible ?? this.visible,
      timeDifference: timeDifference ?? this.timeDifference,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (standAlone.present) {
      map['stand_alone'] = Variable<bool>(standAlone.value);
    }
    if (visible.present) {
      map['visible'] = Variable<bool>(visible.value);
    }
    if (timeDifference.present) {
      map['time_difference'] = Variable<String>(timeDifference.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<int>(groupId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventTypeCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('standAlone: $standAlone, ')
          ..write('visible: $visible, ')
          ..write('timeDifference: $timeDifference, ')
          ..write('groupId: $groupId')
          ..write(')'))
        .toString();
  }
}

class $EventTable extends Event with TableInfo<$EventTable, EventData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _startMeta = const VerificationMeta('start');
  @override
  late final GeneratedColumn<DateTime> start = GeneratedColumn<DateTime>(
    'start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMeta = const VerificationMeta('end');
  @override
  late final GeneratedColumn<DateTime> end = GeneratedColumn<DateTime>(
    'end',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<int> person = GeneratedColumn<int>(
    'person',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES event_type (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    description,
    start,
    end,
    person,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'event';
  @override
  VerificationContext validateIntegrity(
    Insertable<EventData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
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
    if (data.containsKey('start')) {
      context.handle(
        _startMeta,
        start.isAcceptableOrUnknown(data['start']!, _startMeta),
      );
    } else if (isInserting) {
      context.missing(_startMeta);
    }
    if (data.containsKey('end')) {
      context.handle(
        _endMeta,
        end.isAcceptableOrUnknown(data['end']!, _endMeta),
      );
    } else if (isInserting) {
      context.missing(_endMeta);
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EventData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      start: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start'],
      )!,
      end: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end'],
      )!,
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}person'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $EventTable createAlias(String alias) {
    return $EventTable(attachedDatabase, alias);
  }
}

class EventData extends DataClass implements Insertable<EventData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String description;
  final DateTime start;
  final DateTime end;
  final int? person;
  final int type;
  const EventData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.description,
    required this.start,
    required this.end,
    this.person,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['description'] = Variable<String>(description);
    map['start'] = Variable<DateTime>(start);
    map['end'] = Variable<DateTime>(end);
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<int>(person);
    }
    map['type'] = Variable<int>(type);
    return map;
  }

  EventCompanion toCompanion(bool nullToAbsent) {
    return EventCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      description: Value(description),
      start: Value(start),
      end: Value(end),
      person: person == null && nullToAbsent
          ? const Value.absent()
          : Value(person),
      type: Value(type),
    );
  }

  factory EventData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      description: serializer.fromJson<String>(json['description']),
      start: serializer.fromJson<DateTime>(json['start']),
      end: serializer.fromJson<DateTime>(json['end']),
      person: serializer.fromJson<int?>(json['person']),
      type: serializer.fromJson<int>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'description': serializer.toJson<String>(description),
      'start': serializer.toJson<DateTime>(start),
      'end': serializer.toJson<DateTime>(end),
      'person': serializer.toJson<int?>(person),
      'type': serializer.toJson<int>(type),
    };
  }

  EventData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? description,
    DateTime? start,
    DateTime? end,
    Value<int?> person = const Value.absent(),
    int? type,
  }) => EventData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    description: description ?? this.description,
    start: start ?? this.start,
    end: end ?? this.end,
    person: person.present ? person.value : this.person,
    type: type ?? this.type,
  );
  EventData copyWithCompanion(EventCompanion data) {
    return EventData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      description: data.description.present
          ? data.description.value
          : this.description,
      start: data.start.present ? data.start.value : this.start,
      end: data.end.present ? data.end.value : this.end,
      person: data.person.present ? data.person.value : this.person,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EventData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('description: $description, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('person: $person, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    description,
    start,
    end,
    person,
    type,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.description == this.description &&
          other.start == this.start &&
          other.end == this.end &&
          other.person == this.person &&
          other.type == this.type);
}

class EventCompanion extends UpdateCompanion<EventData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> description;
  final Value<DateTime> start;
  final Value<DateTime> end;
  final Value<int?> person;
  final Value<int> type;
  const EventCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.description = const Value.absent(),
    this.start = const Value.absent(),
    this.end = const Value.absent(),
    this.person = const Value.absent(),
    this.type = const Value.absent(),
  });
  EventCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String description,
    required DateTime start,
    required DateTime end,
    this.person = const Value.absent(),
    required int type,
  }) : created = Value(created),
       description = Value(description),
       start = Value(start),
       end = Value(end),
       type = Value(type);
  static Insertable<EventData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? description,
    Expression<DateTime>? start,
    Expression<DateTime>? end,
    Expression<int>? person,
    Expression<int>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (description != null) 'description': description,
      if (start != null) 'start': start,
      if (end != null) 'end': end,
      if (person != null) 'person': person,
      if (type != null) 'type': type,
    });
  }

  EventCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? description,
    Value<DateTime>? start,
    Value<DateTime>? end,
    Value<int?>? person,
    Value<int>? type,
  }) {
    return EventCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      description: description ?? this.description,
      start: start ?? this.start,
      end: end ?? this.end,
      person: person ?? this.person,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (start.present) {
      map['start'] = Variable<DateTime>(start.value);
    }
    if (end.present) {
      map['end'] = Variable<DateTime>(end.value);
    }
    if (person.present) {
      map['person'] = Variable<int>(person.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('description: $description, ')
          ..write('start: $start, ')
          ..write('end: $end, ')
          ..write('person: $person, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $JobTable extends Job with TableInfo<$JobTable, JobData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JobTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'job';
  @override
  VerificationContext validateIntegrity(
    Insertable<JobData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JobData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JobData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
    );
  }

  @override
  $JobTable createAlias(String alias) {
    return $JobTable(attachedDatabase, alias);
  }
}

class JobData extends DataClass implements Insertable<JobData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  const JobData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    return map;
  }

  JobCompanion toCompanion(bool nullToAbsent) {
    return JobCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
    );
  }

  factory JobData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JobData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  JobData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
  }) => JobData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
  );
  JobData copyWithCompanion(JobCompanion data) {
    return JobData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JobData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, synced, syncTime, serverId, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JobData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created);
}

class JobCompanion extends UpdateCompanion<JobData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  const JobCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
  });
  JobCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
  }) : created = Value(created);
  static Insertable<JobData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
    });
  }

  JobCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
  }) {
    return JobCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JobCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

class $UnitTable extends Unit with TableInfo<$UnitTable, UnitData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnitTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    code,
    type,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unit';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnitData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnitData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnitData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
    );
  }

  @override
  $UnitTable createAlias(String alias) {
    return $UnitTable(attachedDatabase, alias);
  }
}

class UnitData extends DataClass implements Insertable<UnitData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String code;
  final String type;
  const UnitData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.code,
    required this.type,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['code'] = Variable<String>(code);
    map['type'] = Variable<String>(type);
    return map;
  }

  UnitCompanion toCompanion(bool nullToAbsent) {
    return UnitCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      code: Value(code),
      type: Value(type),
    );
  }

  factory UnitData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnitData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      code: serializer.fromJson<String>(json['code']),
      type: serializer.fromJson<String>(json['type']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'code': serializer.toJson<String>(code),
      'type': serializer.toJson<String>(type),
    };
  }

  UnitData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? code,
    String? type,
  }) => UnitData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    code: code ?? this.code,
    type: type ?? this.type,
  );
  UnitData copyWithCompanion(UnitCompanion data) {
    return UnitData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      code: data.code.present ? data.code.value : this.code,
      type: data.type.present ? data.type.value : this.type,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnitData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('code: $code, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, synced, syncTime, serverId, created, code, type);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnitData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.code == this.code &&
          other.type == this.type);
}

class UnitCompanion extends UpdateCompanion<UnitData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> code;
  final Value<String> type;
  const UnitCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.code = const Value.absent(),
    this.type = const Value.absent(),
  });
  UnitCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String code,
    required String type,
  }) : created = Value(created),
       code = Value(code),
       type = Value(type);
  static Insertable<UnitData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? code,
    Expression<String>? type,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (code != null) 'code': code,
      if (type != null) 'type': type,
    });
  }

  UnitCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? code,
    Value<String>? type,
  }) {
    return UnitCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      code: code ?? this.code,
      type: type ?? this.type,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnitCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('code: $code, ')
          ..write('type: $type')
          ..write(')'))
        .toString();
  }
}

class $PersonTable extends Person with TableInfo<$PersonTable, PersonData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
    'synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _syncTimeMeta = const VerificationMeta(
    'syncTime',
  );
  @override
  late final GeneratedColumn<DateTime> syncTime = GeneratedColumn<DateTime>(
    'sync_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serverIdMeta = const VerificationMeta(
    'serverId',
  );
  @override
  late final GeneratedColumn<int> serverId = GeneratedColumn<int>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta(
    'created',
  );
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _identifierMeta = const VerificationMeta(
    'identifier',
  );
  @override
  late final GeneratedColumn<String> identifier = GeneratedColumn<String>(
    'identifier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  static const VerificationMeta _typesMeta = const VerificationMeta('types');
  @override
  late final GeneratedColumn<String> types = GeneratedColumn<String>(
    'types',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _surnameMeta = const VerificationMeta(
    'surname',
  );
  @override
  late final GeneratedColumn<String> surname = GeneratedColumn<String>(
    'surname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthMeta = const VerificationMeta('birth');
  @override
  late final GeneratedColumn<DateTime> birth = GeneratedColumn<DateTime>(
    'birth',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _profilePictureMeta = const VerificationMeta(
    'profilePicture',
  );
  @override
  late final GeneratedColumn<String> profilePicture = GeneratedColumn<String>(
    'profile_picture',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    synced,
    syncTime,
    serverId,
    created,
    identifier,
    name,
    types,
    surname,
    birth,
    profilePicture,
    email,
    phone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'person';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(
        _syncedMeta,
        synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta),
      );
    }
    if (data.containsKey('sync_time')) {
      context.handle(
        _syncTimeMeta,
        syncTime.isAcceptableOrUnknown(data['sync_time']!, _syncTimeMeta),
      );
    }
    if (data.containsKey('server_id')) {
      context.handle(
        _serverIdMeta,
        serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta),
      );
    }
    if (data.containsKey('created')) {
      context.handle(
        _createdMeta,
        created.isAcceptableOrUnknown(data['created']!, _createdMeta),
      );
    } else if (isInserting) {
      context.missing(_createdMeta);
    }
    if (data.containsKey('identifier')) {
      context.handle(
        _identifierMeta,
        identifier.isAcceptableOrUnknown(data['identifier']!, _identifierMeta),
      );
    } else if (isInserting) {
      context.missing(_identifierMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('types')) {
      context.handle(
        _typesMeta,
        types.isAcceptableOrUnknown(data['types']!, _typesMeta),
      );
    }
    if (data.containsKey('surname')) {
      context.handle(
        _surnameMeta,
        surname.isAcceptableOrUnknown(data['surname']!, _surnameMeta),
      );
    }
    if (data.containsKey('birth')) {
      context.handle(
        _birthMeta,
        birth.isAcceptableOrUnknown(data['birth']!, _birthMeta),
      );
    }
    if (data.containsKey('profile_picture')) {
      context.handle(
        _profilePictureMeta,
        profilePicture.isAcceptableOrUnknown(
          data['profile_picture']!,
          _profilePictureMeta,
        ),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      synced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}synced'],
      )!,
      syncTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sync_time'],
      ),
      serverId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}server_id'],
      ),
      created: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created'],
      )!,
      identifier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}identifier'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      types: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}types'],
      ),
      surname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}surname'],
      ),
      birth: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth'],
      ),
      profilePicture: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}profile_picture'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
    );
  }

  @override
  $PersonTable createAlias(String alias) {
    return $PersonTable(attachedDatabase, alias);
  }
}

class PersonData extends DataClass implements Insertable<PersonData> {
  final int id;
  final bool synced;
  final DateTime? syncTime;
  final int? serverId;
  final DateTime created;
  final String identifier;
  final String? name;
  final String? types;
  final String? surname;
  final DateTime? birth;
  final String? profilePicture;
  final String? email;
  final String? phone;
  const PersonData({
    required this.id,
    required this.synced,
    this.syncTime,
    this.serverId,
    required this.created,
    required this.identifier,
    this.name,
    this.types,
    this.surname,
    this.birth,
    this.profilePicture,
    this.email,
    this.phone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['synced'] = Variable<bool>(synced);
    if (!nullToAbsent || syncTime != null) {
      map['sync_time'] = Variable<DateTime>(syncTime);
    }
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<int>(serverId);
    }
    map['created'] = Variable<DateTime>(created);
    map['identifier'] = Variable<String>(identifier);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || types != null) {
      map['types'] = Variable<String>(types);
    }
    if (!nullToAbsent || surname != null) {
      map['surname'] = Variable<String>(surname);
    }
    if (!nullToAbsent || birth != null) {
      map['birth'] = Variable<DateTime>(birth);
    }
    if (!nullToAbsent || profilePicture != null) {
      map['profile_picture'] = Variable<String>(profilePicture);
    }
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    return map;
  }

  PersonCompanion toCompanion(bool nullToAbsent) {
    return PersonCompanion(
      id: Value(id),
      synced: Value(synced),
      syncTime: syncTime == null && nullToAbsent
          ? const Value.absent()
          : Value(syncTime),
      serverId: serverId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverId),
      created: Value(created),
      identifier: Value(identifier),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      types: types == null && nullToAbsent
          ? const Value.absent()
          : Value(types),
      surname: surname == null && nullToAbsent
          ? const Value.absent()
          : Value(surname),
      birth: birth == null && nullToAbsent
          ? const Value.absent()
          : Value(birth),
      profilePicture: profilePicture == null && nullToAbsent
          ? const Value.absent()
          : Value(profilePicture),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
    );
  }

  factory PersonData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonData(
      id: serializer.fromJson<int>(json['id']),
      synced: serializer.fromJson<bool>(json['synced']),
      syncTime: serializer.fromJson<DateTime?>(json['syncTime']),
      serverId: serializer.fromJson<int?>(json['serverId']),
      created: serializer.fromJson<DateTime>(json['created']),
      identifier: serializer.fromJson<String>(json['identifier']),
      name: serializer.fromJson<String?>(json['name']),
      types: serializer.fromJson<String?>(json['types']),
      surname: serializer.fromJson<String?>(json['surname']),
      birth: serializer.fromJson<DateTime?>(json['birth']),
      profilePicture: serializer.fromJson<String?>(json['profilePicture']),
      email: serializer.fromJson<String?>(json['email']),
      phone: serializer.fromJson<String?>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'synced': serializer.toJson<bool>(synced),
      'syncTime': serializer.toJson<DateTime?>(syncTime),
      'serverId': serializer.toJson<int?>(serverId),
      'created': serializer.toJson<DateTime>(created),
      'identifier': serializer.toJson<String>(identifier),
      'name': serializer.toJson<String?>(name),
      'types': serializer.toJson<String?>(types),
      'surname': serializer.toJson<String?>(surname),
      'birth': serializer.toJson<DateTime?>(birth),
      'profilePicture': serializer.toJson<String?>(profilePicture),
      'email': serializer.toJson<String?>(email),
      'phone': serializer.toJson<String?>(phone),
    };
  }

  PersonData copyWith({
    int? id,
    bool? synced,
    Value<DateTime?> syncTime = const Value.absent(),
    Value<int?> serverId = const Value.absent(),
    DateTime? created,
    String? identifier,
    Value<String?> name = const Value.absent(),
    Value<String?> types = const Value.absent(),
    Value<String?> surname = const Value.absent(),
    Value<DateTime?> birth = const Value.absent(),
    Value<String?> profilePicture = const Value.absent(),
    Value<String?> email = const Value.absent(),
    Value<String?> phone = const Value.absent(),
  }) => PersonData(
    id: id ?? this.id,
    synced: synced ?? this.synced,
    syncTime: syncTime.present ? syncTime.value : this.syncTime,
    serverId: serverId.present ? serverId.value : this.serverId,
    created: created ?? this.created,
    identifier: identifier ?? this.identifier,
    name: name.present ? name.value : this.name,
    types: types.present ? types.value : this.types,
    surname: surname.present ? surname.value : this.surname,
    birth: birth.present ? birth.value : this.birth,
    profilePicture: profilePicture.present
        ? profilePicture.value
        : this.profilePicture,
    email: email.present ? email.value : this.email,
    phone: phone.present ? phone.value : this.phone,
  );
  PersonData copyWithCompanion(PersonCompanion data) {
    return PersonData(
      id: data.id.present ? data.id.value : this.id,
      synced: data.synced.present ? data.synced.value : this.synced,
      syncTime: data.syncTime.present ? data.syncTime.value : this.syncTime,
      serverId: data.serverId.present ? data.serverId.value : this.serverId,
      created: data.created.present ? data.created.value : this.created,
      identifier: data.identifier.present
          ? data.identifier.value
          : this.identifier,
      name: data.name.present ? data.name.value : this.name,
      types: data.types.present ? data.types.value : this.types,
      surname: data.surname.present ? data.surname.value : this.surname,
      birth: data.birth.present ? data.birth.value : this.birth,
      profilePicture: data.profilePicture.present
          ? data.profilePicture.value
          : this.profilePicture,
      email: data.email.present ? data.email.value : this.email,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonData(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('types: $types, ')
          ..write('surname: $surname, ')
          ..write('birth: $birth, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('email: $email, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    synced,
    syncTime,
    serverId,
    created,
    identifier,
    name,
    types,
    surname,
    birth,
    profilePicture,
    email,
    phone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonData &&
          other.id == this.id &&
          other.synced == this.synced &&
          other.syncTime == this.syncTime &&
          other.serverId == this.serverId &&
          other.created == this.created &&
          other.identifier == this.identifier &&
          other.name == this.name &&
          other.types == this.types &&
          other.surname == this.surname &&
          other.birth == this.birth &&
          other.profilePicture == this.profilePicture &&
          other.email == this.email &&
          other.phone == this.phone);
}

class PersonCompanion extends UpdateCompanion<PersonData> {
  final Value<int> id;
  final Value<bool> synced;
  final Value<DateTime?> syncTime;
  final Value<int?> serverId;
  final Value<DateTime> created;
  final Value<String> identifier;
  final Value<String?> name;
  final Value<String?> types;
  final Value<String?> surname;
  final Value<DateTime?> birth;
  final Value<String?> profilePicture;
  final Value<String?> email;
  final Value<String?> phone;
  const PersonCompanion({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    this.created = const Value.absent(),
    this.identifier = const Value.absent(),
    this.name = const Value.absent(),
    this.types = const Value.absent(),
    this.surname = const Value.absent(),
    this.birth = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
  });
  PersonCompanion.insert({
    this.id = const Value.absent(),
    this.synced = const Value.absent(),
    this.syncTime = const Value.absent(),
    this.serverId = const Value.absent(),
    required DateTime created,
    required String identifier,
    this.name = const Value.absent(),
    this.types = const Value.absent(),
    this.surname = const Value.absent(),
    this.birth = const Value.absent(),
    this.profilePicture = const Value.absent(),
    this.email = const Value.absent(),
    this.phone = const Value.absent(),
  }) : created = Value(created),
       identifier = Value(identifier);
  static Insertable<PersonData> custom({
    Expression<int>? id,
    Expression<bool>? synced,
    Expression<DateTime>? syncTime,
    Expression<int>? serverId,
    Expression<DateTime>? created,
    Expression<String>? identifier,
    Expression<String>? name,
    Expression<String>? types,
    Expression<String>? surname,
    Expression<DateTime>? birth,
    Expression<String>? profilePicture,
    Expression<String>? email,
    Expression<String>? phone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (synced != null) 'synced': synced,
      if (syncTime != null) 'sync_time': syncTime,
      if (serverId != null) 'server_id': serverId,
      if (created != null) 'created': created,
      if (identifier != null) 'identifier': identifier,
      if (name != null) 'name': name,
      if (types != null) 'types': types,
      if (surname != null) 'surname': surname,
      if (birth != null) 'birth': birth,
      if (profilePicture != null) 'profile_picture': profilePicture,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
    });
  }

  PersonCompanion copyWith({
    Value<int>? id,
    Value<bool>? synced,
    Value<DateTime?>? syncTime,
    Value<int?>? serverId,
    Value<DateTime>? created,
    Value<String>? identifier,
    Value<String?>? name,
    Value<String?>? types,
    Value<String?>? surname,
    Value<DateTime?>? birth,
    Value<String?>? profilePicture,
    Value<String?>? email,
    Value<String?>? phone,
  }) {
    return PersonCompanion(
      id: id ?? this.id,
      synced: synced ?? this.synced,
      syncTime: syncTime ?? this.syncTime,
      serverId: serverId ?? this.serverId,
      created: created ?? this.created,
      identifier: identifier ?? this.identifier,
      name: name ?? this.name,
      types: types ?? this.types,
      surname: surname ?? this.surname,
      birth: birth ?? this.birth,
      profilePicture: profilePicture ?? this.profilePicture,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (syncTime.present) {
      map['sync_time'] = Variable<DateTime>(syncTime.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<int>(serverId.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    if (identifier.present) {
      map['identifier'] = Variable<String>(identifier.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (types.present) {
      map['types'] = Variable<String>(types.value);
    }
    if (surname.present) {
      map['surname'] = Variable<String>(surname.value);
    }
    if (birth.present) {
      map['birth'] = Variable<DateTime>(birth.value);
    }
    if (profilePicture.present) {
      map['profile_picture'] = Variable<String>(profilePicture.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonCompanion(')
          ..write('id: $id, ')
          ..write('synced: $synced, ')
          ..write('syncTime: $syncTime, ')
          ..write('serverId: $serverId, ')
          ..write('created: $created, ')
          ..write('identifier: $identifier, ')
          ..write('name: $name, ')
          ..write('types: $types, ')
          ..write('surname: $surname, ')
          ..write('birth: $birth, ')
          ..write('profilePicture: $profilePicture, ')
          ..write('email: $email, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }
}

abstract class _$Database extends GeneratedDatabase {
  _$Database(QueryExecutor e) : super(e);
  $DatabaseManager get managers => $DatabaseManager(this);
  late final $GroupTable group = $GroupTable(this);
  late final $MetricTypeTable metricType = $MetricTypeTable(this);
  late final $MetricTable metric = $MetricTable(this);
  late final $EventTypeTable eventType = $EventTypeTable(this);
  late final $EventTable event = $EventTable(this);
  late final $JobTable job = $JobTable(this);
  late final $UnitTable unit = $UnitTable(this);
  late final $PersonTable person = $PersonTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    group,
    metricType,
    metric,
    eventType,
    event,
    job,
    unit,
    person,
  ];
}

typedef $$GroupTableCreateCompanionBuilder =
    GroupCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String name,
      required String description,
      required bool showOnDashboard,
      required bool showTitle,
    });
typedef $$GroupTableUpdateCompanionBuilder =
    GroupCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> name,
      Value<String> description,
      Value<bool> showOnDashboard,
      Value<bool> showTitle,
    });

final class $$GroupTableReferences
    extends BaseReferences<_$Database, $GroupTable, GroupData> {
  $$GroupTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$MetricTypeTable, List<MetricTypeData>>
  _metricTypeRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.metricType,
    aliasName: 'group__id__metric_type__group_id',
  );

  $$MetricTypeTableProcessedTableManager get metricTypeRefs {
    final manager = $$MetricTypeTableTableManager(
      $_db,
      $_db.metricType,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metricTypeRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$EventTypeTable, List<EventTypeData>>
  _eventTypeRefsTable(_$Database db) => MultiTypedResultKey.fromTable(
    db.eventType,
    aliasName: 'group__id__event_type__group_id',
  );

  $$EventTypeTableProcessedTableManager get eventTypeRefs {
    final manager = $$EventTypeTableTableManager(
      $_db,
      $_db.eventType,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventTypeRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GroupTableFilterComposer extends Composer<_$Database, $GroupTable> {
  $$GroupTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showOnDashboard => $composableBuilder(
    column: $table.showOnDashboard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showTitle => $composableBuilder(
    column: $table.showTitle,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> metricTypeRefs(
    Expression<bool> Function($$MetricTypeTableFilterComposer f) f,
  ) {
    final $$MetricTypeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metricType,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTypeTableFilterComposer(
            $db: $db,
            $table: $db.metricType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventTypeRefs(
    Expression<bool> Function($$EventTypeTableFilterComposer f) f,
  ) {
    final $$EventTypeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventType,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTypeTableFilterComposer(
            $db: $db,
            $table: $db.eventType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupTableOrderingComposer extends Composer<_$Database, $GroupTable> {
  $$GroupTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showOnDashboard => $composableBuilder(
    column: $table.showOnDashboard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showTitle => $composableBuilder(
    column: $table.showTitle,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GroupTableAnnotationComposer extends Composer<_$Database, $GroupTable> {
  $$GroupTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showOnDashboard => $composableBuilder(
    column: $table.showOnDashboard,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get showTitle =>
      $composableBuilder(column: $table.showTitle, builder: (column) => column);

  Expression<T> metricTypeRefs<T extends Object>(
    Expression<T> Function($$MetricTypeTableAnnotationComposer a) f,
  ) {
    final $$MetricTypeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metricType,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTypeTableAnnotationComposer(
            $db: $db,
            $table: $db.metricType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventTypeRefs<T extends Object>(
    Expression<T> Function($$EventTypeTableAnnotationComposer a) f,
  ) {
    final $$EventTypeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.eventType,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTypeTableAnnotationComposer(
            $db: $db,
            $table: $db.eventType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GroupTableTableManager
    extends
        RootTableManager<
          _$Database,
          $GroupTable,
          GroupData,
          $$GroupTableFilterComposer,
          $$GroupTableOrderingComposer,
          $$GroupTableAnnotationComposer,
          $$GroupTableCreateCompanionBuilder,
          $$GroupTableUpdateCompanionBuilder,
          (GroupData, $$GroupTableReferences),
          GroupData,
          PrefetchHooks Function({bool metricTypeRefs, bool eventTypeRefs})
        > {
  $$GroupTableTableManager(_$Database db, $GroupTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GroupTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GroupTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GroupTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<bool> showOnDashboard = const Value.absent(),
                Value<bool> showTitle = const Value.absent(),
              }) => GroupCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                showOnDashboard: showOnDashboard,
                showTitle: showTitle,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String name,
                required String description,
                required bool showOnDashboard,
                required bool showTitle,
              }) => GroupCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                showOnDashboard: showOnDashboard,
                showTitle: showTitle,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$GroupTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({metricTypeRefs = false, eventTypeRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (metricTypeRefs) db.metricType,
                    if (eventTypeRefs) db.eventType,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (metricTypeRefs)
                        await $_getPrefetchedData<
                          GroupData,
                          $GroupTable,
                          MetricTypeData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupTableReferences
                              ._metricTypeRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupTableReferences(
                                db,
                                table,
                                p0,
                              ).metricTypeRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (eventTypeRefs)
                        await $_getPrefetchedData<
                          GroupData,
                          $GroupTable,
                          EventTypeData
                        >(
                          currentTable: table,
                          referencedTable: $$GroupTableReferences
                              ._eventTypeRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GroupTableReferences(
                                db,
                                table,
                                p0,
                              ).eventTypeRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.groupId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GroupTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $GroupTable,
      GroupData,
      $$GroupTableFilterComposer,
      $$GroupTableOrderingComposer,
      $$GroupTableAnnotationComposer,
      $$GroupTableCreateCompanionBuilder,
      $$GroupTableUpdateCompanionBuilder,
      (GroupData, $$GroupTableReferences),
      GroupData,
      PrefetchHooks Function({bool metricTypeRefs, bool eventTypeRefs})
    >;
typedef $$MetricTypeTableCreateCompanionBuilder =
    MetricTypeCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String name,
      Value<String?> description,
      required int groupId,
    });
typedef $$MetricTypeTableUpdateCompanionBuilder =
    MetricTypeCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> name,
      Value<String?> description,
      Value<int> groupId,
    });

final class $$MetricTypeTableReferences
    extends BaseReferences<_$Database, $MetricTypeTable, MetricTypeData> {
  $$MetricTypeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupTable _groupIdTable(_$Database db) =>
      db.group.createAlias('metric_type__group_id__group__id');

  $$GroupTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupTableTableManager(
      $_db,
      $_db.group,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MetricTable, List<MetricData>> _metricRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.metric,
    aliasName: 'metric_type__id__metric__type',
  );

  $$MetricTableProcessedTableManager get metricRefs {
    final manager = $$MetricTableTableManager(
      $_db,
      $_db.metric,
    ).filter((f) => f.type.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_metricRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MetricTypeTableFilterComposer
    extends Composer<_$Database, $MetricTypeTable> {
  $$MetricTypeTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupTableFilterComposer get groupId {
    final $$GroupTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableFilterComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> metricRefs(
    Expression<bool> Function($$MetricTableFilterComposer f) f,
  ) {
    final $$MetricTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metric,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTableFilterComposer(
            $db: $db,
            $table: $db.metric,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricTypeTableOrderingComposer
    extends Composer<_$Database, $MetricTypeTable> {
  $$MetricTypeTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupTableOrderingComposer get groupId {
    final $$GroupTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableOrderingComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetricTypeTableAnnotationComposer
    extends Composer<_$Database, $MetricTypeTable> {
  $$MetricTypeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$GroupTableAnnotationComposer get groupId {
    final $$GroupTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableAnnotationComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> metricRefs<T extends Object>(
    Expression<T> Function($$MetricTableAnnotationComposer a) f,
  ) {
    final $$MetricTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.metric,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTableAnnotationComposer(
            $db: $db,
            $table: $db.metric,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MetricTypeTableTableManager
    extends
        RootTableManager<
          _$Database,
          $MetricTypeTable,
          MetricTypeData,
          $$MetricTypeTableFilterComposer,
          $$MetricTypeTableOrderingComposer,
          $$MetricTypeTableAnnotationComposer,
          $$MetricTypeTableCreateCompanionBuilder,
          $$MetricTypeTableUpdateCompanionBuilder,
          (MetricTypeData, $$MetricTypeTableReferences),
          MetricTypeData,
          PrefetchHooks Function({bool groupId, bool metricRefs})
        > {
  $$MetricTypeTableTableManager(_$Database db, $MetricTypeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricTypeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricTypeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricTypeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> groupId = const Value.absent(),
              }) => MetricTypeCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                groupId: groupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String name,
                Value<String?> description = const Value.absent(),
                required int groupId,
              }) => MetricTypeCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                groupId: groupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MetricTypeTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, metricRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (metricRefs) db.metric],
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
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$MetricTypeTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$MetricTypeTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (metricRefs)
                    await $_getPrefetchedData<
                      MetricTypeData,
                      $MetricTypeTable,
                      MetricData
                    >(
                      currentTable: table,
                      referencedTable: $$MetricTypeTableReferences
                          ._metricRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MetricTypeTableReferences(db, table, p0).metricRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.type == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MetricTypeTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $MetricTypeTable,
      MetricTypeData,
      $$MetricTypeTableFilterComposer,
      $$MetricTypeTableOrderingComposer,
      $$MetricTypeTableAnnotationComposer,
      $$MetricTypeTableCreateCompanionBuilder,
      $$MetricTypeTableUpdateCompanionBuilder,
      (MetricTypeData, $$MetricTypeTableReferences),
      MetricTypeData,
      PrefetchHooks Function({bool groupId, bool metricRefs})
    >;
typedef $$MetricTableCreateCompanionBuilder =
    MetricCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String value,
      required DateTime date,
      Value<int?> person,
      required int type,
    });
typedef $$MetricTableUpdateCompanionBuilder =
    MetricCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> value,
      Value<DateTime> date,
      Value<int?> person,
      Value<int> type,
    });

final class $$MetricTableReferences
    extends BaseReferences<_$Database, $MetricTable, MetricData> {
  $$MetricTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MetricTypeTable _typeTable(_$Database db) =>
      db.metricType.createAlias('metric__type__metric_type__id');

  $$MetricTypeTableProcessedTableManager get type {
    final $_column = $_itemColumn<int>('type')!;

    final manager = $$MetricTypeTableTableManager(
      $_db,
      $_db.metricType,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MetricTableFilterComposer extends Composer<_$Database, $MetricTable> {
  $$MetricTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  $$MetricTypeTableFilterComposer get type {
    final $$MetricTypeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.metricType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTypeTableFilterComposer(
            $db: $db,
            $table: $db.metricType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetricTableOrderingComposer extends Composer<_$Database, $MetricTable> {
  $$MetricTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  $$MetricTypeTableOrderingComposer get type {
    final $$MetricTypeTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.metricType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTypeTableOrderingComposer(
            $db: $db,
            $table: $db.metricType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetricTableAnnotationComposer
    extends Composer<_$Database, $MetricTable> {
  $$MetricTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  $$MetricTypeTableAnnotationComposer get type {
    final $$MetricTypeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.metricType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MetricTypeTableAnnotationComposer(
            $db: $db,
            $table: $db.metricType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MetricTableTableManager
    extends
        RootTableManager<
          _$Database,
          $MetricTable,
          MetricData,
          $$MetricTableFilterComposer,
          $$MetricTableOrderingComposer,
          $$MetricTableAnnotationComposer,
          $$MetricTableCreateCompanionBuilder,
          $$MetricTableUpdateCompanionBuilder,
          (MetricData, $$MetricTableReferences),
          MetricData,
          PrefetchHooks Function({bool type})
        > {
  $$MetricTableTableManager(_$Database db, $MetricTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetricTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetricTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetricTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int?> person = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => MetricCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                value: value,
                date: date,
                person: person,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String value,
                required DateTime date,
                Value<int?> person = const Value.absent(),
                required int type,
              }) => MetricCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                value: value,
                date: date,
                person: person,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MetricTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({type = false}) {
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
                    if (type) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.type,
                                referencedTable: $$MetricTableReferences
                                    ._typeTable(db),
                                referencedColumn: $$MetricTableReferences
                                    ._typeTable(db)
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

typedef $$MetricTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $MetricTable,
      MetricData,
      $$MetricTableFilterComposer,
      $$MetricTableOrderingComposer,
      $$MetricTableAnnotationComposer,
      $$MetricTableCreateCompanionBuilder,
      $$MetricTableUpdateCompanionBuilder,
      (MetricData, $$MetricTableReferences),
      MetricData,
      PrefetchHooks Function({bool type})
    >;
typedef $$EventTypeTableCreateCompanionBuilder =
    EventTypeCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String name,
      Value<String?> description,
      required bool standAlone,
      required bool visible,
      Value<String?> timeDifference,
      required int groupId,
    });
typedef $$EventTypeTableUpdateCompanionBuilder =
    EventTypeCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> name,
      Value<String?> description,
      Value<bool> standAlone,
      Value<bool> visible,
      Value<String?> timeDifference,
      Value<int> groupId,
    });

final class $$EventTypeTableReferences
    extends BaseReferences<_$Database, $EventTypeTable, EventTypeData> {
  $$EventTypeTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GroupTable _groupIdTable(_$Database db) =>
      db.group.createAlias('event_type__group_id__group__id');

  $$GroupTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<int>('group_id')!;

    final manager = $$GroupTableTableManager(
      $_db,
      $_db.group,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$EventTable, List<EventData>> _eventRefsTable(
    _$Database db,
  ) => MultiTypedResultKey.fromTable(
    db.event,
    aliasName: 'event_type__id__event__type',
  );

  $$EventTableProcessedTableManager get eventRefs {
    final manager = $$EventTableTableManager(
      $_db,
      $_db.event,
    ).filter((f) => f.type.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_eventRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EventTypeTableFilterComposer
    extends Composer<_$Database, $EventTypeTable> {
  $$EventTypeTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get standAlone => $composableBuilder(
    column: $table.standAlone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get visible => $composableBuilder(
    column: $table.visible,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timeDifference => $composableBuilder(
    column: $table.timeDifference,
    builder: (column) => ColumnFilters(column),
  );

  $$GroupTableFilterComposer get groupId {
    final $$GroupTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableFilterComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> eventRefs(
    Expression<bool> Function($$EventTableFilterComposer f) f,
  ) {
    final $$EventTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.event,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTableFilterComposer(
            $db: $db,
            $table: $db.event,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventTypeTableOrderingComposer
    extends Composer<_$Database, $EventTypeTable> {
  $$EventTypeTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get standAlone => $composableBuilder(
    column: $table.standAlone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get visible => $composableBuilder(
    column: $table.visible,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timeDifference => $composableBuilder(
    column: $table.timeDifference,
    builder: (column) => ColumnOrderings(column),
  );

  $$GroupTableOrderingComposer get groupId {
    final $$GroupTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableOrderingComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTypeTableAnnotationComposer
    extends Composer<_$Database, $EventTypeTable> {
  $$EventTypeTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get standAlone => $composableBuilder(
    column: $table.standAlone,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get visible =>
      $composableBuilder(column: $table.visible, builder: (column) => column);

  GeneratedColumn<String> get timeDifference => $composableBuilder(
    column: $table.timeDifference,
    builder: (column) => column,
  );

  $$GroupTableAnnotationComposer get groupId {
    final $$GroupTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.group,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GroupTableAnnotationComposer(
            $db: $db,
            $table: $db.group,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> eventRefs<T extends Object>(
    Expression<T> Function($$EventTableAnnotationComposer a) f,
  ) {
    final $$EventTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.event,
      getReferencedColumn: (t) => t.type,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTableAnnotationComposer(
            $db: $db,
            $table: $db.event,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EventTypeTableTableManager
    extends
        RootTableManager<
          _$Database,
          $EventTypeTable,
          EventTypeData,
          $$EventTypeTableFilterComposer,
          $$EventTypeTableOrderingComposer,
          $$EventTypeTableAnnotationComposer,
          $$EventTypeTableCreateCompanionBuilder,
          $$EventTypeTableUpdateCompanionBuilder,
          (EventTypeData, $$EventTypeTableReferences),
          EventTypeData,
          PrefetchHooks Function({bool groupId, bool eventRefs})
        > {
  $$EventTypeTableTableManager(_$Database db, $EventTypeTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventTypeTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventTypeTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventTypeTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> standAlone = const Value.absent(),
                Value<bool> visible = const Value.absent(),
                Value<String?> timeDifference = const Value.absent(),
                Value<int> groupId = const Value.absent(),
              }) => EventTypeCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                standAlone: standAlone,
                visible: visible,
                timeDifference: timeDifference,
                groupId: groupId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String name,
                Value<String?> description = const Value.absent(),
                required bool standAlone,
                required bool visible,
                Value<String?> timeDifference = const Value.absent(),
                required int groupId,
              }) => EventTypeCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                name: name,
                description: description,
                standAlone: standAlone,
                visible: visible,
                timeDifference: timeDifference,
                groupId: groupId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EventTypeTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({groupId = false, eventRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (eventRefs) db.event],
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
                    if (groupId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.groupId,
                                referencedTable: $$EventTypeTableReferences
                                    ._groupIdTable(db),
                                referencedColumn: $$EventTypeTableReferences
                                    ._groupIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (eventRefs)
                    await $_getPrefetchedData<
                      EventTypeData,
                      $EventTypeTable,
                      EventData
                    >(
                      currentTable: table,
                      referencedTable: $$EventTypeTableReferences
                          ._eventRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$EventTypeTableReferences(db, table, p0).eventRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.type == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$EventTypeTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $EventTypeTable,
      EventTypeData,
      $$EventTypeTableFilterComposer,
      $$EventTypeTableOrderingComposer,
      $$EventTypeTableAnnotationComposer,
      $$EventTypeTableCreateCompanionBuilder,
      $$EventTypeTableUpdateCompanionBuilder,
      (EventTypeData, $$EventTypeTableReferences),
      EventTypeData,
      PrefetchHooks Function({bool groupId, bool eventRefs})
    >;
typedef $$EventTableCreateCompanionBuilder =
    EventCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String description,
      required DateTime start,
      required DateTime end,
      Value<int?> person,
      required int type,
    });
typedef $$EventTableUpdateCompanionBuilder =
    EventCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> description,
      Value<DateTime> start,
      Value<DateTime> end,
      Value<int?> person,
      Value<int> type,
    });

final class $$EventTableReferences
    extends BaseReferences<_$Database, $EventTable, EventData> {
  $$EventTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EventTypeTable _typeTable(_$Database db) =>
      db.eventType.createAlias('event__type__event_type__id');

  $$EventTypeTableProcessedTableManager get type {
    final $_column = $_itemColumn<int>('type')!;

    final manager = $$EventTypeTableTableManager(
      $_db,
      $_db.eventType,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_typeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$EventTableFilterComposer extends Composer<_$Database, $EventTable> {
  $$EventTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  $$EventTypeTableFilterComposer get type {
    final $$EventTypeTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.eventType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTypeTableFilterComposer(
            $db: $db,
            $table: $db.eventType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTableOrderingComposer extends Composer<_$Database, $EventTable> {
  $$EventTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get start => $composableBuilder(
    column: $table.start,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get end => $composableBuilder(
    column: $table.end,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  $$EventTypeTableOrderingComposer get type {
    final $$EventTypeTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.eventType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTypeTableOrderingComposer(
            $db: $db,
            $table: $db.eventType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTableAnnotationComposer extends Composer<_$Database, $EventTable> {
  $$EventTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get start =>
      $composableBuilder(column: $table.start, builder: (column) => column);

  GeneratedColumn<DateTime> get end =>
      $composableBuilder(column: $table.end, builder: (column) => column);

  GeneratedColumn<int> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  $$EventTypeTableAnnotationComposer get type {
    final $$EventTypeTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.type,
      referencedTable: $db.eventType,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EventTypeTableAnnotationComposer(
            $db: $db,
            $table: $db.eventType,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$EventTableTableManager
    extends
        RootTableManager<
          _$Database,
          $EventTable,
          EventData,
          $$EventTableFilterComposer,
          $$EventTableOrderingComposer,
          $$EventTableAnnotationComposer,
          $$EventTableCreateCompanionBuilder,
          $$EventTableUpdateCompanionBuilder,
          (EventData, $$EventTableReferences),
          EventData,
          PrefetchHooks Function({bool type})
        > {
  $$EventTableTableManager(_$Database db, $EventTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EventTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EventTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EventTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<DateTime> start = const Value.absent(),
                Value<DateTime> end = const Value.absent(),
                Value<int?> person = const Value.absent(),
                Value<int> type = const Value.absent(),
              }) => EventCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                description: description,
                start: start,
                end: end,
                person: person,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String description,
                required DateTime start,
                required DateTime end,
                Value<int?> person = const Value.absent(),
                required int type,
              }) => EventCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                description: description,
                start: start,
                end: end,
                person: person,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$EventTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({type = false}) {
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
                    if (type) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.type,
                                referencedTable: $$EventTableReferences
                                    ._typeTable(db),
                                referencedColumn: $$EventTableReferences
                                    ._typeTable(db)
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

typedef $$EventTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $EventTable,
      EventData,
      $$EventTableFilterComposer,
      $$EventTableOrderingComposer,
      $$EventTableAnnotationComposer,
      $$EventTableCreateCompanionBuilder,
      $$EventTableUpdateCompanionBuilder,
      (EventData, $$EventTableReferences),
      EventData,
      PrefetchHooks Function({bool type})
    >;
typedef $$JobTableCreateCompanionBuilder =
    JobCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
    });
typedef $$JobTableUpdateCompanionBuilder =
    JobCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
    });

class $$JobTableFilterComposer extends Composer<_$Database, $JobTable> {
  $$JobTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );
}

class $$JobTableOrderingComposer extends Composer<_$Database, $JobTable> {
  $$JobTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JobTableAnnotationComposer extends Composer<_$Database, $JobTable> {
  $$JobTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);
}

class $$JobTableTableManager
    extends
        RootTableManager<
          _$Database,
          $JobTable,
          JobData,
          $$JobTableFilterComposer,
          $$JobTableOrderingComposer,
          $$JobTableAnnotationComposer,
          $$JobTableCreateCompanionBuilder,
          $$JobTableUpdateCompanionBuilder,
          (JobData, BaseReferences<_$Database, $JobTable, JobData>),
          JobData,
          PrefetchHooks Function()
        > {
  $$JobTableTableManager(_$Database db, $JobTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JobTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JobTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JobTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
              }) => JobCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
              }) => JobCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$JobTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $JobTable,
      JobData,
      $$JobTableFilterComposer,
      $$JobTableOrderingComposer,
      $$JobTableAnnotationComposer,
      $$JobTableCreateCompanionBuilder,
      $$JobTableUpdateCompanionBuilder,
      (JobData, BaseReferences<_$Database, $JobTable, JobData>),
      JobData,
      PrefetchHooks Function()
    >;
typedef $$UnitTableCreateCompanionBuilder =
    UnitCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String code,
      required String type,
    });
typedef $$UnitTableUpdateCompanionBuilder =
    UnitCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> code,
      Value<String> type,
    });

class $$UnitTableFilterComposer extends Composer<_$Database, $UnitTable> {
  $$UnitTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnitTableOrderingComposer extends Composer<_$Database, $UnitTable> {
  $$UnitTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnitTableAnnotationComposer extends Composer<_$Database, $UnitTable> {
  $$UnitTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);
}

class $$UnitTableTableManager
    extends
        RootTableManager<
          _$Database,
          $UnitTable,
          UnitData,
          $$UnitTableFilterComposer,
          $$UnitTableOrderingComposer,
          $$UnitTableAnnotationComposer,
          $$UnitTableCreateCompanionBuilder,
          $$UnitTableUpdateCompanionBuilder,
          (UnitData, BaseReferences<_$Database, $UnitTable, UnitData>),
          UnitData,
          PrefetchHooks Function()
        > {
  $$UnitTableTableManager(_$Database db, $UnitTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnitTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnitTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnitTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> type = const Value.absent(),
              }) => UnitCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                code: code,
                type: type,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String code,
                required String type,
              }) => UnitCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                code: code,
                type: type,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnitTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $UnitTable,
      UnitData,
      $$UnitTableFilterComposer,
      $$UnitTableOrderingComposer,
      $$UnitTableAnnotationComposer,
      $$UnitTableCreateCompanionBuilder,
      $$UnitTableUpdateCompanionBuilder,
      (UnitData, BaseReferences<_$Database, $UnitTable, UnitData>),
      UnitData,
      PrefetchHooks Function()
    >;
typedef $$PersonTableCreateCompanionBuilder =
    PersonCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      required DateTime created,
      required String identifier,
      Value<String?> name,
      Value<String?> types,
      Value<String?> surname,
      Value<DateTime?> birth,
      Value<String?> profilePicture,
      Value<String?> email,
      Value<String?> phone,
    });
typedef $$PersonTableUpdateCompanionBuilder =
    PersonCompanion Function({
      Value<int> id,
      Value<bool> synced,
      Value<DateTime?> syncTime,
      Value<int?> serverId,
      Value<DateTime> created,
      Value<String> identifier,
      Value<String?> name,
      Value<String?> types,
      Value<String?> surname,
      Value<DateTime?> birth,
      Value<String?> profilePicture,
      Value<String?> email,
      Value<String?> phone,
    });

class $$PersonTableFilterComposer extends Composer<_$Database, $PersonTable> {
  $$PersonTableFilterComposer({
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

  ColumnFilters<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get surname => $composableBuilder(
    column: $table.surname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birth => $composableBuilder(
    column: $table.birth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PersonTableOrderingComposer extends Composer<_$Database, $PersonTable> {
  $$PersonTableOrderingComposer({
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

  ColumnOrderings<bool> get synced => $composableBuilder(
    column: $table.synced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get syncTime => $composableBuilder(
    column: $table.syncTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serverId => $composableBuilder(
    column: $table.serverId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get created => $composableBuilder(
    column: $table.created,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get types => $composableBuilder(
    column: $table.types,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get surname => $composableBuilder(
    column: $table.surname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birth => $composableBuilder(
    column: $table.birth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PersonTableAnnotationComposer
    extends Composer<_$Database, $PersonTable> {
  $$PersonTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get synced =>
      $composableBuilder(column: $table.synced, builder: (column) => column);

  GeneratedColumn<DateTime> get syncTime =>
      $composableBuilder(column: $table.syncTime, builder: (column) => column);

  GeneratedColumn<int> get serverId =>
      $composableBuilder(column: $table.serverId, builder: (column) => column);

  GeneratedColumn<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => column);

  GeneratedColumn<String> get identifier => $composableBuilder(
    column: $table.identifier,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get types =>
      $composableBuilder(column: $table.types, builder: (column) => column);

  GeneratedColumn<String> get surname =>
      $composableBuilder(column: $table.surname, builder: (column) => column);

  GeneratedColumn<DateTime> get birth =>
      $composableBuilder(column: $table.birth, builder: (column) => column);

  GeneratedColumn<String> get profilePicture => $composableBuilder(
    column: $table.profilePicture,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$PersonTableTableManager
    extends
        RootTableManager<
          _$Database,
          $PersonTable,
          PersonData,
          $$PersonTableFilterComposer,
          $$PersonTableOrderingComposer,
          $$PersonTableAnnotationComposer,
          $$PersonTableCreateCompanionBuilder,
          $$PersonTableUpdateCompanionBuilder,
          (PersonData, BaseReferences<_$Database, $PersonTable, PersonData>),
          PersonData,
          PrefetchHooks Function()
        > {
  $$PersonTableTableManager(_$Database db, $PersonTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
                Value<String> identifier = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> types = const Value.absent(),
                Value<String?> surname = const Value.absent(),
                Value<DateTime?> birth = const Value.absent(),
                Value<String?> profilePicture = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
              }) => PersonCompanion(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                identifier: identifier,
                name: name,
                types: types,
                surname: surname,
                birth: birth,
                profilePicture: profilePicture,
                email: email,
                phone: phone,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> synced = const Value.absent(),
                Value<DateTime?> syncTime = const Value.absent(),
                Value<int?> serverId = const Value.absent(),
                required DateTime created,
                required String identifier,
                Value<String?> name = const Value.absent(),
                Value<String?> types = const Value.absent(),
                Value<String?> surname = const Value.absent(),
                Value<DateTime?> birth = const Value.absent(),
                Value<String?> profilePicture = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> phone = const Value.absent(),
              }) => PersonCompanion.insert(
                id: id,
                synced: synced,
                syncTime: syncTime,
                serverId: serverId,
                created: created,
                identifier: identifier,
                name: name,
                types: types,
                surname: surname,
                birth: birth,
                profilePicture: profilePicture,
                email: email,
                phone: phone,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PersonTableProcessedTableManager =
    ProcessedTableManager<
      _$Database,
      $PersonTable,
      PersonData,
      $$PersonTableFilterComposer,
      $$PersonTableOrderingComposer,
      $$PersonTableAnnotationComposer,
      $$PersonTableCreateCompanionBuilder,
      $$PersonTableUpdateCompanionBuilder,
      (PersonData, BaseReferences<_$Database, $PersonTable, PersonData>),
      PersonData,
      PrefetchHooks Function()
    >;

class $DatabaseManager {
  final _$Database _db;
  $DatabaseManager(this._db);
  $$GroupTableTableManager get group =>
      $$GroupTableTableManager(_db, _db.group);
  $$MetricTypeTableTableManager get metricType =>
      $$MetricTypeTableTableManager(_db, _db.metricType);
  $$MetricTableTableManager get metric =>
      $$MetricTableTableManager(_db, _db.metric);
  $$EventTypeTableTableManager get eventType =>
      $$EventTypeTableTableManager(_db, _db.eventType);
  $$EventTableTableManager get event =>
      $$EventTableTableManager(_db, _db.event);
  $$JobTableTableManager get job => $$JobTableTableManager(_db, _db.job);
  $$UnitTableTableManager get unit => $$UnitTableTableManager(_db, _db.unit);
  $$PersonTableTableManager get person =>
      $$PersonTableTableManager(_db, _db.person);
}
