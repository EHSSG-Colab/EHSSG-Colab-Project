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
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS $malariaTable('
      'data_collector_id INTEGER, '
      'data_collector_name TEXT, '
      'data_collector_township TEXT, '
      'data_collector_village TEXT, '
      'volunteer_id TEXT, '
      'volunteer_name TEXT, '
      'volunteer_township TEXT, '
      'volunteer_village TEXT, '
      't_month TEXT, '
      't_year TEXT, '
      'date_of_rdt TEXT, '
      'patient_name TEXT, '
      'age_unit TEXT, '
      'year TEXT, '
      'patient_age TEXT, '
      'patient_address TEXT, '
      'patient_sex TEXT, '
      'is_pregnant TEXT, '
      'is_lactating_mother TEXT, '
      'rdt_result TEXT, '
      'malaria_parasite TEXT, '
      'symptoms TEXT, '
      'act_24 TEXT, '
      'act_24_count INTEGER, '
      'act_18 TEXT, '
      'act_18_count INTEGER, '
      'act_12 TEXT, '
      'act_12_count INTEGER, '
      'act_6 TEXT, '
      'act_6_count INTEGER, '
      'chloroquine TEXT, '
      'chloroquine_count INTEGER, '
      'primaquine TEXT, '
      'primaquine_count INTEGER, '
      'is_referred TEXT, '
      'is_dead TEXT, '
      'received_treatment TEXT, '
      'has_travelled TEXT, '
      'occupation TEXT, '
      'is_person_with_disabilities TEXT, '
      'is_internally_displaced TEXT, '
      'remark TEXT'
      ')',
    );

    // CREATE VOLUNTEER TABLE
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS $volTable(id INTEGER PRIMARY KEY, vol_name TEXT, vol_tsp TEXT, vol_vil TEXT)',
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
