import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  late Database _db;
  static const String malariaTable = 'malaria';
  static const String volTable = 'volunteer';

  static DatabaseHelper? instance;
  DatabaseHelper() {
    _createDatabase();
  }
  /*CREATE DATABASE*/
  Future<Database> _createDatabase() async {
    var dataPath = await getDatabasesPath();
    String path = join(dataPath, "malaria.db");
    _db = await openDatabase(path);

    //CREATE MALARIA TABLE
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS $malariaTable('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'test_date TEXT, '
      'treatment_month TEXT, '
      'treatment_year TEXT, '
      'patient_name TEXT, '
      'age_unit TEXT, '
      'age INTEGER, '
      'sex TEXT, '
      'preg INTEGER, '
      'lact_mother INTEGER, '
      'address TEXT, '
      'rdt_result INTEGER, '
      'malaria_parasite TEXT, '
      'received_treatment TEXT, '
      'act24 INTEGER, '
      'act24_amount TEXT, '
      'act18 INTEGER, '
      'act18_amount TEXT, '
      'act12 INTEGER, '
      'act12_amount TEXT, '
      'act6 INTEGER, '
      'act6_amount TEXT, '
      'cq INTEGER, '
      'cq_amount TEXT, '
      'pq INTEGER, '
      'pq_amount TEXT, '
      'is_referred INTEGER, '
      'is_dead INTEGER, '
      'symptoms TEXT, '
      'travelling_before INTEGER, '
      'persons_with_disability INTEGER, '
      'internally_displaced INTEGER, '
      'occupation TEXT, '
      'remark TEXT, '
      'reporter_name TEXT, '
      'reporter_id TEXT, '
      'reporter_village TEXT, '
      'reporter_township TEXT, '
      'volunteer_name TEXT, '
      'volunteer_township TEXT, '
      'volunteer_village TEXT);',
    );
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS $volTable(id INTEGER PRIMARY KEY, volunteer_name TEXT, volunteer_village TEXT)',
    );
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
