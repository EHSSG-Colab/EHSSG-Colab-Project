import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/screens/update_volunteers.dart';
import 'package:malaria_report_mobile/widgets/layouts/scaffold_for_scroll_view.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';

import 'package:malaria_report_mobile/widgets/unit_widgets/floating_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';

class Volunteers extends StatelessWidget {
  const Volunteers({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldForScrollView(
      canPop: false,
      appBar: const MyAppBar(
        hasBackArrow: false,
        title: Text('Malaria Volunteers'),
      ),
      children: [
        sizedBoxh20(),
        MyFloatingButton(
          icon: Icon(Icons.add),

          label: 'Add Volunteer',
          onPressed:
              () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateVolunteer(navigateToIndex: 1),
                ),
                (route) => false,
              ),
        ),
      ],
    );
  }
}
