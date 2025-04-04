import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/app_bar.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/floating_button.dart';
import 'package:malaria_report_mobile/widgets/unit_widgets/sized_box.dart';
import 'package:provider/provider.dart';
import '../models/volunteer.dart';
import '../providers/volunteer_provider.dart';
import '../themes/app_icons.dart';
import '../themes/app_theme.dart';
import '../widgets/layouts/scaffold_for_lilst_vew.dart';
import '../widgets/unit_widgets/empty_list_message.dart';
import '../widgets/unit_widgets/list_tile_records_no_badge.dart';
import '../widgets/unit_widgets/tappable_icon.dart';
import 'update_volunteer.dart';

class Volunteers extends StatelessWidget {
  const Volunteers({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<VolunteerProvider>(
      builder: (context, volunteerProvider, child) {
        // construct a list from volunteer provider
        List<Volunteer> volunteers = volunteerProvider.volunteers;
        return ScaffoldForListView(
          appBar: const MyAppBar(
            hasBackArrow: false,
            title: Text('Malaria Volunteers'),
          ),
          canPop: false,
          floatingActionButton: MyFloatingButton(
            label: 'Add Volunteer',
            icon: AppIcons().addOutlineicon(),
            onPressed: () => Navigator.push(
              context,
                MaterialPageRoute(
                  builder: (context) => const UpdateVolunteer(
                    operation: 'Add',
                    navigateToIndex: 2,
                  )
                )
            )
          ),
          child: volunteers.isEmpty
          ?
          const EmptyListMessage(
            message: 'No volunteers yet.',
            icon: Icons.group,
            actionMessage: 'Please tap Add Volunteer button to add new information.'
          ) :
          ListView.builder(
            itemCount: volunteers.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  if (index == 0) sizedBoxh20(),
                  MyListTileRecordsNoBadge(
                    caption: volunteers[index].volName,
                    label: 'Township: ${volunteers[index].volTsp}, Village: ${volunteers[index].volVillage}',
                    leadingIcon: AppIcons().volunteerFilledIcon(),
                    trailingButton: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme().highlightColor().withOpacity(0.1),
                      ),
                       child: SizedBox(
                        height: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: TappableIcon(
                            icon: AppIcons().editIcon(),
                            onTap: () {
                              Navigator.push(
                                context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => UpdateVolunteer(
                                              navigateToIndex: 2,
                                              operation: 'Edit',
                                              id: volunteers[index].id,
                                              volName: volunteers[index].volName,
                                               volTsp: volunteers[index].volTsp,
                                               volVillage:volunteers[index].volVillage,
                                            )
                                          )
                              );
                            }
                          )
                        )
                       )
                    )
                  ),
                  if (index == volunteers.length - 1) sizedBoxh50(),
                ]
              );
            }
          )
        );
      }
    );
    
  }
}
