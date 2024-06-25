import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

import '../../models/patient.dart';

class EditIoTDataScreen extends StatefulWidget {
  final Map<String, dynamic> iotData;

  EditIoTDataScreen({required this.iotData});

  @override
  _EditIoTDataScreenState createState() => _EditIoTDataScreenState();
}

class _EditIoTDataScreenState extends State<EditIoTDataScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _serialNumber;
  late int _patientId;
  late String _fechaDeEntrada;
  late int _temperature;
  late int _oximeter;
  late int _heartRate;
  late int _respiratoryRate;
  late String _ultimaFecha;

  List<Patient> patients = [];

  @override
  void initState() {
    super.initState();
    _serialNumber = widget.iotData['serialNumber'];
    _patientId = widget.iotData['patientId'];
    _fechaDeEntrada = widget.iotData['fechaDeEntrada'];
    _temperature = widget.iotData['temperature'];
    _oximeter = widget.iotData['oximeter'];
    _heartRate = widget.iotData['heartRate'];
    _respiratoryRate = widget.iotData['respiratoryRate'];
    _ultimaFecha = widget.iotData['ultimaFecha'];
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

  Future<void> updateIoTData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Map<String, dynamic> updatedIoTData = {
        'serialNumber': _serialNumber,
        'patientId': _patientId,
        'fechaDeEntrada': _fechaDeEntrada,
        'temperature': _temperature,
        'oximeter': _oximeter,
        'heartRate': _heartRate,
        'respiratoryRate': _respiratoryRate,
        'ultimaFecha': _ultimaFecha,
      };

      final response = await http.put(
        Uri.parse('http://localhost:8080/api/iotdata/${widget.iotData['id']}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(updatedIoTData),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Navigator.pop(context, 'updated'); // Volver a la vista de monitoreo y refrescar la lista
      } else {
        print('Failed to update IoT data: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to update IoT data');
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
    if (picked != null) {
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
        title: Text('Editar Monitoreo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: _serialNumber,
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
                value: _patientId,
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
              TextFormField(
                initialValue: _temperature.toString(),
                decoration: InputDecoration(labelText: 'Temperatura'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la temperatura';
                  }
                  return null;
                },
                onSaved: (value) => _temperature = int.parse(value!),
              ),
              TextFormField(
                initialValue: _oximeter.toString(),
                decoration: InputDecoration(labelText: 'Oxímetro'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el oxímetro';
                  }
                  return null;
                },
                onSaved: (value) => _oximeter = int.parse(value!),
              ),
              TextFormField(
                initialValue: _heartRate.toString(),
                decoration: InputDecoration(labelText: 'Ritmo Cardiaco'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el ritmo cardiaco';
                  }
                  return null;
                },
                onSaved: (value) => _heartRate = int.parse(value!),
              ),
              TextFormField(
                initialValue: _respiratoryRate.toString(),
                decoration: InputDecoration(labelText: 'Ritmo Respiratorio'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el ritmo respiratorio';
                  }
                  return null;
                },
                onSaved: (value) => _respiratoryRate = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateIoTData,
                child: Text('Actualizar Monitoreo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
