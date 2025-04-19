import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/models/malaria.dart';
import 'package:malaria_report_mobile/providers/malaria_provider.dart';
import 'package:malaria_report_mobile/screens/update_malaria.dart';
import 'package:malaria_report_mobile/themes/app_icons.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/utils/malaria_actions.dart';
import 'package:malaria_report_mobile/utils/string_utils.dart';
import 'package:malaria_report_mobile/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/elevated_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/list_tile.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/nav_wrapper.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/vertical_more_icon_button.dart';
import 'package:provider/provider.dart';

class ViewMalaria extends StatefulWidget {
  final int navigateToIndex; // page to navigate after the job is done
  final int id; // malaria record id
  
  const ViewMalaria({
    super.key, 
    required this.navigateToIndex, 
    required this.id
  });

  @override
  State<ViewMalaria> createState() => _ViewMalariaState();
}

class _ViewMalariaState extends State<ViewMalaria> {
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
                  builder: (context) => const NavWrapper(
                        initialIndex: 0,
                      )),
              (route) => false);
        },
        title: Text(
          'Malaria Case Report',
          style: AppTheme().displayLarge(),
        ),
        actions: [_buildAppBarMoreActions()],
      ),
      children: [
        FutureBuilder<Malaria?>(
          future: _futureMalariaRecord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).padding.top,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme().focusedColor(),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text('Malaria record not found'),
              );
            } else {
              final malaria = snapshot.data!;
              return Column(
                children: [
                  sizedBoxh20(),
                  // Example fields, add the rest as needed based on your model
                  MyListTile(
                    label: 'Date of RDT',
                    value: formatDateString(malaria.dateOfRdt),
                  ),
                  MyListTile(
                    label: 'Patient Name',
                    value: malaria.patientName,
                  ),
                  MyListTile(
                    label: 'Age',
                    value: '${malaria.patientAge} ${capitalizeFirstLetter(malaria.ageUnit)}(s)',
                  ),
                  sizedBoxh30(),
                  _buildEditAction(),
                  sizedBoxh10(),
                  _buildCancelAction(),
                  sizedBoxh50(),
                ],
              );
            }
          },
        )
      ],
    );
  }

  // load malaria from database
  Future<Malaria?> _loadMalariaData() async {
    return await Provider.of<MalariaProvider>(context, listen: false)
        .getMalariaById(widget.id);
  }

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

  Widget _buildEditAction() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _editAction,
        child: const Text('Edit'),
      ),
    );
  }

  Widget _buildCancelAction() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavWrapper(
              initialIndex: 0,
            ),
          ),
          (route) => false,
        ),
        child: const Text('Cancel'),
      ),
    );
  }

  Future<void> _editAction() {
    return Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => UpdateMalaria(
          navigateToIndex: 0,
          operation: 'Edit',
          id: widget.id,
        ),
      ),
      (route) => false,
    );
  }
}
