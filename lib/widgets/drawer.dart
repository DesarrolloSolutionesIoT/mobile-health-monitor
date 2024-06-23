import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/settings_page.dart'; // Asegúrate de tener esta importación correcta
import '../models/health_data.dart'; // Asegúrate de tener esta importación correcta

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
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.indigo],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/doctor.jpg'), // Asegúrate de tener esta imagen en la ruta especificada
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Dr. John Doe',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Cardiologist',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
            onTap: () {
              Navigator.pop(context);
              // Aquí puedes agregar la lógica para manejar las notificaciones
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              _openSettings(context); // Define esta función para manejar la navegación a la configuración
            },
          ),
        ],
      ),
    );
  }
}
