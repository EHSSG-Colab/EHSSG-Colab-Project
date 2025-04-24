import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:malaria_case_report_01/database/database_helper.dart';
import 'package:malaria_case_report_01/widgets/unit_widgets/nav_wrapper.dart';

/// Utility class for common malaria record actions
class MalariaActions {
  /// Deletes a malaria record from the database
  static Future<void> deleteRecord(BuildContext context, int id) async {
    try {
      EasyLoading.showProgress(0.1, status: 'Deleting record...');
      final db = DatabaseHelper();
      int result = await db.deleteMalaria(id);

      EasyLoading.dismiss();
      if (result > 0) {
        EasyLoading.showSuccess('Record deleted successfully');
        // Navigate back to home screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const NavWrapper(initialIndex: 0),
          ),
          (route) => false,
        );
      } else {
        EasyLoading.showError('Failed to delete record');
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError('Error deleting record: $e');
    }
  }

  /// Shows a confirmation dialog before deleting a record
  static Future<bool> showDeleteConfirmationDialog(
    BuildContext context,
    String message,
  ) async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Delete'),
              content: Text(message),
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
                    backgroundColor: WidgetStateProperty.all(Colors.red),
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
        ) ??
        false; // Return false if dialog is dismissed
  }
}
