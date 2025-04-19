import 'package:flutter/material.dart';
import 'package:malaria_report_mobile/services/synchronization_helper.dart';
import 'package:provider/provider.dart';

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

  // INIT
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _fetchData();
  }

  void _fetchData() {
    Provider.of<MalariaProvider>(context, listen: false).fetchCases();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MalariaProvider>(
      builder: (context, malariaProvider, child) {
        List<Malaria> malariaCases = MalariaProvider.cases;
      },
    );
  }
}
