import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/widgets/new_profile.dart';
import 'package:malaria_report_mobile/models/profile_details.dart';

class ProfileDetail extends StatefulWidget {
  

  const ProfileDetail( {super.key, this.profileDetails});

  final ProfileDetails? profileDetails;
  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}



class _ProfileDetailState extends State<ProfileDetail> {
  final List<ProfileDetails> _profileDetails = [];
//  ProfileDetails profileDetails = ProfileDetails(
//     id: DateTime.now().toString(), // Example ID generation
//     Reporter_name: '',
//     ReportingTownship:  , 
//     ReportingVillage: ,
    
//   );

  // @override
  // void initState() {
  //   super.initState();
  //   // Initialize with existing data or create new empty profile
  //   profileDetails = widget.profileDetails ?? ProfileDetails(
  //     id: DateTime.now().toString(), // Example ID generation
  //     Reporter_name: '',
  //     ReportingTownship:  , 
  //     ReportingVillage: ,
  //     name: '',
  //   );
  // }
 
  void _openAddProfileOverlay() {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      // builder: (ctx) => NewProfile(onAddProfile: _addProfile),
      // builder: (context) => NewProfile(onAddProfile: _addProfile),
      builder: (context) => Container(
        height: 500,
        child: Column(children: [Text('test')],),
      )
    );
  }

  void _addProfile(ProfileDetails profiledetails) {
    setState(() {
      _profileDetails.add(profiledetails);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = Center(
      child: Text('No Profile Yet. Please add some'),
    );

    if (_profileDetails.isNotEmpty) {
      mainContent = ProfileDetail(
        profileDetails: _profileDetails[0],
        
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile Detail',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: Column(
        children: [
              Padding(padding:const EdgeInsets.all(16),
              child: Center(
                child: Image.asset( 'assets/images/cliniclogo.jpg', width: 100, height: 100),
              ), ),

              Text(
                    "Profile ID: ${widget.profileDetails?.id ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Reporter Name: ${widget.profileDetails?.Reporter_name} ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Reporting Township: ${widget.profileDetails?.ReportingTownship ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Reporting Village: ${widget.profileDetails?.ReportingVillage ?? 'N/A'}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
          
                  ElevatedButton(
                    onPressed: _openAddProfileOverlay,
                    child: Text("Edit Profile"),
                  ),

            
              // Card(
              //   margin: EdgeInsets.all(16),
              //   child: Padding(
              //     padding: EdgeInsets.all(16),
              //     child: mainContent,
              //   ),
              // ),
              
      
            ],
          
        
      ),
    );
  }
}
