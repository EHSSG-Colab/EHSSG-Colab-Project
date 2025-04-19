class MalariaProvider extends ChangeNotifier {
  List<Malaria> cases = [];

  MalariaProvider() {
    init();
  }

  Future<void> init() async {
    final List<Map<String, dynamic>> localMalariaCases =
        await DatabaseHelper().getAllMalaria();

    cases = localMalariaCases.map((data) => Malaria.fromMap(data)).toList();
    notifyListeners();
  }

  Future<void> fetchCases() async {
    final List<Map<String, dynamic>> localMalariaCases =
        await DatabaseHelper().getAllMalaria();

    cases = localMalariaCases.map((data) => Malaria.fromMap(data)).toList();
    notifyListeners();
  }

  Future<void> addMalariaCase({
    required String rxMonth,
    required String rxYear,
    required String testDate,
    required String name,
    required String ageUnit,
    required String age,
    required String address,
    required String sex,
    required String pregnancy,
    required String underSixMonthInfantLactatingMother,
    required String rdtBool,
    required String rdtPosResult,
    required String symptom,
    required String act24,
    required String act24Amount,
    required String act18,
    required String act18Amount,
    required String act12,
    required String act12Amount,
    required String act6,
    required String act6Amount,
    required String chloroquine,
    required String chloroquineAmount,
    required String primaquine,
    required String primaquineAmount,
    required String refer,
    required String death,
    required String receiveRx,
    required String travel,
    required String job,
    required String otherJob,
    required String disabled,
    required String idp,
    required String remark,
    required String volName,
    required String volTsp,
    required String volVil,
    required String tsp,
    required String vil,
    required String usrName,
    required String usrId,
    required String syncedStatus,
  }) async {
    Malaria newCase = Malaria(
      rxMonth: rxMonth,
      rxYear: rxYear,
      testDate: testDate,
      name: name,
      ageUnit: ageUnit,
      age: age,
      address: address,
      sex: sex,
      pregnancy: pregnancy,
      underSixMonthInfantLactatingMother: underSixMonthInfantLactatingMother,
      rdtBool: rdtBool,
      rdtPosResult: rdtPosResult,
      symptom: symptom,
      act24: act24,
      act24Amount: act24Amount,
      act18: act18,
      act18Amount: act18Amount,
      act12: act12,
      act12Amount: act12Amount,
      act6: act6,
      act6Amount: act6Amount,
      chloroquine: chloroquine,
      chloroquineAmount: chloroquineAmount,
      primaquine: primaquine,
      primaquineAmount: primaquineAmount,
      refer: refer,
      death: death,
      receiveRx: receiveRx,
      travel: travel,
      job: job,
      otherJob: otherJob,
      disabled: disabled,
      idp: idp,
      remark: remark,
      volName: volName,
      volTsp: volTsp,
      volVil: volVil,
      tsp: tsp,
      vil: vil,
      usrName: usrName,
      usrId: usrId,
      syncedStatus: syncedStatus,
    );
    int id = await DatabaseHelper().insertMalaria(newCase.toMap());
    newCase.id = id;
    cases.add(newCase);
    notifyListeners();
  }

  Future<Malaria?> getMalariaById(int id) async {
    final DatabaseHelper dbHelper = DatabaseHelper();
    final Map<String, dynamic> malariaMap = await dbHelper.getMalariaById(id);

    if (malariaMap.isNotEmpty) {
      return Malaria.fromMap(malariaMap);
    }
    return null;
  }

  Future<void> updateMalariaCase({
    required int id,
    required String rxMonth,
    required String rxYear,
    required String testDate,
    required String name,
    required String ageUnit,
    required String age,
    required String address,
    required String sex,
    required String pregnancy,
    required String underSixMonthInfantLactatingMother,
    required String rdtBool,
    required String rdtPosResult,
    required String symptom,
    required String act24,
    required String act24Amount,
    required String act18,
    required String act18Amount,
    required String act12,
    required String act12Amount,
    required String act6,
    required String act6Amount,
    required String chloroquine,
    required String chloroquineAmount,
    required String primaquine,
    required String primaquineAmount,
    required String refer,
    required String death,
    required String receiveRx,
    required String travel,
    required String job,
    required String otherJob,
    required String disabled,
    required String idp,
    required String remark,
    required String volName,
    required String volTsp,
    required String volVil,
    required String tsp,
    required String vil,
    required String usrName,
    required String usrId,
    required String syncedStatus,
  }) async {
    Malaria updatedCase = Malaria(
      id: id,
      rxMonth: rxMonth,
      rxYear: rxYear,
      testDate: testDate,
      name: name,
      ageUnit: ageUnit,
      age: age,
      address: address,
      sex: sex,
      pregnancy: pregnancy,
      underSixMonthInfantLactatingMother: underSixMonthInfantLactatingMother,
      rdtBool: rdtBool,
      rdtPosResult: rdtPosResult,
      symptom: symptom,
      act24: act24,
      act24Amount: act24Amount,
      act18: act18,
      act18Amount: act18Amount,
      act12: act12,
      act12Amount: act12Amount,
      act6: act6,
      act6Amount: act6Amount,
      chloroquine: chloroquine,
      chloroquineAmount: chloroquineAmount,
      primaquine: primaquine,
      primaquineAmount: primaquineAmount,
      refer: refer,
      death: death,
      receiveRx: receiveRx,
      travel: travel,
      job: job,
      otherJob: otherJob,
      disabled: disabled,
      idp: idp,
      remark: remark,
      volName: volName,
      volTsp: volTsp,
      volVil: volVil,
      tsp: tsp,
      vil: vil,
      usrName: usrName,
      usrId: usrId,
      syncedStatus: syncedStatus,
    );
    await DatabaseHelper().updateMalaria(updatedCase.toMap(), id);
    int index = cases.indexWhere((updatedCase) => updatedCase.id == id);
    if (index != -1) {
      cases[index] = updatedCase;
      notifyListeners();
    }
  }

  Future<void> deleteMalariaCase(int id) async {
    await DatabaseHelper().deleteMalaria(id);
    cases.removeWhere((deletedCase) => deletedCase.id == id);
    notifyListeners();
  }
}
