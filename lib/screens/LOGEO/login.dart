import 'package:flutter/material.dart';
import '../home/home_doctor_nurse.dart';
import '../home/home_family.dart';
import '../registro/select_user_type.dart';
import 'forget_password.dart';
import '../../models/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<Login> {
  bool _obscureText = true;
  late String _email = '';
  late String _password = '';
  bool _isLoading = false;

  final List<User> users = [
    User(name: 'Admin 1', email: 'admin1@example.com', password: 'admin123', type: 'admin', role: ''),
    User(name: 'Doctor 1', email: 'doctor1@example.com', password: 'doctor123', type: 'user', role: 'doctor'),
    User(name: 'Nurse 1', email: 'nurse1@example.com', password: 'nurse123', type: 'user', role: 'nurse'),
    User(name: 'Family 1', email: 'family1@example.com', password: 'family123', type: 'user', role: 'family'),
  ];

  void _login() {
    if (_email.isEmpty || _password.isEmpty) {
      _showDialog('Complete los datos solicitados');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    User? user = users.firstWhere(
          (user) => user.email == _email && user.password == _password,
      orElse: () => User(name: '', email: '', password: '', type: '', role: ''),
    );

    setState(() {
      _isLoading = false;
    });

    if (user.name.isNotEmpty) {
      if (user.role == 'doctor' || user.role == 'nurse') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeDoctorNurse(currentUser: user),
          ),
        );
      } else if (user.role == 'family') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeFamily(currentUser: user),
          ),
        );
      }
    } else {
      _showDialog('Los datos ingresados son erróneos');
    }
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
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
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/inicio.jpeg'), // Asegúrate de tener esta imagen en la carpeta assets/images
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Formulario de inicio de sesión
          Center(
            child: Container(
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Te damos la bienvenida a HealthCare",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          hintText: "Correo electrónico",
                          labelText: "Correo electrónico",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (valor) {
                          _email = valor;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: "Contraseña",
                          labelText: "Contraseña",
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureText ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscureText = !_obscureText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        onChanged: (valor) {
                          _password = valor;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextButton(
                        child: const Text(
                          "¿Has olvidado tu contraseña?",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgetPassword(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(
                            color: Colors.lime,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 70.0),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "¿Aún no tienes una cuenta?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10.0),
                      ElevatedButton(
                        child: const Text(
                          "Regístrate ",
                          style: TextStyle(
                            color: Colors.lime,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SelectUserType()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo.shade800,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 80.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
