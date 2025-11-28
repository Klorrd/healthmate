import 'package:flutter/material.dart';
import '../../database/healthmate_db.dart';
import '../../../models/health_record.dart';

class HealthRecordsProvider extends ChangeNotifier {
  List<HealthRecord> _records = [];
  bool _isLoading = false;

  List<HealthRecord> get records => _records;
  bool get isLoading => _isLoading;

  // Load all records from DB
  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();

    final db = HealthmateDatabase.instance;
    _records = await db.getAllRecords();

    _isLoading = false;
    notifyListeners();
  }

  // Add new record
  Future<void> addRecord(HealthRecord record) async {
    final db = HealthmateDatabase.instance;
    await db.insertRecord(record);

    await loadRecords(); // refresh list
  }

  // Update existing record
  Future<void> updateRecord(HealthRecord record) async {
    final db = HealthmateDatabase.instance;
    await db.updateRecord(record);

    await loadRecords();
  }

  // Delete record
  Future<void> deleteRecord(int id) async {
    final db = HealthmateDatabase.instance;
    await db.deleteRecord(id);

    await loadRecords();
  }

  // Search records by date
  Future<void> searchByDate(String date) async {
    _isLoading = true;
    notifyListeners();

    final db = HealthmateDatabase.instance;
    _records = await db.getRecordsByDate(date);

    _isLoading = false;
    notifyListeners();
  }

  // Reset filtered results back to full list
  Future<void> loadAll() async {
    await loadRecords();
  }
}
