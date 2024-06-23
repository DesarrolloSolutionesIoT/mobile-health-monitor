import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/health_data.dart';
import 'screens/INICIAL/login.dart';


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

    );
  }
}