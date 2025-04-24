import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/malaria.dart';

class MalariaProvider extends ChangeNotifier {
  List<Malaria> cases = [];

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

  Malaria _mapToMalaria(Map<String, dynamic> map) {
    return Malaria(
      id: map['id'],
      reporter_id: map['data_collector_id'].toString(),
      reporter_name: map['data_collector_name'] ?? '',
      reporter_township: map['data_collector_township'] ?? '',
      reporter_village: map['data_collector_village'] ?? '',
      volunteer_id: map['volunteer_id'] ?? '',
      volunteer_name: map['volunteer_name'] ?? '',
      volunteer_township: map['volunteer_township'] ?? '',
      volunteer_village: map['volunteer_village'] ?? '',
      treatment_month: map['t_month'] ?? '',
      treatment_year: map['t_year'] ?? '',
      test_date: map['date_of_rdt'] ?? '',
      patient_name: map['patient_name'] ?? '',
      age_unit: map['age_unit'] ?? '',
      age: map['patient_age'] ?? '',
      address: map['patient_address'] ?? '',
      sex: map['patient_sex'] ?? '',
      isPregnant: map['is_pregnant'] ?? '',
      lact_mother: map['is_lactating_mother'] ?? '',
      rdtResult: map['rdt_result'] ?? '',
      malariaParasite: map['malaria_parasite'] ?? '',
      symptoms: map['symptoms'] ?? '',
      act24: map['act_24'] ?? '',
      act24_amount: map['act_24_count']?.toString() ?? '0',
      act18: map['act_18'] ?? '',
      act18_amount: map['act_18_count']?.toString() ?? '0',
      act12: map['act_12'] ?? '',
      act12_amount: map['act_12_count']?.toString() ?? '0',
      act6: map['act_6'] ?? '',
      act6_amount: map['act_6_count']?.toString() ?? '0',
      cq: map['chloroquine'] ?? '',
      cq_amount: map['chloroquine_count']?.toString() ?? '0',
      pq: map['primaquine'] ?? '',
      pq_amount: map['primaquine_count']?.toString() ?? '0',
      isReferred: map['is_referred'] ?? '',
      isDead: map['is_dead'] ?? '',
      receivedTreatment: map['received_treatment'] ?? '',
      travelling_before: map['has_travelled'] ?? '',
      occupation: map['occupation'] ?? '',
      persons_with_disability: map['is_person_with_disabilities'] ?? '',
      internally_displaced: map['is_internally_displaced'] ?? '',
      remark: map['remark'] ?? '',
      syncStatus: map['sync_status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> _malariaToMap(Malaria malaria) {
    return {
      if (malaria.id != null) 'id': malaria.id,
      'data_collector_id': malaria.reporter_id,
      'data_collector_name': malaria.reporter_name,
      'data_collector_township': malaria.reporter_township,
      'data_collector_village': malaria.reporter_village,
      'volunteer_id': malaria.volunteer_id,
      'volunteer_name': malaria.volunteer_name,
      'volunteer_township': malaria.volunteer_township,
      'volunteer_village': malaria.volunteer_village,
      't_month': malaria.treatment_month,
      't_year': malaria.treatment_year,
      'date_of_rdt': malaria.test_date,
      'patient_name': malaria.patient_name,
      'age_unit': malaria.age_unit,
      'patient_age': malaria.age,
      'patient_address': malaria.address,
      'patient_sex': malaria.sex,
      'is_pregnant': malaria.isPregnant,
      'is_lactating_mother': malaria.lact_mother,
      'rdt_result': malaria.rdtResult,
      'malaria_parasite': malaria.malariaParasite,
      'symptoms': malaria.symptoms,
      'act_24': malaria.act24,
      'act_24_count': int.tryParse(malaria.act24_amount) ?? 0,
      'act_18': malaria.act18,
      'act_18_count': int.tryParse(malaria.act18_amount) ?? 0,
      'act_12': malaria.act12,
      'act_12_count': int.tryParse(malaria.act12_amount) ?? 0,
      'act_6': malaria.act6,
      'act_6_count': int.tryParse(malaria.act6_amount) ?? 0,
      'chloroquine': malaria.cq,
      'chloroquine_count': int.tryParse(malaria.cq) ?? 0,
      'primaquine': malaria.pq,
      'primaquine_count': int.tryParse(malaria.pq_amount) ?? 0,
      'is_referred': malaria.isReferred,
      'is_dead': malaria.isDead,
      'received_treatment': malaria.receivedTreatment,
      'has_travelled': malaria.travelling_before,
      'occupation': malaria.occupation,
      'is_person_with_disabilities': malaria.persons_with_disability,
      'is_internally_displaced': malaria.internally_displaced,
      'remark': malaria.remark,
      'sync_status': malaria.syncStatus,
    };
  }

  Future<void> addMalariaCase(Malaria malaria) async {
    final malariaMap = _malariaToMap(malaria);
    int id = await DatabaseHelper().insertMalaria(malariaMap);
    malaria.id = id;
    cases.add(malaria);
    notifyListeners();
  }

  Future<Malaria?> getMalariaById(int id) async {
    final Map<String, dynamic> malariaMap = await DatabaseHelper()
        .getMalariaById(id);
    if (malariaMap.isEmpty) {
      return null;
    }
    return _mapToMalaria(malariaMap);
  }

  Future<void> updateMalariaCase(Malaria malaria) async {
    if (malaria.id == null) {
      throw Exception("Cannot update a malaria case without an ID");
    }
    final malariaMap = _malariaToMap(malaria);
    await DatabaseHelper().updateMalaria(malariaMap, malaria.id!);
    int index = cases.indexWhere((c) => c.id == malaria.id);
    if (index != -1) {
      cases[index] = malaria;
      notifyListeners();
    }
  }

  Future<void> deleteMalariaCase(int id) async {
    await DatabaseHelper().deleteMalaria(id);
    cases.removeWhere((c) => c.id == id);
    notifyListeners();
  }

  Future<List<Malaria>> getUnsyncedCases() async {
    final List<Map<String, dynamic>> unsyncedMalariaCases =
        await DatabaseHelper().getAllUnsyncedMalaria();
    return unsyncedMalariaCases.map((data) => _mapToMalaria(data)).toList();
  }

  Future<void> updateSyncStatus(List<int> syncedIds) async {
    await DatabaseHelper().updateAfterSync(syncedIds);
    await fetchCases();
  }
}
