import 'package:flutter/material.dart';
import 'package:health_guard_monitor/screens/LOGEO/register_admin.dart';
import 'package:health_guard_monitor/screens/LOGEO/register_user.dart';

class SelectUserType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterAdmin()),
                );
              },
              child: Column(
                children: [
                  Image.asset('assets/admin.jpg', width: 100, height: 100),
                  SizedBox(height: 10),
                  Text('Admin'),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterUser()),
                );
              },
              child: Column(
                children: [
                  Image.asset('assets/user.jpg', width: 100, height: 100),
                  SizedBox(height: 10),
                  Text('User'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
