import 'package:malaria_case_report_01/models/malaria.dart';
import 'package:malaria_case_report_01/screens/malaria/malaria_form_data.dart';

import '../../constants/dropdown_options.dart';

/// Class responsible for transforming data between the Malaria model and form data
/// This separates the data transformation logic from the UI and validation
class MalariaDataTransformer {
  /// Convert form data to Malaria model for saving to database
  static Malaria formDataToModel(MalariaFormData formData, int? id) {
    return Malaria(
      id: id,
      reporter_id: formData.userInfo['userid'] ?? '',
      reporter_name: formData.userInfo['userName'] ?? '',
      reporter_township: formData.userInfo['userTownship'] ?? '',
      reporter_village: formData.userInfo['userVillage'] ?? '',
      volunteer_id: '', // This would need to be retrieved from the database
      volunteer_name: formData.selectedVolunteer ?? '',
      volunteer_township: formData.volunteerTownshipPlaceholder ?? '',
      volunteer_village: formData.volunteerVillagePlaceholder ?? '',
      treatment_month: formData.selectedMonth ?? '',
      treatment_year: formData.selectedYear ?? '',
      test_date: formData.testDate?.toIso8601String() ?? '',
      patient_name: formData.nameController.text,
      age_unit: formData.selectedAgeUnit ?? 'year',
      age: formData.ageController.text,
      address: formData.addressController.text,
      sex: formData.selectedGender ?? '',
      isPregnant: formData.isPregnant ? 'Yes' : 'No',
      lact_mother: formData.isLactatingMother ? 'Yes' : 'No',
      rdtResult: formData.selectedRdtResult ?? '',
      malariaParasite: formData.malariaParasite ?? '',
      symptoms: formData.symptomType ?? '',
      act24: formData.act24 ? 'Yes' : 'No',
      act24_amount: formData.act24AmountController.text,
      act18: formData.act18 ? 'Yes' : 'No',
      act18_amount: formData.act18AmountController.text,
      act12: formData.act12 ? 'Yes' : 'No',
      act12_amount: formData.act12AmountController.text,
      act6: formData.act6 ? 'Yes' : 'No',
      act6_amount: formData.act6AmountController.text,
      cq: formData.chloroquine ? 'Yes' : 'No',
      cq_amount: formData.chloroquineAmountController.text,
      pq: formData.primaquine ? 'Yes' : 'No',
      pq_amount: formData.primaquineAmountController.text,
      isReferred: formData.isReferred ? 'Yes' : 'No',
      isDead: formData.isDead ? 'Yes' : 'No',
      receivedTreatment: formData.receivedTreatment ?? '',
      travelling_before: formData.hasTravelled ? 'Yes' : 'No',
      occupation:
          formData.selectedOccupation == 'Other'
              ? formData.otherOccupationController.text
              : formData.selectedOccupation ?? '',
      persons_with_disability: formData.isDisabled ? 'Yes' : 'No',
      internally_displaced: formData.isIdp ? 'Yes' : 'No',
      remark: formData.remarkController.text,
      syncStatus: 'PENDING',
    );
  }

  /// Load data from Malaria model to form data for editing
  static void modelToFormData(Malaria malaria, MalariaFormData formData) {
    // Basic information
    formData.selectedMonth = malaria.treatment_month;
    formData.selectedYear = malaria.treatment_year;

    // Test date
    if (malaria.test_date.isNotEmpty) {
      formData.testDate = DateTime.parse(malaria.test_date);
      formData.isDatePicked = true;
    }

    // Patient information
    formData.nameController.text = malaria.patient_name;
    formData.selectedAgeUnit = malaria.age_unit;
    formData.ageController.text = malaria.age;
    formData.addressController.text = malaria.address;
    formData.selectedGender = malaria.sex;
    formData.isPregnant = malaria.isPregnant == 'Yes';
    formData.isLactatingMother = malaria.lact_mother == 'Yes';

    // Test results
    formData.selectedRdtResult = malaria.rdtResult;
    formData.malariaParasite = malaria.malariaParasite;
    formData.symptomType = malaria.symptoms;

    // Treatment details
    formData.act24 = malaria.act24 == 'Yes';
    formData.act24AmountController.text = malaria.act24_amount;
    formData.act18 = malaria.act18 == 'Yes';
    formData.act18AmountController.text = malaria.act18_amount;
    formData.act12 = malaria.act12 == 'Yes';
    formData.act12AmountController.text = malaria.act12_amount;
    formData.act6 = malaria.act6 == 'Yes';
    formData.act6AmountController.text = malaria.act6_amount;
    formData.chloroquine = malaria.cq == 'Yes';
    formData.chloroquineAmountController.text = malaria.cq_amount;
    formData.primaquine = malaria.pq == 'Yes';
    formData.primaquineAmountController.text = malaria.pq_amount;

    // Outcome
    formData.isReferred = malaria.isReferred == 'Yes';
    formData.isDead = malaria.isDead == 'Yes';
    formData.receivedTreatment = malaria.receivedTreatment;
    formData.hasTravelled = malaria.travelling_before == 'Yes';

    // Handle occupation and other fields
    if (malaria.occupation.isNotEmpty) {
      if (Constants.jobs.contains(malaria.occupation)) {
        formData.selectedOccupation = malaria.occupation;
      } else {
        formData.selectedOccupation = 'Other';
        formData.otherOccupationController.text = malaria.occupation;
      }
    }

    // Additional information
    formData.isDisabled = malaria.persons_with_disability == 'Yes';
    formData.isIdp = malaria.internally_displaced == 'Yes';
    formData.remarkController.text = malaria.remark;

    // Volunteer information
    formData.selectedVolunteer = malaria.volunteer_name;
    formData.volunteerTownshipPlaceholder = malaria.volunteer_township;
    formData.volunteerVillagePlaceholder = malaria.volunteer_village;
  }
}
