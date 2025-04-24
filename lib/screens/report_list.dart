import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../widgets/unit_widgets/app_bar.dart';
import 'report_details.dart';

class ReportList extends StatefulWidget {
  const ReportList({super.key});

  @override
  State<ReportList> createState() => _ReportListState();
}

class _ReportListState extends State<ReportList> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    final reports = await _dbHelper.getAllMalaria();
    setState(() {
      _reports = reports.reversed.toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(hasBackArrow: true, title: Text('All Reports')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                onRefresh: _loadReports,
                child: ListView.builder(
                  itemCount: _reports.length,
                  itemBuilder: (context, index) {
                    final report = _reports[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          report['patient_name'] ?? 'Unknown Patient',
                        ),
                        subtitle: Text(
                          'Date: ${report['date_of_rdt']}\n'
                          'RDT: ${report['rdt_result'] == 1 ? 'Positive' : 'Negative'}',
                        ),
                        isThreeLine: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ReportDetails(report: report),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
