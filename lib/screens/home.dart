import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/database/database_helper.dart';
import 'package:malaria_case_report_01/screens/add_report.dart'; // Import AddReport page
import 'package:malaria_case_report_01/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/floating_button.dart';
import 'package:malaria_case_report_01/themes/app_icons.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _volunteers = [];
  bool _isLoading = true;
  int totalVolunteers = 0;
  int townships = 0;
  int villages = 0;

  @override
  void initState() {
    super.initState();
    _loadVolunteers();
  }

  Future<void> _loadVolunteers() async {
    try {
      final volunteerData = await _dbHelper.getAllVol();
      final Set<String> uniqueTownships = {};
      final Set<String> uniqueVillages = {};

      for (var volunteer in volunteerData) {
        uniqueTownships.add(volunteer['vol_tsp'] ?? '');
        uniqueVillages.add(volunteer['vol_vil'] ?? '');
      }

      setState(() {
        _volunteers = volunteerData.reversed.toList();
        totalVolunteers = volunteerData.length;
        townships = uniqueTownships.length;
        villages = uniqueVillages.length;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading volunteers: $e');
      setState(() => _isLoading = false);
    }
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color bgColor,
    Color iconColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentVolunteersList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child:
          _volunteers.isEmpty
              ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    'No volunteers available',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              )
              : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _volunteers.length > 5 ? 5 : _volunteers.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final volunteer = _volunteers[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      radius: 25,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(
                      volunteer['vol_name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      'Township: ${volunteer['vol_tsp'] ?? 'N/A'}\n'
                      'Village: ${volunteer['vol_vil'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    isThreeLine: true,
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                      size: 16,
                    ),
                  );
                },
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        hasBackArrow: false,
        title: Text('Malaria App Dashboard'),
      ),
      backgroundColor: Colors.grey.shade100, // Neutral background color
      floatingActionButton: MyFloatingButton(
        label: 'Add Reporter',
        icon: AppIcons().addOutlineicon(),
        onPressed:
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => const AddReport(), // Navigate to AddReport
              ),
            ),
      ),
      body: SafeArea(
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                  onRefresh: _loadVolunteers,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            _buildStatCard(
                              'Total Volunteers',
                              totalVolunteers.toString(),
                              Icons.people_outline,
                              Colors.blue.shade50,
                              Colors.blue.shade700,
                            ),
                            _buildStatCard(
                              'Townships',
                              townships.toString(),
                              Icons.location_city_outlined,
                              Colors.blue.shade50,
                              Colors.blue.shade700,
                            ),
                            _buildStatCard(
                              'Villages',
                              villages.toString(),
                              Icons.home_work_outlined,
                              Colors.blue.shade50,
                              Colors.blue.shade700,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Recent Volunteers List',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildRecentVolunteersList(),
                      ],
                    ),
                  ),
                ),
      ),
    );
  }
}
