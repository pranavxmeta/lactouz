// lib/core/database/database.dart
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

class MilkLogs extends Table {
  TextColumn get date => text().named('date')(); // Format: yyyy-MM-dd
  RealColumn get quantity => real().withDefault(const Constant(0.0))();
  RealColumn get unitPrice => real().withDefault(const Constant(65.0))();
  BoolColumn get isSkipped => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {date};
}

class AppConfigs extends Table {
  TextColumn get configKey => text().named('key')();
  TextColumn get configValue => text().named('value')();

  @override
  Set<Column> get primaryKey => {configKey};
}

@DriftDatabase(tables: [MilkLogs, AppConfigs])
class AppDatabase extends _$AppDatabase {
  // driftDatabase handles Android (SQLite via background isolate)
  // and Web (WASM / OPFS) automatically without dart:ffi issues
  AppDatabase()
    : super(
        driftDatabase(
          name: 'milk_tracker_db',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 1;

  Stream<List<MilkLog>> watchMonthLogs(String yearMonthPrefix) {
    return (select(milkLogs)
          ..where((tbl) => tbl.date.like('$yearMonthPrefix%'))
          ..orderBy([(t) => OrderingTerm(expression: t.date)]))
        .watch();
  }

  Stream<MilkLog?> watchLogForDate(String dateStr) {
    return (select(
      milkLogs,
    )..where((tbl) => tbl.date.equals(dateStr))).watchSingleOrNull();
  }

  Future<int> setMilkEntry({
    required String dateStr,
    required double qty,
    required double price,
    bool isSkipped = false,
    String? note,
  }) {
    return into(milkLogs).insertOnConflictUpdate(
      MilkLogsCompanion.insert(
        date: dateStr,
        quantity: Value(isSkipped ? 0.0 : qty),
        unitPrice: Value(price),
        isSkipped: Value(isSkipped),
        note: Value(note),
      ),
    );
  }

  Stream<String?> watchConfig(String key) {
    return (select(appConfigs)..where((tbl) => tbl.configKey.equals(key)))
        .map((row) => row.configValue)
        .watchSingleOrNull();
  }

  Future<void> setConfig(String key, String value) {
    return into(appConfigs).insertOnConflictUpdate(
      AppConfigsCompanion.insert(configKey: key, configValue: value),
    );
  }
}
