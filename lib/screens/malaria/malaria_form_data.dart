import 'package:flutter/material.dart';

/// Central class for managing all form data and state
/// This allows us to pass a single object between files instead of many parameters
class MalariaFormData {
  // User and volunteer information
  Map<String, dynamic> userInfo = {};
  List<String> volunteerNames = [];
  String? volunteerTownshipPlaceholder;
  String? volunteerVillagePlaceholder;
  String? selectedVolunteer;

  // Date and time information
  String? selectedMonth;
  String? selectedYear;
  DateTime? testDate;
  bool isDatePicked = false;

  // Patient information
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String? selectedGender;
  String? selectedAgeUnit = 'year';
  bool isPregnant = false;
  bool isLactatingMother = false;

  // Test results
  String? selectedRdtResult;
  String? malariaParasite;
  String? symptomType;

  // Treatment details
  bool act24 = false;
  bool act18 = false;
  bool act12 = false;
  bool act6 = false;
  bool chloroquine = false;
  bool primaquine = false;
  final TextEditingController act24AmountController = TextEditingController();
  final TextEditingController act18AmountController = TextEditingController();
  final TextEditingController act12AmountController = TextEditingController();
  final TextEditingController act6AmountController = TextEditingController();
  final TextEditingController chloroquineAmountController =
      TextEditingController();
  final TextEditingController primaquineAmountController =
      TextEditingController();

  // Treatment outcome
  bool isReferred = false;
  bool isDead = false;
  String? receivedTreatment;
  bool hasTravelled = false;

  // Additional information
  String? selectedOccupation;
  final TextEditingController otherOccupationController =
      TextEditingController();
  bool isDisabled = false;
  bool isIdp = false;
  final TextEditingController remarkController = TextEditingController();

  // Helper methods
  String getDateText() {
    if (testDate == null) {
      isDatePicked = false;
      return 'Select date';
    } else {
      isDatePicked = true;
      return '${testDate!.day}-${testDate!.month}-${testDate!.year}';
    }
  }

  // Clear all form data
  void reset() {
    // Reset selections
    selectedVolunteer = null;
    selectedMonth = null;
    selectedYear = null;
    testDate = null;
    isDatePicked = false;
    selectedGender = null;
    selectedAgeUnit = 'year';
    isPregnant = false;
    isLactatingMother = false;
    selectedRdtResult = null;
    malariaParasite = null;
    symptomType = null;

    // Reset treatment options
    act24 = false;
    act18 = false;
    act12 = false;
    act6 = false;
    chloroquine = false;
    primaquine = false;
    isReferred = false;
    isDead = false;
    receivedTreatment = null;
    hasTravelled = false;

    // Reset additional info
    selectedOccupation = null;
    isDisabled = false;
    isIdp = false;

    // Clear text controllers
    nameController.clear();
    ageController.clear();
    addressController.clear();
    act24AmountController.clear();
    act18AmountController.clear();
    act12AmountController.clear();
    act6AmountController.clear();
    chloroquineAmountController.clear();
    primaquineAmountController.clear();
    otherOccupationController.clear();
    remarkController.clear();

    // Reset placeholders
    volunteerTownshipPlaceholder = null;
    volunteerVillagePlaceholder = null;
  }

  // Dispose controllers to prevent memory leaks
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    act24AmountController.dispose();
    act18AmountController.dispose();
    act12AmountController.dispose();
    act6AmountController.dispose();
    chloroquineAmountController.dispose();
    primaquineAmountController.dispose();
    otherOccupationController.dispose();
    remarkController.dispose();
  }
}
