import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'AddIoTDataScreen.dart';
import 'EditIoTDataScreen.dart';
import 'LiveMonitoringScreen.dart'; // Importar la nueva pantalla
import '../../models/patient.dart';

class IoTDataScreen extends StatefulWidget {
  @override
  _IoTDataScreenState createState() => _IoTDataScreenState();
}

class _IoTDataScreenState extends State<IoTDataScreen> {
  List<dynamic> iotData = [];
  List<Patient> patients = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchPatients();
    fetchIoTData();
  }

  Future<void> fetchPatients() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/patients'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          patients = data.map((patient) => Patient.fromJson(patient)).toList();
        });
      } else {
        throw Exception('Failed to load patients');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> fetchIoTData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/api/iotdata'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          iotData = data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load IoT data';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> deleteIoTData(int id) async {
    try {
      final response = await http.delete(Uri.parse('http://localhost:8080/api/iotdata/$id'));
      if (response.statusCode == 204) {
        setState(() {
          iotData.removeWhere((data) => data['id'] == id);
        });
      } else {
        throw Exception('Failed to delete IoT data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Patient? findPatientById(int patientId) {
    try {
      return patients.firstWhere((patient) => patient.id == patientId);
    } catch (e) {
      return null;
    }
  }

  void refreshIoTData() {
    fetchIoTData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Monitoreo'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(child: Text(_errorMessage))
          : ListView.builder(
        itemCount: iotData.length,
        itemBuilder: (context, index) {
          var data = iotData[index];
          Patient? patient = findPatientById(data['patientId']);
          return Card(
            child: ListTile(
              title: Text('Serial Number: ${data['serialNumber']}'),
              subtitle: Text(
                patient != null
                    ? 'Paciente: ${patient.firstName} ${patient.lastName} (DNI: ${patient.dni})\n'
                    'Edad: ${patient.age}\nGénero: ${patient.gender}\n'
                    'Fecha de Entrada: ${data['fechaDeEntrada']}\n'
                    'Temperatura: ${data['temperature']}\n'
                    'Oxímetro: ${data['oximeter']}\n'
                    'Ritmo Cardiaco: ${data['heartRate']}\n'
                    'Ritmo Respiratorio: ${data['respiratoryRate']}\n'
                    'Última Fecha: ${data['ultimaFecha']}'
                    : 'Paciente no encontrado',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.visibility),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveMonitoringScreen(iotData: data),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditIoTDataScreen(iotData: data),
                        ),
                      );
                      if (result == 'updated') {
                        refreshIoTData(); // Refresca la lista de monitoreo después de actualizar uno
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteIoTData(data['id']);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddIoTDataScreen()),
          );
          if (result == 'added') {
            refreshIoTData(); // Refresca la lista de monitoreo después de agregar uno nuevo
          }
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
