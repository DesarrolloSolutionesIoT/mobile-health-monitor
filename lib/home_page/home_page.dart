import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'health_monitor.dart';
import 'drawer.dart';
import 'health_data.dart';

class HealthMonitorHomePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HealthDataProvider(context),
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Health Monitor'),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        endDrawer: AppDrawer(),
        body: HealthMonitor(),
      ),
    );
  }
}