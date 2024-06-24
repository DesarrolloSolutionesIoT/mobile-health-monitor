import 'package:flutter/material.dart';

class RegisterAdmin extends StatefulWidget {
  @override
  _RegisterAdminState createState() => _RegisterAdminState();
}

class _RegisterAdminState extends State<RegisterAdmin> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _surname;
  late String _email;
  late String _password;
  late String _companyCode;

  void _register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes agregar la lógica para registrar al administrador.
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
        title: Text('Register Admin'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Company Code'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the company code';
                  }
                  return null;
                },
                onSaved: (value) => _companyCode = value!,
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
