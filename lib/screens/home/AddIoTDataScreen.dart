import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Para formatear y seleccionar fechas

import '../../models/patient.dart';

class AddIoTDataScreen extends StatefulWidget {
  @override
  _AddIoTDataScreenState createState() => _AddIoTDataScreenState();
}

class _AddIoTDataScreenState extends State<AddIoTDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _serialNumber;
  late int _patientId;
  String _fechaDeEntrada = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String _ultimaFecha = DateFormat('yyyy-MM-dd').format(DateTime.now());
  int _temperature = 37; // Valor estándar
  int _oximeter = 98; // Valor estándar
  int _heartRate = 75; // Valor estándar
  int _respiratoryRate = 16; // Valor estándar

  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    fetchPatients();
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
      print('Error: $e');
    }
  }

  Future<void> saveIoTData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> newIoTData = {
        'serialNumber': _serialNumber,
        'patientId': _patientId,
        'fechaDeEntrada': _fechaDeEntrada,
        'temperature': _temperature,
        'oximeter': _oximeter,
        'heartRate': _heartRate,
        'respiratoryRate': _respiratoryRate,
        'ultimaFecha': _ultimaFecha,
      };

      final response = await http.post(
        Uri.parse('http://localhost:8080/api/iotdata'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newIoTData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        Navigator.pop(context, 'added'); // Volver a la vista de monitoreo y refrescar la lista
      } else {
        print('Failed to add IoT data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to add IoT data');
      }
    }
  }

  Future<void> _selectDate(BuildContext context, String field) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        if (field == 'fechaDeEntrada') {
          _fechaDeEntrada = DateFormat('yyyy-MM-dd').format(picked);
        } else if (field == 'ultimaFecha') {
          _ultimaFecha = DateFormat('yyyy-MM-dd').format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Monitoreo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el número de serie';
                  }
                  return null;
                },
                onSaved: (value) => _serialNumber = value!,
              ),
              DropdownButtonFormField<int>(
                decoration: InputDecoration(labelText: 'Paciente'),
                items: patients.map((Patient patient) {
                  return DropdownMenuItem<int>(
                    value: patient.id,
                    child: Text('${patient.firstName} ${patient.lastName} (DNI: ${patient.dni})'),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _patientId = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Por favor seleccione un paciente';
                  }
                  return null;
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Fecha de Entrada',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, 'fechaDeEntrada'),
                  ),
                ),
                controller: TextEditingController(text: _fechaDeEntrada),
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Última Fecha',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, 'ultimaFecha'),
                  ),
                ),
                controller: TextEditingController(text: _ultimaFecha),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveIoTData,
                child: Text('Guardar Monitoreo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
