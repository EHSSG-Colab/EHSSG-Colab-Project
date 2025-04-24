import 'package:flutter/material.dart';
import '../widgets/unit_widgets/app_bar.dart';

class ReportDetails extends StatelessWidget {
  final Map<String, dynamic> report;

  const ReportDetails({super.key, required this.report});

  Widget _buildInfoSection(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(hasBackArrow: true, title: Text('Report Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection(
                      'Patient Name',
                      report['patient_name'] ?? 'N/A',
                    ),
                    _buildInfoSection(
                      'Test Date',
                      report['date_of_rdt'] ?? 'N/A',
                    ),
                    _buildInfoSection(
                      'RDT Result',
                      report['rdt_result'] == 1 ? 'Positive' : 'Negative',
                    ),
                    _buildInfoSection(
                      'Age',
                      '${report['age']} ${report['age_unit']}',
                    ),
                    _buildInfoSection(
                      'Sex',
                      report['sex']?.toUpperCase() ?? 'N/A',
                    ),
                    if (report['malaria_parasite'] != null)
                      _buildInfoSection(
                        'Parasite Type',
                        report['malaria_parasite'],
                      ),
                    if (report['received_treatment'] != null)
                      _buildInfoSection(
                        'Treatment',
                        report['received_treatment'],
                      ),
                    _buildInfoSection(
                      'Reporter',
                      report['reporter_name'] ?? 'N/A',
                    ),
                    _buildInfoSection(
                      'Township',
                      report['reporter_township'] ?? 'N/A',
                    ),
                    _buildInfoSection(
                      'Village',
                      report['reporter_village'] ?? 'N/A',
                    ),
                    if (report['remarks'] != null &&
                        report['remarks'].isNotEmpty)
                      _buildInfoSection('Remarks', report['remarks']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
