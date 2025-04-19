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
  /*CREATE DATABASE*/
  Future<Database> _createDatabase() async {
    var dataPath = await getDatabasesPath();
    String path = join(dataPath, "malaria.db");
    _db = await openDatabase(path);

    //CREATE MALARIA TABLE
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS $malariaTable(
      id INTEGER PRIMARY KEY,
      data_collector_id INTEGER,
      data_collector_name TEXT,
      data_collector_township TEXT,
      data_collector_village TEXT,
      volunteer_id TEXT,
      volunteer_name TEXT,
      volunteer_township TEXT,
      volunteer_village TEXT,
      t_month TEXT,
      t_year TEXT,
      date_of_rdt TEXT,
      patient_name TEXT,
      age_unit TEXT,
      patient_age TEXT,
      patient_address TEXT,
      patient_sex TEXT,
      is_pregnant TEXT,
      is_lactating_mother TEXT,
      rdt_result TEXT,
      malaria_parasite TEXT,
      symptoms TEXT,
      act_24 TEXT,
      act_24_count INTEGER,
      act_18 TEXT,
      act_18_count INTEGER,
      act_12 TEXT,
      act_12_count INTEGER,
      act_6 TEXT,
      act_6_count INTEGER,
      chloroquine TEXT,
      chloroquine_count INTEGER,
      primaquine TEXT,
      primaquine_count INTEGER,
      is_referred TEXT,
      is_dead TEXT,
      received_treatment TEXT,
      has_travelled TEXT,
      occupation TEXT,
      is_person_with_disabilities TEXT,
      is_internally_displaced TEXT,
      remark TEXT,
      sync_status TEXT
      )''');

    // CREATE VOLUNTEER TABLE
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS $volTable(
      id INTEGER PRIMARY KEY,
      vol_name TEXT,
      vol_tsp TEXT,
      vol_vil TEXT)''');
    return _db;
  }

  // INSERT INTO MALARIA TABLE
  Future<int> insertMalaria(Map<String, dynamic> malaria) async {
    _db = await _createDatabase();
    return await _db.insert(malariaTable, malaria);
  }

  //SELECT * FROM MALARIA TABLE
  Future<List<Map<String, dynamic>>> getAllMalaria() async {
    _db = await _createDatabase();
    return await _db.rawQuery('SELECT * from $malariaTable ORDER BY id desc');
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
    await _db.close();
    return data;
  }

  //UPDATE MALARIA TABLE
  Future<int> updateMalaria(Map<String, dynamic> malaria, int id) async {
    _db = await _createDatabase();
    return await _db.update(
      malariaTable,
      malaria,
      where: "id=?",
      whereArgs: [id],
    );
  }

  //DELETE MALARIA ROW
  Future<int> deleteMalaria(int id) async {
    _db = await _createDatabase();
    return await _db.delete(malariaTable, where: "id=?", whereArgs: [id]);
  }

  //DELETE ALL ROW MALARIA TABLE
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

  /// Checks if there are any synced malaria records in the database
  /// Returns true if there are any records with 'UPLOADED' sync status
  Future<bool> hasSyncedRecords() async {
    _db = await _createDatabase();
    List<Map<String, dynamic>> syncedData = await _db.query(
      malariaTable,
      where: 'sync_status = ?',
      whereArgs: ['UPLOADED'],
      limit:
          1, // We only need to know if at least one exists, so limit query to 1 record
    );

    // Return true if at least one synced record exists
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
      'SELECT * FROM $volTable WHERE vol_name=?',
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
