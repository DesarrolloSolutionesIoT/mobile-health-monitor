import 'package:flutter/material.dart';
import '../../models/patient.dart';

class PatientMonitoring extends StatelessWidget {
  final Patient patient;

  const PatientMonitoring({Key? key, required this.patient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoreo de ${patient.firstName} ${patient.lastName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            // Aquí puedes añadir más información de monitoreo específica del paciente
          ],
        ),
      ),
    );
  }
}
