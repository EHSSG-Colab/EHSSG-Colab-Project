import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/models/malaria.dart';
import 'package:malaria_case_report_01/providers/malaria_provider.dart';
import 'package:malaria_case_report_01/screens/update_malaria.dart';
import 'package:malaria_case_report_01/themes/app_icons.dart';
import 'package:malaria_case_report_01/themes/app_theme.dart';
import 'package:malaria_case_report_01/utils/malaria_actions.dart';
import 'package:malaria_case_report_01/utils/string_utils.dart';
import 'package:malaria_case_report_01/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/divider.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/nav_wrapper.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/vertical_more_icon_button.dart';

import 'package:provider/provider.dart';

class ViewMalaria extends StatefulWidget {
  final int navigateToIndex; // Page to navigate after the job is done
  final int id; // Malaria record ID

  const ViewMalaria({
    super.key,
    required this.navigateToIndex,
    required this.id,
  });

  @override
  State<ViewMalaria> createState() => _ViewMalariaState();
}

class _ViewMalariaState extends State<ViewMalaria> {
  // Holds future that will resolve to the malaria record
  late Future<Malaria?> _futureMalariaRecord;

  @override
  void initState() {
    super.initState();
    _futureMalariaRecord = _loadMalariaData();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: true,
      appBar: MyAppBar(
        hasBackArrow: false,
        leadingIcon: Icons.arrow_back_ios,
        leadingIconOnPressed: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const NavWrapper(initialIndex: 0),
            ),
            (route) => false,
          );
        },
        title: Text('Malaria Case Report'),
        actions: [_buildAppBarMoreActions()],
      ),
      children: [
        FutureBuilder<Malaria?>(
          future: _futureMalariaRecord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for data
              return _buildLoadingIndicator();
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Malaria record not found'));
            } else {
              // Display all malaria record data in organized sections
              final malaria = snapshot.data!;
              return _buildMalariaRecordView(malaria);
            }
          },
        ),
      ],
    );
  }

  // Widget to display loading indicator centered on screen
  Widget _buildLoadingIndicator() {
    return SizedBox(
      height:
          MediaQuery.of(context).size.height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme().focusedColor()),
        ),
      ),
    );
  }

  // Build the complete malaria record view with all sections
  Widget _buildMalariaRecordView(Malaria malaria) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedBoxh20(),
        // Volunteer Information Section
        _buildSectionTitle('Volunteer Information'),
        _buildVolunteerSection(malaria),
        sizedBoxh20(),
        const MyDivider(),

        // Patient Information Section
        _buildSectionTitle('Patient Information'),
        _buildPatientSection(malaria),
        sizedBoxh20(),
        const MyDivider(),

        // Test Results Section
        _buildSectionTitle('Test Results'),
        _buildTestResultsSection(malaria),
        sizedBoxh20(),
        const MyDivider(),

        // Treatment Section (only if positive)
        if (malaria.rdtResult == 'Positive') ...[
          _buildSectionTitle('Treatment'),
          _buildTreatmentSection(malaria),
          sizedBoxh20(),
          const MyDivider(),
        ],

        // Additional Information Section
        _buildSectionTitle('Additional Information'),
        _buildAdditionalInfoSection(malaria),
        sizedBoxh30(),

        // Action Buttons
        _buildEditAction(),
        sizedBoxh10(),
        _buildCancelAction(),
        sizedBoxh50(),
      ],
    );
  }

  // Section title with consistent styling
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppTheme().secondaryColor(),
        ),
      ),
    );
  }

  // Volunteer Information Section
  Widget _buildVolunteerSection(Malaria malaria) {
    return Column(
      children: [
        MyListTile(label: 'Data Collector', value: malaria.reporter_name),

        MyListTile(
          label: 'Data Collector Location',
          value: '${malaria.reporter_township} - ${malaria.reporter_village}',
        ),
        sizedBoxh10(),
        MyListTile(label: 'Volunteer Name', value: malaria.volunteer_name),
        MyListTile(
          label: 'Volunteer Location',
          value: '${malaria.volunteer_township} - ${malaria.volunteer_village}',
        ),
      ],
    );
  }

  // Patient Information Section
  Widget _buildPatientSection(Malaria malaria) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MyListTile(label: 'Month', value: malaria.treatment_month),
            ),
            Expanded(
              child: MyListTile(label: 'Year', value: malaria.treatment_year),
            ),
          ],
        ),
        MyListTile(
          label: 'Date of RDT',
          value: formatDateString(malaria.test_date),
        ),
        MyListTile(label: 'Patient Name', value: malaria.patient_name),
        MyListTile(
          label: 'Age',
          value: '${malaria.age} ${capitalizeFirstLetter(malaria.age_unit)}(s)',
        ),
        MyListTile(label: 'Address', value: malaria.address),
        MyListTile(label: 'Gender', value: malaria.sex),
        if (malaria.sex == 'Female') ...[
          MyListTile(label: 'Pregnant', value: malaria.isPregnant),
          MyListTile(label: 'Lactating Mother', value: malaria.lact_mother),
        ],
      ],
    );
  }

  // Test Results Section
  Widget _buildTestResultsSection(Malaria malaria) {
    return Column(
      children: [
        MyListTile(
          label: 'RDT Result',
          value: malaria.rdtResult,
          color:
              malaria.rdtResult == 'Positive'
                  ? TileColor.danger
                  : TileColor.primary,
        ),
        if (malaria.rdtResult == 'Positive') ...[
          MyListTile(label: 'Malaria Parasite', value: malaria.malariaParasite),
          MyListTile(label: 'Symptoms', value: malaria.symptoms),
        ],
      ],
    );
  }

  // Treatment Section
  Widget _buildTreatmentSection(Malaria malaria) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Antimalarial Medication',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: AppTheme().secondaryColor(),
            ),
          ),
        ),
        sizedBoxh10(),
        // Display only medications that were prescribed
        if (malaria.act24 == 'Yes')
          MyListTile(label: 'ACT-24', value: '${malaria.act24_amount} units'),
        if (malaria.act18 == 'Yes')
          MyListTile(label: 'ACT-18', value: '${malaria.act18_amount} units'),
        if (malaria.act12 == 'Yes')
          MyListTile(label: 'ACT-12', value: '${malaria.act12_amount} units'),
        if (malaria.act6 == 'Yes')
          MyListTile(label: 'ACT-6', value: '${malaria.act6_amount} units'),
        if (malaria.cq == 'Yes')
          MyListTile(label: 'Chloroquine', value: '${malaria.cq_amount} units'),
        if (malaria.pq == 'Yes')
          MyListTile(label: 'Primaquine', value: '${malaria.pq_amount} units'),
        sizedBoxh10(),
        MyListTile(label: 'Patient Referred', value: malaria.isReferred),
        MyListTile(label: 'Expired with RDT Positive', value: malaria.isDead),
        MyListTile(
          label: 'Treatment Received',
          value:
              malaria.receivedTreatment == '<24'
                  ? 'Within 24 hours of fever'
                  : 'After 24 hours of fever',
        ),
      ],
    );
  }

  // Additional Information Section
  Widget _buildAdditionalInfoSection(Malaria malaria) {
    return Column(
      children: [
        if (malaria.rdtResult == 'Positive')
          MyListTile(
            label: 'Travel History (2wks-1mth)',
            value: malaria.travelling_before,
          ),
        MyListTile(label: 'Occupation', value: malaria.occupation),
        MyListTile(
          label: 'Person with Disabilities',
          value: malaria.persons_with_disability,
        ),
        MyListTile(
          label: 'Internally Displaced Person',
          value: malaria.internally_displaced,
        ),
        if (malaria.remark.isNotEmpty)
          MyListTile(label: 'Remarks', value: malaria.remark),
        MyListTile(
          label: 'Sync Status',
          value: malaria.syncStatus,
          color:
              malaria.syncStatus == 'SYNCED'
                  ? TileColor.primary
                  : TileColor.warning,
        ),
      ],
    );
  }

  // Load malaria from database
  Future<Malaria?> _loadMalariaData() async {
    return await Provider.of<MalariaProvider>(
      context,
      listen: false,
    ).getMalariaById(widget.id);
  }

  // App bar actions menu
  Widget _buildAppBarMoreActions() {
    return VerticalMoreIconButton(
      icon: AppIcons().moreIcon(),
      menuItems: [
        PopupMenuItem(
          child: ListTile(
            leading: AppIcons().deleteIcon(),
            iconColor: AppTheme().rosyColor(),
            title: const Text(
              'Delete this record',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              Navigator.pop(context);
              bool confirm = await MalariaActions.showDeleteConfirmationDialog(
                context,
                'Are you sure you want to delete this record?',
              );
              if (confirm) {
                await MalariaActions.deleteRecord(context, widget.id);
              }
            },
          ),
        ),
      ],
    );
  }

  // Edit button
  Widget _buildEditAction() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _editAction,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme().secondaryColor(),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: const Text('Edit'),
      ),
    );
  }

  // Cancel button
  Widget _buildCancelAction() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed:
            () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const NavWrapper(initialIndex: 0),
              ),
              (route) => false,
            ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: BorderSide(color: AppTheme().secondaryColor()),
        ),
        child: Text(
          'Back to Home',
          style: TextStyle(color: AppTheme().secondaryColor()),
        ),
      ),
    );
  }

  // Navigate to edit screen
  Future<void> _editAction() {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (BuildContext context) => UpdateMalaria(
              navigateToIndex: 0,
              operation: 'Edit',
              id: widget.id,
            ),
      ),
      (route) => false,
    );
  }
}
