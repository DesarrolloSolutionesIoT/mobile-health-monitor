import 'package:flutter/material.dart';

class RegisterUser extends StatefulWidget {
  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _surname;
  late String _email;
  late String _password;
  String _role = 'doctor'; // Inicializar con un valor predeterminado
  late String _additionalCode;

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes agregar la lógica para registrar al usuario.
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Registro Exitoso'),
          content: Text('Su registro ha sido exitoso.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login'); // Redirigir al login
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Revise sus datos, algún dato es incorrecto.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Surname'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your surname';
                  }
                  return null;
                },
                onSaved: (value) => _surname = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Role'),
                value: _role,
                items: ['doctor', 'nurse', 'family']
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _role = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a role';
                  }
                  return null;
                },
              ),
              if (_role == 'doctor')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Hospital Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the hospital code';
                    }
                    return null;
                  },
                  onSaved: (value) => _additionalCode = value!,
                ),
              if (_role == 'nurse')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nurse Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the nurse code';
                    }
                    return null;
                  },
                  onSaved: (value) => _additionalCode = value!,
                ),
              if (_role == 'family')
                TextFormField(
                  decoration: InputDecoration(labelText: 'Patient Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the patient code';
                    }
                    return null;
                  },
                  onSaved: (value) => _additionalCode = value!,
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
