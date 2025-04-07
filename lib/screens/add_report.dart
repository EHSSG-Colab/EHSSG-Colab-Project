// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class AddReport extends StatefulWidget {
//   const AddReport({super.key});

//   @override
//   State<AddReport> createState() => _AddReportState();
// }

// class _AddReportState extends State<AddReport> {
//   final _formKey = GlobalKey<FormState>();
  
//   // Test Information
//   final TextEditingController _testDateController = TextEditingController();
//   final TextEditingController _treatmentMonthController = TextEditingController();
//   final TextEditingController _treatmentYearController = TextEditingController();
  
//   // Patient Information
//   final TextEditingController _patientNameController = TextEditingController();
//   final TextEditingController _ageController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
  
//   String _selectedAgeUnit = 'year';
//   String? _selectedSex;
//   bool _isPregnant = false;
//   bool _isLactating = false;
  
//   // Test Results
//   bool _rdtResult = false;
//   String? _malariaParasite;
//   String? _receivedTreatment;
  
//   // Treatment Information
//   bool _act24 = false;
//   bool _act18 = false;
//   bool _act12 = false;
//   bool _act6 = false;
//   bool _cq = false;
//   bool _pq = false;
  
//   final TextEditingController _act24AmountController = TextEditingController();
//   final TextEditingController _act18AmountController = TextEditingController();
//   final TextEditingController _act12AmountController = TextEditingController();
//   final TextEditingController _act6AmountController = TextEditingController();
//   final TextEditingController _cqAmountController = TextEditingController();
//   final TextEditingController _pqAmountController = TextEditingController();
  
//   bool _isReferred = false;
//   bool _isDead = false;
//   String? _symptoms;
  
//   // Additional Information
//   bool _travellingBefore = false;
//   bool _personsWithDisability = false;
//   bool _internallyDisplaced = false;
//   final TextEditingController _occupationController = TextEditingController();
  
//   // Volunteer Information
//   final TextEditingController _volunteerNameController = TextEditingController();
//   final TextEditingController _volunteerTownshipController = TextEditingController();
//   final TextEditingController _volunteerVillageController = TextEditingController();
  
//   // Reporter Information
//   final TextEditingController _reporterNameController = TextEditingController();
//   final TextEditingController _reporterIdController = TextEditingController();
//   final TextEditingController _reporterVillageController = TextEditingController();
//   final TextEditingController _reporterTownshipController = TextEditingController();
  
//   // Remarks
//   final TextEditingController _remarkController = TextEditingController();

//   @override
//   void dispose() {
//     // Dispose all controllers
//     _testDateController.dispose();
//     _treatmentMonthController.dispose();
//     _treatmentYearController.dispose();
//     _patientNameController.dispose();
//     _ageController.dispose();
//     _addressController.dispose();
//     _act24AmountController.dispose();
//     _act18AmountController.dispose();
//     _act12AmountController.dispose();
//     _act6AmountController.dispose();
//     _cqAmountController.dispose();
//     _pqAmountController.dispose();
//     _occupationController.dispose();
//     _volunteerNameController.dispose();
//     _volunteerTownshipController.dispose();
//     _volunteerVillageController.dispose();
//     _reporterNameController.dispose();
//     _reporterIdController.dispose();
//     _reporterVillageController.dispose();
//     _reporterTownshipController.dispose();
//     _remarkController.dispose();
//     super.dispose();
//   }

//   Widget _buildSectionTitle(String title) {
//       return Padding(
//         padding: const EdgeInsets.symmetric(vertical: 8.0),
//         child: Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       );
//     }
  
//     Widget _buildTreatmentRow(
//       String label,
//       bool value,
//       TextEditingController controller,
//     ) {
//       return Row(
//         children: [
//           Expanded(
//             flex: 2,
//             child: CheckboxListTile(
//               title: Text(label),
//               value: value,
//               onChanged: (bool? newValue) {
//                 setState(() {
//                   if (label == 'ACT 24') _act24 = newValue ?? false;
//                   if (label == 'ACT 18') _act18 = newValue ?? false;
//                   if (label == 'ACT 12') _act12 = newValue ?? false;
//                   if (label == 'ACT 6') _act6 = newValue ?? false;
//                   if (label == 'CQ') _cq = newValue ?? false;
//                   if (label == 'PQ') _pq = newValue ?? false;
//                 });
//               },
//             ),
//           ),
//           if (value)
//             Expanded(
//               child: TextFormField(
//                 controller: controller,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Amount',
//                   suffixText: 'mg',
//                 ),
//               ),
//             ),
//         ],
//       );
//     }
  
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Add Malaria Case Report'),
//           backgroundColor: Colors.blue.shade50,
//         ),
//         body: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Test Information Section
//                 _buildSectionTitle('Test Information'),
//                 TextFormField(
//                   controller: _testDateController,
//                   decoration: const InputDecoration(
//                     labelText: 'Test Date',
//                     suffixIcon: Icon(Icons.calendar_today),
//                   ),
//                   readOnly: true,
//                   onTap: () async {
//                     final DateTime? picked = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime(2000),
//                       lastDate: DateTime.now(),
//                     );
//                     if (picked != null) {
//                       setState(() {
//                         _testDateController.text = 
//                             DateFormat('yyyy-MM-dd').format(picked);
//                       });
//                     }
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please select test date';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
  
//                 // Patient Information Section
//                 _buildSectionTitle('Patient Information'),
//                 TextFormField(
//                   controller: _patientNameController,
//                   decoration: const InputDecoration(labelText: 'Patient Name'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter patient name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
                
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 2,
//                       child: TextFormField(
//                         controller: _ageController,
//                         keyboardType: TextInputType.number,
//                         decoration: const InputDecoration(labelText: 'Age'),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter age';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       flex: 3,
//                       child: DropdownButtonFormField<String>(
//                         value: _selectedAgeUnit,
//                         items: ['day', 'month', 'year'].map((String unit) {
//                           return DropdownMenuItem(
//                             value: unit,
//                             child: Text(unit.toUpperCase()),
//                           );
//                         }).toList(),
//                         onChanged: (String? newValue) {
//                           setState(() {
//                             _selectedAgeUnit = newValue!;
//                           });
//                         },
//                         decoration: const InputDecoration(labelText: 'Age Unit'),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),
  
//                 // Sex and Pregnancy Section
//                 DropdownButtonFormField<String>(
//                   value: _selectedSex,
//                   items: ['m', 'f', 'other'].map((String sex) {
//                     return DropdownMenuItem(
//                       value: sex,
//                       child: Text(sex.toUpperCase()),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _selectedSex = newValue;
//                       if (newValue != 'f') {
//                         _isPregnant = false;
//                         _isLactating = false;
//                       }
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: 'Sex'),
//                 ),
//                 if (_selectedSex == 'f') ...[
//                   CheckboxListTile(
//                     title: const Text('Pregnant'),
//                     value: _isPregnant,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _isPregnant = value ?? false;
//                       });
//                     },
//                   ),
//                   CheckboxListTile(
//                     title: const Text('Lactating Mother'),
//                     value: _isLactating,
//                     onChanged: (bool? value) {
//                       setState(() {
//                         _isLactating = value ?? false;
//                       });
//                     },
//                   ),
//                 ],
  
//                 TextFormField(
//                   controller: _addressController,
//                   decoration: const InputDecoration(labelText: 'Address'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 24),
  
//                 // Test Results Section
//                 _buildSectionTitle('Test Results'),
//                 SwitchListTile(
//                   title: const Text('RDT Result'),
//                   value: _rdtResult,
//                   onChanged: (bool value) {
//                     setState(() {
//                       _rdtResult = value;
//                     });
//                   },
//                 ),
                
//                 if (_rdtResult) ...[
//                   DropdownButtonFormField<String>(
//                     value: _malariaParasite,
//                     items: ['pf', 'pv', 'mixed'].map((String type) {
//                       return DropdownMenuItem(
//                         value: type,
//                         child: Text(type.toUpperCase()),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _malariaParasite = newValue;
//                       });
//                     },
//                     decoration: const InputDecoration(labelText: 'Malaria Parasite'),
//                   ),
//                   const SizedBox(height: 16),
                  
//                   DropdownButtonFormField<String>(
//                     value: _receivedTreatment,
//                     items: ['<24', '>24'].map((String hours) {
//                       return DropdownMenuItem(
//                         value: hours,
//                         child: Text('$hours hours'),
//                       );
//                     }).toList(),
//                     onChanged: (String? newValue) {
//                       setState(() {
//                         _receivedTreatment = newValue;
//                       });
//                     },
//                     decoration: const InputDecoration(labelText: 'Received Treatment'),
//                   ),
//                 ],
  
//                 // Add Treatment Month and Year
//                 _buildSectionTitle('Treatment Information'),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: _treatmentMonthController,
//                         decoration: const InputDecoration(
//                           labelText: 'Treatment Month',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter treatment month';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                     const SizedBox(width: 16),
//                     Expanded(
//                       child: TextFormField(
//                         controller: _treatmentYearController,
//                         decoration: const InputDecoration(
//                           labelText: 'Treatment Year',
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter treatment year';
//                           }
//                           return null;
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
  
//                 // Add Volunteer Information
//                 _buildSectionTitle('Volunteer Information'),
//                 TextFormField(
//                   controller: _volunteerNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Volunteer Name',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter volunteer name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _volunteerTownshipController,
//                   decoration: const InputDecoration(
//                     labelText: 'Volunteer Township',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter volunteer township';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _volunteerVillageController,
//                   decoration: const InputDecoration(
//                     labelText: 'Volunteer Village',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter volunteer village';
//                     }
//                     return null;
//                   },
//                 ),
  
//                 // Add Reporter Information
//                 _buildSectionTitle('Reporter Information'),
//                 TextFormField(
//                   controller: _reporterNameController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reporter Name',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter reporter name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _reporterIdController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reporter ID',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter reporter ID';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 TextFormField(
//                   controller: _reporterVillageController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reporter Village',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter reporter village';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 // Reporter Information fields
//                 TextFormField(
//                   controller: _reporterTownshipController,
//                   decoration: const InputDecoration(
//                     labelText: 'Reporter Township',
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter reporter township';
//                     }
//                     return null;
//                   },
//                 ),

//                 const SizedBox(height: 24),
//                 // Treatment Information Section
//                 _buildSectionTitle('Treatment Information'),
//                 _buildTreatmentRow('ACT 24', _act24, _act24AmountController),
//                 _buildTreatmentRow('ACT 18', _act18, _act18AmountController),
//                 _buildTreatmentRow('ACT 12', _act12, _act12AmountController),
//                 _buildTreatmentRow('ACT 6', _act6, _act6AmountController),
//                 _buildTreatmentRow('CQ', _cq, _cqAmountController),
//                 _buildTreatmentRow('PQ', _pq, _pqAmountController),
                
//                 const SizedBox(height: 16),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: CheckboxListTile(
//                         title: const Text('Referred'),
//                         value: _isReferred,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _isReferred = value ?? false;
//                           });
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: CheckboxListTile(
//                         title: const Text('Dead'),
//                         value: _isDead,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             _isDead = value ?? false;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 DropdownButtonFormField<String>(
//                   value: _symptoms,
//                   items: ['moderate', 'severe'].map((String symptom) {
//                     return DropdownMenuItem(
//                       value: symptom,
//                       child: Text(symptom.toUpperCase()),
//                     );
//                   }).toList(),
//                   onChanged: (String? newValue) {
//                     setState(() {
//                       _symptoms = newValue;
//                     });
//                   },
//                   decoration: const InputDecoration(labelText: 'Symptoms'),
//                 ),
                
//                 const SizedBox(height: 24),
                
//                 // Additional Information Section
//                 _buildSectionTitle('Additional Information'),
//                 CheckboxListTile(
//                   title: const Text('Travelling Before'),
//                   value: _travellingBefore,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _travellingBefore = value ?? false;
//                     });
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Persons with Disability'),
//                   value: _personsWithDisability,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _personsWithDisability = value ?? false;
//                     });
//                   },
//                 ),
//                 CheckboxListTile(
//                   title: const Text('Internally Displaced'),
//                   value: _internallyDisplaced,
//                   onChanged: (bool? value) {
//                     setState(() {
//                       _internallyDisplaced = value ?? false;
//                     });
//                   },
//                 ),
                
//                 TextFormField(
//                   controller: _occupationController,
//                   decoration: const InputDecoration(labelText: 'Occupation'),
//                 ),
                
//                 const SizedBox(height: 24),
                
//                 // Remarks Section
//                 _buildSectionTitle('Remarks'),
//                 TextFormField(
//                   controller: _remarkController,
//                   maxLines: 3,
//                   decoration: const InputDecoration(
//                     labelText: 'Remarks',
//                     alignLabelWithHint: true,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
                
//                 // Submit Button
//                 SizedBox(
//                   width: double.infinity,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         // TODO: Implement form submission
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Processing Data'),
//                             backgroundColor: Colors.green,
//                           ),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(vertical: 16),
//                       backgroundColor: Colors.blue,
//                       foregroundColor: Colors.white,
//                     ),
//                     child: const Text(
//                       'Submit Report',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//               ],
//             ),
//           ),
//         ),
//       );
//     }
// }