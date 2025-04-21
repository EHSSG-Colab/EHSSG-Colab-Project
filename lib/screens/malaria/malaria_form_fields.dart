import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/constants/dropdown_options.dart';
import 'package:malaria_report_mobile/database/database_helper.dart';
import 'package:malaria_report_mobile/screens/malaria/malaria_form_data.dart';
import 'package:malaria_report_mobile/utils/string_utils.dart';
import 'package:malaria_report_mobile/widgets/form_widgets/simple_form_label.dart';
import 'package:malaria_report_mobile/widgets/form_widgets/simple_radio.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/checkbox.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/simple_dropdown.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/text_form_field.dart';

/// Class responsible for building form field components
/// This centralizes all form field creation in one place for better maintainability
class MalariaFormFields {
  // User information display
  static Widget buildUserInfoWrapper(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return Row(
      children: [
        Expanded(child: buildUserNameListTile(context, formData)),
        Expanded(child: buildUserTownshipVillageListTile(context, formData)),
      ],
    );
  }

  static Widget buildUserNameListTile(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyListTile(
      label: 'Data Collector',
      value: formData.userInfo['userName'] ?? '',
    );
  }

  static Widget buildUserTownshipVillageListTile(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyListTile(
      label: 'Township - Village',
      value:
          '${formData.userInfo['userTownship'] ?? ''} - ${formData.userInfo['userVillage'] ?? ''}',
    );
  }

  // Volunteer selection
  static Widget buildVolunteerSelect(
    BuildContext context,
    MalariaFormData formData, {
    Function? onVolunteerSelected,
  }) {
    return SimpleSelect(
      options: formData.volunteerNames,
      label: 'Volunteer',
      placeholder: 'Please select volunteer',
      isRequired: true,
      initialValue: formData.selectedVolunteer,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a volunteer';
        }
        return null;
      },
      onSelected: (value) {
        formData.selectedVolunteer = value;
        if (value != null) {
          _getVolunteerTownshipVillage(value, formData, onVolunteerSelected);
        } else {
          formData.volunteerTownshipPlaceholder = null;
          formData.volunteerVillagePlaceholder = null;

          if (onVolunteerSelected != null) {
            onVolunteerSelected();
          }
        }
      },
    );
  }

  // Helper method to get volunteer details
  static Future<void> _getVolunteerTownshipVillage(
    String name,
    MalariaFormData formData,
    Function? onVolunteerSelected,
  ) async {
    try {
      Map<String, dynamic> volunteerInfo = await DatabaseHelper()
          .getVolunteerByName(name);
      formData.volunteerTownshipPlaceholder = volunteerInfo['vol_tsp'] ?? 'N/A';
      formData.volunteerVillagePlaceholder = volunteerInfo['vol_vil'] ?? 'N/A';

      // Update the UI after volunteer is selected
      if (onVolunteerSelected != null) {
        onVolunteerSelected();
      }
    } catch (e) {
      formData.volunteerTownshipPlaceholder = 'Error';
      formData.volunteerVillagePlaceholder = 'Error';

      // Update the UI to show error
      if (onVolunteerSelected != null) {
        onVolunteerSelected();
      }
    }
  }

  static Widget buildVolunteerInfoWrapper(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return Row(
      children: [
        Expanded(
          child: MyListTile(
            label: 'Volunteer Township',
            value: formData.volunteerTownshipPlaceholder ?? 'Select volunteer',
          ),
        ),
        Expanded(
          child: MyListTile(
            label: 'Volunteer Village',
            value: formData.volunteerVillagePlaceholder ?? 'Select volunteer',
          ),
        ),
      ],
    );
  }

  // Month and Year selection
  static Widget buildMonthYearWrapper(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SimpleSelect(
            options: Constants.months,
            label: 'Treatment Month',
            placeholder: 'Please select month',
            isRequired: true,
            initialValue: formData.selectedMonth,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a month';
              }
              return null;
            },
            onSelected: (value) {
              formData.selectedMonth = value;
            },
          ),
        ),
        sizedBoxw10(),
        Expanded(
          flex: 1,
          child: SimpleSelect(
            options: Constants.generateYearList(),
            label: 'Year',
            placeholder: 'Year',
            isRequired: true,
            initialValue: formData.selectedYear,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Select year';
              }
              return null;
            },
            onSelected: (value) {
              formData.selectedYear = value;
            },
          ),
        ),
      ],
    );
  }

  // Date picker
  static Widget buildRdtDateWrapper(
    BuildContext context,
    MalariaFormData formData, {
    Function? onDateSelected,
  }) {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: MyFormLabel(labelText: 'Date of RDT', isRequired: true),
        ),
        sizedBoxw10(),
        Expanded(
          flex: 2,
          child: MyButton(
            buttonLabel: formData.getDateText(),
            onPressed: () => _pickDate(context, formData, onDateSelected),
          ),
        ),
      ],
    );
  }

  static Future<void> _pickDate(
    BuildContext context,
    MalariaFormData formData,
    Function? onDateSelected,
  ) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: formData.testDate ?? initialDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime.now(),
    );
    if (newDate == null) return;
    formData.testDate = newDate;
    formData.isDatePicked = true;

    // Update the UI after date is selected
    if (onDateSelected != null) {
      onDateSelected();
    }
  }

  // Patient information fields
  static Widget buildNameField(BuildContext context, MalariaFormData formData) {
    return MyTextFormField(
      myController: formData.nameController,
      labelText: 'Patient Name',
      placeholderText: 'Enter patient name',
      isRequired: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter patient name';
        }
        return null;
      },
    );
  }

  static Widget buildAgeWrapper(
    BuildContext context,
    MalariaFormData formData, {
    Function? onAgeUnitChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: MyRadio(
            options: const ['day', 'month', 'year'],
            optionLabels: const ['Day', 'Month', 'Year'],
            label: 'Age Unit',
            value: formData.selectedAgeUnit,
            isHorizontal: true,
            onChanged: (value) {
              formData.selectedAgeUnit = value;
              // Update the UI after age unit is changed
              if (onAgeUnitChanged != null) {
                onAgeUnitChanged();
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select age unit';
              }
              return null;
            },
            isRequired: true,
          ),
        ),
        sizedBoxw10(),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              MyTextFormField(
                myController: formData.ageController,
                labelText: 'Age',
                placeholderText: 'Age',
                isRequired: true,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter age';
                  }
                  return null;
                },
              ),
              Text(
                '${capitalizeFirstLetter(formData.selectedAgeUnit ?? 'year')}(s)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget buildAddressField(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyTextFormField(
      myController: formData.addressController,
      labelText: 'Address',
      placeholderText: 'Enter patient address',
      isRequired: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter patient address';
        }
        return null;
      },
    );
  }

  static Widget buildGenderRadioButtons(
    BuildContext context,
    MalariaFormData formData, {
    Function? onGenderChanged,
  }) {
    return MyRadio(
      options: const ['Male', 'Female', 'Other'],
      optionLabels: const ['Male', 'Female', 'Other'],
      label: 'Gender',
      value: formData.selectedGender,
      isHorizontal: true,
      onChanged: (value) {
        formData.selectedGender = value;
        if (value != 'Female') {
          formData.isPregnant = false;
          formData.isLactatingMother = false;
        }
        // Update the UI after gender is changed
        if (onGenderChanged != null) {
          onGenderChanged();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select gender';
        }
        return null;
      },
      isRequired: true,
    );
  }

  static Widget buildIsPregnantCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Pregnancy',
      initialValue: formData.isPregnant,
      onChanged: (value) {
        formData.isPregnant = value;
      },
    );
  }

  static Widget buildIsLactatingMotherCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Lactating mother of under six month infant',
      initialValue: formData.isLactatingMother,
      onChanged: (value) {
        formData.isLactatingMother = value;
      },
    );
  }

  // Test result fields
  static Widget buildRdtResultRadioButtons(
    BuildContext context,
    MalariaFormData formData, {
    Function? onRdtResultChanged,
  }) {
    return MyRadio(
      options: const ['Positive', 'Negative'],
      optionLabels: const ['Positive', 'Negative'],
      label: 'RDT Test Result',
      value: formData.selectedRdtResult,
      isHorizontal: true,
      onChanged: (value) {
        formData.selectedRdtResult = value;
        if (value == 'Negative') {
          // Reset relevant fields for negative results
          formData.malariaParasite = null;
          formData.symptomType = null;
          formData.act24 = false;
          formData.act24AmountController.text = '';
          formData.act18 = false;
          formData.act18AmountController.text = '';
          formData.act12 = false;
          formData.act12AmountController.text = '';
          formData.act6 = false;
          formData.act6AmountController.text = '';
          formData.chloroquine = false;
          formData.chloroquineAmountController.text = '';
          formData.primaquine = false;
          formData.primaquineAmountController.text = '';
          formData.isReferred = false;
          formData.isDead = false;
          formData.receivedTreatment = null;
          formData.hasTravelled = false;
        }
        // Update the UI after RDT result is changed
        if (onRdtResultChanged != null) {
          onRdtResultChanged();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select RDT result';
        }
        return null;
      },
      isRequired: true,
    );
  }

  static Widget buildMalariaParasiteRadioButtons(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyRadio(
      options: const ['Plasmodium falciparum', 'Plasmodium vivax', 'Mixed'],
      optionLabels: const [
        'Plasmodium falciparum',
        'Plasmodium vivax',
        'Mixed',
      ],
      label: 'Malaria Parasite Type',
      value: formData.malariaParasite,
      isHorizontal: false,
      onChanged: (value) {
        formData.malariaParasite = value;
      },
      validator: (value) {
        if (formData.selectedRdtResult == 'Positive' &&
            (value == null || value.isEmpty)) {
          return 'Please select malaria parasite type';
        }
        return null;
      },
      isRequired: formData.selectedRdtResult == 'Positive',
    );
  }

  static Widget buildSymptomTypeRadioButtons(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyRadio(
      options: const ['Moderate', 'Severe'],
      optionLabels: const ['Moderate', 'Severe'],
      label: 'Symptoms',
      value: formData.symptomType,
      isHorizontal: true,
      onChanged: (value) {
        formData.symptomType = value;
      },
      validator: (value) {
        if (formData.selectedRdtResult == 'Positive' &&
            (value == null || value.isEmpty)) {
          return 'Please select symptoms';
        }
        return null;
      },
      isRequired: formData.selectedRdtResult == 'Positive',
    );
  }

  // Treatment fields
  static Widget buildTreatmentFields(
    BuildContext context,
    MalariaFormData formData, {
    Function? onTreatmentChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const MyFormLabel(
          labelText: 'Antimalaria Prescribed',
          isRequired: true,
        ),

        // ACT-24
        MyCheckBoxListTile(
          title: 'ACT-24',
          initialValue: formData.act24,
          onChanged: (value) {
            formData.act24 = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.act24)
          MyTextFormField(
            myController: formData.act24AmountController,
            labelText: 'ACT-24 Amount',
            placeholderText: 'Enter ACT-24 amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.act24 && (value == null || value.isEmpty)) {
                return 'Please enter ACT-24 amount';
              }
              return null;
            },
          ),

        // ACT-18
        MyCheckBoxListTile(
          title: 'ACT-18',
          initialValue: formData.act18,
          onChanged: (value) {
            formData.act18 = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.act18)
          MyTextFormField(
            myController: formData.act18AmountController,
            labelText: 'ACT-18 Amount',
            placeholderText: 'Enter ACT-18 amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.act18 && (value == null || value.isEmpty)) {
                return 'Please enter ACT-18 amount';
              }
              return null;
            },
          ),

        // ACT-12
        MyCheckBoxListTile(
          title: 'ACT-12',
          initialValue: formData.act12,
          onChanged: (value) {
            formData.act12 = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.act12)
          MyTextFormField(
            myController: formData.act12AmountController,
            labelText: 'ACT-12 Amount',
            placeholderText: 'Enter ACT-12 amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.act12 && (value == null || value.isEmpty)) {
                return 'Please enter ACT-12 amount';
              }
              return null;
            },
          ),

        // ACT-6
        MyCheckBoxListTile(
          title: 'ACT-6',
          initialValue: formData.act6,
          onChanged: (value) {
            formData.act6 = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.act6)
          MyTextFormField(
            myController: formData.act6AmountController,
            labelText: 'ACT-6 Amount',
            placeholderText: 'Enter ACT-6 amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.act6 && (value == null || value.isEmpty)) {
                return 'Please enter ACT-6 amount';
              }
              return null;
            },
          ),

        // Chloroquine
        MyCheckBoxListTile(
          title: 'Chloroquine',
          initialValue: formData.chloroquine,
          onChanged: (value) {
            formData.chloroquine = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.chloroquine)
          MyTextFormField(
            myController: formData.chloroquineAmountController,
            labelText: 'Chloroquine Amount',
            placeholderText: 'Enter Chloroquine amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.chloroquine && (value == null || value.isEmpty)) {
                return 'Please enter Chloroquine amount';
              }
              return null;
            },
          ),

        // Primaquine
        MyCheckBoxListTile(
          title: 'Primaquine',
          initialValue: formData.primaquine,
          onChanged: (value) {
            formData.primaquine = value;
            // Update the UI after treatment is changed
            if (onTreatmentChanged != null) {
              onTreatmentChanged();
            }
          },
        ),
        if (formData.primaquine)
          MyTextFormField(
            myController: formData.primaquineAmountController,
            labelText: 'Primaquine Amount',
            placeholderText: 'Enter Primaquine amount',
            keyboardType: TextInputType.number,
            isRequired: true,
            validator: (value) {
              if (formData.primaquine && (value == null || value.isEmpty)) {
                return 'Please enter Primaquine amount';
              }
              return null;
            },
          ),
      ],
    );
  }

  static Widget buildReferralCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Patient referred with Malaria',
      initialValue: formData.isReferred,
      onChanged: (value) {
        formData.isReferred = value;
      },
    );
  }

  static Widget buildDeathCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Expired with RDT Positive',
      initialValue: formData.isDead,
      onChanged: (value) {
        formData.isDead = value;
      },
    );
  }

  static Widget buildReceivedTreatmentRadioButtons(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyRadio(
      options: const ['<24', '>24'],
      optionLabels: const ['Within 24hr of fever', 'After 24hr of fever'],
      label: 'Received treatment since',
      value: formData.receivedTreatment,
      isHorizontal: true,
      onChanged: (value) {
        formData.receivedTreatment = value;
      },
      validator: (value) {
        if (formData.selectedRdtResult == 'Positive' &&
            (value == null || value.isEmpty)) {
          return 'Please select treatment interval';
        }
        return null;
      },
      isRequired: formData.selectedRdtResult == 'Positive',
    );
  }

  // Additional information fields
  static Widget buildHasTravelledCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Travelling 2wks-1mth before',
      initialValue: formData.hasTravelled,
      onChanged: (value) {
        formData.hasTravelled = value;
      },
    );
  }

  static Widget buildOccupationSelect(
    BuildContext context,
    MalariaFormData formData, {
    Function? onOccupationChanged,
  }) {
    return SimpleSelect(
      options: Constants.jobs,
      label: 'Occupation',
      placeholder: 'Select occupation',
      initialValue: formData.selectedOccupation,
      onSelected: (value) {
        formData.selectedOccupation = value;
        if (value != 'Other') {
          formData.otherOccupationController.text = '';
        }
        // Update the UI after occupation is changed
        if (onOccupationChanged != null) {
          onOccupationChanged();
        }
      },
    );
  }

  static Widget buildOtherOccupationField(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyTextFormField(
      myController: formData.otherOccupationController,
      labelText: 'Other Occupation',
      placeholderText: 'Please specify occupation',
      isRequired: formData.selectedOccupation == 'Other',
      validator: (value) {
        if (formData.selectedOccupation == 'Other' &&
            (value == null || value.isEmpty)) {
          return 'Please specify occupation';
        }
        return null;
      },
    );
  }

  static Widget buildDisabledCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Person with disabilities',
      initialValue: formData.isDisabled,
      onChanged: (value) {
        formData.isDisabled = value;
      },
    );
  }

  static Widget buildIdpCheckbox(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyCheckBoxListTile(
      title: 'Internally displaced person',
      initialValue: formData.isIdp,
      onChanged: (value) {
        formData.isIdp = value;
      },
    );
  }

  static Widget buildRemarkField(
    BuildContext context,
    MalariaFormData formData,
  ) {
    return MyTextFormField(
      myController: formData.remarkController,
      labelText: 'Remark',
      placeholderText: 'Enter any remarks if needed',
      validator: (value) {
        return null;
      },
      isRequired: false,
    );
  }
}
