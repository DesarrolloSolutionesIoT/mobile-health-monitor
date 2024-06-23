import 'package:flutter/material.dart';
import 'package:health_guard_monitor/main.dart';
import 'package:health_guard_monitor/widgets/health_monitor.dart';
import '../models/patient.dart';

import '../screens/monitoreo.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;

  const PatientCard({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Código de Paciente: ${patient.code}"),
            Text("Nombre: ${patient.firstName}"),
            Text("Apellido: ${patient.lastName}"),
            Text("Edad: ${patient.age}"),
            Text("DNI: ${patient.dni}"),
            Text("Número de Contacto de Familiar: ${patient.contactNumber}"),
            Text("Fecha de Ingreso a UCI: ${patient.admissionDate.toLocal()}".split(' ')[0]),
            Text("Estado Actual: ${patient.currentState}"),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HealthMonitorHomePage(),
                  ),
                );
              },
              child: const Text("Monitoreo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
