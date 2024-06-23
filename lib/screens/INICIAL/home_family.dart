import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../widgets/drawer.dart';
import '../alertas.dart';


import 'lista_familiares.dart';
import 'perfil.dart';

class HomeFamily extends StatelessWidget {
  final User currentUser;
  const HomeFamily({Key? key, required this.currentUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HealthCare'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Monitoreo de Familiares'),
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
        body: const TabBarView(
          children: [
            FamilyList(),
            Alerts(),
          ],
        ),
      ),
    );
  }
}
