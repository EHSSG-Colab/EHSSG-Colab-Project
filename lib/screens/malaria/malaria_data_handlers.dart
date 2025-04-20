import 'package:malaria_report_mobile/models/malaria.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_data.dart';

/// Class responsible for transforming data between the Malaria model and form data
/// This separates the data transformation logic from the UI and validation
class MalariaDataTransformer {
  /// Convert form data to Malaria model for saving to database
  static Malaria formDataToModel(MalariaFormData formData, int? id) {
    return Malaria(
      id: id,
      dataCollectorId: formData.userInfo['userId'] ?? '',
      dataCollectorName: formData.userInfo['userName'] ?? '',
      dataCollectorTownship: formData.userInfo['userTownship'] ?? '',
      dataCollectorVillage: formData.userInfo['userVillage'] ?? '',
      volunteerId: '', // This would need to be retrieved from database
      volunteerName: formData.selectedVolunteer ?? '',
      volunteerTownship: formData.volunteerTownshipPlaceholder ?? '',
      volunteerVillage: formData.volunteerVillagePlaceholder ?? '',
      tMonth: formData.selectedMonth ?? '',
      tYear: formData.selectedYear ?? '',
      dateOfRdt: formData.testDate?.toIso8601String() ?? '',
      patientName: formData.nameController.text,
      ageUnit: formData.selectedAgeUnit ?? 'year',
      patientAge: formData.ageController.text,
      patientAddress: formData.addressController.text,
      patientSex: formData.selectedGender ?? '',
      isPregnant: formData.isPregnant ? 'Yes' : 'No',
      isLactatingMother: formData.isLactatingMother ? 'Yes' : 'No',
      rdtResult: formData.selectedRdtResult ?? '',
      malariaParasite: formData.malariaParasite ?? '',
      symptoms: formData.symptomType ?? '',
      act24: formData.act24 ? 'Yes' : 'No',
      act24Count: formData.act24AmountController.text,
      act18: formData.act18 ? 'Yes' : 'No',
      act18Count: formData.act18AmountController.text,
      act12: formData.act12 ? 'Yes' : 'No',
      act12Count: formData.act12AmountController.text,
      act6: formData.act6 ? 'Yes' : 'No',
      act6Count: formData.act6AmountController.text,
      chloroquine: formData.chloroquine ? 'Yes' : 'No',
      chloroquineCount: formData.chloroquineAmountController.text,
      primaquine: formData.primaquine ? 'Yes' : 'No',
      primaquineCount: formData.primaquineAmountController.text,
      isReferred: formData.isReferred ? 'Yes' : 'No',
      isDead: formData.isDead ? 'Yes' : 'No',
      receivedTreatment: formData.receivedTreatment ?? '',
      hasTravelled: formData.hasTravelled ? 'Yes' : 'No',
      occupation:
          formData.selectedOccupation == 'Other'
              ? formData.otherOccupationController.text
              : formData.selectedOccupation ?? '',
      isPersonWithDisabilities: formData.isDisabled ? 'Yes' : 'No',
      isInternallyDisplaced: formData.isIdp ? 'Yes' : 'No',
      remark: formData.remarkController.text,
      syncStatus: 'PENDING',
    );
  }

  /// Load data from Malaria model to form data for editing
  static void modelToFormData(Malaria malaria, MalariaFormData formData) {
    // Basic information
    formData.selectedMonth = malaria.tMonth;
    formData.selectedYear = malaria.tYear;

    // Test date
    if (malaria.dateOfRdt.isNotEmpty) {
      formData.testDate = DateTime.parse(malaria.dateOfRdt);
      formData.isDatePicked = true;
    }

    // Patient information
    formData.nameController.text = malaria.patientName;
    formData.selectedAgeUnit = malaria.ageUnit;
    formData.ageController.text = malaria.patientAge;
    formData.addressController.text = malaria.patientAddress;
    formData.selectedGender = malaria.patientSex;
    formData.isPregnant = malaria.isPregnant == 'Yes';
    formData.isLactatingMother = malaria.isLactatingMother == 'Yes';

    // Test results
    formData.selectedRdtResult = malaria.rdtResult;
    formData.malariaParasite = malaria.malariaParasite;
    formData.symptomType = malaria.symptoms;

    // Treatment details
    formData.act24 = malaria.act24 == 'Yes';
    formData.act24AmountController.text = malaria.act24Count;
    formData.act18 = malaria.act18 == 'Yes';
    formData.act18AmountController.text = malaria.act18Count;
    formData.act12 = malaria.act12 == 'Yes';
    formData.act12AmountController.text = malaria.act12Count;
    formData.act6 = malaria.act6 == 'Yes';
    formData.act6AmountController.text = malaria.act6Count;
    formData.chloroquine = malaria.chloroquine == 'Yes';
    formData.chloroquineAmountController.text = malaria.chloroquineCount;
    formData.primaquine = malaria.primaquine == 'Yes';
    formData.primaquineAmountController.text = malaria.primaquineCount;

    // Outcome
    formData.isReferred = malaria.isReferred == 'Yes';
    formData.isDead = malaria.isDead == 'Yes';
    formData.receivedTreatment = malaria.receivedTreatment;
    formData.hasTravelled = malaria.hasTravelled == 'Yes';

    // Handle occupation and other fields
    // Check if occupation is in the predefined list, otherwise set to "Other"
    if (malaria.occupation.isNotEmpty) {
      // This requires access to Constants.jobs
      // If occupation is not in the predefined list, set to "Other"
      // This part might need adjustment based on your Constants class
      if (isJobInPredefinedList(malaria.occupation)) {
        formData.selectedOccupation = malaria.occupation;
      } else {
        formData.selectedOccupation = 'Other';
        formData.otherOccupationController.text = malaria.occupation;
      }
    }

    // Additional information
    formData.isDisabled = malaria.isPersonWithDisabilities == 'Yes';
    formData.isIdp = malaria.isInternallyDisplaced == 'Yes';
    formData.remarkController.text = malaria.remark;

    // Volunteer information
    formData.selectedVolunteer = malaria.volunteerName;
    formData.volunteerTownshipPlaceholder = malaria.volunteerTownship;
    formData.volunteerVillagePlaceholder = malaria.volunteerVillage;
  }

  /// Helper method to check if a job is in the predefined list
  /// This would ideally use Constants.jobs but for simplicity we're hardcoding common jobs
  static bool isJobInPredefinedList(String job) {
    const commonJobs = [
      'Farmer',
      'Teacher',
      'Student',
      'Housewife',
      'Trader',
      'Businessman',
      'Driver',
      'Laborer',
      'Government',
      'Private',
      'Unemployed',
      'Other',
    ];

    return commonJobs.contains(job);
  }
}
