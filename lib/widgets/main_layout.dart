import 'package:flutter/material.dart';
import '../../widgets/drawer.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;

  const MainLayout({required this.child, this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      endDrawer: AppDrawer(),
      body: SafeArea(
        child: child,
      ),
    );
  }
}
