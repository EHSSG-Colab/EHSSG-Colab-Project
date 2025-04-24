import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_case_report_01/screens/malaria/malaria_form_data.dart';

/// Class containing validation logic and other utilities for the malaria form
/// This separates the validation logic from the UI and data handling
class MalariaFormValidator {
  /// Validate a specific step in the form
  static bool validateStep(
    int step,
    GlobalKey<FormState> formKey,
    MalariaFormData formData,
  ) {
    // Ensure form is valid first
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return false;
    }

    // Different validation for each step
    switch (step) {
      case 0:
        // Volunteer Information - check if volunteer is selected
        return formData.selectedVolunteer != null &&
            formData.selectedVolunteer!.isNotEmpty;

      case 1:
        // Patient Information
        return _validatePatientInfoStep(formData);

      case 2:
        // Test Results & Symptoms
        return _validateTestResultsStep(formData);

      case 3:
        // Treatment Details
        return _validateTreatmentStep(formData);

      case 4:
        // Additional Information
        return _validateAdditionalInfoStep(formData);

      default:
        return false;
    }
  }

  /// Validate all steps in the form
  static bool validateAllSteps(
    List<GlobalKey<FormState>> formKeys,
    MalariaFormData formData,
  ) {
    for (int i = 0; i < formKeys.length; i++) {
      if (!validateStep(i, formKeys[i], formData)) {
        EasyLoading.showError('Please complete step ${i + 1}');
        return false;
      }
    }

    if (!formData.isDatePicked) {
      EasyLoading.showError('Please select RDT date');
      return false;
    }

    return true;
  }

  /// Validate the patient information step
  static bool _validatePatientInfoStep(MalariaFormData formData) {
    // Check required fields
    if (formData.selectedMonth == null || formData.selectedMonth!.isEmpty) {
      return false;
    }

    if (formData.selectedYear == null || formData.selectedYear!.isEmpty) {
      return false;
    }

    if (!formData.isDatePicked) {
      return false;
    }

    if (formData.nameController.text.isEmpty) {
      return false;
    }

    if (formData.ageController.text.isEmpty) {
      return false;
    }

    if (formData.addressController.text.isEmpty) {
      return false;
    }

    if (formData.selectedGender == null || formData.selectedGender!.isEmpty) {
      return false;
    }

    return true;
  }

  /// Validate the test results step
  static bool _validateTestResultsStep(MalariaFormData formData) {
    // Check RDT result is selected
    if (formData.selectedRdtResult == null ||
        formData.selectedRdtResult!.isEmpty) {
      return false;
    }

    // If positive, check additional fields
    if (formData.selectedRdtResult == 'Positive') {
      if (formData.malariaParasite == null ||
          formData.malariaParasite!.isEmpty) {
        return false;
      }

      if (formData.symptomType == null || formData.symptomType!.isEmpty) {
        return false;
      }
    }

    return true;
  }

  /// Validate the treatment step
  static bool _validateTreatmentStep(MalariaFormData formData) {
    // If negative RDT, no treatment needed
    if (formData.selectedRdtResult != 'Positive') {
      return true;
    }

    // Check if at least one treatment is selected
    bool hasTreatment =
        formData.act24 ||
        formData.act18 ||
        formData.act12 ||
        formData.act6 ||
        formData.chloroquine ||
        formData.primaquine;

    if (!hasTreatment) {
      EasyLoading.showError('Please select at least one treatment option');
      return false;
    }

    // Validate treatment amounts for selected treatments
    if (formData.act24 && formData.act24AmountController.text.isEmpty) {
      EasyLoading.showError('Please enter ACT-24 amount');
      return false;
    }

    if (formData.act18 && formData.act18AmountController.text.isEmpty) {
      EasyLoading.showError('Please enter ACT-18 amount');
      return false;
    }

    if (formData.act12 && formData.act12AmountController.text.isEmpty) {
      EasyLoading.showError('Please enter ACT-12 amount');
      return false;
    }

    if (formData.act6 && formData.act6AmountController.text.isEmpty) {
      EasyLoading.showError('Please enter ACT-6 amount');
      return false;
    }

    if (formData.chloroquine &&
        formData.chloroquineAmountController.text.isEmpty) {
      EasyLoading.showError('Please enter Chloroquine amount');
      return false;
    }

    if (formData.primaquine &&
        formData.primaquineAmountController.text.isEmpty) {
      EasyLoading.showError('Please enter Primaquine amount');
      return false;
    }

    // Check if treatment time is selected
    if (formData.receivedTreatment == null ||
        formData.receivedTreatment!.isEmpty) {
      EasyLoading.showError('Please select when treatment was received');
      return false;
    }

    return true;
  }

  /// Validate the additional information step
  static bool _validateAdditionalInfoStep(MalariaFormData formData) {
    // Check other occupation if "Other" is selected
    if (formData.selectedOccupation == 'Other' &&
        formData.otherOccupationController.text.isEmpty) {
      EasyLoading.showError('Please specify other occupation');
      return false;
    }

    return true;
  }
}

/// Utility functions for the malaria form
class MalariaFormUtils {
  /// Format date to string in dd-MM-yyyy format
  static String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day.toString().padLeft(2, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.year}';
  }

  /// Get the step state based on current step and step index
  static StepState getStepState(int step, int currentStep) {
    if (currentStep > step) {
      return StepState.complete; // Step is completed
    } else if (currentStep == step) {
      return StepState.editing; // Current step
    } else {
      return StepState.indexed; // Step is ahead
    }
  }

  /// Get the appropriate step title for a given step index
  static String getStepTitle(int step) {
    switch (step) {
      case 0:
        return 'Volunteer Information';
      case 1:
        return 'Patient Information';
      case 2:
        return 'Test Results';
      case 3:
        return 'Treatment';
      case 4:
        return 'Additional Information';
      default:
        return 'Unknown Step';
    }
  }

  /// Get short initials for malaria parasite types (for display)
  static String getMalariaParasiteInitials(String? parasiteType) {
    if (parasiteType == null) return 'N/A';

    switch (parasiteType.toLowerCase()) {
      case 'plasmodium falciparum':
        return 'Pf';
      case 'plasmodium vivax':
        return 'Pv';
      case 'mixed':
        return 'Mixed';
      default:
        return 'N/A';
    }
  }
}
