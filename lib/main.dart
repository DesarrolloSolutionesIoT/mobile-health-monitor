import 'package:flutter/material.dart';
import 'home_page/home_page.dart';

void main() {
  runApp(HealthMonitorApp());
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
      home: HealthMonitorHomePage(),
    );
  }
}
