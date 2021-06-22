import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:intl/date_symbol_data_custom.dart';

String urlBase = 'http://wscibertec2021.somee.com';
String controlerCliente = "Cliente";
String controlerProveedor = "Proveedor";
String controlerServicio = "Servicios";
String controlerDocente = "Docente";

bool isNumeric(String s) {
  if (s.isEmpty) return false;
  final n = num.tryParse(s);
  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String titulo, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

void mostrarMensajeError(BuildContext context) {
  mostrarAlerta(
      context, "Error", "Lo sentimo, ha ocurrido un error en la aplicación.");
}
/*
String dateTimeToString(DateTime dt, String format) {
  DateFormat dateFormat = DateFormat(format);
  String s = dateFormat.format(dt);
  return s;
}
*/
