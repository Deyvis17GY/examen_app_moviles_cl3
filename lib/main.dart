import 'package:flutter/material.dart';
import './ListadoClientes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud Clientes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListadoClientes("Consulta de Clientes"),
    );
  }
}
