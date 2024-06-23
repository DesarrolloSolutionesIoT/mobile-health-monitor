import 'package:flutter/material.dart';
import 'package:health_guard_monitor/screens/LOGEO/perfil.dart';
import '../../models/user.dart';
import '../../models/patient.dart';
import '../../widgets/patient_card.dart';
import '../../widgets/drawer.dart';
import '../alertas.dart';

class HomeDoctorNurse extends StatefulWidget {
  final User currentUser;

  const HomeDoctorNurse({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomeDoctorNurseState createState() => _HomeDoctorNurseState();
}

class _HomeDoctorNurseState extends State<HomeDoctorNurse> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Patient> patients = [
    Patient(
      code: 'P1223',
      firstName: 'John',
      lastName: 'Doe',
      age: 45,
      dni: '76234567',
      contactNumber: '989123445',
      admissionDate: DateTime.now(),
      currentState: 'Crítico',
    ),

  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Ajuste en el número de pestañas
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HealthCare'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Lista de Pacientes'),
              Tab(text: 'Alertas'),
            ],
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: AppDrawer(), // Usar endDrawer en lugar de drawer
        body: TabBarView(
          controller: _tabController,
          children: [
            ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return PatientCard(patient: patients[index]);
              },
            ),
            const Alerts(),
          ],
        ),
      ),
    );
  }
}
