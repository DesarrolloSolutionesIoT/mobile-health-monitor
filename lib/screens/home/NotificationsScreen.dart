import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  // Lista de ejemplo de notificaciones
  final List<Notification> notifications = [
    Notification(patientName: "Juan Perez", age: 30, dni: "12345678", message: "Chequeo anual programado"),
    Notification(patientName: "Maria Gomez", age: 25, dni: "87654321", message: "Vacuna pendiente"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            child: ListTile(
              title: Text('${notification.patientName}, ${notification.age} años (DNI: ${notification.dni})'),
              subtitle: Text(notification.message),
            ),
          );
        },
      ),
    );
  }
}

class Notification {
  final String patientName;
  final int age;
  final String dni;
  final String message;

  Notification({
    required this.patientName,
    required this.age,
    required this.dni,
    required this.message,
  });
}
