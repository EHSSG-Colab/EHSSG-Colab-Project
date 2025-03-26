// import 'package:flutter/material.dart';
// import 'package:malaria_case_report_01/provider/profile_provider.dart';
// import 'package:provider/provider.dart';

// class EditProfilePage extends StatefulWidget {
//   const EditProfilePage({super.key});

//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   late TextEditingController _usernameController;
//   late TextEditingController _townshipController;
//   late TextEditingController _villageController;

//   @override
//   void initState() {
//     super.initState();
//     final profile = Provider.of<ProfileProvider>(context, listen: false);

//     _usernameController = TextEditingController(text: profile.username);
//     _townshipController = TextEditingController(text: profile.township);
//     _villageController = TextEditingController(text: profile.village);
//   }

//   @override
//   void dispose() {
//     _usernameController.dispose();
//     _townshipController.dispose();
//     _villageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final profile = Provider.of<ProfileProvider>(context, listen: false);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(labelText: 'Username'),
//             ),
//             TextField(
//               controller: _townshipController,
//               decoration: const InputDecoration(labelText: 'Township'),
//             ),
//             TextField(
//               controller: _villageController,
//               decoration: const InputDecoration(labelText: 'Village'),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Save updated profile data to provider
//                 profile.updateProfile(
//                   _usernameController.text,
//                   _townshipController.text,
//                   _villageController.text,
//                 );

//                 // Show success message
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Profile Updated')),
//                 );

//                 // Go back to ProfileDetail page
//                 Navigator.pop(context);
//               },
//               child: const Text('Save Changes'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
