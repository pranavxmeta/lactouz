// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MilkLogsTable extends MilkLogs with TableInfo<$MilkLogsTable, MilkLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MilkLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _unitPriceMeta = const VerificationMeta(
    'unitPrice',
  );
  @override
  late final GeneratedColumn<double> unitPrice = GeneratedColumn<double>(
    'unit_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(65.0),
  );
  static const VerificationMeta _isSkippedMeta = const VerificationMeta(
    'isSkipped',
  );
  @override
  late final GeneratedColumn<bool> isSkipped = GeneratedColumn<bool>(
    'is_skipped',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_skipped" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    date,
    quantity,
    unitPrice,
    isSkipped,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'milk_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<MilkLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
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
    }
    if (data.containsKey('unit_price')) {
      context.handle(
        _unitPriceMeta,
        unitPrice.isAcceptableOrUnknown(data['unit_price']!, _unitPriceMeta),
      );
    }
    if (data.containsKey('is_skipped')) {
      context.handle(
        _isSkippedMeta,
        isSkipped.isAcceptableOrUnknown(data['is_skipped']!, _isSkippedMeta),
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
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  MilkLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MilkLog(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unitPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}unit_price'],
      )!,
      isSkipped: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_skipped'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $MilkLogsTable createAlias(String alias) {
    return $MilkLogsTable(attachedDatabase, alias);
  }
}

class MilkLog extends DataClass implements Insertable<MilkLog> {
  final String date;
  final double quantity;
  final double unitPrice;
  final bool isSkipped;
  final String? note;
  const MilkLog({
    required this.date,
    required this.quantity,
    required this.unitPrice,
    required this.isSkipped,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['quantity'] = Variable<double>(quantity);
    map['unit_price'] = Variable<double>(unitPrice);
    map['is_skipped'] = Variable<bool>(isSkipped);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  MilkLogsCompanion toCompanion(bool nullToAbsent) {
    return MilkLogsCompanion(
      date: Value(date),
      quantity: Value(quantity),
      unitPrice: Value(unitPrice),
      isSkipped: Value(isSkipped),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory MilkLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MilkLog(
      date: serializer.fromJson<String>(json['date']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unitPrice: serializer.fromJson<double>(json['unitPrice']),
      isSkipped: serializer.fromJson<bool>(json['isSkipped']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'quantity': serializer.toJson<double>(quantity),
      'unitPrice': serializer.toJson<double>(unitPrice),
      'isSkipped': serializer.toJson<bool>(isSkipped),
      'note': serializer.toJson<String?>(note),
    };
  }

  MilkLog copyWith({
    String? date,
    double? quantity,
    double? unitPrice,
    bool? isSkipped,
    Value<String?> note = const Value.absent(),
  }) => MilkLog(
    date: date ?? this.date,
    quantity: quantity ?? this.quantity,
    unitPrice: unitPrice ?? this.unitPrice,
    isSkipped: isSkipped ?? this.isSkipped,
    note: note.present ? note.value : this.note,
  );
  MilkLog copyWithCompanion(MilkLogsCompanion data) {
    return MilkLog(
      date: data.date.present ? data.date.value : this.date,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPrice: data.unitPrice.present ? data.unitPrice.value : this.unitPrice,
      isSkipped: data.isSkipped.present ? data.isSkipped.value : this.isSkipped,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MilkLog(')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(date, quantity, unitPrice, isSkipped, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MilkLog &&
          other.date == this.date &&
          other.quantity == this.quantity &&
          other.unitPrice == this.unitPrice &&
          other.isSkipped == this.isSkipped &&
          other.note == this.note);
}

class MilkLogsCompanion extends UpdateCompanion<MilkLog> {
  final Value<String> date;
  final Value<double> quantity;
  final Value<double> unitPrice;
  final Value<bool> isSkipped;
  final Value<String?> note;
  final Value<int> rowid;
  const MilkLogsCompanion({
    this.date = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MilkLogsCompanion.insert({
    required String date,
    this.quantity = const Value.absent(),
    this.unitPrice = const Value.absent(),
    this.isSkipped = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : date = Value(date);
  static Insertable<MilkLog> custom({
    Expression<String>? date,
    Expression<double>? quantity,
    Expression<double>? unitPrice,
    Expression<bool>? isSkipped,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (quantity != null) 'quantity': quantity,
      if (unitPrice != null) 'unit_price': unitPrice,
      if (isSkipped != null) 'is_skipped': isSkipped,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MilkLogsCompanion copyWith({
    Value<String>? date,
    Value<double>? quantity,
    Value<double>? unitPrice,
    Value<bool>? isSkipped,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return MilkLogsCompanion(
      date: date ?? this.date,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      isSkipped: isSkipped ?? this.isSkipped,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unitPrice.present) {
      map['unit_price'] = Variable<double>(unitPrice.value);
    }
    if (isSkipped.present) {
      map['is_skipped'] = Variable<bool>(isSkipped.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MilkLogsCompanion(')
          ..write('date: $date, ')
          ..write('quantity: $quantity, ')
          ..write('unitPrice: $unitPrice, ')
          ..write('isSkipped: $isSkipped, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppConfigsTable extends AppConfigs
    with TableInfo<$AppConfigsTable, AppConfig> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppConfigsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _configKeyMeta = const VerificationMeta(
    'configKey',
  );
  @override
  late final GeneratedColumn<String> configKey = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _configValueMeta = const VerificationMeta(
    'configValue',
  );
  @override
  late final GeneratedColumn<String> configValue = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [configKey, configValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_configs';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppConfig> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _configKeyMeta,
        configKey.isAcceptableOrUnknown(data['key']!, _configKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_configKeyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _configValueMeta,
        configValue.isAcceptableOrUnknown(data['value']!, _configValueMeta),
      );
    } else if (isInserting) {
      context.missing(_configValueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {configKey};
  @override
  AppConfig map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppConfig(
      configKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      configValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppConfigsTable createAlias(String alias) {
    return $AppConfigsTable(attachedDatabase, alias);
  }
}

class AppConfig extends DataClass implements Insertable<AppConfig> {
  final String configKey;
  final String configValue;
  const AppConfig({required this.configKey, required this.configValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(configKey);
    map['value'] = Variable<String>(configValue);
    return map;
  }

  AppConfigsCompanion toCompanion(bool nullToAbsent) {
    return AppConfigsCompanion(
      configKey: Value(configKey),
      configValue: Value(configValue),
    );
  }

  factory AppConfig.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppConfig(
      configKey: serializer.fromJson<String>(json['configKey']),
      configValue: serializer.fromJson<String>(json['configValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'configKey': serializer.toJson<String>(configKey),
      'configValue': serializer.toJson<String>(configValue),
    };
  }

  AppConfig copyWith({String? configKey, String? configValue}) => AppConfig(
    configKey: configKey ?? this.configKey,
    configValue: configValue ?? this.configValue,
  );
  AppConfig copyWithCompanion(AppConfigsCompanion data) {
    return AppConfig(
      configKey: data.configKey.present ? data.configKey.value : this.configKey,
      configValue: data.configValue.present
          ? data.configValue.value
          : this.configValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppConfig(')
          ..write('configKey: $configKey, ')
          ..write('configValue: $configValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(configKey, configValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppConfig &&
          other.configKey == this.configKey &&
          other.configValue == this.configValue);
}

class AppConfigsCompanion extends UpdateCompanion<AppConfig> {
  final Value<String> configKey;
  final Value<String> configValue;
  final Value<int> rowid;
  const AppConfigsCompanion({
    this.configKey = const Value.absent(),
    this.configValue = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppConfigsCompanion.insert({
    required String configKey,
    required String configValue,
    this.rowid = const Value.absent(),
  }) : configKey = Value(configKey),
       configValue = Value(configValue);
  static Insertable<AppConfig> custom({
    Expression<String>? configKey,
    Expression<String>? configValue,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (configKey != null) 'key': configKey,
      if (configValue != null) 'value': configValue,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppConfigsCompanion copyWith({
    Value<String>? configKey,
    Value<String>? configValue,
    Value<int>? rowid,
  }) {
    return AppConfigsCompanion(
      configKey: configKey ?? this.configKey,
      configValue: configValue ?? this.configValue,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (configKey.present) {
      map['key'] = Variable<String>(configKey.value);
    }
    if (configValue.present) {
      map['value'] = Variable<String>(configValue.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppConfigsCompanion(')
          ..write('configKey: $configKey, ')
          ..write('configValue: $configValue, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MilkLogsTable milkLogs = $MilkLogsTable(this);
  late final $AppConfigsTable appConfigs = $AppConfigsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [milkLogs, appConfigs];
}

typedef $$MilkLogsTableCreateCompanionBuilder =
    MilkLogsCompanion Function({
      required String date,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<bool> isSkipped,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$MilkLogsTableUpdateCompanionBuilder =
    MilkLogsCompanion Function({
      Value<String> date,
      Value<double> quantity,
      Value<double> unitPrice,
      Value<bool> isSkipped,
      Value<String?> note,
      Value<int> rowid,
    });

class $$MilkLogsTableFilterComposer
    extends Composer<_$AppDatabase, $MilkLogsTable> {
  $$MilkLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MilkLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $MilkLogsTable> {
  $$MilkLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get unitPrice => $composableBuilder(
    column: $table.unitPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSkipped => $composableBuilder(
    column: $table.isSkipped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MilkLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MilkLogsTable> {
  $$MilkLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get unitPrice =>
      $composableBuilder(column: $table.unitPrice, builder: (column) => column);

  GeneratedColumn<bool> get isSkipped =>
      $composableBuilder(column: $table.isSkipped, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);
}

class $$MilkLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MilkLogsTable,
          MilkLog,
          $$MilkLogsTableFilterComposer,
          $$MilkLogsTableOrderingComposer,
          $$MilkLogsTableAnnotationComposer,
          $$MilkLogsTableCreateCompanionBuilder,
          $$MilkLogsTableUpdateCompanionBuilder,
          (MilkLog, BaseReferences<_$AppDatabase, $MilkLogsTable, MilkLog>),
          MilkLog,
          PrefetchHooks Function()
        > {
  $$MilkLogsTableTableManager(_$AppDatabase db, $MilkLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MilkLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MilkLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MilkLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilkLogsCompanion(
                date: date,
                quantity: quantity,
                unitPrice: unitPrice,
                isSkipped: isSkipped,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<double> quantity = const Value.absent(),
                Value<double> unitPrice = const Value.absent(),
                Value<bool> isSkipped = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MilkLogsCompanion.insert(
                date: date,
                quantity: quantity,
                unitPrice: unitPrice,
                isSkipped: isSkipped,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MilkLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MilkLogsTable,
      MilkLog,
      $$MilkLogsTableFilterComposer,
      $$MilkLogsTableOrderingComposer,
      $$MilkLogsTableAnnotationComposer,
      $$MilkLogsTableCreateCompanionBuilder,
      $$MilkLogsTableUpdateCompanionBuilder,
      (MilkLog, BaseReferences<_$AppDatabase, $MilkLogsTable, MilkLog>),
      MilkLog,
      PrefetchHooks Function()
    >;
typedef $$AppConfigsTableCreateCompanionBuilder =
    AppConfigsCompanion Function({
      required String configKey,
      required String configValue,
      Value<int> rowid,
    });
typedef $$AppConfigsTableUpdateCompanionBuilder =
    AppConfigsCompanion Function({
      Value<String> configKey,
      Value<String> configValue,
      Value<int> rowid,
    });

class $$AppConfigsTableFilterComposer
    extends Composer<_$AppDatabase, $AppConfigsTable> {
  $$AppConfigsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get configKey => $composableBuilder(
    column: $table.configKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppConfigsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppConfigsTable> {
  $$AppConfigsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get configKey => $composableBuilder(
    column: $table.configKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppConfigsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppConfigsTable> {
  $$AppConfigsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get configKey =>
      $composableBuilder(column: $table.configKey, builder: (column) => column);

  GeneratedColumn<String> get configValue => $composableBuilder(
    column: $table.configValue,
    builder: (column) => column,
  );
}

class $$AppConfigsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppConfigsTable,
          AppConfig,
          $$AppConfigsTableFilterComposer,
          $$AppConfigsTableOrderingComposer,
          $$AppConfigsTableAnnotationComposer,
          $$AppConfigsTableCreateCompanionBuilder,
          $$AppConfigsTableUpdateCompanionBuilder,
          (
            AppConfig,
            BaseReferences<_$AppDatabase, $AppConfigsTable, AppConfig>,
          ),
          AppConfig,
          PrefetchHooks Function()
        > {
  $$AppConfigsTableTableManager(_$AppDatabase db, $AppConfigsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppConfigsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppConfigsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppConfigsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> configKey = const Value.absent(),
                Value<String> configValue = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppConfigsCompanion(
                configKey: configKey,
                configValue: configValue,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String configKey,
                required String configValue,
                Value<int> rowid = const Value.absent(),
              }) => AppConfigsCompanion.insert(
                configKey: configKey,
                configValue: configValue,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppConfigsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppConfigsTable,
      AppConfig,
      $$AppConfigsTableFilterComposer,
      $$AppConfigsTableOrderingComposer,
      $$AppConfigsTableAnnotationComposer,
      $$AppConfigsTableCreateCompanionBuilder,
      $$AppConfigsTableUpdateCompanionBuilder,
      (AppConfig, BaseReferences<_$AppDatabase, $AppConfigsTable, AppConfig>),
      AppConfig,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MilkLogsTableTableManager get milkLogs =>
      $$MilkLogsTableTableManager(_db, _db.milkLogs);
  $$AppConfigsTableTableManager get appConfigs =>
      $$AppConfigsTableTableManager(_db, _db.appConfigs);
}
