import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/health_record.dart';

class HealthmateDatabase {
  static final HealthmateDatabase instance = HealthmateDatabase._init();
  static Database? _database;

  HealthmateDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('healthmate.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE health_records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        steps INTEGER NOT NULL,
        calories INTEGER NOT NULL,
        water INTEGER NOT NULL
      )
    ''');

    await _insertDummyData(db);
  }


  // Dummy data to initialize app
  Future<void> _insertDummyData(Database db) async {
    final List<HealthRecord> dummyRecords = [
      HealthRecord(
        date: '2025-11-15',
        steps: 5000,
        calories: 300,
        water: 1500,
      ),
      HealthRecord(
        date: '2025-11-19',
        steps: 8000,
        calories: 450,
        water: 2000,
      ),
      HealthRecord(
        date: '2025-11-25',
        steps: 2500,
        calories: 180,
        water: 1000,
      ),
    ];

    for (var record in dummyRecords) {
      await db.insert('health_records', record.toMap());
    }
  }

  // CRUD Stuff
  Future<int> insertRecord(HealthRecord record) async {
    final db = await instance.database;
    final map = record.toMap()..remove('id');
    return await db.insert('health_records', map);
  }

  Future<List<HealthRecord>> getAllRecords() async {
    final db = await instance.database;
    final result = await db.query(
      'health_records',
      orderBy: 'date DESC',
    );
    return result.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<List<HealthRecord>> getRecordsByDate(String date) async {
    final db = await instance.database;
    final result = await db.query(
      'health_records',
      where: 'date = ?',
      whereArgs: [date],
      orderBy: 'id DESC',
    );
    return result.map((map) => HealthRecord.fromMap(map)).toList();
  }

  Future<int> updateRecord(HealthRecord record) async {
    final db = await instance.database;
    return await db.update(
      'health_records',
      record.toMap(),
      where: 'id = ?',
      whereArgs: [record.id],
    );
  }

  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete(
      'health_records',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
