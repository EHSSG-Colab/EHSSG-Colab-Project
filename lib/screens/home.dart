import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/database/database_helper.dart';
import 'package:malaria_case_report_01/screens/update_volunteer.dart';

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
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Icon(icon, size: 80, color: iconColor.withOpacity(0.1)),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: iconColor.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                child: Center(child: Text('No volunteers available')),
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
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Township: ${volunteer['vol_tsp'] ?? 'N/A'}\n'
                      'Village: ${volunteer['vol_vil'] ?? 'N/A'}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    isThreeLine: true,
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
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
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade50,
      ),
      backgroundColor: Colors.grey.shade100,
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
                              const Color(0xFFE3F2FD),
                              const Color(0xFF2196F3),
                            ),
                            _buildStatCard(
                              'Townships',
                              townships.toString(),
                              Icons.location_city_outlined,
                              const Color(0xFFE8F5E9),
                              const Color(0xFF4CAF50),
                            ),
                            _buildStatCard(
                              'Villages',
                              villages.toString(),
                              Icons.home_work_outlined,
                              const Color(0xFFFFF3E0),
                              const Color(0xFFFF9800),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => const UpdateVolunteer(
                                          operation: 'Add',
                                          navigateToIndex: 2,
                                        ),
                                  ),
                                );
                              },
                              child: _buildStatCard(
                                'Add Volunteers',
                                'Add',
                                Icons.person_add_outlined,
                                const Color(0xFFF3E5F5),
                                const Color(0xFF9C27B0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Recent Volunteers List',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineSmall?.copyWith(
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
