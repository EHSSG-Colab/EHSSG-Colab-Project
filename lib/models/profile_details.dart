import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum ReportingTownship {
  Demoso,
  Bawlake,
  Hpasawng,
  Hpruso,
  Loikaw,
  Mese,
  Pekon,
  Shadaw,
}

enum ReportingVillage { AhDoe, BaHan, BaHone, BanDein }

class ProfileDetails {
  ProfileDetails({
    
    required this.Reporter_name,
    required this.ReportingTownship,
    required this.ReportingVillage,
  }) : id = uuid.v4();

  final String id;
  final String Reporter_name;
  final Enum ReportingTownship;
  final Enum ReportingVillage;

  static var values;
}

class ProfileList {
  ProfileList({
    required this.reportingTownship,
    required this.reportingVillage,
    required this.profiledetails,
  });

  ProfileList.forReportingTownship(
    List<ProfileDetails> allProfiles,
    this.reportingTownship,
    this.reportingVillage,
  ) : profiledetails =
          allProfiles
              .where(
                (profiledetails) =>
                    profiledetails.ReportingTownship == reportingTownship,
              )
              .toList();

  ProfileList.forReportingVillage(
    List<ProfileDetails> allProfiles,
    this.reportingVillage,
    this.reportingTownship,
  ) : profiledetails =
          allProfiles
              .where(
                (profiledetails) =>
                    profiledetails.ReportingTownship == reportingVillage,
              )
              .toList();

  final ReportingTownship reportingTownship;
  final ReportingVillage reportingVillage;
  final List<ProfileDetails> profiledetails;
}
