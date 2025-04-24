import 'package:flutter/material.dart';
import 'package:malaria_case_report_01/models/volunteers.dart';
import '../database/database_helper.dart';

class VolunteerProvider extends ChangeNotifier {
  // LIST TO STORE VOLUNTEER OBJECTS
  List<Volunteer> volunteers = [];

  // LIST TO STORE VOLUNTEER NAMES
  List<String> volunteerNames = [];

  VolunteerProvider() {
    init();
  }

  Future<void> init() async {
    // FETCH FROM DATABASE
    final List<Map<String, dynamic>> localVolunteers =
        await DatabaseHelper().getAllVol();
    volunteers =
        localVolunteers.map((data) => Volunteer.fromMap(data)).toList();

    // Populate volunteerNames using the corrected field name
    volunteerNames =
        volunteers.map((volunteer) => volunteer.volunteer_name).toList();
    notifyListeners();
  }

  Future<void> insertVolunteerInfo({
    required String volunteerName,
    required String volunteerTownship,
    required String volunteerVillage,
  }) async {
    Volunteer newVolunteer = Volunteer(
      id: null,
      volunteer_name: volunteerName, // Corrected typo
      volunteer_township: volunteerTownship,
      volunteer_village: volunteerVillage,
    );

    // SAVE THE NEW VOLUNTEER AND GET THE NEW ID FROM LOCAL DATABASE
    int id = await DatabaseHelper().insertVol(newVolunteer.toMap());
    // UPDATE THE NEW VOLUNTEER ID FROM DATABASE TO WIDGET TREE
    newVolunteer.id = id;
    // UPDATE THE VOLUNTEER LIST IN WIDGET TREE WITH UPDATED LIST
    volunteers.add(newVolunteer);
    notifyListeners();
  }

  Future<void> editVolunteerInfo({
    required int id,
    required String volunteerName,
    required String volunteerTownship,
    required String volunteerVillage,
  }) async {
    Volunteer updatedVolunteer = Volunteer(
      id: id,
      volunteer_name: volunteerName, // Corrected typo
      volunteer_township: volunteerTownship,
      volunteer_village: volunteerVillage,
    );

    await DatabaseHelper().updateVol(updatedVolunteer.toMap(), id);

    // UPDATE THE WIDGET TREE
    int index = volunteers.indexWhere((volunteer) => volunteer.id == id);
    if (index != -1) {
      volunteers[index] = updatedVolunteer;
    }
    notifyListeners();
  }

  Future<void> deleteVolunteer(int id) async {
    await DatabaseHelper().deleteVol(id);

    // UPDATE THE WIDGET TREE
    volunteers.removeWhere((volunteer) => volunteer.id == id);
    notifyListeners();
  }
}
