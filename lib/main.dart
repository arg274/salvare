import 'package:flutter/material.dart';
import 'package:salvare/view/navbar.dart';

void main() {
  runApp(const Salvare());
}

class Salvare extends StatelessWidget {
  const Salvare({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salvare',
      theme:
          ThemeData(primarySwatch: Colors.teal, brightness: Brightness.light),
      darkTheme:
          ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const Dashboard(title: 'Dashboard'),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: SalvareNavbar(),
          ),
        ));
  }
}
