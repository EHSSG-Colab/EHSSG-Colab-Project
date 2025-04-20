import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/malaria.dart';

class MalariaProvider extends ChangeNotifier {
  // Initiate empty list of malaria cases
  List<Malaria> cases = [];

  // Initiate
  MalariaProvider() {
    init();
  }

  Future<void> init() async {
    await fetchCases();
  }

  Future<void> fetchCases() async {
    final List<Map<String, dynamic>> localMalariaCases =
        await DatabaseHelper().getAllMalaria();

    cases = localMalariaCases.map((data) => _mapToMalaria(data)).toList();
    notifyListeners();
  }

  // Convert database Map object to Malaria object based on Malaria model class
  Malaria _mapToMalaria(Map<String, dynamic> map) {
    return Malaria(
      id: map['id'],
      dataCollectorId: map['data_collector_id'].toString(),
      dataCollectorName: map['data_collector_name'] ?? '',
      dataCollectorTownship: map['data_collector_township'] ?? '',
      dataCollectorVillage: map['data_collector_village'] ?? '',
      volunteerId: map['volunteer_id'] ?? '',
      volunteerName: map['volunteer_name'] ?? '',
      volunteerTownship: map['volunteer_township'] ?? '',
      volunteerVillage: map['volunteer_village'] ?? '',
      tMonth: map['t_month'] ?? '',
      tYear: map['t_year'] ?? '',
      dateOfRdt: map['date_of_rdt'] ?? '',
      patientName: map['patient_name'] ?? '',
      ageUnit: map['age_unit'] ?? '',
      patientAge: map['patient_age'] ?? '',
      patientAddress: map['patient_address'] ?? '',
      patientSex: map['patient_sex'] ?? '',
      isPregnant: map['is_pregnant'] ?? '',
      isLactatingMother: map['is_lactating_mother'] ?? '',
      rdtResult: map['rdt_result'] ?? '',
      malariaParasite: map['malaria_parasite'] ?? '',
      symptoms: map['symptoms'] ?? '',
      act24: map['act_24'] ?? '',
      act24Count: map['act_24_count']?.toString() ?? '0',
      act18: map['act_18'] ?? '',
      act18Count: map['act_18_count']?.toString() ?? '0',
      act12: map['act_12'] ?? '',
      act12Count: map['act_12_count']?.toString() ?? '0',
      act6: map['act_6'] ?? '',
      act6Count: map['act_6_count']?.toString() ?? '0',
      chloroquine: map['chloroquine'] ?? '',
      chloroquineCount: map['chloroquine_count']?.toString() ?? '0',
      primaquine: map['primaquine'] ?? '',
      primaquineCount: map['primaquine_count']?.toString() ?? '0',
      isReferred: map['is_referred'] ?? '',
      isDead: map['is_dead'] ?? '',
      receivedTreatment: map['received_treatment'] ?? '',
      hasTravelled: map['has_travelled'] ?? '',
      occupation: map['occupation'] ?? '',
      isPersonWithDisabilities: map['is_person_with_disabilities'] ?? '',
      isInternallyDisplaced: map['is_internally_displaced'] ?? '',
      remark: map['remark'] ?? '',
      syncStatus: map['sync_status'] ?? 'PENDING',
    );
  }

  // Convert malaria object to database map object
  Map<String, dynamic> _malariaToMap(Malaria malaria) {
    return {
      if (malaria.id != null) 'id': malaria.id,
      'data_collector_id': malaria.dataCollectorId,
      'data_collector_name': malaria.dataCollectorName,
      'data_collector_township': malaria.dataCollectorTownship,
      'data_collector_village': malaria.dataCollectorVillage,

      'volunteer_id': malaria.volunteerId,
      'volunteer_name': malaria.volunteerName,
      'volunteer_township': malaria.volunteerTownship,
      'volunteer_village': malaria.volunteerVillage,

      't_month': malaria.tMonth,
      't_year': malaria.tYear,
      'date_of_rdt': malaria.dateOfRdt,

      'patient_name': malaria.patientName,
      'age_unit': malaria.ageUnit,
      'patient_age': malaria.patientAge,
      'patient_address': malaria.patientAddress,
      'patient_sex': malaria.patientSex,
      'is_pregnant': malaria.isPregnant,
      'is_lactating_mother': malaria.isLactatingMother,

      'rdt_result': malaria.rdtResult,
      'malaria_parasite': malaria.malariaParasite,

      'symptoms': malaria.symptoms,

      'act_24': malaria.act24,
      'act_24_count': int.tryParse(malaria.act24Count) ?? 0,
      'act_18': malaria.act18,
      'act_18_count': int.tryParse(malaria.act18Count) ?? 0,
      'act_12': malaria.act12,
      'act_12_count': int.tryParse(malaria.act12Count) ?? 0,
      'act_6': malaria.act6,
      'act_6_count': int.tryParse(malaria.act6Count) ?? 0,
      'chloroquine': malaria.chloroquine,
      'chloroquine_count': int.tryParse(malaria.chloroquineCount) ?? 0,
      'primaquine': malaria.primaquine,
      'primaquine_count': int.tryParse(malaria.primaquineCount) ?? 0,

      'is_referred': malaria.isReferred,
      'is_dead': malaria.isDead,
      'received_treatment': malaria.receivedTreatment,
      'has_travelled': malaria.hasTravelled,
      'occupation': malaria.occupation,
      'is_person_with_disabilities': malaria.isPersonWithDisabilities,
      'is_internally_displaced': malaria.isInternallyDisplaced,
      'remark': malaria.remark,
      'sync_status': malaria.syncStatus,
    };
  }

  // Add new malaria case
  Future<void> addMalariaCase(Malaria malaria) async {
    final malariaMap = _malariaToMap(malaria);
    int id = await DatabaseHelper().insertMalaria(malariaMap);
    malaria.id = id;
    cases.add(malaria);
    notifyListeners();
  }

  // Get a malaria record by id
  Future<Malaria?> getMalariaById(int id) async {
    final Map<String, dynamic> malariaMap = await DatabaseHelper()
        .getMalariaById(id);

    if (malariaMap.isEmpty) {
      return null;
    }
    return _mapToMalaria(malariaMap);
  }

  // Update a malaria record
  Future<void> updateMalariaCase(Malaria malaria) async {
    if (malaria.id == null) {
      throw Exception("Cannot update a malaria case without and ID");
    }

    final malariaMap = _malariaToMap(malaria);
    await DatabaseHelper().updateMalaria(malariaMap, malaria.id!);

    int index = cases.indexWhere((c) => c.id == malaria.id);

    if (index != -1) {
      cases[index] = malaria;
      notifyListeners();
    }
  }

  // Delete a malaria record
  Future<void> deleteMalariaCase(int id) async {
    await DatabaseHelper().deleteMalaria(id);
    cases.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  // Get unsynced cases for synchronization
  Future<List<Malaria>> getUnsyncedCases() async {
    final List<Map<String, dynamic>> unsyncedMalariaCases =
        await DatabaseHelper().getAllUnsyncedMalaria();

    return unsyncedMalariaCases.map((data) => _mapToMalaria(data)).toList();
  }

  // Update sync status after synchronization
  Future<void> updateSyncStatus(List<int> syncedIds) async {
    await DatabaseHelper().updateAfterSync(syncedIds);

    // refresh the local list
    await fetchCases();
  }
}
