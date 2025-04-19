import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:malaria_report_mobile/database/database_helper.dart';
import 'package:malaria_report_mobile/services/api.dart';
import 'package:malaria_report_mobile/services/network_check.dart';
import 'package:malaria_report_mobile/services/shared_preferences.dart';
import 'package:malaria_report_mobile/services/synchronization_helper.dart';
import 'package:malaria_report_mobile/themes/app_icons.dart';
import 'package:malaria_report_mobile/themes/app_theme.dart';
import 'package:malaria_report_mobile/widgets/layouts/scaffold_for_lilst_vew.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/icon_text_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/vertical_more_icon_button.dart';
import 'package:provider/provider.dart';

import '../models/malaria.dart';
import '../providers/malaria_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver
// WidgetBindingObserver is used to automatically update the widget when the information stored in local database has changes
{
  // get instance of synchronization helper a.k.a instantiation
  final SynchronizationHelper _synchronizationHelper = SynchronizationHelper();

  // Instantiate DatabaseHelper
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Authentication token is required to send data to database
  late String token;

  // Instantiate ApiService as late since token value will be fetched later
  late ApiService _apiService;

  // determines whether enable or disable the Send button
  bool _hasUnsyncedRecords = false;
  // determines whether enable or disable the More button
  bool _hasSyncedRecords = false;
  // INIT
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // making sure to run fetch token first
    _fetchToken().then((_) {
      _fetchData();
      _checkUnsyncedRecords();
      _checkSyncedRecords();
    });
  }

  // get local malaria case data
  void _fetchData() {
    Provider.of<MalariaProvider>(context, listen: false).fetchCases();
    _checkUnsyncedRecords();
    _checkSyncedRecords();
  }

  // get authentication token
  Future<void> _fetchToken() async {
    token = await SharedPrefService.getToken();

    // Initialize ApiService with token
    _apiService = ApiService(token);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchData();
      _checkUnsyncedRecords();
      _checkSyncedRecords();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MalariaProvider>(
      builder: (context, malariaProvider, child) {
        // get data from database
        List<Malaria> malariaCases = malariaProvider.cases;

        return ScaffoldForListView(
          appBar: MyAppBar(
            hasBackArrow: false,
            title: _appBarTitle(),
            actions: [
              MyIconTextButton(
                // Disable the button when there is no unsynced records
                onPressed:
                    _hasUnsyncedRecords
                        ? () => _showUploadConfirmationDialog()
                        : null,
                icon: AppIcons().pendingSyncIcon(),
                label: 'Send',
                // Opacity styling based on number of unsynced malaria records
                opacity: _hasUnsyncedRecords ? 1.0 : 0.5,
              ),
              sizedBoxh10(),
              _buildAppBarMoreButton(),
            ],
          ),
          canPop: false,
          child: const Placeholder(),
        );
      },
    );
  }

  // Appbar title
  Widget _appBarTitle() {
    return const Text('Home');
  }

  // Upload confirmation dialog
  void _showUploadConfirmationDialog() async {
    bool isConnected = await NetworkCheck.isConnected();

    if (!isConnected) {
      EasyLoading.showError('No internet connection');
      return;
    }

    // Check for pending records
    List<Map<String, dynamic>> pendingData =
        await _databaseHelper.getAllUnsyncedMalaria();

    if (pendingData.isEmpty) {
      EasyLoading.showError(
        'All existing malaria records has already been synchronized.',
      );
      return;
    }

    // Show dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload'),
          content: const Text(
            'All unsynced malaria records will be sent to server.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await _uploadData();
                if (success) {
                  _fetchData();
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  AppTheme().secondaryDarkColor(),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Upload method
  Future<bool> _uploadData() async {
    // check connection
    bool isConnected = await NetworkCheck.isConnected();
    if (isConnected) {
      // get data from database
      List<Map<String, dynamic>> data =
          await _databaseHelper.getAllUnsyncedMalaria();

      // convert to json
      String dataJson = _synchronizationHelper.convertToJson(data);

      EasyLoading.showProgress(0.9, status: 'Sending data');

      // Upload to API
      try {
        Map<String, dynamic> result = await _apiService.postMalariaDataToApi(
          dataJson,
        );

        bool responseHandlerOutput = await _synchronizationHelper
            .handleResponse(result['response'] as http.Response, data);

        if (responseHandlerOutput) {
          _checkUnsyncedRecords();
          _checkSyncedRecords();
          return true;
        }
        return responseHandlerOutput;
      } catch (e) {
        EasyLoading.showError('Error uploading data - $e');
        return false;
      }
    } else {
      EasyLoading.showError('No internet connection!');
      return false;
    }
  }

  // AppBar More Button
  Widget _buildAppBarMoreButton() {
    return VerticalMoreIconButton(
      icon: AppIcons().moreIcon(),
      // Only enable button when there are synced records to delete
      enabled: _hasSyncedRecords,
      // Apply opacity styling based on whether there are synced records
      opacity: _hasSyncedRecords ? 1.0 : 0.5,
      menuItems: [
        PopupMenuItem(
          child: ListTile(
            leading: AppIcons().deleteIcon(),
            iconColor: AppTheme().rosyColor(),
            title: const Text(
              'Delete only synced records',
              style: TextStyle(color: Colors.red),
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            bool confirmDeleteSynced = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm deleting synced records'),
                  content: const Text(
                    'Are you sure you want to delete synced records?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          AppTheme().rosyColor(),
                        ),
                      ),
                      child: const Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
            if (confirmDeleteSynced == true) {
              await _deleteSyncedRecords();
            }
          },
        ),
      ],
    );
  }

  // Delete synced records
  Future<void> _deleteSyncedRecords() async {
    EasyLoading.showProgress(0.1, status: 'Deleting synced malaria records...');
    try {
      int deletedCount = await _databaseHelper.deleteSyncedMalaria();
      EasyLoading.dismiss();

      if (deletedCount > 0) {
        EasyLoading.showSuccess(
          'Deleted $deletedCount synchronized malaria records.',
        );
        _fetchData();
        _checkUnsyncedRecords();
        _checkSyncedRecords();
      } else {
        EasyLoading.showError('No more records to delete');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Error deleting records - $e');
    }
  }

  /// Checks if there are any unsynced malaria records in the database
  /// Updates the _hasUnsyncedRecords state variable
  Future<void> _checkUnsyncedRecords() async {
    // Get all unsynced malaria records from the database
    List<Map<String, dynamic>> pendingData =
        await _databaseHelper.getAllUnsyncedMalaria();
    // Update state based on whether there are any pending records
    setState(() {
      _hasUnsyncedRecords = pendingData.isNotEmpty;
    });
  }

  /// Updates the _hasSyncedRecords state variable based on data from DatabaseHelper
  Future<void> _checkSyncedRecords() async {
    // Use the new method in DatabaseHelper to check for synced records
    bool hasSynced = await _databaseHelper.hasSyncedRecords();

    // Only update state if the value has changed to avoid unnecessary rebuilds
    if (hasSynced != _hasSyncedRecords) {
      setState(() {
        _hasSyncedRecords = hasSynced;
      });
    }
  }
}
