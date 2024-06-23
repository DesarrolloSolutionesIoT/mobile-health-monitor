import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../widgets/drawer.dart';
import '../alertas.dart';
import '../../widgets/lista_familiares.dart';
import '../LOGEO/perfil.dart';
import '../../widgets/main_layout.dart'; // Asegúrate de importar el archivo donde definiste MainLayout

class HomeFamily extends StatefulWidget {
  final User currentUser;
  const HomeFamily({Key? key, required this.currentUser}) : super(key: key);

  @override
  _HomeFamilyState createState() => _HomeFamilyState();
}

class _HomeFamilyState extends State<HomeFamily> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBar: AppBar(
        title: const Text('HealthCare'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monitoreo de Familiares'),
            Tab(text: 'Alertas'),
          ],
        ),
      ),
      child: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            FamilyList(),
            Alerts(),
          ],
        ),
      ),
    );
  }
}
