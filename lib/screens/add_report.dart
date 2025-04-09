import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/layouts/scaffold_for_lilst_vew.dart'; // Correct import for ScaffoldForListView
import '../widgets/unit_widgets/app_bar.dart';
import '../widgets/unit_widgets/floating_button.dart';

class AddReport extends StatefulWidget {
  const AddReport({super.key});

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final _formKey = GlobalKey<FormState>();

  // Variables to hold form data
  DateTime? testDate;
  String? treatmentMonth;
  String? treatmentYear;
  String? patientName;
  String? ageUnit = 'year';
  int? age;
  String? sex;
  bool isPregnant = false;
  bool isLactatingMother = false;
  String? address;
  bool rdtResult = false;
  String? malariaParasite;
  String? receivedTreatment;
  bool isReferred = false;
  bool isDead = false;
  String? symptoms;
  bool travelledBefore = false;
  bool isPersonWithDisability = false;
  bool isInternallyDisplaced = false;
  String? occupation;
  String? reporterName;
  String? reporterId;
  String? reporterVillage;
  String? reporterTownship;
  String? remarks;

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForListView(
      canPop: true,
      appBar: const MyAppBar(
        hasBackArrow: true,
        title: Text('Add Malaria Case Report'),
      ),
      floatingActionButton: MyFloatingButton(
        label: 'Submit Report',
        icon: const Icon(Icons.check),
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Processing Data'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Test Information Section
            _buildSectionTitle('Test Information'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Test Date',
                suffixIcon: Icon(Icons.calendar_today),
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) {
                  setState(() {
                    testDate = picked;
                  });
                }
              },
              validator: (value) {
                if (testDate == null) {
                  return 'Please select test date';
                }
                return null;
              },
              controller: TextEditingController(
                text:
                    testDate != null
                        ? DateFormat('yyyy-MM-dd').format(testDate!)
                        : '',
              ),
            ),
            const SizedBox(height: 16),

            // Treatment Information Section
            _buildSectionTitle('Treatment Information'),
            DropdownButtonFormField<String>(
              value: treatmentMonth,
              items: List.generate(
                12,
                (index) => DropdownMenuItem(
                  value: (index + 1).toString().padLeft(2, '0'),
                  child: Text(DateFormat.MMMM().format(DateTime(0, index + 1))),
                ),
              ),
              onChanged:
                  (value) => setState(() {
                    treatmentMonth = value;
                  }),
              decoration: const InputDecoration(
                labelText: 'Treatment Month',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select treatment month';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: treatmentYear,
              items:
                  [
                    DateTime.now().year.toString(),
                    (DateTime.now().year - 1).toString(),
                  ].map((year) {
                    return DropdownMenuItem(value: year, child: Text(year));
                  }).toList(),
              onChanged:
                  (value) => setState(() {
                    treatmentYear = value;
                  }),
              decoration: const InputDecoration(
                labelText: 'Treatment Year',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select treatment year';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Patient Information Section
            _buildSectionTitle('Patient Information'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => patientName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter patient name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => age = int.tryParse(value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: DropdownButtonFormField<String>(
                    value: ageUnit,
                    items:
                        ['day', 'month', 'year']
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit.toUpperCase()),
                              ),
                            )
                            .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        ageUnit = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Age Unit',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: sex,
              items:
                  ['m', 'f', 'other']
                      .map(
                        (sex) => DropdownMenuItem(
                          value: sex,
                          child: Text(sex.toUpperCase()),
                        ),
                      )
                      .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  sex = newValue;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Sex',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Reporter Information Section
            _buildSectionTitle('Reporter Information'),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Reporter Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => reporterName = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter reporter name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Reporter ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => reporterId = value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter reporter ID';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Remarks Section
            _buildSectionTitle('Remarks'),
            TextFormField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Remarks',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => remarks = value,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
