import 'package:flutter/material.dart';
import 'package:health_guard_monitor/screens/registro/register_admin.dart';
import 'package:health_guard_monitor/screens/registro/register_user.dart';
import 'package:provider/provider.dart';
import 'models/health_data.dart';
import 'screens/LOGEO/login.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HealthDataProvider()),
      ],
      child: HealthMonitorApp(),
    ),
  );
}

class HealthMonitorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Monitor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Login(),
      routes: {
        '/login': (context) => Login(), // Pantalla de login
        '/registerAdmin': (context) => RegisterAdmin(),
        '/registerUser': (context) => RegisterUser(),
      },
    );
  }
}