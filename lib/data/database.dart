import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// История сохранённых заключений: черновик выбора (JSON) + готовый текст,
/// чтобы можно было и посмотреть текст, и загрузить выбор обратно
/// в конструктор одним нажатием.
class SavedReports extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get examJson => text()();
  TextColumn get fullText => text()();
  TextColumn get descriptionText => text()();
  TextColumn get conclusionText => text()();
}

@DriftDatabase(tables: [SavedReports])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> saveReport({
    required String examJson,
    required String fullText,
    required String descriptionText,
    required String conclusionText,
  }) {
    return into(savedReports).insert(
      SavedReportsCompanion.insert(
        examJson: examJson,
        fullText: fullText,
        descriptionText: descriptionText,
        conclusionText: conclusionText,
      ),
    );
  }

  Stream<List<SavedReport>> watchAllReports() {
    return (select(savedReports)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<void> deleteReport(int id) {
    return (delete(savedReports)..where((t) => t.id.equals(id))).go();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'mammo_reports',
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
    ),
  );
}
