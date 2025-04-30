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
      reporter_id: map['reporter_id'].toString(),
      reporter_name: map['reporter_name'] ?? '',
      reporter_township: map['reporter_township'] ?? '',
      reporter_village: map['reporter_village'] ?? '',
      volunteer_id: map['volunteer_id'] ?? '',
      volunteer_name: map['volunteer_name'] ?? '',
      volunteer_township: map['volunteer_township'] ?? '',
      volunteer_village: map['volunteer_village'] ?? '',
      treatment_month: map['treatment_month'] ?? '',
      treatment_year: map['treatment_year'] ?? '',
      test_date: map['test_date'] ?? '',
      patient_name: map['patient_name'] ?? '',
      age_unit: map['age_unit'] ?? '',
      age: map['patient_age'] ?? '',
      address: map['address'] ?? '',
      sex: map['sex'] ?? '',
      isPregnant: map['preg'] ?? '',
      lact_mother: map['lact_mother'] ?? '',
      rdtResult: map['rdt_result'] ?? '',
      malariaParasite: map['malaria_parasite'] ?? '',
      symptoms: map['symptoms'] ?? '',
      act24: map['act24'] ?? '',
      act24_amount: map['act24_amount']?.toString() ?? '0',
      act18: map['act18'] ?? '',
      act18_amount: map['act18_amount']?.toString() ?? '0',
      act12: map['act12'] ?? '',
      act12_amount: map['act12_amount']?.toString() ?? '0',
      act6: map['act6'] ?? '',
      act6_amount: map['act6_amount']?.toString() ?? '0',
      cq: map['cq'] ?? '',
      cq_amount: map['cq_amount']?.toString() ?? '0',
      pq: map['pq'] ?? '',
      pq_amount: map['pq_amount']?.toString() ?? '0',
      isReferred: map['is_referred'] ?? '',
      isDead: map['is_dead'] ?? '',
      receivedTreatment: map['received_treatment'] ?? '',
      travelling_before: map['vvv'] ?? '',
      occupation: map['occupation'] ?? '',
      persons_with_disability: map['persons_with_disability'] ?? '',
      internally_displaced: map['internally_displaced'] ?? '',
      remark: map['remark'] ?? '',
      syncStatus: map['sync_status'] ?? 'PENDING',
    );
  }

  Map<String, dynamic> _malariaToMap(Malaria malaria) {
    return {
      if (malaria.id != null) 'id': malaria.id,
      'reporter_id': malaria.reporter_id,
      'reporter_name': malaria.reporter_name,
      'reporter_township': malaria.reporter_township,
      'reporter_village': malaria.reporter_village,
      'volunteer_id': malaria.volunteer_id,
      'volunteer_name': malaria.volunteer_name,
      'volunteer_township': malaria.volunteer_township,
      'volunteer_village': malaria.volunteer_village,
      'treatment_month': malaria.treatment_month,
      'treatment_year': malaria.treatment_year,
      'test_date': malaria.test_date,
      'patient_name': malaria.patient_name,
      'age_unit': malaria.age_unit,
      'age': malaria.age,
      'address': malaria.address,
      'sex': malaria.sex,
      'preg': malaria.isPregnant,
      'lact_mother': malaria.lact_mother,
      'rdt_result': malaria.rdtResult,
      'malaria_parasite': malaria.malariaParasite,
      'symptoms': malaria.symptoms,
      'act24': malaria.act24,
      'act24_amount': int.tryParse(malaria.act24_amount) ?? 0,
      'act18': malaria.act18,
      'act18_amount': int.tryParse(malaria.act18_amount) ?? 0,
      'act12': malaria.act12,
      'act12_amount': int.tryParse(malaria.act12_amount) ?? 0,
      'act6': malaria.act6,
      'act6_amount': int.tryParse(malaria.act6_amount) ?? 0,
      'cq': malaria.cq,
      'cq_amount': int.tryParse(malaria.cq) ?? 0,
      'pq': malaria.pq,
      'pq_amount': int.tryParse(malaria.pq_amount) ?? 0,
      'is_referred': malaria.isReferred,
      'is_dead': malaria.isDead,
      'received_treatment': malaria.receivedTreatment,
      'travelling_before': malaria.travelling_before,
      'occupation': malaria.occupation,
      'persons_with_disability': malaria.persons_with_disability,
      'internally_displaced': malaria.internally_displaced,
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
