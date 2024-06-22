import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/settings_page.dart';
import '../models/health_data.dart';

class AppDrawer extends StatelessWidget {
  void _openSettings(BuildContext context) async {
    HealthDataProvider provider =
        Provider.of<HealthDataProvider>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingsPage(
          notificationsEnabled: provider.notificationsEnabled,
          onNotificationsChanged: (value) {
            provider.notificationsEnabled = value;
            provider.notifyListeners();
          },
        ),
      ),
    );

    if (result != null && result is bool) {
      provider.notificationsEnabled = result;
      provider.notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/doctor.jpg'), // Replace with the path to your doctor image
                ),
                SizedBox(height: 10),
                Text(
                  'Dr. John Doe',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  'Cardiologist',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _openSettings(context);
            },
          ),
        ],
      ),
    );
  }
}
