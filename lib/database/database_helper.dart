import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _db;
  static const String malariaTable = 'malaria';
  static const String volTable = 'volunteer';

  static var instance;
  DatabaseHelper() {
    _createDatabase();
  }

  /* CREATE DATABASE */
  Future<Database> _createDatabase() async {
    var dataPath = await getDatabasesPath();
    String path = join(dataPath, "malaria.db");
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // CREATE MALARIA TABLE
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $malariaTable(
          id INTEGER PRIMARY KEY,
          test_date TEXT,
          treatment_month TEXT,
          treatment_year TEXT,
          patient_name TEXT,
          age_unit TEXT,
          age TEXT,
          sex TEXT,
          preg TEXT,
          lact_mother TEXT,
          address TEXT,
          rdt_result TEXT,
          malaria_parasite TEXT,
          received_treatment TEXT,
          act24 TEXT,
          act24_amount INTEGER,
          act18 TEXT,
          act18_amount INTEGER,
          act12 TEXT,
          act12_amount INTEGER,
          act6 TEXT,
          act6_amount INTEGER,
          cq TEXT,
          cq_amount INTEGER,
          pq TEXT,
          pq_amount INTEGER,
          is_referred TEXT,
          is_dead TEXT,
          symptoms TEXT,
          travelling_before TEXT,
          persons_with_disability TEXT,
          internally_displaced TEXT,
          occupation TEXT,
          volunteer_id TEXT,
          volunteer_name TEXT,
          volunteer_village TEXT,
          volunteer_township TEXT,
          remark TEXT,
          reporter_name TEXT,
          reporter_id TEXT,
          reporter_village TEXT,
          reporter_township TEXT,
          sync_status TEXT
        )
      ''');

        // CREATE VOLUNTEER TABLE
        await db.execute('''
        CREATE TABLE IF NOT EXISTS $volTable(
          id INTEGER PRIMARY KEY,
          volunteer_name TEXT,
          volunteer_township TEXT,
          volunteer_village TEXT
        )
      ''');
      },
    );

    return _db;
  }

  // INSERT INTO MALARIA TABLE
  Future<int> insertMalaria(Map<String, dynamic> malaria) async {
    _db = await _createDatabase();
    return await _db.insert(malariaTable, malaria);
  }

  // SELECT * FROM MALARIA TABLE
  Future<List<Map<String, dynamic>>> getAllMalaria() async {
    _db = await _createDatabase();
    return await _db.rawQuery('SELECT * FROM $malariaTable ORDER BY id DESC');
  }

  // GET SINGLE MALARIA RECORD
  Future<Map<String, dynamic>> getMalariaById(int id) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> results = await _db.query(
      malariaTable,
      where: 'id=?',
      whereArgs: [id],
    );
    if (results.isEmpty) {
      return {};
    }
    return results.first;
  }

  // GET ALL UNSYNCED MALARIA RECORDS
  Future<List<Map<String, dynamic>>> getAllUnsyncedMalaria() async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> data = await _db.rawQuery(
      'SELECT * FROM $malariaTable WHERE sync_status=?',
      ['PENDING'],
    );
    return data;
  }

  // UPDATE MALARIA TABLE
  Future<int> updateMalaria(Map<String, dynamic> malaria, int id) async {
    _db = await _createDatabase();
    return await _db.update(
      malariaTable,
      malaria,
      where: "id=?",
      whereArgs: [id],
    );
  }

  // DELETE MALARIA ROW
  Future<int> deleteMalaria(int id) async {
    _db = await _createDatabase();
    return await _db.delete(malariaTable, where: "id=?", whereArgs: [id]);
  }

  // DELETE ALL ROWS IN MALARIA TABLE
  Future<int> delete() async {
    _db = await _createDatabase();
    return await _db.rawDelete("DELETE FROM $malariaTable");
  }

  // UPDATE sync_status AFTER SYNCHRONIZATION COMPLETED
  Future<void> updateAfterSync(List<int> syncedIds) async {
    _db = await _createDatabase();
    await _db.transaction((transaction) async {
      for (int id in syncedIds) {
        await transaction.update(
          malariaTable,
          {'sync_status': 'UPLOADED'},
          where: 'id=?',
          whereArgs: [id],
        );
      }
    });
    await _db.close();
  }

  // DELETE ALL SYNCED MALARIA RECORDS
  Future<int> deleteSyncedMalaria() async {
    _db = await _createDatabase();
    int deletedCount = await _db.delete(
      malariaTable,
      where: 'sync_status = ?',
      whereArgs: ['UPLOADED'],
    );
    await _db.close();
    return deletedCount;
  }

  // CHECK IF THERE ARE ANY SYNCED MALARIA RECORDS
  Future<bool> hasSyncedRecords() async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> syncedData = await _db.query(
      malariaTable,
      where: 'sync_status = ?',
      whereArgs: ['UPLOADED'],
      limit: 1, // We only need to know if at least one exists
    );
    return syncedData.isNotEmpty;
  }

  // INSERT INTO VOLUNTEER TABLE
  Future<int> insertVol(Map<String, dynamic> volunteer) async {
    _db = await _createDatabase();
    return await _db.insert(volTable, volunteer);
  }

  // SELECT * FROM VOLUNTEER TABLE
  Future<List<Map<String, dynamic>>> getAllVol() async {
    _db = await _createDatabase();
    return await _db.rawQuery('SELECT * FROM $volTable ORDER BY id ASC');
  }

  // GET ONE VOLUNTEER
  Future<Map<String, dynamic>> getVolunteerByName(String name) async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> result = await _db.rawQuery(
      'SELECT * FROM $volTable WHERE volunteer_name=?',
      [name],
    );
    return result.first;
  }

  // UPDATE VOLUNTEER TABLE
  Future<int> updateVol(Map<String, dynamic> volunteer, int id) async {
    _db = await _createDatabase();
    return await _db.update(
      volTable,
      volunteer,
      where: "id=?",
      whereArgs: [id],
    );
  }

  // DELETE VOLUNTEER ROW
  Future<int> deleteVol(int id) async {
    _db = await _createDatabase();
    return await _db.delete(volTable, where: "id=?", whereArgs: [id]);
  }
}
