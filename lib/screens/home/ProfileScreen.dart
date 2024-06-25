import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/User.dart';

class ProfileScreen extends StatelessWidget {
  String getAccountType(String typeId) {
    switch (typeId) {
      case '1':
        return 'ADMIN';
      case '2':
        return 'USER';
      default:
        return 'UNKNOWN';
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = UserMemory.getUser();
    return user == null
        ? Center(child: Text('No se encontraron datos del usuario'))
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/profile_placeholder.png'), // Añade una imagen de placeholder en assets
          ),
          SizedBox(height: 16),
          Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            user.email,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Tipo de cuenta: ${getAccountType(user.typeId)}',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
