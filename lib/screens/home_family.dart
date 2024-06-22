import 'package:flutter/material.dart';
import '../models/user.dart';
import 'alertas.dart';
import 'monitoreo.dart';
import 'perfil.dart';


class HomeFamily extends StatelessWidget {
  final User currentUser;
  const HomeFamily({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HealthCare'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monitoreo de Paciente'),
              Tab(text: 'Alertas'),
              Tab(text: 'Perfil'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Monitoring(),
            Alerts(),
            Profile(),
          ],
        ),
      ),
    );
  }
}