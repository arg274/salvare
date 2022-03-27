import 'package:flutter/material.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(),
        ));
  }
}
