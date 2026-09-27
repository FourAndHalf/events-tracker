// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currencySymbolMeta = const VerificationMeta(
    'currencySymbol',
  );
  @override
  late final GeneratedColumn<String> currencySymbol = GeneratedColumn<String>(
    'currency_symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('\$'),
  );
  static const VerificationMeta _sleepGoalMinutesMeta = const VerificationMeta(
    'sleepGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepGoalMinutes = GeneratedColumn<int>(
    'sleep_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(480),
  );
  static const VerificationMeta _targetBedtimeMinutesMeta =
      const VerificationMeta('targetBedtimeMinutes');
  @override
  late final GeneratedColumn<int> targetBedtimeMinutes = GeneratedColumn<int>(
    'target_bedtime_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1380),
  );
  static const VerificationMeta _weeklyReportEnabledMeta =
      const VerificationMeta('weeklyReportEnabled');
  @override
  late final GeneratedColumn<bool> weeklyReportEnabled = GeneratedColumn<bool>(
    'weekly_report_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weekly_report_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _weeklyReportMinutesMeta =
      const VerificationMeta('weeklyReportMinutes');
  @override
  late final GeneratedColumn<int> weeklyReportMinutes = GeneratedColumn<int>(
    'weekly_report_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1140),
  );
  static const VerificationMeta _memoryRemindMinutesMeta =
      const VerificationMeta('memoryRemindMinutes');
  @override
  late final GeneratedColumn<int> memoryRemindMinutes = GeneratedColumn<int>(
    'memory_remind_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(540),
  );
  static const VerificationMeta _onThisDayEnabledMeta = const VerificationMeta(
    'onThisDayEnabled',
  );
  @override
  late final GeneratedColumn<bool> onThisDayEnabled = GeneratedColumn<bool>(
    'on_this_day_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("on_this_day_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    currencySymbol,
    sleepGoalMinutes,
    targetBedtimeMinutes,
    weeklyReportEnabled,
    weeklyReportMinutes,
    memoryRemindMinutes,
    onThisDayEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('currency_symbol')) {
      context.handle(
        _currencySymbolMeta,
        currencySymbol.isAcceptableOrUnknown(
          data['currency_symbol']!,
          _currencySymbolMeta,
        ),
      );
    }
    if (data.containsKey('sleep_goal_minutes')) {
      context.handle(
        _sleepGoalMinutesMeta,
        sleepGoalMinutes.isAcceptableOrUnknown(
          data['sleep_goal_minutes']!,
          _sleepGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('target_bedtime_minutes')) {
      context.handle(
        _targetBedtimeMinutesMeta,
        targetBedtimeMinutes.isAcceptableOrUnknown(
          data['target_bedtime_minutes']!,
          _targetBedtimeMinutesMeta,
        ),
      );
    }
    if (data.containsKey('weekly_report_enabled')) {
      context.handle(
        _weeklyReportEnabledMeta,
        weeklyReportEnabled.isAcceptableOrUnknown(
          data['weekly_report_enabled']!,
          _weeklyReportEnabledMeta,
        ),
      );
    }
    if (data.containsKey('weekly_report_minutes')) {
      context.handle(
        _weeklyReportMinutesMeta,
        weeklyReportMinutes.isAcceptableOrUnknown(
          data['weekly_report_minutes']!,
          _weeklyReportMinutesMeta,
        ),
      );
    }
    if (data.containsKey('memory_remind_minutes')) {
      context.handle(
        _memoryRemindMinutesMeta,
        memoryRemindMinutes.isAcceptableOrUnknown(
          data['memory_remind_minutes']!,
          _memoryRemindMinutesMeta,
        ),
      );
    }
    if (data.containsKey('on_this_day_enabled')) {
      context.handle(
        _onThisDayEnabledMeta,
        onThisDayEnabled.isAcceptableOrUnknown(
          data['on_this_day_enabled']!,
          _onThisDayEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currencySymbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_symbol'],
      )!,
      sleepGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_goal_minutes'],
      )!,
      targetBedtimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_bedtime_minutes'],
      )!,
      weeklyReportEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekly_report_enabled'],
      )!,
      weeklyReportMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_report_minutes'],
      )!,
      memoryRemindMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}memory_remind_minutes'],
      )!,
      onThisDayEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}on_this_day_enabled'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final int id;
  final String currencySymbol;
  final int sleepGoalMinutes;
  final int targetBedtimeMinutes;
  final bool weeklyReportEnabled;
  final int weeklyReportMinutes;
  final int memoryRemindMinutes;
  final bool onThisDayEnabled;
  const Setting({
    required this.id,
    required this.currencySymbol,
    required this.sleepGoalMinutes,
    required this.targetBedtimeMinutes,
    required this.weeklyReportEnabled,
    required this.weeklyReportMinutes,
    required this.memoryRemindMinutes,
    required this.onThisDayEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['currency_symbol'] = Variable<String>(currencySymbol);
    map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes);
    map['target_bedtime_minutes'] = Variable<int>(targetBedtimeMinutes);
    map['weekly_report_enabled'] = Variable<bool>(weeklyReportEnabled);
    map['weekly_report_minutes'] = Variable<int>(weeklyReportMinutes);
    map['memory_remind_minutes'] = Variable<int>(memoryRemindMinutes);
    map['on_this_day_enabled'] = Variable<bool>(onThisDayEnabled);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      currencySymbol: Value(currencySymbol),
      sleepGoalMinutes: Value(sleepGoalMinutes),
      targetBedtimeMinutes: Value(targetBedtimeMinutes),
      weeklyReportEnabled: Value(weeklyReportEnabled),
      weeklyReportMinutes: Value(weeklyReportMinutes),
      memoryRemindMinutes: Value(memoryRemindMinutes),
      onThisDayEnabled: Value(onThisDayEnabled),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<int>(json['id']),
      currencySymbol: serializer.fromJson<String>(json['currencySymbol']),
      sleepGoalMinutes: serializer.fromJson<int>(json['sleepGoalMinutes']),
      targetBedtimeMinutes: serializer.fromJson<int>(
        json['targetBedtimeMinutes'],
      ),
      weeklyReportEnabled: serializer.fromJson<bool>(
        json['weeklyReportEnabled'],
      ),
      weeklyReportMinutes: serializer.fromJson<int>(
        json['weeklyReportMinutes'],
      ),
      memoryRemindMinutes: serializer.fromJson<int>(
        json['memoryRemindMinutes'],
      ),
      onThisDayEnabled: serializer.fromJson<bool>(json['onThisDayEnabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currencySymbol': serializer.toJson<String>(currencySymbol),
      'sleepGoalMinutes': serializer.toJson<int>(sleepGoalMinutes),
      'targetBedtimeMinutes': serializer.toJson<int>(targetBedtimeMinutes),
      'weeklyReportEnabled': serializer.toJson<bool>(weeklyReportEnabled),
      'weeklyReportMinutes': serializer.toJson<int>(weeklyReportMinutes),
      'memoryRemindMinutes': serializer.toJson<int>(memoryRemindMinutes),
      'onThisDayEnabled': serializer.toJson<bool>(onThisDayEnabled),
    };
  }

  Setting copyWith({
    int? id,
    String? currencySymbol,
    int? sleepGoalMinutes,
    int? targetBedtimeMinutes,
    bool? weeklyReportEnabled,
    int? weeklyReportMinutes,
    int? memoryRemindMinutes,
    bool? onThisDayEnabled,
  }) => Setting(
    id: id ?? this.id,
    currencySymbol: currencySymbol ?? this.currencySymbol,
    sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
    targetBedtimeMinutes: targetBedtimeMinutes ?? this.targetBedtimeMinutes,
    weeklyReportEnabled: weeklyReportEnabled ?? this.weeklyReportEnabled,
    weeklyReportMinutes: weeklyReportMinutes ?? this.weeklyReportMinutes,
    memoryRemindMinutes: memoryRemindMinutes ?? this.memoryRemindMinutes,
    onThisDayEnabled: onThisDayEnabled ?? this.onThisDayEnabled,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      currencySymbol: data.currencySymbol.present
          ? data.currencySymbol.value
          : this.currencySymbol,
      sleepGoalMinutes: data.sleepGoalMinutes.present
          ? data.sleepGoalMinutes.value
          : this.sleepGoalMinutes,
      targetBedtimeMinutes: data.targetBedtimeMinutes.present
          ? data.targetBedtimeMinutes.value
          : this.targetBedtimeMinutes,
      weeklyReportEnabled: data.weeklyReportEnabled.present
          ? data.weeklyReportEnabled.value
          : this.weeklyReportEnabled,
      weeklyReportMinutes: data.weeklyReportMinutes.present
          ? data.weeklyReportMinutes.value
          : this.weeklyReportMinutes,
      memoryRemindMinutes: data.memoryRemindMinutes.present
          ? data.memoryRemindMinutes.value
          : this.memoryRemindMinutes,
      onThisDayEnabled: data.onThisDayEnabled.present
          ? data.onThisDayEnabled.value
          : this.onThisDayEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('targetBedtimeMinutes: $targetBedtimeMinutes, ')
          ..write('weeklyReportEnabled: $weeklyReportEnabled, ')
          ..write('weeklyReportMinutes: $weeklyReportMinutes, ')
          ..write('memoryRemindMinutes: $memoryRemindMinutes, ')
          ..write('onThisDayEnabled: $onThisDayEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    currencySymbol,
    sleepGoalMinutes,
    targetBedtimeMinutes,
    weeklyReportEnabled,
    weeklyReportMinutes,
    memoryRemindMinutes,
    onThisDayEnabled,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.currencySymbol == this.currencySymbol &&
          other.sleepGoalMinutes == this.sleepGoalMinutes &&
          other.targetBedtimeMinutes == this.targetBedtimeMinutes &&
          other.weeklyReportEnabled == this.weeklyReportEnabled &&
          other.weeklyReportMinutes == this.weeklyReportMinutes &&
          other.memoryRemindMinutes == this.memoryRemindMinutes &&
          other.onThisDayEnabled == this.onThisDayEnabled);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<int> id;
  final Value<String> currencySymbol;
  final Value<int> sleepGoalMinutes;
  final Value<int> targetBedtimeMinutes;
  final Value<bool> weeklyReportEnabled;
  final Value<int> weeklyReportMinutes;
  final Value<int> memoryRemindMinutes;
  final Value<bool> onThisDayEnabled;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.sleepGoalMinutes = const Value.absent(),
    this.targetBedtimeMinutes = const Value.absent(),
    this.weeklyReportEnabled = const Value.absent(),
    this.weeklyReportMinutes = const Value.absent(),
    this.memoryRemindMinutes = const Value.absent(),
    this.onThisDayEnabled = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.currencySymbol = const Value.absent(),
    this.sleepGoalMinutes = const Value.absent(),
    this.targetBedtimeMinutes = const Value.absent(),
    this.weeklyReportEnabled = const Value.absent(),
    this.weeklyReportMinutes = const Value.absent(),
    this.memoryRemindMinutes = const Value.absent(),
    this.onThisDayEnabled = const Value.absent(),
  });
  static Insertable<Setting> custom({
    Expression<int>? id,
    Expression<String>? currencySymbol,
    Expression<int>? sleepGoalMinutes,
    Expression<int>? targetBedtimeMinutes,
    Expression<bool>? weeklyReportEnabled,
    Expression<int>? weeklyReportMinutes,
    Expression<int>? memoryRemindMinutes,
    Expression<bool>? onThisDayEnabled,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currencySymbol != null) 'currency_symbol': currencySymbol,
      if (sleepGoalMinutes != null) 'sleep_goal_minutes': sleepGoalMinutes,
      if (targetBedtimeMinutes != null)
        'target_bedtime_minutes': targetBedtimeMinutes,
      if (weeklyReportEnabled != null)
        'weekly_report_enabled': weeklyReportEnabled,
      if (weeklyReportMinutes != null)
        'weekly_report_minutes': weeklyReportMinutes,
      if (memoryRemindMinutes != null)
        'memory_remind_minutes': memoryRemindMinutes,
      if (onThisDayEnabled != null) 'on_this_day_enabled': onThisDayEnabled,
    });
  }

  SettingsCompanion copyWith({
    Value<int>? id,
    Value<String>? currencySymbol,
    Value<int>? sleepGoalMinutes,
    Value<int>? targetBedtimeMinutes,
    Value<bool>? weeklyReportEnabled,
    Value<int>? weeklyReportMinutes,
    Value<int>? memoryRemindMinutes,
    Value<bool>? onThisDayEnabled,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
      targetBedtimeMinutes: targetBedtimeMinutes ?? this.targetBedtimeMinutes,
      weeklyReportEnabled: weeklyReportEnabled ?? this.weeklyReportEnabled,
      weeklyReportMinutes: weeklyReportMinutes ?? this.weeklyReportMinutes,
      memoryRemindMinutes: memoryRemindMinutes ?? this.memoryRemindMinutes,
      onThisDayEnabled: onThisDayEnabled ?? this.onThisDayEnabled,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currencySymbol.present) {
      map['currency_symbol'] = Variable<String>(currencySymbol.value);
    }
    if (sleepGoalMinutes.present) {
      map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes.value);
    }
    if (targetBedtimeMinutes.present) {
      map['target_bedtime_minutes'] = Variable<int>(targetBedtimeMinutes.value);
    }
    if (weeklyReportEnabled.present) {
      map['weekly_report_enabled'] = Variable<bool>(weeklyReportEnabled.value);
    }
    if (weeklyReportMinutes.present) {
      map['weekly_report_minutes'] = Variable<int>(weeklyReportMinutes.value);
    }
    if (memoryRemindMinutes.present) {
      map['memory_remind_minutes'] = Variable<int>(memoryRemindMinutes.value);
    }
    if (onThisDayEnabled.present) {
      map['on_this_day_enabled'] = Variable<bool>(onThisDayEnabled.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('currencySymbol: $currencySymbol, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('targetBedtimeMinutes: $targetBedtimeMinutes, ')
          ..write('weeklyReportEnabled: $weeklyReportEnabled, ')
          ..write('weeklyReportMinutes: $weeklyReportMinutes, ')
          ..write('memoryRemindMinutes: $memoryRemindMinutes, ')
          ..write('onThisDayEnabled: $onThisDayEnabled')
          ..write(')'))
        .toString();
  }
}

class $SleepSessionsTable extends SleepSessions
    with TableInfo<$SleepSessionsTable, SleepSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SleepSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _sleepAtMeta = const VerificationMeta(
    'sleepAt',
  );
  @override
  late final GeneratedColumn<DateTime> sleepAt = GeneratedColumn<DateTime>(
    'sleep_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wakeAtMeta = const VerificationMeta('wakeAt');
  @override
  late final GeneratedColumn<DateTime> wakeAt = GeneratedColumn<DateTime>(
    'wake_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<int> quality = GeneratedColumn<int>(
    'quality',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, sleepAt, wakeAt, quality, note];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sleep_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<SleepSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('sleep_at')) {
      context.handle(
        _sleepAtMeta,
        sleepAt.isAcceptableOrUnknown(data['sleep_at']!, _sleepAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sleepAtMeta);
    }
    if (data.containsKey('wake_at')) {
      context.handle(
        _wakeAtMeta,
        wakeAt.isAcceptableOrUnknown(data['wake_at']!, _wakeAtMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SleepSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SleepSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      sleepAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sleep_at'],
      )!,
      wakeAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}wake_at'],
      ),
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quality'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $SleepSessionsTable createAlias(String alias) {
    return $SleepSessionsTable(attachedDatabase, alias);
  }
}

class SleepSession extends DataClass implements Insertable<SleepSession> {
  final int id;
  final DateTime sleepAt;
  final DateTime? wakeAt;
  final int? quality;
  final String? note;
  const SleepSession({
    required this.id,
    required this.sleepAt,
    this.wakeAt,
    this.quality,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['sleep_at'] = Variable<DateTime>(sleepAt);
    if (!nullToAbsent || wakeAt != null) {
      map['wake_at'] = Variable<DateTime>(wakeAt);
    }
    if (!nullToAbsent || quality != null) {
      map['quality'] = Variable<int>(quality);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  SleepSessionsCompanion toCompanion(bool nullToAbsent) {
    return SleepSessionsCompanion(
      id: Value(id),
      sleepAt: Value(sleepAt),
      wakeAt: wakeAt == null && nullToAbsent
          ? const Value.absent()
          : Value(wakeAt),
      quality: quality == null && nullToAbsent
          ? const Value.absent()
          : Value(quality),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory SleepSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SleepSession(
      id: serializer.fromJson<int>(json['id']),
      sleepAt: serializer.fromJson<DateTime>(json['sleepAt']),
      wakeAt: serializer.fromJson<DateTime?>(json['wakeAt']),
      quality: serializer.fromJson<int?>(json['quality']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sleepAt': serializer.toJson<DateTime>(sleepAt),
      'wakeAt': serializer.toJson<DateTime?>(wakeAt),
      'quality': serializer.toJson<int?>(quality),
      'note': serializer.toJson<String?>(note),
    };
  }

  SleepSession copyWith({
    int? id,
    DateTime? sleepAt,
    Value<DateTime?> wakeAt = const Value.absent(),
    Value<int?> quality = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => SleepSession(
    id: id ?? this.id,
    sleepAt: sleepAt ?? this.sleepAt,
    wakeAt: wakeAt.present ? wakeAt.value : this.wakeAt,
    quality: quality.present ? quality.value : this.quality,
    note: note.present ? note.value : this.note,
  );
  SleepSession copyWithCompanion(SleepSessionsCompanion data) {
    return SleepSession(
      id: data.id.present ? data.id.value : this.id,
      sleepAt: data.sleepAt.present ? data.sleepAt.value : this.sleepAt,
      wakeAt: data.wakeAt.present ? data.wakeAt.value : this.wakeAt,
      quality: data.quality.present ? data.quality.value : this.quality,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SleepSession(')
          ..write('id: $id, ')
          ..write('sleepAt: $sleepAt, ')
          ..write('wakeAt: $wakeAt, ')
          ..write('quality: $quality, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, sleepAt, wakeAt, quality, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SleepSession &&
          other.id == this.id &&
          other.sleepAt == this.sleepAt &&
          other.wakeAt == this.wakeAt &&
          other.quality == this.quality &&
          other.note == this.note);
}

class SleepSessionsCompanion extends UpdateCompanion<SleepSession> {
  final Value<int> id;
  final Value<DateTime> sleepAt;
  final Value<DateTime?> wakeAt;
  final Value<int?> quality;
  final Value<String?> note;
  const SleepSessionsCompanion({
    this.id = const Value.absent(),
    this.sleepAt = const Value.absent(),
    this.wakeAt = const Value.absent(),
    this.quality = const Value.absent(),
    this.note = const Value.absent(),
  });
  SleepSessionsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime sleepAt,
    this.wakeAt = const Value.absent(),
    this.quality = const Value.absent(),
    this.note = const Value.absent(),
  }) : sleepAt = Value(sleepAt);
  static Insertable<SleepSession> custom({
    Expression<int>? id,
    Expression<DateTime>? sleepAt,
    Expression<DateTime>? wakeAt,
    Expression<int>? quality,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sleepAt != null) 'sleep_at': sleepAt,
      if (wakeAt != null) 'wake_at': wakeAt,
      if (quality != null) 'quality': quality,
      if (note != null) 'note': note,
    });
  }

  SleepSessionsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? sleepAt,
    Value<DateTime?>? wakeAt,
    Value<int?>? quality,
    Value<String?>? note,
  }) {
    return SleepSessionsCompanion(
      id: id ?? this.id,
      sleepAt: sleepAt ?? this.sleepAt,
      wakeAt: wakeAt ?? this.wakeAt,
      quality: quality ?? this.quality,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sleepAt.present) {
      map['sleep_at'] = Variable<DateTime>(sleepAt.value);
    }
    if (wakeAt.present) {
      map['wake_at'] = Variable<DateTime>(wakeAt.value);
    }
    if (quality.present) {
      map['quality'] = Variable<int>(quality.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SleepSessionsCompanion(')
          ..write('id: $id, ')
          ..write('sleepAt: $sleepAt, ')
          ..write('wakeAt: $wakeAt, ')
          ..write('quality: $quality, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetCentsMeta = const VerificationMeta(
    'budgetCents',
  );
  @override
  late final GeneratedColumn<int> budgetCents = GeneratedColumn<int>(
    'budget_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, budgetCents, archived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('budget_cents')) {
      context.handle(
        _budgetCentsMeta,
        budgetCents.isAcceptableOrUnknown(
          data['budget_cents']!,
          _budgetCentsMeta,
        ),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      budgetCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}budget_cents'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final int id;
  final String name;
  final int? budgetCents;
  final bool archived;
  const Category({
    required this.id,
    required this.name,
    this.budgetCents,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || budgetCents != null) {
      map['budget_cents'] = Variable<int>(budgetCents);
    }
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      budgetCents: budgetCents == null && nullToAbsent
          ? const Value.absent()
          : Value(budgetCents),
      archived: Value(archived),
    );
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      budgetCents: serializer.fromJson<int?>(json['budgetCents']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'budgetCents': serializer.toJson<int?>(budgetCents),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  Category copyWith({
    int? id,
    String? name,
    Value<int?> budgetCents = const Value.absent(),
    bool? archived,
  }) => Category(
    id: id ?? this.id,
    name: name ?? this.name,
    budgetCents: budgetCents.present ? budgetCents.value : this.budgetCents,
    archived: archived ?? this.archived,
  );
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      budgetCents: data.budgetCents.present
          ? data.budgetCents.value
          : this.budgetCents,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, budgetCents, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category &&
          other.id == this.id &&
          other.name == this.name &&
          other.budgetCents == this.budgetCents &&
          other.archived == this.archived);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<int> id;
  final Value<String> name;
  final Value<int?> budgetCents;
  final Value<bool> archived;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.budgetCents = const Value.absent(),
    this.archived = const Value.absent(),
  });
  CategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.budgetCents = const Value.absent(),
    this.archived = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Category> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? budgetCents,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (budgetCents != null) 'budget_cents': budgetCents,
      if (archived != null) 'archived': archived,
    });
  }

  CategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int?>? budgetCents,
    Value<bool>? archived,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      budgetCents: budgetCents ?? this.budgetCents,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (budgetCents.present) {
      map['budget_cents'] = Variable<int>(budgetCents.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('budgetCents: $budgetCents, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id)',
    ),
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
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _itemMeta = const VerificationMeta('item');
  @override
  late final GeneratedColumn<String> item = GeneratedColumn<String>(
    'item',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storeMeta = const VerificationMeta('store');
  @override
  late final GeneratedColumn<String> store = GeneratedColumn<String>(
    'store',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _warrantyOrReturnByMeta =
      const VerificationMeta('warrantyOrReturnBy');
  @override
  late final GeneratedColumn<DateTime> warrantyOrReturnBy =
      GeneratedColumn<DateTime>(
        'warranty_or_return_by',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amountCents,
    categoryId,
    date,
    paymentMethod,
    note,
    item,
    store,
    warrantyOrReturnBy,
    receiptPath,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('item')) {
      context.handle(
        _itemMeta,
        item.isAcceptableOrUnknown(data['item']!, _itemMeta),
      );
    }
    if (data.containsKey('store')) {
      context.handle(
        _storeMeta,
        store.isAcceptableOrUnknown(data['store']!, _storeMeta),
      );
    }
    if (data.containsKey('warranty_or_return_by')) {
      context.handle(
        _warrantyOrReturnByMeta,
        warrantyOrReturnBy.isAcceptableOrUnknown(
          data['warranty_or_return_by']!,
          _warrantyOrReturnByMeta,
        ),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      item: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item'],
      ),
      store: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store'],
      ),
      warrantyOrReturnBy: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}warranty_or_return_by'],
      ),
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final int id;
  final int amountCents;
  final int categoryId;
  final DateTime date;
  final String paymentMethod;
  final String? note;
  final String? item;
  final String? store;
  final DateTime? warrantyOrReturnBy;
  final String? receiptPath;
  const Expense({
    required this.id,
    required this.amountCents,
    required this.categoryId,
    required this.date,
    required this.paymentMethod,
    this.note,
    this.item,
    this.store,
    this.warrantyOrReturnBy,
    this.receiptPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount_cents'] = Variable<int>(amountCents);
    map['category_id'] = Variable<int>(categoryId);
    map['date'] = Variable<DateTime>(date);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || item != null) {
      map['item'] = Variable<String>(item);
    }
    if (!nullToAbsent || store != null) {
      map['store'] = Variable<String>(store);
    }
    if (!nullToAbsent || warrantyOrReturnBy != null) {
      map['warranty_or_return_by'] = Variable<DateTime>(warrantyOrReturnBy);
    }
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      amountCents: Value(amountCents),
      categoryId: Value(categoryId),
      date: Value(date),
      paymentMethod: Value(paymentMethod),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      item: item == null && nullToAbsent ? const Value.absent() : Value(item),
      store: store == null && nullToAbsent
          ? const Value.absent()
          : Value(store),
      warrantyOrReturnBy: warrantyOrReturnBy == null && nullToAbsent
          ? const Value.absent()
          : Value(warrantyOrReturnBy),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<int>(json['id']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      date: serializer.fromJson<DateTime>(json['date']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      note: serializer.fromJson<String?>(json['note']),
      item: serializer.fromJson<String?>(json['item']),
      store: serializer.fromJson<String?>(json['store']),
      warrantyOrReturnBy: serializer.fromJson<DateTime?>(
        json['warrantyOrReturnBy'],
      ),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amountCents': serializer.toJson<int>(amountCents),
      'categoryId': serializer.toJson<int>(categoryId),
      'date': serializer.toJson<DateTime>(date),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'note': serializer.toJson<String?>(note),
      'item': serializer.toJson<String?>(item),
      'store': serializer.toJson<String?>(store),
      'warrantyOrReturnBy': serializer.toJson<DateTime?>(warrantyOrReturnBy),
      'receiptPath': serializer.toJson<String?>(receiptPath),
    };
  }

  Expense copyWith({
    int? id,
    int? amountCents,
    int? categoryId,
    DateTime? date,
    String? paymentMethod,
    Value<String?> note = const Value.absent(),
    Value<String?> item = const Value.absent(),
    Value<String?> store = const Value.absent(),
    Value<DateTime?> warrantyOrReturnBy = const Value.absent(),
    Value<String?> receiptPath = const Value.absent(),
  }) => Expense(
    id: id ?? this.id,
    amountCents: amountCents ?? this.amountCents,
    categoryId: categoryId ?? this.categoryId,
    date: date ?? this.date,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    note: note.present ? note.value : this.note,
    item: item.present ? item.value : this.item,
    store: store.present ? store.value : this.store,
    warrantyOrReturnBy: warrantyOrReturnBy.present
        ? warrantyOrReturnBy.value
        : this.warrantyOrReturnBy,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      date: data.date.present ? data.date.value : this.date,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      note: data.note.present ? data.note.value : this.note,
      item: data.item.present ? data.item.value : this.item,
      store: data.store.present ? data.store.value : this.store,
      warrantyOrReturnBy: data.warrantyOrReturnBy.present
          ? data.warrantyOrReturnBy.value
          : this.warrantyOrReturnBy,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('item: $item, ')
          ..write('store: $store, ')
          ..write('warrantyOrReturnBy: $warrantyOrReturnBy, ')
          ..write('receiptPath: $receiptPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amountCents,
    categoryId,
    date,
    paymentMethod,
    note,
    item,
    store,
    warrantyOrReturnBy,
    receiptPath,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.amountCents == this.amountCents &&
          other.categoryId == this.categoryId &&
          other.date == this.date &&
          other.paymentMethod == this.paymentMethod &&
          other.note == this.note &&
          other.item == this.item &&
          other.store == this.store &&
          other.warrantyOrReturnBy == this.warrantyOrReturnBy &&
          other.receiptPath == this.receiptPath);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<int> id;
  final Value<int> amountCents;
  final Value<int> categoryId;
  final Value<DateTime> date;
  final Value<String> paymentMethod;
  final Value<String?> note;
  final Value<String?> item;
  final Value<String?> store;
  final Value<DateTime?> warrantyOrReturnBy;
  final Value<String?> receiptPath;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.date = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.note = const Value.absent(),
    this.item = const Value.absent(),
    this.store = const Value.absent(),
    this.warrantyOrReturnBy = const Value.absent(),
    this.receiptPath = const Value.absent(),
  });
  ExpensesCompanion.insert({
    this.id = const Value.absent(),
    required int amountCents,
    required int categoryId,
    required DateTime date,
    required String paymentMethod,
    this.note = const Value.absent(),
    this.item = const Value.absent(),
    this.store = const Value.absent(),
    this.warrantyOrReturnBy = const Value.absent(),
    this.receiptPath = const Value.absent(),
  }) : amountCents = Value(amountCents),
       categoryId = Value(categoryId),
       date = Value(date),
       paymentMethod = Value(paymentMethod);
  static Insertable<Expense> custom({
    Expression<int>? id,
    Expression<int>? amountCents,
    Expression<int>? categoryId,
    Expression<DateTime>? date,
    Expression<String>? paymentMethod,
    Expression<String>? note,
    Expression<String>? item,
    Expression<String>? store,
    Expression<DateTime>? warrantyOrReturnBy,
    Expression<String>? receiptPath,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amountCents != null) 'amount_cents': amountCents,
      if (categoryId != null) 'category_id': categoryId,
      if (date != null) 'date': date,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (note != null) 'note': note,
      if (item != null) 'item': item,
      if (store != null) 'store': store,
      if (warrantyOrReturnBy != null)
        'warranty_or_return_by': warrantyOrReturnBy,
      if (receiptPath != null) 'receipt_path': receiptPath,
    });
  }

  ExpensesCompanion copyWith({
    Value<int>? id,
    Value<int>? amountCents,
    Value<int>? categoryId,
    Value<DateTime>? date,
    Value<String>? paymentMethod,
    Value<String?>? note,
    Value<String?>? item,
    Value<String?>? store,
    Value<DateTime?>? warrantyOrReturnBy,
    Value<String?>? receiptPath,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      amountCents: amountCents ?? this.amountCents,
      categoryId: categoryId ?? this.categoryId,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      note: note ?? this.note,
      item: item ?? this.item,
      store: store ?? this.store,
      warrantyOrReturnBy: warrantyOrReturnBy ?? this.warrantyOrReturnBy,
      receiptPath: receiptPath ?? this.receiptPath,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (item.present) {
      map['item'] = Variable<String>(item.value);
    }
    if (store.present) {
      map['store'] = Variable<String>(store.value);
    }
    if (warrantyOrReturnBy.present) {
      map['warranty_or_return_by'] = Variable<DateTime>(
        warrantyOrReturnBy.value,
      );
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('amountCents: $amountCents, ')
          ..write('categoryId: $categoryId, ')
          ..write('date: $date, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('note: $note, ')
          ..write('item: $item, ')
          ..write('store: $store, ')
          ..write('warrantyOrReturnBy: $warrantyOrReturnBy, ')
          ..write('receiptPath: $receiptPath')
          ..write(')'))
        .toString();
  }
}

class $StocksTable extends Stocks with TableInfo<$StocksTable, Stock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StocksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
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
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPriceCentsMeta = const VerificationMeta(
    'lastPriceCents',
  );
  @override
  late final GeneratedColumn<int> lastPriceCents = GeneratedColumn<int>(
    'last_price_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priceDateMeta = const VerificationMeta(
    'priceDate',
  );
  @override
  late final GeneratedColumn<DateTime> priceDate = GeneratedColumn<DateTime>(
    'price_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    symbol,
    name,
    lastPriceCents,
    priceDate,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stocks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Stock> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_price_cents')) {
      context.handle(
        _lastPriceCentsMeta,
        lastPriceCents.isAcceptableOrUnknown(
          data['last_price_cents']!,
          _lastPriceCentsMeta,
        ),
      );
    }
    if (data.containsKey('price_date')) {
      context.handle(
        _priceDateMeta,
        priceDate.isAcceptableOrUnknown(data['price_date']!, _priceDateMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Stock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Stock(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastPriceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_price_cents'],
      ),
      priceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}price_date'],
      ),
    );
  }

  @override
  $StocksTable createAlias(String alias) {
    return $StocksTable(attachedDatabase, alias);
  }
}

class Stock extends DataClass implements Insertable<Stock> {
  final int id;
  final String symbol;
  final String name;
  final int? lastPriceCents;
  final DateTime? priceDate;
  const Stock({
    required this.id,
    required this.symbol,
    required this.name,
    this.lastPriceCents,
    this.priceDate,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lastPriceCents != null) {
      map['last_price_cents'] = Variable<int>(lastPriceCents);
    }
    if (!nullToAbsent || priceDate != null) {
      map['price_date'] = Variable<DateTime>(priceDate);
    }
    return map;
  }

  StocksCompanion toCompanion(bool nullToAbsent) {
    return StocksCompanion(
      id: Value(id),
      symbol: Value(symbol),
      name: Value(name),
      lastPriceCents: lastPriceCents == null && nullToAbsent
          ? const Value.absent()
          : Value(lastPriceCents),
      priceDate: priceDate == null && nullToAbsent
          ? const Value.absent()
          : Value(priceDate),
    );
  }

  factory Stock.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Stock(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String>(json['name']),
      lastPriceCents: serializer.fromJson<int?>(json['lastPriceCents']),
      priceDate: serializer.fromJson<DateTime?>(json['priceDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String>(name),
      'lastPriceCents': serializer.toJson<int?>(lastPriceCents),
      'priceDate': serializer.toJson<DateTime?>(priceDate),
    };
  }

  Stock copyWith({
    int? id,
    String? symbol,
    String? name,
    Value<int?> lastPriceCents = const Value.absent(),
    Value<DateTime?> priceDate = const Value.absent(),
  }) => Stock(
    id: id ?? this.id,
    symbol: symbol ?? this.symbol,
    name: name ?? this.name,
    lastPriceCents: lastPriceCents.present
        ? lastPriceCents.value
        : this.lastPriceCents,
    priceDate: priceDate.present ? priceDate.value : this.priceDate,
  );
  Stock copyWithCompanion(StocksCompanion data) {
    return Stock(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      lastPriceCents: data.lastPriceCents.present
          ? data.lastPriceCents.value
          : this.lastPriceCents,
      priceDate: data.priceDate.present ? data.priceDate.value : this.priceDate,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Stock(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('lastPriceCents: $lastPriceCents, ')
          ..write('priceDate: $priceDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, symbol, name, lastPriceCents, priceDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Stock &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.lastPriceCents == this.lastPriceCents &&
          other.priceDate == this.priceDate);
}

class StocksCompanion extends UpdateCompanion<Stock> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> name;
  final Value<int?> lastPriceCents;
  final Value<DateTime?> priceDate;
  const StocksCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.lastPriceCents = const Value.absent(),
    this.priceDate = const Value.absent(),
  });
  StocksCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String name,
    this.lastPriceCents = const Value.absent(),
    this.priceDate = const Value.absent(),
  }) : symbol = Value(symbol),
       name = Value(name);
  static Insertable<Stock> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<int>? lastPriceCents,
    Expression<DateTime>? priceDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (lastPriceCents != null) 'last_price_cents': lastPriceCents,
      if (priceDate != null) 'price_date': priceDate,
    });
  }

  StocksCompanion copyWith({
    Value<int>? id,
    Value<String>? symbol,
    Value<String>? name,
    Value<int?>? lastPriceCents,
    Value<DateTime?>? priceDate,
  }) {
    return StocksCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      lastPriceCents: lastPriceCents ?? this.lastPriceCents,
      priceDate: priceDate ?? this.priceDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastPriceCents.present) {
      map['last_price_cents'] = Variable<int>(lastPriceCents.value);
    }
    if (priceDate.present) {
      map['price_date'] = Variable<DateTime>(priceDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StocksCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('lastPriceCents: $lastPriceCents, ')
          ..write('priceDate: $priceDate')
          ..write(')'))
        .toString();
  }
}

class $TradesTable extends Trades with TableInfo<$TradesTable, Trade> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TradesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _stockIdMeta = const VerificationMeta(
    'stockId',
  );
  @override
  late final GeneratedColumn<int> stockId = GeneratedColumn<int>(
    'stock_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stocks (id)',
    ),
  );
  static const VerificationMeta _isBuyMeta = const VerificationMeta('isBuy');
  @override
  late final GeneratedColumn<bool> isBuy = GeneratedColumn<bool>(
    'is_buy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_buy" IN (0, 1))',
    ),
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
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceCentsMeta = const VerificationMeta(
    'priceCents',
  );
  @override
  late final GeneratedColumn<int> priceCents = GeneratedColumn<int>(
    'price_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _feesCentsMeta = const VerificationMeta(
    'feesCents',
  );
  @override
  late final GeneratedColumn<int> feesCents = GeneratedColumn<int>(
    'fees_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    stockId,
    isBuy,
    date,
    quantity,
    priceCents,
    feesCents,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trades';
  @override
  VerificationContext validateIntegrity(
    Insertable<Trade> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('stock_id')) {
      context.handle(
        _stockIdMeta,
        stockId.isAcceptableOrUnknown(data['stock_id']!, _stockIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stockIdMeta);
    }
    if (data.containsKey('is_buy')) {
      context.handle(
        _isBuyMeta,
        isBuy.isAcceptableOrUnknown(data['is_buy']!, _isBuyMeta),
      );
    } else if (isInserting) {
      context.missing(_isBuyMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price_cents')) {
      context.handle(
        _priceCentsMeta,
        priceCents.isAcceptableOrUnknown(data['price_cents']!, _priceCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_priceCentsMeta);
    }
    if (data.containsKey('fees_cents')) {
      context.handle(
        _feesCentsMeta,
        feesCents.isAcceptableOrUnknown(data['fees_cents']!, _feesCentsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Trade map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Trade(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      stockId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock_id'],
      )!,
      isBuy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_buy'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      priceCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price_cents'],
      )!,
      feesCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fees_cents'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $TradesTable createAlias(String alias) {
    return $TradesTable(attachedDatabase, alias);
  }
}

class Trade extends DataClass implements Insertable<Trade> {
  final int id;
  final int stockId;
  final bool isBuy;
  final DateTime date;
  final int quantity;
  final int priceCents;
  final int feesCents;
  final String? note;
  const Trade({
    required this.id,
    required this.stockId,
    required this.isBuy,
    required this.date,
    required this.quantity,
    required this.priceCents,
    required this.feesCents,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['stock_id'] = Variable<int>(stockId);
    map['is_buy'] = Variable<bool>(isBuy);
    map['date'] = Variable<DateTime>(date);
    map['quantity'] = Variable<int>(quantity);
    map['price_cents'] = Variable<int>(priceCents);
    map['fees_cents'] = Variable<int>(feesCents);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  TradesCompanion toCompanion(bool nullToAbsent) {
    return TradesCompanion(
      id: Value(id),
      stockId: Value(stockId),
      isBuy: Value(isBuy),
      date: Value(date),
      quantity: Value(quantity),
      priceCents: Value(priceCents),
      feesCents: Value(feesCents),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory Trade.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Trade(
      id: serializer.fromJson<int>(json['id']),
      stockId: serializer.fromJson<int>(json['stockId']),
      isBuy: serializer.fromJson<bool>(json['isBuy']),
      date: serializer.fromJson<DateTime>(json['date']),
      quantity: serializer.fromJson<int>(json['quantity']),
      priceCents: serializer.fromJson<int>(json['priceCents']),
      feesCents: serializer.fromJson<int>(json['feesCents']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'stockId': serializer.toJson<int>(stockId),
      'isBuy': serializer.toJson<bool>(isBuy),
      'date': serializer.toJson<DateTime>(date),
      'quantity': serializer.toJson<int>(quantity),
      'priceCents': serializer.toJson<int>(priceCents),
      'feesCents': serializer.toJson<int>(feesCents),
      'note': serializer.toJson<String?>(note),
    };
  }

  Trade copyWith({
    int? id,
    int? stockId,
    bool? isBuy,
    DateTime? date,
    int? quantity,
    int? priceCents,
    int? feesCents,
    Value<String?> note = const Value.absent(),
  }) => Trade(
    id: id ?? this.id,
    stockId: stockId ?? this.stockId,
    isBuy: isBuy ?? this.isBuy,
    date: date ?? this.date,
    quantity: quantity ?? this.quantity,
    priceCents: priceCents ?? this.priceCents,
    feesCents: feesCents ?? this.feesCents,
    note: note.present ? note.value : this.note,
  );
  Trade copyWithCompanion(TradesCompanion data) {
    return Trade(
      id: data.id.present ? data.id.value : this.id,
      stockId: data.stockId.present ? data.stockId.value : this.stockId,
      isBuy: data.isBuy.present ? data.isBuy.value : this.isBuy,
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      priceCents: data.priceCents.present
          ? data.priceCents.value
          : this.priceCents,
      feesCents: data.feesCents.present ? data.feesCents.value : this.feesCents,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Trade(')
          ..write('id: $id, ')
          ..write('stockId: $stockId, ')
          ..write('isBuy: $isBuy, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('priceCents: $priceCents, ')
          ..write('feesCents: $feesCents, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    stockId,
    isBuy,
    date,
    quantity,
    priceCents,
    feesCents,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Trade &&
          other.id == this.id &&
          other.stockId == this.stockId &&
          other.isBuy == this.isBuy &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.priceCents == this.priceCents &&
          other.feesCents == this.feesCents &&
          other.note == this.note);
}

class TradesCompanion extends UpdateCompanion<Trade> {
  final Value<int> id;
  final Value<int> stockId;
  final Value<bool> isBuy;
  final Value<DateTime> date;
  final Value<int> quantity;
  final Value<int> priceCents;
  final Value<int> feesCents;
  final Value<String?> note;
  const TradesCompanion({
    this.id = const Value.absent(),
    this.stockId = const Value.absent(),
    this.isBuy = const Value.absent(),
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.priceCents = const Value.absent(),
    this.feesCents = const Value.absent(),
    this.note = const Value.absent(),
  });
  TradesCompanion.insert({
    this.id = const Value.absent(),
    required int stockId,
    required bool isBuy,
    required DateTime date,
    required int quantity,
    required int priceCents,
    this.feesCents = const Value.absent(),
    this.note = const Value.absent(),
  }) : stockId = Value(stockId),
       isBuy = Value(isBuy),
       date = Value(date),
       quantity = Value(quantity),
       priceCents = Value(priceCents);
  static Insertable<Trade> custom({
    Expression<int>? id,
    Expression<int>? stockId,
    Expression<bool>? isBuy,
    Expression<DateTime>? date,
    Expression<int>? quantity,
    Expression<int>? priceCents,
    Expression<int>? feesCents,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (stockId != null) 'stock_id': stockId,
      if (isBuy != null) 'is_buy': isBuy,
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (priceCents != null) 'price_cents': priceCents,
      if (feesCents != null) 'fees_cents': feesCents,
      if (note != null) 'note': note,
    });
  }

  TradesCompanion copyWith({
    Value<int>? id,
    Value<int>? stockId,
    Value<bool>? isBuy,
    Value<DateTime>? date,
    Value<int>? quantity,
    Value<int>? priceCents,
    Value<int>? feesCents,
    Value<String?>? note,
  }) {
    return TradesCompanion(
      id: id ?? this.id,
      stockId: stockId ?? this.stockId,
      isBuy: isBuy ?? this.isBuy,
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      priceCents: priceCents ?? this.priceCents,
      feesCents: feesCents ?? this.feesCents,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (stockId.present) {
      map['stock_id'] = Variable<int>(stockId.value);
    }
    if (isBuy.present) {
      map['is_buy'] = Variable<bool>(isBuy.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (priceCents.present) {
      map['price_cents'] = Variable<int>(priceCents.value);
    }
    if (feesCents.present) {
      map['fees_cents'] = Variable<int>(feesCents.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TradesCompanion(')
          ..write('id: $id, ')
          ..write('stockId: $stockId, ')
          ..write('isBuy: $isBuy, ')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('priceCents: $priceCents, ')
          ..write('feesCents: $feesCents, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $WeeklySnapshotsTable extends WeeklySnapshots
    with TableInfo<$WeeklySnapshotsTable, WeeklySnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeeklySnapshotsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _weekStartMeta = const VerificationMeta(
    'weekStart',
  );
  @override
  late final GeneratedColumn<DateTime> weekStart = GeneratedColumn<DateTime>(
    'week_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _investedCentsMeta = const VerificationMeta(
    'investedCents',
  );
  @override
  late final GeneratedColumn<int> investedCents = GeneratedColumn<int>(
    'invested_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueCentsMeta = const VerificationMeta(
    'valueCents',
  );
  @override
  late final GeneratedColumn<int> valueCents = GeneratedColumn<int>(
    'value_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekStart,
    investedCents,
    valueCents,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weekly_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeeklySnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start')) {
      context.handle(
        _weekStartMeta,
        weekStart.isAcceptableOrUnknown(data['week_start']!, _weekStartMeta),
      );
    } else if (isInserting) {
      context.missing(_weekStartMeta);
    }
    if (data.containsKey('invested_cents')) {
      context.handle(
        _investedCentsMeta,
        investedCents.isAcceptableOrUnknown(
          data['invested_cents']!,
          _investedCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_investedCentsMeta);
    }
    if (data.containsKey('value_cents')) {
      context.handle(
        _valueCentsMeta,
        valueCents.isAcceptableOrUnknown(data['value_cents']!, _valueCentsMeta),
      );
    } else if (isInserting) {
      context.missing(_valueCentsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeeklySnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeeklySnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}week_start'],
      )!,
      investedCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}invested_cents'],
      )!,
      valueCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value_cents'],
      )!,
    );
  }

  @override
  $WeeklySnapshotsTable createAlias(String alias) {
    return $WeeklySnapshotsTable(attachedDatabase, alias);
  }
}

class WeeklySnapshot extends DataClass implements Insertable<WeeklySnapshot> {
  final int id;
  final DateTime weekStart;
  final int investedCents;
  final int valueCents;
  const WeeklySnapshot({
    required this.id,
    required this.weekStart,
    required this.investedCents,
    required this.valueCents,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start'] = Variable<DateTime>(weekStart);
    map['invested_cents'] = Variable<int>(investedCents);
    map['value_cents'] = Variable<int>(valueCents);
    return map;
  }

  WeeklySnapshotsCompanion toCompanion(bool nullToAbsent) {
    return WeeklySnapshotsCompanion(
      id: Value(id),
      weekStart: Value(weekStart),
      investedCents: Value(investedCents),
      valueCents: Value(valueCents),
    );
  }

  factory WeeklySnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeeklySnapshot(
      id: serializer.fromJson<int>(json['id']),
      weekStart: serializer.fromJson<DateTime>(json['weekStart']),
      investedCents: serializer.fromJson<int>(json['investedCents']),
      valueCents: serializer.fromJson<int>(json['valueCents']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStart': serializer.toJson<DateTime>(weekStart),
      'investedCents': serializer.toJson<int>(investedCents),
      'valueCents': serializer.toJson<int>(valueCents),
    };
  }

  WeeklySnapshot copyWith({
    int? id,
    DateTime? weekStart,
    int? investedCents,
    int? valueCents,
  }) => WeeklySnapshot(
    id: id ?? this.id,
    weekStart: weekStart ?? this.weekStart,
    investedCents: investedCents ?? this.investedCents,
    valueCents: valueCents ?? this.valueCents,
  );
  WeeklySnapshot copyWithCompanion(WeeklySnapshotsCompanion data) {
    return WeeklySnapshot(
      id: data.id.present ? data.id.value : this.id,
      weekStart: data.weekStart.present ? data.weekStart.value : this.weekStart,
      investedCents: data.investedCents.present
          ? data.investedCents.value
          : this.investedCents,
      valueCents: data.valueCents.present
          ? data.valueCents.value
          : this.valueCents,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeeklySnapshot(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('investedCents: $investedCents, ')
          ..write('valueCents: $valueCents')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStart, investedCents, valueCents);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeeklySnapshot &&
          other.id == this.id &&
          other.weekStart == this.weekStart &&
          other.investedCents == this.investedCents &&
          other.valueCents == this.valueCents);
}

class WeeklySnapshotsCompanion extends UpdateCompanion<WeeklySnapshot> {
  final Value<int> id;
  final Value<DateTime> weekStart;
  final Value<int> investedCents;
  final Value<int> valueCents;
  const WeeklySnapshotsCompanion({
    this.id = const Value.absent(),
    this.weekStart = const Value.absent(),
    this.investedCents = const Value.absent(),
    this.valueCents = const Value.absent(),
  });
  WeeklySnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime weekStart,
    required int investedCents,
    required int valueCents,
  }) : weekStart = Value(weekStart),
       investedCents = Value(investedCents),
       valueCents = Value(valueCents);
  static Insertable<WeeklySnapshot> custom({
    Expression<int>? id,
    Expression<DateTime>? weekStart,
    Expression<int>? investedCents,
    Expression<int>? valueCents,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStart != null) 'week_start': weekStart,
      if (investedCents != null) 'invested_cents': investedCents,
      if (valueCents != null) 'value_cents': valueCents,
    });
  }

  WeeklySnapshotsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? weekStart,
    Value<int>? investedCents,
    Value<int>? valueCents,
  }) {
    return WeeklySnapshotsCompanion(
      id: id ?? this.id,
      weekStart: weekStart ?? this.weekStart,
      investedCents: investedCents ?? this.investedCents,
      valueCents: valueCents ?? this.valueCents,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStart.present) {
      map['week_start'] = Variable<DateTime>(weekStart.value);
    }
    if (investedCents.present) {
      map['invested_cents'] = Variable<int>(investedCents.value);
    }
    if (valueCents.present) {
      map['value_cents'] = Variable<int>(valueCents.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeeklySnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('weekStart: $weekStart, ')
          ..write('investedCents: $investedCents, ')
          ..write('valueCents: $valueCents')
          ..write(')'))
        .toString();
  }
}

class $BooksTable extends Books with TableInfo<$BooksTable, Book> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BooksTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _totalPagesMeta = const VerificationMeta(
    'totalPages',
  );
  @override
  late final GeneratedColumn<int> totalPages = GeneratedColumn<int>(
    'total_pages',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('wantToRead'),
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverPathMeta = const VerificationMeta(
    'coverPath',
  );
  @override
  late final GeneratedColumn<String> coverPath = GeneratedColumn<String>(
    'cover_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _finishedAtMeta = const VerificationMeta(
    'finishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> finishedAt = GeneratedColumn<DateTime>(
    'finished_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    totalPages,
    status,
    rating,
    coverPath,
    finishedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'books';
  @override
  VerificationContext validateIntegrity(
    Insertable<Book> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('total_pages')) {
      context.handle(
        _totalPagesMeta,
        totalPages.isAcceptableOrUnknown(data['total_pages']!, _totalPagesMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('cover_path')) {
      context.handle(
        _coverPathMeta,
        coverPath.isAcceptableOrUnknown(data['cover_path']!, _coverPathMeta),
      );
    }
    if (data.containsKey('finished_at')) {
      context.handle(
        _finishedAtMeta,
        finishedAt.isAcceptableOrUnknown(data['finished_at']!, _finishedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Book map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Book(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      )!,
      totalPages: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_pages'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      coverPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_path'],
      ),
      finishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}finished_at'],
      ),
    );
  }

  @override
  $BooksTable createAlias(String alias) {
    return $BooksTable(attachedDatabase, alias);
  }
}

class Book extends DataClass implements Insertable<Book> {
  final int id;
  final String title;
  final String author;
  final int? totalPages;
  final String status;
  final int? rating;
  final String? coverPath;
  final DateTime? finishedAt;
  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.totalPages,
    required this.status,
    this.rating,
    this.coverPath,
    this.finishedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['author'] = Variable<String>(author);
    if (!nullToAbsent || totalPages != null) {
      map['total_pages'] = Variable<int>(totalPages);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    if (!nullToAbsent || coverPath != null) {
      map['cover_path'] = Variable<String>(coverPath);
    }
    if (!nullToAbsent || finishedAt != null) {
      map['finished_at'] = Variable<DateTime>(finishedAt);
    }
    return map;
  }

  BooksCompanion toCompanion(bool nullToAbsent) {
    return BooksCompanion(
      id: Value(id),
      title: Value(title),
      author: Value(author),
      totalPages: totalPages == null && nullToAbsent
          ? const Value.absent()
          : Value(totalPages),
      status: Value(status),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      coverPath: coverPath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverPath),
      finishedAt: finishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(finishedAt),
    );
  }

  factory Book.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Book(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String>(json['author']),
      totalPages: serializer.fromJson<int?>(json['totalPages']),
      status: serializer.fromJson<String>(json['status']),
      rating: serializer.fromJson<int?>(json['rating']),
      coverPath: serializer.fromJson<String?>(json['coverPath']),
      finishedAt: serializer.fromJson<DateTime?>(json['finishedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String>(author),
      'totalPages': serializer.toJson<int?>(totalPages),
      'status': serializer.toJson<String>(status),
      'rating': serializer.toJson<int?>(rating),
      'coverPath': serializer.toJson<String?>(coverPath),
      'finishedAt': serializer.toJson<DateTime?>(finishedAt),
    };
  }

  Book copyWith({
    int? id,
    String? title,
    String? author,
    Value<int?> totalPages = const Value.absent(),
    String? status,
    Value<int?> rating = const Value.absent(),
    Value<String?> coverPath = const Value.absent(),
    Value<DateTime?> finishedAt = const Value.absent(),
  }) => Book(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author ?? this.author,
    totalPages: totalPages.present ? totalPages.value : this.totalPages,
    status: status ?? this.status,
    rating: rating.present ? rating.value : this.rating,
    coverPath: coverPath.present ? coverPath.value : this.coverPath,
    finishedAt: finishedAt.present ? finishedAt.value : this.finishedAt,
  );
  Book copyWithCompanion(BooksCompanion data) {
    return Book(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      totalPages: data.totalPages.present
          ? data.totalPages.value
          : this.totalPages,
      status: data.status.present ? data.status.value : this.status,
      rating: data.rating.present ? data.rating.value : this.rating,
      coverPath: data.coverPath.present ? data.coverPath.value : this.coverPath,
      finishedAt: data.finishedAt.present
          ? data.finishedAt.value
          : this.finishedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Book(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('totalPages: $totalPages, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('coverPath: $coverPath, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    totalPages,
    status,
    rating,
    coverPath,
    finishedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Book &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.totalPages == this.totalPages &&
          other.status == this.status &&
          other.rating == this.rating &&
          other.coverPath == this.coverPath &&
          other.finishedAt == this.finishedAt);
}

class BooksCompanion extends UpdateCompanion<Book> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> author;
  final Value<int?> totalPages;
  final Value<String> status;
  final Value<int?> rating;
  final Value<String?> coverPath;
  final Value<DateTime?> finishedAt;
  const BooksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.finishedAt = const Value.absent(),
  });
  BooksCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.author = const Value.absent(),
    this.totalPages = const Value.absent(),
    this.status = const Value.absent(),
    this.rating = const Value.absent(),
    this.coverPath = const Value.absent(),
    this.finishedAt = const Value.absent(),
  }) : title = Value(title);
  static Insertable<Book> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<int>? totalPages,
    Expression<String>? status,
    Expression<int>? rating,
    Expression<String>? coverPath,
    Expression<DateTime>? finishedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (totalPages != null) 'total_pages': totalPages,
      if (status != null) 'status': status,
      if (rating != null) 'rating': rating,
      if (coverPath != null) 'cover_path': coverPath,
      if (finishedAt != null) 'finished_at': finishedAt,
    });
  }

  BooksCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? author,
    Value<int?>? totalPages,
    Value<String>? status,
    Value<int?>? rating,
    Value<String?>? coverPath,
    Value<DateTime?>? finishedAt,
  }) {
    return BooksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      totalPages: totalPages ?? this.totalPages,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      coverPath: coverPath ?? this.coverPath,
      finishedAt: finishedAt ?? this.finishedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (totalPages.present) {
      map['total_pages'] = Variable<int>(totalPages.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (coverPath.present) {
      map['cover_path'] = Variable<String>(coverPath.value);
    }
    if (finishedAt.present) {
      map['finished_at'] = Variable<DateTime>(finishedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BooksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('totalPages: $totalPages, ')
          ..write('status: $status, ')
          ..write('rating: $rating, ')
          ..write('coverPath: $coverPath, ')
          ..write('finishedAt: $finishedAt')
          ..write(')'))
        .toString();
  }
}

class $ReadingSessionsTable extends ReadingSessions
    with TableInfo<$ReadingSessionsTable, ReadingSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingSessionsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endPageMeta = const VerificationMeta(
    'endPage',
  );
  @override
  late final GeneratedColumn<int> endPage = GeneratedColumn<int>(
    'end_page',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, bookId, startAt, endAt, endPage];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('end_page')) {
      context.handle(
        _endPageMeta,
        endPage.isAcceptableOrUnknown(data['end_page']!, _endPageMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      endPage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_page'],
      ),
    );
  }

  @override
  $ReadingSessionsTable createAlias(String alias) {
    return $ReadingSessionsTable(attachedDatabase, alias);
  }
}

class ReadingSession extends DataClass implements Insertable<ReadingSession> {
  final int id;
  final int bookId;
  final DateTime startAt;
  final DateTime? endAt;
  final int? endPage;
  const ReadingSession({
    required this.id,
    required this.bookId,
    required this.startAt,
    this.endAt,
    this.endPage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    map['start_at'] = Variable<DateTime>(startAt);
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    if (!nullToAbsent || endPage != null) {
      map['end_page'] = Variable<int>(endPage);
    }
    return map;
  }

  ReadingSessionsCompanion toCompanion(bool nullToAbsent) {
    return ReadingSessionsCompanion(
      id: Value(id),
      bookId: Value(bookId),
      startAt: Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      endPage: endPage == null && nullToAbsent
          ? const Value.absent()
          : Value(endPage),
    );
  }

  factory ReadingSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingSession(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime?>(json['endAt']),
      endPage: serializer.fromJson<int?>(json['endPage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime?>(endAt),
      'endPage': serializer.toJson<int?>(endPage),
    };
  }

  ReadingSession copyWith({
    int? id,
    int? bookId,
    DateTime? startAt,
    Value<DateTime?> endAt = const Value.absent(),
    Value<int?> endPage = const Value.absent(),
  }) => ReadingSession(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    startAt: startAt ?? this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    endPage: endPage.present ? endPage.value : this.endPage,
  );
  ReadingSession copyWithCompanion(ReadingSessionsCompanion data) {
    return ReadingSession(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      endPage: data.endPage.present ? data.endPage.value : this.endPage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSession(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('endPage: $endPage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookId, startAt, endAt, endPage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingSession &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.endPage == this.endPage);
}

class ReadingSessionsCompanion extends UpdateCompanion<ReadingSession> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<DateTime> startAt;
  final Value<DateTime?> endAt;
  final Value<int?> endPage;
  const ReadingSessionsCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.endPage = const Value.absent(),
  });
  ReadingSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    required DateTime startAt,
    this.endAt = const Value.absent(),
    this.endPage = const Value.absent(),
  }) : bookId = Value(bookId),
       startAt = Value(startAt);
  static Insertable<ReadingSession> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<int>? endPage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (endPage != null) 'end_page': endPage,
    });
  }

  ReadingSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<DateTime>? startAt,
    Value<DateTime?>? endAt,
    Value<int?>? endPage,
  }) {
    return ReadingSessionsCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      endPage: endPage ?? this.endPage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (endPage.present) {
      map['end_page'] = Variable<int>(endPage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingSessionsCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('endPage: $endPage')
          ..write(')'))
        .toString();
  }
}

class $ReadingNotesTable extends ReadingNotes
    with TableInfo<$ReadingNotesTable, ReadingNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
    'book_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES books (id)',
    ),
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<int> sessionId = GeneratedColumn<int>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES reading_sessions (id)',
    ),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isQuoteMeta = const VerificationMeta(
    'isQuote',
  );
  @override
  late final GeneratedColumn<bool> isQuote = GeneratedColumn<bool>(
    'is_quote',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_quote" IN (0, 1))',
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    bookId,
    sessionId,
    body,
    isQuote,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingNote> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('book_id')) {
      context.handle(
        _bookIdMeta,
        bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_quote')) {
      context.handle(
        _isQuoteMeta,
        isQuote.isAcceptableOrUnknown(data['is_quote']!, _isQuoteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadingNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingNote(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      bookId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}book_id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}session_id'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isQuote: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_quote'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReadingNotesTable createAlias(String alias) {
    return $ReadingNotesTable(attachedDatabase, alias);
  }
}

class ReadingNote extends DataClass implements Insertable<ReadingNote> {
  final int id;
  final int bookId;
  final int? sessionId;
  final String body;
  final bool isQuote;
  final DateTime createdAt;
  const ReadingNote({
    required this.id,
    required this.bookId,
    this.sessionId,
    required this.body,
    required this.isQuote,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['book_id'] = Variable<int>(bookId);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<int>(sessionId);
    }
    map['body'] = Variable<String>(body);
    map['is_quote'] = Variable<bool>(isQuote);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReadingNotesCompanion toCompanion(bool nullToAbsent) {
    return ReadingNotesCompanion(
      id: Value(id),
      bookId: Value(bookId),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      body: Value(body),
      isQuote: Value(isQuote),
      createdAt: Value(createdAt),
    );
  }

  factory ReadingNote.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingNote(
      id: serializer.fromJson<int>(json['id']),
      bookId: serializer.fromJson<int>(json['bookId']),
      sessionId: serializer.fromJson<int?>(json['sessionId']),
      body: serializer.fromJson<String>(json['body']),
      isQuote: serializer.fromJson<bool>(json['isQuote']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookId': serializer.toJson<int>(bookId),
      'sessionId': serializer.toJson<int?>(sessionId),
      'body': serializer.toJson<String>(body),
      'isQuote': serializer.toJson<bool>(isQuote),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReadingNote copyWith({
    int? id,
    int? bookId,
    Value<int?> sessionId = const Value.absent(),
    String? body,
    bool? isQuote,
    DateTime? createdAt,
  }) => ReadingNote(
    id: id ?? this.id,
    bookId: bookId ?? this.bookId,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    body: body ?? this.body,
    isQuote: isQuote ?? this.isQuote,
    createdAt: createdAt ?? this.createdAt,
  );
  ReadingNote copyWithCompanion(ReadingNotesCompanion data) {
    return ReadingNote(
      id: data.id.present ? data.id.value : this.id,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      body: data.body.present ? data.body.value : this.body,
      isQuote: data.isQuote.present ? data.isQuote.value : this.isQuote,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingNote(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sessionId: $sessionId, ')
          ..write('body: $body, ')
          ..write('isQuote: $isQuote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, bookId, sessionId, body, isQuote, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingNote &&
          other.id == this.id &&
          other.bookId == this.bookId &&
          other.sessionId == this.sessionId &&
          other.body == this.body &&
          other.isQuote == this.isQuote &&
          other.createdAt == this.createdAt);
}

class ReadingNotesCompanion extends UpdateCompanion<ReadingNote> {
  final Value<int> id;
  final Value<int> bookId;
  final Value<int?> sessionId;
  final Value<String> body;
  final Value<bool> isQuote;
  final Value<DateTime> createdAt;
  const ReadingNotesCompanion({
    this.id = const Value.absent(),
    this.bookId = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.body = const Value.absent(),
    this.isQuote = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReadingNotesCompanion.insert({
    this.id = const Value.absent(),
    required int bookId,
    this.sessionId = const Value.absent(),
    required String body,
    this.isQuote = const Value.absent(),
    required DateTime createdAt,
  }) : bookId = Value(bookId),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<ReadingNote> custom({
    Expression<int>? id,
    Expression<int>? bookId,
    Expression<int>? sessionId,
    Expression<String>? body,
    Expression<bool>? isQuote,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookId != null) 'book_id': bookId,
      if (sessionId != null) 'session_id': sessionId,
      if (body != null) 'body': body,
      if (isQuote != null) 'is_quote': isQuote,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReadingNotesCompanion copyWith({
    Value<int>? id,
    Value<int>? bookId,
    Value<int?>? sessionId,
    Value<String>? body,
    Value<bool>? isQuote,
    Value<DateTime>? createdAt,
  }) {
    return ReadingNotesCompanion(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      sessionId: sessionId ?? this.sessionId,
      body: body ?? this.body,
      isQuote: isQuote ?? this.isQuote,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<int>(sessionId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isQuote.present) {
      map['is_quote'] = Variable<bool>(isQuote.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingNotesCompanion(')
          ..write('id: $id, ')
          ..write('bookId: $bookId, ')
          ..write('sessionId: $sessionId, ')
          ..write('body: $body, ')
          ..write('isQuote: $isQuote, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MemoryCategoriesTable extends MemoryCategories
    with TableInfo<$MemoryCategoriesTable, MemoryCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, archived];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
    );
  }

  @override
  $MemoryCategoriesTable createAlias(String alias) {
    return $MemoryCategoriesTable(attachedDatabase, alias);
  }
}

class MemoryCategory extends DataClass implements Insertable<MemoryCategory> {
  final int id;
  final String name;
  final bool archived;
  const MemoryCategory({
    required this.id,
    required this.name,
    required this.archived,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['archived'] = Variable<bool>(archived);
    return map;
  }

  MemoryCategoriesCompanion toCompanion(bool nullToAbsent) {
    return MemoryCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      archived: Value(archived),
    );
  }

  factory MemoryCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryCategory(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      archived: serializer.fromJson<bool>(json['archived']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'archived': serializer.toJson<bool>(archived),
    };
  }

  MemoryCategory copyWith({int? id, String? name, bool? archived}) =>
      MemoryCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        archived: archived ?? this.archived,
      );
  MemoryCategory copyWithCompanion(MemoryCategoriesCompanion data) {
    return MemoryCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      archived: data.archived.present ? data.archived.value : this.archived,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, archived);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.archived == this.archived);
}

class MemoryCategoriesCompanion extends UpdateCompanion<MemoryCategory> {
  final Value<int> id;
  final Value<String> name;
  final Value<bool> archived;
  const MemoryCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.archived = const Value.absent(),
  });
  MemoryCategoriesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.archived = const Value.absent(),
  }) : name = Value(name);
  static Insertable<MemoryCategory> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<bool>? archived,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (archived != null) 'archived': archived,
    });
  }

  MemoryCategoriesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<bool>? archived,
  }) {
    return MemoryCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      archived: archived ?? this.archived,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('archived: $archived')
          ..write(')'))
        .toString();
  }
}

class $MemoryEventsTable extends MemoryEvents
    with TableInfo<$MemoryEventsTable, MemoryEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryEventsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('oneTime'),
  );
  static const VerificationMeta _precisionMeta = const VerificationMeta(
    'precision',
  );
  @override
  late final GeneratedColumn<String> precision = GeneratedColumn<String>(
    'precision',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('day'),
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<int> day = GeneratedColumn<int>(
    'day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _personMeta = const VerificationMeta('person');
  @override
  late final GeneratedColumn<String> person = GeneratedColumn<String>(
    'person',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<int> categoryId = GeneratedColumn<int>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memory_categories (id)',
    ),
  );
  static const VerificationMeta _placeMeta = const VerificationMeta('place');
  @override
  late final GeneratedColumn<String> place = GeneratedColumn<String>(
    'place',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _coverMediaIdMeta = const VerificationMeta(
    'coverMediaId',
  );
  @override
  late final GeneratedColumn<int> coverMediaId = GeneratedColumn<int>(
    'cover_media_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindOnDayMeta = const VerificationMeta(
    'remindOnDay',
  );
  @override
  late final GeneratedColumn<bool> remindOnDay = GeneratedColumn<bool>(
    'remind_on_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remind_on_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remindDaysBeforeMeta = const VerificationMeta(
    'remindDaysBefore',
  );
  @override
  late final GeneratedColumn<String> remindDaysBefore = GeneratedColumn<String>(
    'remind_days_before',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
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
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    kind,
    precision,
    year,
    month,
    day,
    person,
    categoryId,
    place,
    description,
    coverMediaId,
    remindOnDay,
    remindDaysBefore,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    }
    if (data.containsKey('precision')) {
      context.handle(
        _precisionMeta,
        precision.isAcceptableOrUnknown(data['precision']!, _precisionMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('person')) {
      context.handle(
        _personMeta,
        person.isAcceptableOrUnknown(data['person']!, _personMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('place')) {
      context.handle(
        _placeMeta,
        place.isAcceptableOrUnknown(data['place']!, _placeMeta),
      );
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
    if (data.containsKey('cover_media_id')) {
      context.handle(
        _coverMediaIdMeta,
        coverMediaId.isAcceptableOrUnknown(
          data['cover_media_id']!,
          _coverMediaIdMeta,
        ),
      );
    }
    if (data.containsKey('remind_on_day')) {
      context.handle(
        _remindOnDayMeta,
        remindOnDay.isAcceptableOrUnknown(
          data['remind_on_day']!,
          _remindOnDayMeta,
        ),
      );
    }
    if (data.containsKey('remind_days_before')) {
      context.handle(
        _remindDaysBeforeMeta,
        remindDaysBefore.isAcceptableOrUnknown(
          data['remind_days_before']!,
          _remindDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      precision: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}precision'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      ),
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day'],
      ),
      person: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}person'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}category_id'],
      )!,
      place: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      coverMediaId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_media_id'],
      ),
      remindOnDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remind_on_day'],
      )!,
      remindDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remind_days_before'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MemoryEventsTable createAlias(String alias) {
    return $MemoryEventsTable(attachedDatabase, alias);
  }
}

class MemoryEvent extends DataClass implements Insertable<MemoryEvent> {
  final int id;
  final String title;
  final String kind;
  final String precision;
  final int? year;
  final int? month;
  final int? day;
  final String? person;
  final int categoryId;
  final String? place;
  final String? description;
  final int? coverMediaId;
  final bool remindOnDay;
  final String remindDaysBefore;
  final DateTime createdAt;
  const MemoryEvent({
    required this.id,
    required this.title,
    required this.kind,
    required this.precision,
    this.year,
    this.month,
    this.day,
    this.person,
    required this.categoryId,
    this.place,
    this.description,
    this.coverMediaId,
    required this.remindOnDay,
    required this.remindDaysBefore,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['kind'] = Variable<String>(kind);
    map['precision'] = Variable<String>(precision);
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    if (!nullToAbsent || month != null) {
      map['month'] = Variable<int>(month);
    }
    if (!nullToAbsent || day != null) {
      map['day'] = Variable<int>(day);
    }
    if (!nullToAbsent || person != null) {
      map['person'] = Variable<String>(person);
    }
    map['category_id'] = Variable<int>(categoryId);
    if (!nullToAbsent || place != null) {
      map['place'] = Variable<String>(place);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || coverMediaId != null) {
      map['cover_media_id'] = Variable<int>(coverMediaId);
    }
    map['remind_on_day'] = Variable<bool>(remindOnDay);
    map['remind_days_before'] = Variable<String>(remindDaysBefore);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MemoryEventsCompanion toCompanion(bool nullToAbsent) {
    return MemoryEventsCompanion(
      id: Value(id),
      title: Value(title),
      kind: Value(kind),
      precision: Value(precision),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      month: month == null && nullToAbsent
          ? const Value.absent()
          : Value(month),
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      person: person == null && nullToAbsent
          ? const Value.absent()
          : Value(person),
      categoryId: Value(categoryId),
      place: place == null && nullToAbsent
          ? const Value.absent()
          : Value(place),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      coverMediaId: coverMediaId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverMediaId),
      remindOnDay: Value(remindOnDay),
      remindDaysBefore: Value(remindDaysBefore),
      createdAt: Value(createdAt),
    );
  }

  factory MemoryEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryEvent(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      kind: serializer.fromJson<String>(json['kind']),
      precision: serializer.fromJson<String>(json['precision']),
      year: serializer.fromJson<int?>(json['year']),
      month: serializer.fromJson<int?>(json['month']),
      day: serializer.fromJson<int?>(json['day']),
      person: serializer.fromJson<String?>(json['person']),
      categoryId: serializer.fromJson<int>(json['categoryId']),
      place: serializer.fromJson<String?>(json['place']),
      description: serializer.fromJson<String?>(json['description']),
      coverMediaId: serializer.fromJson<int?>(json['coverMediaId']),
      remindOnDay: serializer.fromJson<bool>(json['remindOnDay']),
      remindDaysBefore: serializer.fromJson<String>(json['remindDaysBefore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'kind': serializer.toJson<String>(kind),
      'precision': serializer.toJson<String>(precision),
      'year': serializer.toJson<int?>(year),
      'month': serializer.toJson<int?>(month),
      'day': serializer.toJson<int?>(day),
      'person': serializer.toJson<String?>(person),
      'categoryId': serializer.toJson<int>(categoryId),
      'place': serializer.toJson<String?>(place),
      'description': serializer.toJson<String?>(description),
      'coverMediaId': serializer.toJson<int?>(coverMediaId),
      'remindOnDay': serializer.toJson<bool>(remindOnDay),
      'remindDaysBefore': serializer.toJson<String>(remindDaysBefore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MemoryEvent copyWith({
    int? id,
    String? title,
    String? kind,
    String? precision,
    Value<int?> year = const Value.absent(),
    Value<int?> month = const Value.absent(),
    Value<int?> day = const Value.absent(),
    Value<String?> person = const Value.absent(),
    int? categoryId,
    Value<String?> place = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<int?> coverMediaId = const Value.absent(),
    bool? remindOnDay,
    String? remindDaysBefore,
    DateTime? createdAt,
  }) => MemoryEvent(
    id: id ?? this.id,
    title: title ?? this.title,
    kind: kind ?? this.kind,
    precision: precision ?? this.precision,
    year: year.present ? year.value : this.year,
    month: month.present ? month.value : this.month,
    day: day.present ? day.value : this.day,
    person: person.present ? person.value : this.person,
    categoryId: categoryId ?? this.categoryId,
    place: place.present ? place.value : this.place,
    description: description.present ? description.value : this.description,
    coverMediaId: coverMediaId.present ? coverMediaId.value : this.coverMediaId,
    remindOnDay: remindOnDay ?? this.remindOnDay,
    remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
    createdAt: createdAt ?? this.createdAt,
  );
  MemoryEvent copyWithCompanion(MemoryEventsCompanion data) {
    return MemoryEvent(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      kind: data.kind.present ? data.kind.value : this.kind,
      precision: data.precision.present ? data.precision.value : this.precision,
      year: data.year.present ? data.year.value : this.year,
      month: data.month.present ? data.month.value : this.month,
      day: data.day.present ? data.day.value : this.day,
      person: data.person.present ? data.person.value : this.person,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      place: data.place.present ? data.place.value : this.place,
      description: data.description.present
          ? data.description.value
          : this.description,
      coverMediaId: data.coverMediaId.present
          ? data.coverMediaId.value
          : this.coverMediaId,
      remindOnDay: data.remindOnDay.present
          ? data.remindOnDay.value
          : this.remindOnDay,
      remindDaysBefore: data.remindDaysBefore.present
          ? data.remindDaysBefore.value
          : this.remindDaysBefore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEvent(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('precision: $precision, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('person: $person, ')
          ..write('categoryId: $categoryId, ')
          ..write('place: $place, ')
          ..write('description: $description, ')
          ..write('coverMediaId: $coverMediaId, ')
          ..write('remindOnDay: $remindOnDay, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    kind,
    precision,
    year,
    month,
    day,
    person,
    categoryId,
    place,
    description,
    coverMediaId,
    remindOnDay,
    remindDaysBefore,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryEvent &&
          other.id == this.id &&
          other.title == this.title &&
          other.kind == this.kind &&
          other.precision == this.precision &&
          other.year == this.year &&
          other.month == this.month &&
          other.day == this.day &&
          other.person == this.person &&
          other.categoryId == this.categoryId &&
          other.place == this.place &&
          other.description == this.description &&
          other.coverMediaId == this.coverMediaId &&
          other.remindOnDay == this.remindOnDay &&
          other.remindDaysBefore == this.remindDaysBefore &&
          other.createdAt == this.createdAt);
}

class MemoryEventsCompanion extends UpdateCompanion<MemoryEvent> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> kind;
  final Value<String> precision;
  final Value<int?> year;
  final Value<int?> month;
  final Value<int?> day;
  final Value<String?> person;
  final Value<int> categoryId;
  final Value<String?> place;
  final Value<String?> description;
  final Value<int?> coverMediaId;
  final Value<bool> remindOnDay;
  final Value<String> remindDaysBefore;
  final Value<DateTime> createdAt;
  const MemoryEventsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.kind = const Value.absent(),
    this.precision = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.day = const Value.absent(),
    this.person = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.place = const Value.absent(),
    this.description = const Value.absent(),
    this.coverMediaId = const Value.absent(),
    this.remindOnDay = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MemoryEventsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.kind = const Value.absent(),
    this.precision = const Value.absent(),
    this.year = const Value.absent(),
    this.month = const Value.absent(),
    this.day = const Value.absent(),
    this.person = const Value.absent(),
    required int categoryId,
    this.place = const Value.absent(),
    this.description = const Value.absent(),
    this.coverMediaId = const Value.absent(),
    this.remindOnDay = const Value.absent(),
    this.remindDaysBefore = const Value.absent(),
    required DateTime createdAt,
  }) : title = Value(title),
       categoryId = Value(categoryId),
       createdAt = Value(createdAt);
  static Insertable<MemoryEvent> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? kind,
    Expression<String>? precision,
    Expression<int>? year,
    Expression<int>? month,
    Expression<int>? day,
    Expression<String>? person,
    Expression<int>? categoryId,
    Expression<String>? place,
    Expression<String>? description,
    Expression<int>? coverMediaId,
    Expression<bool>? remindOnDay,
    Expression<String>? remindDaysBefore,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (kind != null) 'kind': kind,
      if (precision != null) 'precision': precision,
      if (year != null) 'year': year,
      if (month != null) 'month': month,
      if (day != null) 'day': day,
      if (person != null) 'person': person,
      if (categoryId != null) 'category_id': categoryId,
      if (place != null) 'place': place,
      if (description != null) 'description': description,
      if (coverMediaId != null) 'cover_media_id': coverMediaId,
      if (remindOnDay != null) 'remind_on_day': remindOnDay,
      if (remindDaysBefore != null) 'remind_days_before': remindDaysBefore,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MemoryEventsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? kind,
    Value<String>? precision,
    Value<int?>? year,
    Value<int?>? month,
    Value<int?>? day,
    Value<String?>? person,
    Value<int>? categoryId,
    Value<String?>? place,
    Value<String?>? description,
    Value<int?>? coverMediaId,
    Value<bool>? remindOnDay,
    Value<String>? remindDaysBefore,
    Value<DateTime>? createdAt,
  }) {
    return MemoryEventsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      kind: kind ?? this.kind,
      precision: precision ?? this.precision,
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      person: person ?? this.person,
      categoryId: categoryId ?? this.categoryId,
      place: place ?? this.place,
      description: description ?? this.description,
      coverMediaId: coverMediaId ?? this.coverMediaId,
      remindOnDay: remindOnDay ?? this.remindOnDay,
      remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (precision.present) {
      map['precision'] = Variable<String>(precision.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(day.value);
    }
    if (person.present) {
      map['person'] = Variable<String>(person.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<int>(categoryId.value);
    }
    if (place.present) {
      map['place'] = Variable<String>(place.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (coverMediaId.present) {
      map['cover_media_id'] = Variable<int>(coverMediaId.value);
    }
    if (remindOnDay.present) {
      map['remind_on_day'] = Variable<bool>(remindOnDay.value);
    }
    if (remindDaysBefore.present) {
      map['remind_days_before'] = Variable<String>(remindDaysBefore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryEventsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('kind: $kind, ')
          ..write('precision: $precision, ')
          ..write('year: $year, ')
          ..write('month: $month, ')
          ..write('day: $day, ')
          ..write('person: $person, ')
          ..write('categoryId: $categoryId, ')
          ..write('place: $place, ')
          ..write('description: $description, ')
          ..write('coverMediaId: $coverMediaId, ')
          ..write('remindOnDay: $remindOnDay, ')
          ..write('remindDaysBefore: $remindDaysBefore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MemoryMediaTable extends MemoryMedia
    with TableInfo<$MemoryMediaTable, MemoryMediaItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MemoryMediaTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _eventIdMeta = const VerificationMeta(
    'eventId',
  );
  @override
  late final GeneratedColumn<int> eventId = GeneratedColumn<int>(
    'event_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES memory_events (id)',
    ),
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
  static const VerificationMeta _isVideoMeta = const VerificationMeta(
    'isVideo',
  );
  @override
  late final GeneratedColumn<bool> isVideo = GeneratedColumn<bool>(
    'is_video',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_video" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _thumbPathMeta = const VerificationMeta(
    'thumbPath',
  );
  @override
  late final GeneratedColumn<String> thumbPath = GeneratedColumn<String>(
    'thumb_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    eventId,
    path,
    isVideo,
    thumbPath,
    durationMs,
    sortOrder,
    sizeBytes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'memory_media';
  @override
  VerificationContext validateIntegrity(
    Insertable<MemoryMediaItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('event_id')) {
      context.handle(
        _eventIdMeta,
        eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta),
      );
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('is_video')) {
      context.handle(
        _isVideoMeta,
        isVideo.isAcceptableOrUnknown(data['is_video']!, _isVideoMeta),
      );
    }
    if (data.containsKey('thumb_path')) {
      context.handle(
        _thumbPathMeta,
        thumbPath.isAcceptableOrUnknown(data['thumb_path']!, _thumbPathMeta),
      );
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MemoryMediaItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MemoryMediaItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      eventId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}event_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      isVideo: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_video'],
      )!,
      thumbPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thumb_path'],
      ),
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
    );
  }

  @override
  $MemoryMediaTable createAlias(String alias) {
    return $MemoryMediaTable(attachedDatabase, alias);
  }
}

class MemoryMediaItem extends DataClass implements Insertable<MemoryMediaItem> {
  final int id;
  final int eventId;
  final String path;
  final bool isVideo;
  final String? thumbPath;
  final int? durationMs;
  final int sortOrder;
  final int sizeBytes;
  const MemoryMediaItem({
    required this.id,
    required this.eventId,
    required this.path,
    required this.isVideo,
    this.thumbPath,
    this.durationMs,
    required this.sortOrder,
    required this.sizeBytes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['event_id'] = Variable<int>(eventId);
    map['path'] = Variable<String>(path);
    map['is_video'] = Variable<bool>(isVideo);
    if (!nullToAbsent || thumbPath != null) {
      map['thumb_path'] = Variable<String>(thumbPath);
    }
    if (!nullToAbsent || durationMs != null) {
      map['duration_ms'] = Variable<int>(durationMs);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['size_bytes'] = Variable<int>(sizeBytes);
    return map;
  }

  MemoryMediaCompanion toCompanion(bool nullToAbsent) {
    return MemoryMediaCompanion(
      id: Value(id),
      eventId: Value(eventId),
      path: Value(path),
      isVideo: Value(isVideo),
      thumbPath: thumbPath == null && nullToAbsent
          ? const Value.absent()
          : Value(thumbPath),
      durationMs: durationMs == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMs),
      sortOrder: Value(sortOrder),
      sizeBytes: Value(sizeBytes),
    );
  }

  factory MemoryMediaItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MemoryMediaItem(
      id: serializer.fromJson<int>(json['id']),
      eventId: serializer.fromJson<int>(json['eventId']),
      path: serializer.fromJson<String>(json['path']),
      isVideo: serializer.fromJson<bool>(json['isVideo']),
      thumbPath: serializer.fromJson<String?>(json['thumbPath']),
      durationMs: serializer.fromJson<int?>(json['durationMs']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventId': serializer.toJson<int>(eventId),
      'path': serializer.toJson<String>(path),
      'isVideo': serializer.toJson<bool>(isVideo),
      'thumbPath': serializer.toJson<String?>(thumbPath),
      'durationMs': serializer.toJson<int?>(durationMs),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
    };
  }

  MemoryMediaItem copyWith({
    int? id,
    int? eventId,
    String? path,
    bool? isVideo,
    Value<String?> thumbPath = const Value.absent(),
    Value<int?> durationMs = const Value.absent(),
    int? sortOrder,
    int? sizeBytes,
  }) => MemoryMediaItem(
    id: id ?? this.id,
    eventId: eventId ?? this.eventId,
    path: path ?? this.path,
    isVideo: isVideo ?? this.isVideo,
    thumbPath: thumbPath.present ? thumbPath.value : this.thumbPath,
    durationMs: durationMs.present ? durationMs.value : this.durationMs,
    sortOrder: sortOrder ?? this.sortOrder,
    sizeBytes: sizeBytes ?? this.sizeBytes,
  );
  MemoryMediaItem copyWithCompanion(MemoryMediaCompanion data) {
    return MemoryMediaItem(
      id: data.id.present ? data.id.value : this.id,
      eventId: data.eventId.present ? data.eventId.value : this.eventId,
      path: data.path.present ? data.path.value : this.path,
      isVideo: data.isVideo.present ? data.isVideo.value : this.isVideo,
      thumbPath: data.thumbPath.present ? data.thumbPath.value : this.thumbPath,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MemoryMediaItem(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('path: $path, ')
          ..write('isVideo: $isVideo, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sizeBytes: $sizeBytes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    eventId,
    path,
    isVideo,
    thumbPath,
    durationMs,
    sortOrder,
    sizeBytes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MemoryMediaItem &&
          other.id == this.id &&
          other.eventId == this.eventId &&
          other.path == this.path &&
          other.isVideo == this.isVideo &&
          other.thumbPath == this.thumbPath &&
          other.durationMs == this.durationMs &&
          other.sortOrder == this.sortOrder &&
          other.sizeBytes == this.sizeBytes);
}

class MemoryMediaCompanion extends UpdateCompanion<MemoryMediaItem> {
  final Value<int> id;
  final Value<int> eventId;
  final Value<String> path;
  final Value<bool> isVideo;
  final Value<String?> thumbPath;
  final Value<int?> durationMs;
  final Value<int> sortOrder;
  final Value<int> sizeBytes;
  const MemoryMediaCompanion({
    this.id = const Value.absent(),
    this.eventId = const Value.absent(),
    this.path = const Value.absent(),
    this.isVideo = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.sizeBytes = const Value.absent(),
  });
  MemoryMediaCompanion.insert({
    this.id = const Value.absent(),
    required int eventId,
    required String path,
    this.isVideo = const Value.absent(),
    this.thumbPath = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.sizeBytes = const Value.absent(),
  }) : eventId = Value(eventId),
       path = Value(path);
  static Insertable<MemoryMediaItem> custom({
    Expression<int>? id,
    Expression<int>? eventId,
    Expression<String>? path,
    Expression<bool>? isVideo,
    Expression<String>? thumbPath,
    Expression<int>? durationMs,
    Expression<int>? sortOrder,
    Expression<int>? sizeBytes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventId != null) 'event_id': eventId,
      if (path != null) 'path': path,
      if (isVideo != null) 'is_video': isVideo,
      if (thumbPath != null) 'thumb_path': thumbPath,
      if (durationMs != null) 'duration_ms': durationMs,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
    });
  }

  MemoryMediaCompanion copyWith({
    Value<int>? id,
    Value<int>? eventId,
    Value<String>? path,
    Value<bool>? isVideo,
    Value<String?>? thumbPath,
    Value<int?>? durationMs,
    Value<int>? sortOrder,
    Value<int>? sizeBytes,
  }) {
    return MemoryMediaCompanion(
      id: id ?? this.id,
      eventId: eventId ?? this.eventId,
      path: path ?? this.path,
      isVideo: isVideo ?? this.isVideo,
      thumbPath: thumbPath ?? this.thumbPath,
      durationMs: durationMs ?? this.durationMs,
      sortOrder: sortOrder ?? this.sortOrder,
      sizeBytes: sizeBytes ?? this.sizeBytes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (isVideo.present) {
      map['is_video'] = Variable<bool>(isVideo.value);
    }
    if (thumbPath.present) {
      map['thumb_path'] = Variable<String>(thumbPath.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MemoryMediaCompanion(')
          ..write('id: $id, ')
          ..write('eventId: $eventId, ')
          ..write('path: $path, ')
          ..write('isVideo: $isVideo, ')
          ..write('thumbPath: $thumbPath, ')
          ..write('durationMs: $durationMs, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('sizeBytes: $sizeBytes')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SleepSessionsTable sleepSessions = $SleepSessionsTable(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $StocksTable stocks = $StocksTable(this);
  late final $TradesTable trades = $TradesTable(this);
  late final $WeeklySnapshotsTable weeklySnapshots = $WeeklySnapshotsTable(
    this,
  );
  late final $BooksTable books = $BooksTable(this);
  late final $ReadingSessionsTable readingSessions = $ReadingSessionsTable(
    this,
  );
  late final $ReadingNotesTable readingNotes = $ReadingNotesTable(this);
  late final $MemoryCategoriesTable memoryCategories = $MemoryCategoriesTable(
    this,
  );
  late final $MemoryEventsTable memoryEvents = $MemoryEventsTable(this);
  late final $MemoryMediaTable memoryMedia = $MemoryMediaTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    sleepSessions,
    categories,
    expenses,
    stocks,
    trades,
    weeklySnapshots,
    books,
    readingSessions,
    readingNotes,
    memoryCategories,
    memoryEvents,
    memoryMedia,
  ];
}

typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> currencySymbol,
  Value<int> sleepGoalMinutes,
  Value<int> targetBedtimeMinutes,
  Value<bool> weeklyReportEnabled,
  Value<int> weeklyReportMinutes,
  Value<int> memoryRemindMinutes,
  Value<bool> onThisDayEnabled,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<int> id,
  Value<String> currencySymbol,
  Value<int> sleepGoalMinutes,
  Value<int> targetBedtimeMinutes,
  Value<bool> weeklyReportEnabled,
  Value<int> weeklyReportMinutes,
  Value<int> memoryRemindMinutes,
  Value<bool> onThisDayEnabled,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
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

  ColumnFilters<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetBedtimeMinutes => $composableBuilder(
    column: $table.targetBedtimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weeklyReportEnabled => $composableBuilder(
    column: $table.weeklyReportEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyReportMinutes => $composableBuilder(
    column: $table.weeklyReportMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get memoryRemindMinutes => $composableBuilder(
    column: $table.memoryRemindMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onThisDayEnabled => $composableBuilder(
    column: $table.onThisDayEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
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

  ColumnOrderings<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetBedtimeMinutes => $composableBuilder(
    column: $table.targetBedtimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weeklyReportEnabled => $composableBuilder(
    column: $table.weeklyReportEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyReportMinutes => $composableBuilder(
    column: $table.weeklyReportMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get memoryRemindMinutes => $composableBuilder(
    column: $table.memoryRemindMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onThisDayEnabled => $composableBuilder(
    column: $table.onThisDayEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currencySymbol => $composableBuilder(
    column: $table.currencySymbol,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetBedtimeMinutes => $composableBuilder(
    column: $table.targetBedtimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weeklyReportEnabled => $composableBuilder(
    column: $table.weeklyReportEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyReportMinutes => $composableBuilder(
    column: $table.weeklyReportMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get memoryRemindMinutes => $composableBuilder(
    column: $table.memoryRemindMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onThisDayEnabled => $composableBuilder(
    column: $table.onThisDayEnabled,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> sleepGoalMinutes = const Value.absent(),
                Value<int> targetBedtimeMinutes = const Value.absent(),
                Value<bool> weeklyReportEnabled = const Value.absent(),
                Value<int> weeklyReportMinutes = const Value.absent(),
                Value<int> memoryRemindMinutes = const Value.absent(),
                Value<bool> onThisDayEnabled = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                currencySymbol: currencySymbol,
                sleepGoalMinutes: sleepGoalMinutes,
                targetBedtimeMinutes: targetBedtimeMinutes,
                weeklyReportEnabled: weeklyReportEnabled,
                weeklyReportMinutes: weeklyReportMinutes,
                memoryRemindMinutes: memoryRemindMinutes,
                onThisDayEnabled: onThisDayEnabled,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> currencySymbol = const Value.absent(),
                Value<int> sleepGoalMinutes = const Value.absent(),
                Value<int> targetBedtimeMinutes = const Value.absent(),
                Value<bool> weeklyReportEnabled = const Value.absent(),
                Value<int> weeklyReportMinutes = const Value.absent(),
                Value<int> memoryRemindMinutes = const Value.absent(),
                Value<bool> onThisDayEnabled = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                currencySymbol: currencySymbol,
                sleepGoalMinutes: sleepGoalMinutes,
                targetBedtimeMinutes: targetBedtimeMinutes,
                weeklyReportEnabled: weeklyReportEnabled,
                weeklyReportMinutes: weeklyReportMinutes,
                memoryRemindMinutes: memoryRemindMinutes,
                onThisDayEnabled: onThisDayEnabled,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
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

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$SleepSessionsTableCreateCompanionBuilder =
    SleepSessionsCompanion Function({
      Value<int> id,
      required DateTime sleepAt,
      Value<DateTime?> wakeAt,
      Value<int?> quality,
      Value<String?> note,
    });
typedef $$SleepSessionsTableUpdateCompanionBuilder =
    SleepSessionsCompanion Function({
      Value<int> id,
      Value<DateTime> sleepAt,
      Value<DateTime?> wakeAt,
      Value<int?> quality,
      Value<String?> note,
    });

class $$SleepSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get sleepAt => $composableBuilder(
    column: $table.sleepAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get wakeAt => $composableBuilder(
    column: $table.wakeAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SleepSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get sleepAt => $composableBuilder(
    column: $table.sleepAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get wakeAt => $composableBuilder(
    column: $table.wakeAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SleepSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SleepSessionsTable> {
  $$SleepSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get sleepAt =>
      $composableBuilder(column: $table.sleepAt, builder: (column) => column);

  GeneratedColumn<DateTime> get wakeAt =>
      $composableBuilder(column: $table.wakeAt, builder: (column) => column);

  GeneratedColumn<int> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$SleepSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SleepSessionsTable,
          SleepSession,
          $$SleepSessionsTableFilterComposer,
          $$SleepSessionsTableOrderingComposer,
          $$SleepSessionsTableAnnotationComposer,
          $$SleepSessionsTableCreateCompanionBuilder,
          $$SleepSessionsTableUpdateCompanionBuilder,
          (
            SleepSession,
            BaseReferences<_$AppDatabase, $SleepSessionsTable, SleepSession>,
          ),
          SleepSession,
          PrefetchHooks Function()
        > {
  $$SleepSessionsTableTableManager(_$AppDatabase db, $SleepSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SleepSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SleepSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SleepSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> sleepAt = const Value.absent(),
                Value<DateTime?> wakeAt = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SleepSessionsCompanion(
                id: id,
                sleepAt: sleepAt,
                wakeAt: wakeAt,
                quality: quality,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime sleepAt,
                Value<DateTime?> wakeAt = const Value.absent(),
                Value<int?> quality = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => SleepSessionsCompanion.insert(
                id: id,
                sleepAt: sleepAt,
                wakeAt: wakeAt,
                quality: quality,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SleepSessionsTable, SleepSession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SleepSessionsTable,
                    SleepSession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SleepSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SleepSessionsTable,
      SleepSession,
      $$SleepSessionsTableFilterComposer,
      $$SleepSessionsTableOrderingComposer,
      $$SleepSessionsTableAnnotationComposer,
      $$SleepSessionsTableCreateCompanionBuilder,
      $$SleepSessionsTableUpdateCompanionBuilder,
      (
        SleepSession,
        BaseReferences<_$AppDatabase, $SleepSessionsTable, SleepSession>,
      ),
      SleepSession,
      PrefetchHooks Function()
    >;
typedef $$CategoriesTableCreateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  required String name,
  Value<int?> budgetCents,
  Value<bool> archived,
});
typedef $$CategoriesTableUpdateCompanionBuilder = CategoriesCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<int?> budgetCents,
  Value<bool> archived,
});

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, Category> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: 'categories__id__expenses__category_id',
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get budgetCents => $composableBuilder(
    column: $table.budgetCents,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, $$CategoriesTableReferences),
          Category,
          PrefetchHooks Function({bool expensesRefs})
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> budgetCents = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                budgetCents: budgetCents,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int?> budgetCents = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                budgetCents: budgetCents,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTable, Category>(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({expensesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (expensesRefs) db.expenses],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (expensesRefs)
                    await $_getPrefetchedData<
                      Category,
                      $CategoriesTable,
                      Expense
                    >(
                      currentTable: table,
                      referencedTable: $$CategoriesTableReferences
                          ._expensesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).expensesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, $$CategoriesTableReferences),
      Category,
      PrefetchHooks Function({bool expensesRefs})
    >;
typedef $$ExpensesTableCreateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  required int amountCents,
  required int categoryId,
  required DateTime date,
  required String paymentMethod,
  Value<String?> note,
  Value<String?> item,
  Value<String?> store,
  Value<DateTime?> warrantyOrReturnBy,
  Value<String?> receiptPath,
});
typedef $$ExpensesTableUpdateCompanionBuilder = ExpensesCompanion Function({
  Value<int> id,
  Value<int> amountCents,
  Value<int> categoryId,
  Value<DateTime> date,
  Value<String> paymentMethod,
  Value<String?> note,
  Value<String?> item,
  Value<String?> store,
  Value<DateTime?> warrantyOrReturnBy,
  Value<String?> receiptPath,
});

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias('expenses__category_id__categories__id');

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
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

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get warrantyOrReturnBy => $composableBuilder(
    column: $table.warrantyOrReturnBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
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

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get item => $composableBuilder(
    column: $table.item,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get store => $composableBuilder(
    column: $table.store,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get warrantyOrReturnBy => $composableBuilder(
    column: $table.warrantyOrReturnBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get item =>
      $composableBuilder(column: $table.item, builder: (column) => column);

  GeneratedColumn<String> get store =>
      $composableBuilder(column: $table.store, builder: (column) => column);

  GeneratedColumn<DateTime> get warrantyOrReturnBy => $composableBuilder(
    column: $table.warrantyOrReturnBy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool categoryId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> item = const Value.absent(),
                Value<String?> store = const Value.absent(),
                Value<DateTime?> warrantyOrReturnBy = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                amountCents: amountCents,
                categoryId: categoryId,
                date: date,
                paymentMethod: paymentMethod,
                note: note,
                item: item,
                store: store,
                warrantyOrReturnBy: warrantyOrReturnBy,
                receiptPath: receiptPath,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amountCents,
                required int categoryId,
                required DateTime date,
                required String paymentMethod,
                Value<String?> note = const Value.absent(),
                Value<String?> item = const Value.absent(),
                Value<String?> store = const Value.absent(),
                Value<DateTime?> warrantyOrReturnBy = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                amountCents: amountCents,
                categoryId: categoryId,
                date: date,
                paymentMethod: paymentMethod,
                note: note,
                item: item,
                store: store,
                warrantyOrReturnBy: warrantyOrReturnBy,
                receiptPath: receiptPath,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ExpensesTable, Expense>(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({categoryId = false}) {
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
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$ExpensesTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$ExpensesTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool categoryId})
    >;
typedef $$StocksTableCreateCompanionBuilder = StocksCompanion Function({
  Value<int> id,
  required String symbol,
  required String name,
  Value<int?> lastPriceCents,
  Value<DateTime?> priceDate,
});
typedef $$StocksTableUpdateCompanionBuilder = StocksCompanion Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> name,
  Value<int?> lastPriceCents,
  Value<DateTime?> priceDate,
});

final class $$StocksTableReferences
    extends BaseReferences<_$AppDatabase, $StocksTable, Stock> {
  $$StocksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TradesTable, List<Trade>> _tradesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trades,
    aliasName: 'stocks__id__trades__stock_id',
  );

  $$TradesTableProcessedTableManager get tradesRefs {
    final manager = $$TradesTableTableManager(
      $_db,
      $_db.trades,
    ).filter((f) => f.stockId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tradesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StocksTableFilterComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableFilterComposer({
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

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPriceCents => $composableBuilder(
    column: $table.lastPriceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get priceDate => $composableBuilder(
    column: $table.priceDate,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> tradesRefs(
    Expression<bool> Function($$TradesTableFilterComposer f) f,
  ) {
    final $$TradesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trades,
      getReferencedColumn: (t) => t.stockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradesTableFilterComposer(
            $db: $db,
            $table: $db.trades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocksTableOrderingComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableOrderingComposer({
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

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPriceCents => $composableBuilder(
    column: $table.lastPriceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get priceDate => $composableBuilder(
    column: $table.priceDate,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $StocksTable> {
  $$StocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get lastPriceCents => $composableBuilder(
    column: $table.lastPriceCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get priceDate =>
      $composableBuilder(column: $table.priceDate, builder: (column) => column);

  Expression<T> tradesRefs<T extends Object>(
    Expression<T> Function($$TradesTableAnnotationComposer a) f,
  ) {
    final $$TradesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trades,
      getReferencedColumn: (t) => t.stockId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TradesTableAnnotationComposer(
            $db: $db,
            $table: $db.trades,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StocksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StocksTable,
          Stock,
          $$StocksTableFilterComposer,
          $$StocksTableOrderingComposer,
          $$StocksTableAnnotationComposer,
          $$StocksTableCreateCompanionBuilder,
          $$StocksTableUpdateCompanionBuilder,
          (Stock, $$StocksTableReferences),
          Stock,
          PrefetchHooks Function({bool tradesRefs})
        > {
  $$StocksTableTableManager(_$AppDatabase db, $StocksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> lastPriceCents = const Value.absent(),
                Value<DateTime?> priceDate = const Value.absent(),
              }) => StocksCompanion(
                id: id,
                symbol: symbol,
                name: name,
                lastPriceCents: lastPriceCents,
                priceDate: priceDate,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String symbol,
                required String name,
                Value<int?> lastPriceCents = const Value.absent(),
                Value<DateTime?> priceDate = const Value.absent(),
              }) => StocksCompanion.insert(
                id: id,
                symbol: symbol,
                name: name,
                lastPriceCents: lastPriceCents,
                priceDate: priceDate,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StocksTable, Stock>(table),
                  $$StocksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({tradesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tradesRefs) db.trades],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tradesRefs)
                    await $_getPrefetchedData<Stock, $StocksTable, Trade>(
                      currentTable: table,
                      referencedTable: $$StocksTableReferences._tradesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$StocksTableReferences(db, table, p0).tradesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.stockId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$StocksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StocksTable,
      Stock,
      $$StocksTableFilterComposer,
      $$StocksTableOrderingComposer,
      $$StocksTableAnnotationComposer,
      $$StocksTableCreateCompanionBuilder,
      $$StocksTableUpdateCompanionBuilder,
      (Stock, $$StocksTableReferences),
      Stock,
      PrefetchHooks Function({bool tradesRefs})
    >;
typedef $$TradesTableCreateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  required int stockId,
  required bool isBuy,
  required DateTime date,
  required int quantity,
  required int priceCents,
  Value<int> feesCents,
  Value<String?> note,
});
typedef $$TradesTableUpdateCompanionBuilder = TradesCompanion Function({
  Value<int> id,
  Value<int> stockId,
  Value<bool> isBuy,
  Value<DateTime> date,
  Value<int> quantity,
  Value<int> priceCents,
  Value<int> feesCents,
  Value<String?> note,
});

final class $$TradesTableReferences
    extends BaseReferences<_$AppDatabase, $TradesTable, Trade> {
  $$TradesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $StocksTable _stockIdTable(_$AppDatabase db) =>
      db.stocks.createAlias('trades__stock_id__stocks__id');

  $$StocksTableProcessedTableManager get stockId {
    final $_column = $_itemColumn<int>('stock_id')!;

    final manager = $$StocksTableTableManager(
      $_db,
      $_db.stocks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_stockIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TradesTableFilterComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableFilterComposer({
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

  ColumnFilters<bool> get isBuy => $composableBuilder(
    column: $table.isBuy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get feesCents => $composableBuilder(
    column: $table.feesCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$StocksTableFilterComposer get stockId {
    final $$StocksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableFilterComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradesTableOrderingComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableOrderingComposer({
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

  ColumnOrderings<bool> get isBuy => $composableBuilder(
    column: $table.isBuy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get feesCents => $composableBuilder(
    column: $table.feesCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$StocksTableOrderingComposer get stockId {
    final $$StocksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableOrderingComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TradesTable> {
  $$TradesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isBuy =>
      $composableBuilder(column: $table.isBuy, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get priceCents => $composableBuilder(
    column: $table.priceCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get feesCents =>
      $composableBuilder(column: $table.feesCents, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$StocksTableAnnotationComposer get stockId {
    final $$StocksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.stockId,
      referencedTable: $db.stocks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StocksTableAnnotationComposer(
            $db: $db,
            $table: $db.stocks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TradesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TradesTable,
          Trade,
          $$TradesTableFilterComposer,
          $$TradesTableOrderingComposer,
          $$TradesTableAnnotationComposer,
          $$TradesTableCreateCompanionBuilder,
          $$TradesTableUpdateCompanionBuilder,
          (Trade, $$TradesTableReferences),
          Trade,
          PrefetchHooks Function({bool stockId})
        > {
  $$TradesTableTableManager(_$AppDatabase db, $TradesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TradesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TradesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TradesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> stockId = const Value.absent(),
                Value<bool> isBuy = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> priceCents = const Value.absent(),
                Value<int> feesCents = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => TradesCompanion(
                id: id,
                stockId: stockId,
                isBuy: isBuy,
                date: date,
                quantity: quantity,
                priceCents: priceCents,
                feesCents: feesCents,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int stockId,
                required bool isBuy,
                required DateTime date,
                required int quantity,
                required int priceCents,
                Value<int> feesCents = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => TradesCompanion.insert(
                id: id,
                stockId: stockId,
                isBuy: isBuy,
                date: date,
                quantity: quantity,
                priceCents: priceCents,
                feesCents: feesCents,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TradesTable, Trade>(table),
                  $$TradesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({stockId = false}) {
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
                    if (stockId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.stockId,
                        referencedTable: $$TradesTableReferences._stockIdTable(
                          db,
                        ),
                        referencedColumn: $$TradesTableReferences
                            ._stockIdTable(db)
                            .id,
                      ) as T;
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

typedef $$TradesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TradesTable,
      Trade,
      $$TradesTableFilterComposer,
      $$TradesTableOrderingComposer,
      $$TradesTableAnnotationComposer,
      $$TradesTableCreateCompanionBuilder,
      $$TradesTableUpdateCompanionBuilder,
      (Trade, $$TradesTableReferences),
      Trade,
      PrefetchHooks Function({bool stockId})
    >;
typedef $$WeeklySnapshotsTableCreateCompanionBuilder =
    WeeklySnapshotsCompanion Function({
      Value<int> id,
      required DateTime weekStart,
      required int investedCents,
      required int valueCents,
    });
typedef $$WeeklySnapshotsTableUpdateCompanionBuilder =
    WeeklySnapshotsCompanion Function({
      Value<int> id,
      Value<DateTime> weekStart,
      Value<int> investedCents,
      Value<int> valueCents,
    });

class $$WeeklySnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $WeeklySnapshotsTable> {
  $$WeeklySnapshotsTableFilterComposer({
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

  ColumnFilters<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get investedCents => $composableBuilder(
    column: $table.investedCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get valueCents => $composableBuilder(
    column: $table.valueCents,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeeklySnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeeklySnapshotsTable> {
  $$WeeklySnapshotsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get weekStart => $composableBuilder(
    column: $table.weekStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get investedCents => $composableBuilder(
    column: $table.investedCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get valueCents => $composableBuilder(
    column: $table.valueCents,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeeklySnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeeklySnapshotsTable> {
  $$WeeklySnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get weekStart =>
      $composableBuilder(column: $table.weekStart, builder: (column) => column);

  GeneratedColumn<int> get investedCents => $composableBuilder(
    column: $table.investedCents,
    builder: (column) => column,
  );

  GeneratedColumn<int> get valueCents => $composableBuilder(
    column: $table.valueCents,
    builder: (column) => column,
  );
}

class $$WeeklySnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeeklySnapshotsTable,
          WeeklySnapshot,
          $$WeeklySnapshotsTableFilterComposer,
          $$WeeklySnapshotsTableOrderingComposer,
          $$WeeklySnapshotsTableAnnotationComposer,
          $$WeeklySnapshotsTableCreateCompanionBuilder,
          $$WeeklySnapshotsTableUpdateCompanionBuilder,
          (
            WeeklySnapshot,
            BaseReferences<
              _$AppDatabase,
              $WeeklySnapshotsTable,
              WeeklySnapshot
            >,
          ),
          WeeklySnapshot,
          PrefetchHooks Function()
        > {
  $$WeeklySnapshotsTableTableManager(
    _$AppDatabase db,
    $WeeklySnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeeklySnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeeklySnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeeklySnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> weekStart = const Value.absent(),
                Value<int> investedCents = const Value.absent(),
                Value<int> valueCents = const Value.absent(),
              }) => WeeklySnapshotsCompanion(
                id: id,
                weekStart: weekStart,
                investedCents: investedCents,
                valueCents: valueCents,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime weekStart,
                required int investedCents,
                required int valueCents,
              }) => WeeklySnapshotsCompanion.insert(
                id: id,
                weekStart: weekStart,
                investedCents: investedCents,
                valueCents: valueCents,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WeeklySnapshotsTable, WeeklySnapshot>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WeeklySnapshotsTable,
                    WeeklySnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeeklySnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeeklySnapshotsTable,
      WeeklySnapshot,
      $$WeeklySnapshotsTableFilterComposer,
      $$WeeklySnapshotsTableOrderingComposer,
      $$WeeklySnapshotsTableAnnotationComposer,
      $$WeeklySnapshotsTableCreateCompanionBuilder,
      $$WeeklySnapshotsTableUpdateCompanionBuilder,
      (
        WeeklySnapshot,
        BaseReferences<_$AppDatabase, $WeeklySnapshotsTable, WeeklySnapshot>,
      ),
      WeeklySnapshot,
      PrefetchHooks Function()
    >;
typedef $$BooksTableCreateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  required String title,
  Value<String> author,
  Value<int?> totalPages,
  Value<String> status,
  Value<int?> rating,
  Value<String?> coverPath,
  Value<DateTime?> finishedAt,
});
typedef $$BooksTableUpdateCompanionBuilder = BooksCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> author,
  Value<int?> totalPages,
  Value<String> status,
  Value<int?> rating,
  Value<String?> coverPath,
  Value<DateTime?> finishedAt,
});

final class $$BooksTableReferences
    extends BaseReferences<_$AppDatabase, $BooksTable, Book> {
  $$BooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ReadingSessionsTable, List<ReadingSession>>
  _readingSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingSessions,
    aliasName: 'books__id__reading_sessions__book_id',
  );

  $$ReadingSessionsTableProcessedTableManager get readingSessionsRefs {
    final manager = $$ReadingSessionsTableTableManager(
      $_db,
      $_db.readingSessions,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingSessionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReadingNotesTable, List<ReadingNote>>
  _readingNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingNotes,
    aliasName: 'books__id__reading_notes__book_id',
  );

  $$ReadingNotesTableProcessedTableManager get readingNotesRefs {
    final manager = $$ReadingNotesTableTableManager(
      $_db,
      $_db.readingNotes,
    ).filter((f) => f.bookId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BooksTableFilterComposer extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> readingSessionsRefs(
    Expression<bool> Function($$ReadingSessionsTableFilterComposer f) f,
  ) {
    final $$ReadingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readingNotesRefs(
    Expression<bool> Function($$ReadingNotesTableFilterComposer f) f,
  ) {
    final $$ReadingNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingNotesTableFilterComposer(
            $db: $db,
            $table: $db.readingNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableOrderingComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverPath => $composableBuilder(
    column: $table.coverPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BooksTable> {
  $$BooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<int> get totalPages => $composableBuilder(
    column: $table.totalPages,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get coverPath =>
      $composableBuilder(column: $table.coverPath, builder: (column) => column);

  GeneratedColumn<DateTime> get finishedAt => $composableBuilder(
    column: $table.finishedAt,
    builder: (column) => column,
  );

  Expression<T> readingSessionsRefs<T extends Object>(
    Expression<T> Function($$ReadingSessionsTableAnnotationComposer a) f,
  ) {
    final $$ReadingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readingNotesRefs<T extends Object>(
    Expression<T> Function($$ReadingNotesTableAnnotationComposer a) f,
  ) {
    final $$ReadingNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingNotes,
      getReferencedColumn: (t) => t.bookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.readingNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BooksTable,
          Book,
          $$BooksTableFilterComposer,
          $$BooksTableOrderingComposer,
          $$BooksTableAnnotationComposer,
          $$BooksTableCreateCompanionBuilder,
          $$BooksTableUpdateCompanionBuilder,
          (Book, $$BooksTableReferences),
          Book,
          PrefetchHooks Function({
            bool readingSessionsRefs,
            bool readingNotesRefs,
          })
        > {
  $$BooksTableTableManager(_$AppDatabase db, $BooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> author = const Value.absent(),
                Value<int?> totalPages = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => BooksCompanion(
                id: id,
                title: title,
                author: author,
                totalPages: totalPages,
                status: status,
                rating: rating,
                coverPath: coverPath,
                finishedAt: finishedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> author = const Value.absent(),
                Value<int?> totalPages = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<String?> coverPath = const Value.absent(),
                Value<DateTime?> finishedAt = const Value.absent(),
              }) => BooksCompanion.insert(
                id: id,
                title: title,
                author: author,
                totalPages: totalPages,
                status: status,
                rating: rating,
                coverPath: coverPath,
                finishedAt: finishedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BooksTable, Book>(table),
                  $$BooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({readingSessionsRefs = false, readingNotesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingSessionsRefs) db.readingSessions,
                    if (readingNotesRefs) db.readingNotes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingSessionsRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingSession
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (readingNotesRefs)
                        await $_getPrefetchedData<
                          Book,
                          $BooksTable,
                          ReadingNote
                        >(
                          currentTable: table,
                          referencedTable: $$BooksTableReferences
                              ._readingNotesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BooksTableReferences(
                                db,
                                table,
                                p0,
                              ).readingNotesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.bookId == item.id,
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

typedef $$BooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BooksTable,
      Book,
      $$BooksTableFilterComposer,
      $$BooksTableOrderingComposer,
      $$BooksTableAnnotationComposer,
      $$BooksTableCreateCompanionBuilder,
      $$BooksTableUpdateCompanionBuilder,
      (Book, $$BooksTableReferences),
      Book,
      PrefetchHooks Function({bool readingSessionsRefs, bool readingNotesRefs})
    >;
typedef $$ReadingSessionsTableCreateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      required int bookId,
      required DateTime startAt,
      Value<DateTime?> endAt,
      Value<int?> endPage,
    });
typedef $$ReadingSessionsTableUpdateCompanionBuilder =
    ReadingSessionsCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<DateTime> startAt,
      Value<DateTime?> endAt,
      Value<int?> endPage,
    });

final class $$ReadingSessionsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReadingSessionsTable, ReadingSession> {
  $$ReadingSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_sessions__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingNotesTable, List<ReadingNote>>
  _readingNotesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingNotes,
    aliasName: 'reading_sessions__id__reading_notes__session_id',
  );

  $$ReadingNotesTableProcessedTableManager get readingNotesRefs {
    final manager = $$ReadingNotesTableTableManager(
      $_db,
      $_db.readingNotes,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_readingNotesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ReadingSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableFilterComposer({
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

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingNotesRefs(
    Expression<bool> Function($$ReadingNotesTableFilterComposer f) f,
  ) {
    final $$ReadingNotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingNotes,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingNotesTableFilterComposer(
            $db: $db,
            $table: $db.readingNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endPage => $composableBuilder(
    column: $table.endPage,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingSessionsTable> {
  $$ReadingSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<int> get endPage =>
      $composableBuilder(column: $table.endPage, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingNotesRefs<T extends Object>(
    Expression<T> Function($$ReadingNotesTableAnnotationComposer a) f,
  ) {
    final $$ReadingNotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingNotes,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingNotesTableAnnotationComposer(
            $db: $db,
            $table: $db.readingNotes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ReadingSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingSessionsTable,
          ReadingSession,
          $$ReadingSessionsTableFilterComposer,
          $$ReadingSessionsTableOrderingComposer,
          $$ReadingSessionsTableAnnotationComposer,
          $$ReadingSessionsTableCreateCompanionBuilder,
          $$ReadingSessionsTableUpdateCompanionBuilder,
          (ReadingSession, $$ReadingSessionsTableReferences),
          ReadingSession,
          PrefetchHooks Function({bool bookId, bool readingNotesRefs})
        > {
  $$ReadingSessionsTableTableManager(
    _$AppDatabase db,
    $ReadingSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<int?> endPage = const Value.absent(),
              }) => ReadingSessionsCompanion(
                id: id,
                bookId: bookId,
                startAt: startAt,
                endAt: endAt,
                endPage: endPage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                required DateTime startAt,
                Value<DateTime?> endAt = const Value.absent(),
                Value<int?> endPage = const Value.absent(),
              }) => ReadingSessionsCompanion.insert(
                id: id,
                bookId: bookId,
                startAt: startAt,
                endAt: endAt,
                endPage: endPage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingSessionsTable, ReadingSession>(table),
                  $$ReadingSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, readingNotesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (readingNotesRefs) db.readingNotes],
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
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $$ReadingSessionsTableReferences
                            ._bookIdTable(db),
                        referencedColumn: $$ReadingSessionsTableReferences
                            ._bookIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (readingNotesRefs)
                    await $_getPrefetchedData<
                      ReadingSession,
                      $ReadingSessionsTable,
                      ReadingNote
                    >(
                      currentTable: table,
                      referencedTable: $$ReadingSessionsTableReferences
                          ._readingNotesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ReadingSessionsTableReferences(
                            db,
                            table,
                            p0,
                          ).readingNotesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.sessionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ReadingSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingSessionsTable,
      ReadingSession,
      $$ReadingSessionsTableFilterComposer,
      $$ReadingSessionsTableOrderingComposer,
      $$ReadingSessionsTableAnnotationComposer,
      $$ReadingSessionsTableCreateCompanionBuilder,
      $$ReadingSessionsTableUpdateCompanionBuilder,
      (ReadingSession, $$ReadingSessionsTableReferences),
      ReadingSession,
      PrefetchHooks Function({bool bookId, bool readingNotesRefs})
    >;
typedef $$ReadingNotesTableCreateCompanionBuilder =
    ReadingNotesCompanion Function({
      Value<int> id,
      required int bookId,
      Value<int?> sessionId,
      required String body,
      Value<bool> isQuote,
      required DateTime createdAt,
    });
typedef $$ReadingNotesTableUpdateCompanionBuilder =
    ReadingNotesCompanion Function({
      Value<int> id,
      Value<int> bookId,
      Value<int?> sessionId,
      Value<String> body,
      Value<bool> isQuote,
      Value<DateTime> createdAt,
    });

final class $$ReadingNotesTableReferences
    extends BaseReferences<_$AppDatabase, $ReadingNotesTable, ReadingNote> {
  $$ReadingNotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BooksTable _bookIdTable(_$AppDatabase db) =>
      db.books.createAlias('reading_notes__book_id__books__id');

  $$BooksTableProcessedTableManager get bookId {
    final $_column = $_itemColumn<int>('book_id')!;

    final manager = $$BooksTableTableManager(
      $_db,
      $_db.books,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ReadingSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .readingSessions
      .createAlias('reading_notes__session_id__reading_sessions__id');

  $$ReadingSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<int>('session_id');
    if ($_column == null) return null;
    final manager = $$ReadingSessionsTableTableManager(
      $_db,
      $_db.readingSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingNotesTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingNotesTable> {
  $$ReadingNotesTableFilterComposer({
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

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isQuote => $composableBuilder(
    column: $table.isQuote,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$BooksTableFilterComposer get bookId {
    final $$BooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableFilterComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingSessionsTableFilterComposer get sessionId {
    final $$ReadingSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableFilterComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingNotesTable> {
  $$ReadingNotesTableOrderingComposer({
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

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isQuote => $composableBuilder(
    column: $table.isQuote,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$BooksTableOrderingComposer get bookId {
    final $$BooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableOrderingComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingSessionsTableOrderingComposer get sessionId {
    final $$ReadingSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingNotesTable> {
  $$ReadingNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isQuote =>
      $composableBuilder(column: $table.isQuote, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$BooksTableAnnotationComposer get bookId {
    final $$BooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bookId,
      referencedTable: $db.books,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BooksTableAnnotationComposer(
            $db: $db,
            $table: $db.books,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ReadingSessionsTableAnnotationComposer get sessionId {
    final $$ReadingSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.readingSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.readingSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingNotesTable,
          ReadingNote,
          $$ReadingNotesTableFilterComposer,
          $$ReadingNotesTableOrderingComposer,
          $$ReadingNotesTableAnnotationComposer,
          $$ReadingNotesTableCreateCompanionBuilder,
          $$ReadingNotesTableUpdateCompanionBuilder,
          (ReadingNote, $$ReadingNotesTableReferences),
          ReadingNote,
          PrefetchHooks Function({bool bookId, bool sessionId})
        > {
  $$ReadingNotesTableTableManager(_$AppDatabase db, $ReadingNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> bookId = const Value.absent(),
                Value<int?> sessionId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isQuote = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReadingNotesCompanion(
                id: id,
                bookId: bookId,
                sessionId: sessionId,
                body: body,
                isQuote: isQuote,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int bookId,
                Value<int?> sessionId = const Value.absent(),
                required String body,
                Value<bool> isQuote = const Value.absent(),
                required DateTime createdAt,
              }) => ReadingNotesCompanion.insert(
                id: id,
                bookId: bookId,
                sessionId: sessionId,
                body: body,
                isQuote: isQuote,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingNotesTable, ReadingNote>(table),
                  $$ReadingNotesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({bookId = false, sessionId = false}) {
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
                    if (bookId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.bookId,
                        referencedTable: $$ReadingNotesTableReferences
                            ._bookIdTable(db),
                        referencedColumn: $$ReadingNotesTableReferences
                            ._bookIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$ReadingNotesTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$ReadingNotesTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
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

typedef $$ReadingNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingNotesTable,
      ReadingNote,
      $$ReadingNotesTableFilterComposer,
      $$ReadingNotesTableOrderingComposer,
      $$ReadingNotesTableAnnotationComposer,
      $$ReadingNotesTableCreateCompanionBuilder,
      $$ReadingNotesTableUpdateCompanionBuilder,
      (ReadingNote, $$ReadingNotesTableReferences),
      ReadingNote,
      PrefetchHooks Function({bool bookId, bool sessionId})
    >;
typedef $$MemoryCategoriesTableCreateCompanionBuilder =
    MemoryCategoriesCompanion Function({
      Value<int> id,
      required String name,
      Value<bool> archived,
    });
typedef $$MemoryCategoriesTableUpdateCompanionBuilder =
    MemoryCategoriesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<bool> archived,
    });

final class $$MemoryCategoriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $MemoryCategoriesTable, MemoryCategory> {
  $$MemoryCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$MemoryEventsTable, List<MemoryEvent>>
  _memoryEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoryEvents,
    aliasName: 'memory_categories__id__memory_events__category_id',
  );

  $$MemoryEventsTableProcessedTableManager get memoryEventsRefs {
    final manager = $$MemoryEventsTableTableManager(
      $_db,
      $_db.memoryEvents,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoryEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemoryCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryCategoriesTable> {
  $$MemoryCategoriesTableFilterComposer({
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> memoryEventsRefs(
    Expression<bool> Function($$MemoryEventsTableFilterComposer f) f,
  ) {
    final $$MemoryEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryEvents,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEventsTableFilterComposer(
            $db: $db,
            $table: $db.memoryEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryCategoriesTable> {
  $$MemoryCategoriesTableOrderingComposer({
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MemoryCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryCategoriesTable> {
  $$MemoryCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  Expression<T> memoryEventsRefs<T extends Object>(
    Expression<T> Function($$MemoryEventsTableAnnotationComposer a) f,
  ) {
    final $$MemoryEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryEvents,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryCategoriesTable,
          MemoryCategory,
          $$MemoryCategoriesTableFilterComposer,
          $$MemoryCategoriesTableOrderingComposer,
          $$MemoryCategoriesTableAnnotationComposer,
          $$MemoryCategoriesTableCreateCompanionBuilder,
          $$MemoryCategoriesTableUpdateCompanionBuilder,
          (MemoryCategory, $$MemoryCategoriesTableReferences),
          MemoryCategory,
          PrefetchHooks Function({bool memoryEventsRefs})
        > {
  $$MemoryCategoriesTableTableManager(
    _$AppDatabase db,
    $MemoryCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> archived = const Value.absent(),
              }) => MemoryCategoriesCompanion(
                id: id,
                name: name,
                archived: archived,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<bool> archived = const Value.absent(),
              }) => MemoryCategoriesCompanion.insert(
                id: id,
                name: name,
                archived: archived,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemoryCategoriesTable, MemoryCategory>(table),
                  $$MemoryCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memoryEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (memoryEventsRefs) db.memoryEvents],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (memoryEventsRefs)
                    await $_getPrefetchedData<
                      MemoryCategory,
                      $MemoryCategoriesTable,
                      MemoryEvent
                    >(
                      currentTable: table,
                      referencedTable: $$MemoryCategoriesTableReferences
                          ._memoryEventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MemoryCategoriesTableReferences(
                            db,
                            table,
                            p0,
                          ).memoryEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.categoryId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MemoryCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryCategoriesTable,
      MemoryCategory,
      $$MemoryCategoriesTableFilterComposer,
      $$MemoryCategoriesTableOrderingComposer,
      $$MemoryCategoriesTableAnnotationComposer,
      $$MemoryCategoriesTableCreateCompanionBuilder,
      $$MemoryCategoriesTableUpdateCompanionBuilder,
      (MemoryCategory, $$MemoryCategoriesTableReferences),
      MemoryCategory,
      PrefetchHooks Function({bool memoryEventsRefs})
    >;
typedef $$MemoryEventsTableCreateCompanionBuilder =
    MemoryEventsCompanion Function({
      Value<int> id,
      required String title,
      Value<String> kind,
      Value<String> precision,
      Value<int?> year,
      Value<int?> month,
      Value<int?> day,
      Value<String?> person,
      required int categoryId,
      Value<String?> place,
      Value<String?> description,
      Value<int?> coverMediaId,
      Value<bool> remindOnDay,
      Value<String> remindDaysBefore,
      required DateTime createdAt,
    });
typedef $$MemoryEventsTableUpdateCompanionBuilder =
    MemoryEventsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String> kind,
      Value<String> precision,
      Value<int?> year,
      Value<int?> month,
      Value<int?> day,
      Value<String?> person,
      Value<int> categoryId,
      Value<String?> place,
      Value<String?> description,
      Value<int?> coverMediaId,
      Value<bool> remindOnDay,
      Value<String> remindDaysBefore,
      Value<DateTime> createdAt,
    });

final class $$MemoryEventsTableReferences
    extends BaseReferences<_$AppDatabase, $MemoryEventsTable, MemoryEvent> {
  $$MemoryEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemoryCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .memoryCategories
      .createAlias('memory_events__category_id__memory_categories__id');

  $$MemoryCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<int>('category_id')!;

    final manager = $$MemoryCategoriesTableTableManager(
      $_db,
      $_db.memoryCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MemoryMediaTable, List<MemoryMediaItem>>
  _memoryMediaRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.memoryMedia,
    aliasName: 'memory_events__id__memory_media__event_id',
  );

  $$MemoryMediaTableProcessedTableManager get memoryMediaRefs {
    final manager = $$MemoryMediaTableTableManager(
      $_db,
      $_db.memoryMedia,
    ).filter((f) => f.eventId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_memoryMediaRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MemoryEventsTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get precision => $composableBuilder(
    column: $table.precision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remindOnDay => $composableBuilder(
    column: $table.remindOnDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryCategoriesTableFilterComposer get categoryId {
    final $$MemoryCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.memoryCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.memoryCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> memoryMediaRefs(
    Expression<bool> Function($$MemoryMediaTableFilterComposer f) f,
  ) {
    final $$MemoryMediaTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryMedia,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryMediaTableFilterComposer(
            $db: $db,
            $table: $db.memoryMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get precision => $composableBuilder(
    column: $table.precision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get person => $composableBuilder(
    column: $table.person,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get place => $composableBuilder(
    column: $table.place,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remindOnDay => $composableBuilder(
    column: $table.remindOnDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryCategoriesTableOrderingComposer get categoryId {
    final $$MemoryCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.memoryCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.memoryCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryEventsTable> {
  $$MemoryEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get precision =>
      $composableBuilder(column: $table.precision, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get person =>
      $composableBuilder(column: $table.person, builder: (column) => column);

  GeneratedColumn<String> get place =>
      $composableBuilder(column: $table.place, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get coverMediaId => $composableBuilder(
    column: $table.coverMediaId,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remindOnDay => $composableBuilder(
    column: $table.remindOnDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remindDaysBefore => $composableBuilder(
    column: $table.remindDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$MemoryCategoriesTableAnnotationComposer get categoryId {
    final $$MemoryCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.memoryCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> memoryMediaRefs<T extends Object>(
    Expression<T> Function($$MemoryMediaTableAnnotationComposer a) f,
  ) {
    final $$MemoryMediaTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.memoryMedia,
      getReferencedColumn: (t) => t.eventId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryMediaTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryMedia,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MemoryEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryEventsTable,
          MemoryEvent,
          $$MemoryEventsTableFilterComposer,
          $$MemoryEventsTableOrderingComposer,
          $$MemoryEventsTableAnnotationComposer,
          $$MemoryEventsTableCreateCompanionBuilder,
          $$MemoryEventsTableUpdateCompanionBuilder,
          (MemoryEvent, $$MemoryEventsTableReferences),
          MemoryEvent,
          PrefetchHooks Function({bool categoryId, bool memoryMediaRefs})
        > {
  $$MemoryEventsTableTableManager(_$AppDatabase db, $MemoryEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> precision = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<int?> day = const Value.absent(),
                Value<String?> person = const Value.absent(),
                Value<int> categoryId = const Value.absent(),
                Value<String?> place = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> coverMediaId = const Value.absent(),
                Value<bool> remindOnDay = const Value.absent(),
                Value<String> remindDaysBefore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MemoryEventsCompanion(
                id: id,
                title: title,
                kind: kind,
                precision: precision,
                year: year,
                month: month,
                day: day,
                person: person,
                categoryId: categoryId,
                place: place,
                description: description,
                coverMediaId: coverMediaId,
                remindOnDay: remindOnDay,
                remindDaysBefore: remindDaysBefore,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String> kind = const Value.absent(),
                Value<String> precision = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<int?> month = const Value.absent(),
                Value<int?> day = const Value.absent(),
                Value<String?> person = const Value.absent(),
                required int categoryId,
                Value<String?> place = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int?> coverMediaId = const Value.absent(),
                Value<bool> remindOnDay = const Value.absent(),
                Value<String> remindDaysBefore = const Value.absent(),
                required DateTime createdAt,
              }) => MemoryEventsCompanion.insert(
                id: id,
                title: title,
                kind: kind,
                precision: precision,
                year: year,
                month: month,
                day: day,
                person: person,
                categoryId: categoryId,
                place: place,
                description: description,
                coverMediaId: coverMediaId,
                remindOnDay: remindOnDay,
                remindDaysBefore: remindDaysBefore,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemoryEventsTable, MemoryEvent>(table),
                  $$MemoryEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({categoryId = false, memoryMediaRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (memoryMediaRefs) db.memoryMedia,
                  ],
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
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$MemoryEventsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$MemoryEventsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (memoryMediaRefs)
                        await $_getPrefetchedData<
                          MemoryEvent,
                          $MemoryEventsTable,
                          MemoryMediaItem
                        >(
                          currentTable: table,
                          referencedTable: $$MemoryEventsTableReferences
                              ._memoryMediaRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$MemoryEventsTableReferences(
                                db,
                                table,
                                p0,
                              ).memoryMediaRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.eventId == item.id,
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

typedef $$MemoryEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryEventsTable,
      MemoryEvent,
      $$MemoryEventsTableFilterComposer,
      $$MemoryEventsTableOrderingComposer,
      $$MemoryEventsTableAnnotationComposer,
      $$MemoryEventsTableCreateCompanionBuilder,
      $$MemoryEventsTableUpdateCompanionBuilder,
      (MemoryEvent, $$MemoryEventsTableReferences),
      MemoryEvent,
      PrefetchHooks Function({bool categoryId, bool memoryMediaRefs})
    >;
typedef $$MemoryMediaTableCreateCompanionBuilder =
    MemoryMediaCompanion Function({
      Value<int> id,
      required int eventId,
      required String path,
      Value<bool> isVideo,
      Value<String?> thumbPath,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> sizeBytes,
    });
typedef $$MemoryMediaTableUpdateCompanionBuilder =
    MemoryMediaCompanion Function({
      Value<int> id,
      Value<int> eventId,
      Value<String> path,
      Value<bool> isVideo,
      Value<String?> thumbPath,
      Value<int?> durationMs,
      Value<int> sortOrder,
      Value<int> sizeBytes,
    });

final class $$MemoryMediaTableReferences
    extends BaseReferences<_$AppDatabase, $MemoryMediaTable, MemoryMediaItem> {
  $$MemoryMediaTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MemoryEventsTable _eventIdTable(_$AppDatabase db) =>
      db.memoryEvents.createAlias('memory_media__event_id__memory_events__id');

  $$MemoryEventsTableProcessedTableManager get eventId {
    final $_column = $_itemColumn<int>('event_id')!;

    final manager = $$MemoryEventsTableTableManager(
      $_db,
      $_db.memoryEvents,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_eventIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MemoryMediaTableFilterComposer
    extends Composer<_$AppDatabase, $MemoryMediaTable> {
  $$MemoryMediaTableFilterComposer({
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

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  $$MemoryEventsTableFilterComposer get eventId {
    final $$MemoryEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.memoryEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEventsTableFilterComposer(
            $db: $db,
            $table: $db.memoryEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaTableOrderingComposer
    extends Composer<_$AppDatabase, $MemoryMediaTable> {
  $$MemoryMediaTableOrderingComposer({
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

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVideo => $composableBuilder(
    column: $table.isVideo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get thumbPath => $composableBuilder(
    column: $table.thumbPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  $$MemoryEventsTableOrderingComposer get eventId {
    final $$MemoryEventsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.memoryEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEventsTableOrderingComposer(
            $db: $db,
            $table: $db.memoryEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MemoryMediaTable> {
  $$MemoryMediaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<bool> get isVideo =>
      $composableBuilder(column: $table.isVideo, builder: (column) => column);

  GeneratedColumn<String> get thumbPath =>
      $composableBuilder(column: $table.thumbPath, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  $$MemoryEventsTableAnnotationComposer get eventId {
    final $$MemoryEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.eventId,
      referencedTable: $db.memoryEvents,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MemoryEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.memoryEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MemoryMediaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MemoryMediaTable,
          MemoryMediaItem,
          $$MemoryMediaTableFilterComposer,
          $$MemoryMediaTableOrderingComposer,
          $$MemoryMediaTableAnnotationComposer,
          $$MemoryMediaTableCreateCompanionBuilder,
          $$MemoryMediaTableUpdateCompanionBuilder,
          (MemoryMediaItem, $$MemoryMediaTableReferences),
          MemoryMediaItem,
          PrefetchHooks Function({bool eventId})
        > {
  $$MemoryMediaTableTableManager(_$AppDatabase db, $MemoryMediaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MemoryMediaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MemoryMediaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MemoryMediaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> eventId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<bool> isVideo = const Value.absent(),
                Value<String?> thumbPath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
              }) => MemoryMediaCompanion(
                id: id,
                eventId: eventId,
                path: path,
                isVideo: isVideo,
                thumbPath: thumbPath,
                durationMs: durationMs,
                sortOrder: sortOrder,
                sizeBytes: sizeBytes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int eventId,
                required String path,
                Value<bool> isVideo = const Value.absent(),
                Value<String?> thumbPath = const Value.absent(),
                Value<int?> durationMs = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
              }) => MemoryMediaCompanion.insert(
                id: id,
                eventId: eventId,
                path: path,
                isVideo: isVideo,
                thumbPath: thumbPath,
                durationMs: durationMs,
                sortOrder: sortOrder,
                sizeBytes: sizeBytes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MemoryMediaTable, MemoryMediaItem>(table),
                  $$MemoryMediaTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({eventId = false}) {
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
                    if (eventId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.eventId,
                        referencedTable: $$MemoryMediaTableReferences
                            ._eventIdTable(db),
                        referencedColumn: $$MemoryMediaTableReferences
                            ._eventIdTable(db)
                            .id,
                      ) as T;
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

typedef $$MemoryMediaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MemoryMediaTable,
      MemoryMediaItem,
      $$MemoryMediaTableFilterComposer,
      $$MemoryMediaTableOrderingComposer,
      $$MemoryMediaTableAnnotationComposer,
      $$MemoryMediaTableCreateCompanionBuilder,
      $$MemoryMediaTableUpdateCompanionBuilder,
      (MemoryMediaItem, $$MemoryMediaTableReferences),
      MemoryMediaItem,
      PrefetchHooks Function({bool eventId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SleepSessionsTableTableManager get sleepSessions =>
      $$SleepSessionsTableTableManager(_db, _db.sleepSessions);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$StocksTableTableManager get stocks =>
      $$StocksTableTableManager(_db, _db.stocks);
  $$TradesTableTableManager get trades =>
      $$TradesTableTableManager(_db, _db.trades);
  $$WeeklySnapshotsTableTableManager get weeklySnapshots =>
      $$WeeklySnapshotsTableTableManager(_db, _db.weeklySnapshots);
  $$BooksTableTableManager get books =>
      $$BooksTableTableManager(_db, _db.books);
  $$ReadingSessionsTableTableManager get readingSessions =>
      $$ReadingSessionsTableTableManager(_db, _db.readingSessions);
  $$ReadingNotesTableTableManager get readingNotes =>
      $$ReadingNotesTableTableManager(_db, _db.readingNotes);
  $$MemoryCategoriesTableTableManager get memoryCategories =>
      $$MemoryCategoriesTableTableManager(_db, _db.memoryCategories);
  $$MemoryEventsTableTableManager get memoryEvents =>
      $$MemoryEventsTableTableManager(_db, _db.memoryEvents);
  $$MemoryMediaTableTableManager get memoryMedia =>
      $$MemoryMediaTableTableManager(_db, _db.memoryMedia);
}
