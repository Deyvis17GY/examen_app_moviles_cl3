import 'package:flutter/material.dart';
import './ClienteObject.dart';
import 'package:http/http.dart' as http;
import 'dart:async' show Future;
import 'dart:convert';

class NuevoCliente extends StatefulWidget {
  String titulo;
  ClienteObject oCliente = new ClienteObject();
  int codigoClienteSeleccioando = 0;

  String urlGeneral = "http://wscibertec2021.somee.com";
  String urlController = "/Servicio/";
  String urlRegistraModifica = "RegistraModifica?";
  String mensaje = "";
  bool validacion = false;

  NuevoCliente(this.titulo, this.codigoClienteSeleccioando);

  @override
  _NuevoCliente createState() => _NuevoCliente();
}

class _NuevoCliente extends State<NuevoCliente> {
  final _tfNombreCliente = TextEditingController();
  final _tfNumeroOrdenServicio = TextEditingController();
  final _tfFechaProgramada = TextEditingController();
  final _tfLinea = TextEditingController();
  final _tfObservaciones = TextEditingController();
  final _tfEstado = TextEditingController();

  void initState() {
    super.initState();
    widget.oCliente.limpiarPropiedades();
    // if (widget.codigoClienteSeleccioando > 0) {
    //   _listarKeyProvider();
    // }
  }

  Future<String> _listarKey() async {
    String urlListaClientes = "";
    urlListaClientes = widget.urlGeneral +
        widget.urlController +
        widget.codigoClienteSeleccioando.toString();

    var respuesta = await http.get(Uri.parse(urlListaClientes));

    setState(() {
      widget.oCliente = ClienteObject.fromJson(json.decode(respuesta.body));
      if (widget.oCliente.CodigoServicio > 0) {
        widget.mensaje = "Estas actualizando los datos";
        _mostrarDatos();
      }
    });

    return "procesado";
  }

  void _mostrarDatos() {
    _tfNombreCliente.text = widget.oCliente.NombreCliente;
    _tfNumeroOrdenServicio.text = widget.oCliente.NumeroOrdenServicio;
    _tfFechaProgramada.text = widget.oCliente.FechaProgramada;
    _tfLinea.text = widget.oCliente.Linea;
    _tfEstado.text = widget.oCliente.Estado;
    _tfObservaciones.text = widget.oCliente.Observaciones;
  }

  // void _cargarEntidad() {
  //   widget.oCliente.NombreCliente = _tfNombreCliente.text;
  //   widget.oCliente.NumeroOrdenServicio = _tfNumeroOrdenServicio.text;
  //   widget.oCliente.FechaProgramada = _tfFechaProgramada.text;
  //   widget.oCliente.Linea = _tfLinea.text;
  //   widget.oCliente.Estado = _tfEstado.text;
  //   widget.oCliente.Observaciones = _tfObservaciones.text;
  // }

  bool _validarRegistro() {
    if (_tfNombreCliente.text.toString() == "" ||
        _tfNumeroOrdenServicio.text.toString() == "") {
      widget.validacion = false;
      setState(() {
        widget.mensaje = "Falta completar los campos obligatorios";
      });
      return false;
    }
    return true;
  }

  void _grabarRegistro() {
    if (_validarRegistro()) {
      _ejecutarServicioGrabadoProvider();
      //_ejecutarServicioGrabado();
    }
  }

  Future<String> _ejecutarServicioGrabadoProvider() async {
    String accion = "N";
    if (widget.oCliente.CodigoServicio > 0) {
      accion = "N";
    }

    String strParametros = "";
    strParametros += "Accion=" + accion;
    strParametros +=
        "&CodigoServicio=" + widget.oCliente.CodigoServicio.toString();
    strParametros += "&NombreCliente=" + _tfNombreCliente.text;
    strParametros += "&NumeroOrdenServicio=" + _tfNumeroOrdenServicio.text;
    strParametros += "&FechaProgramada=" + _tfFechaProgramada.text;
    strParametros += "&Linea=" + _tfLinea.text;
    strParametros += "&Estado=" + _tfEstado.text;
    strParametros += "&Observaciones=" + _tfObservaciones.text;

    String urlRegistroCliente = "";
    urlRegistroCliente = widget.urlGeneral +
        widget.urlController +
        widget.urlRegistraModifica +
        strParametros;

    var respuesta = await http.get(Uri.parse(urlRegistroCliente));
    var data = respuesta.body;

    setState(() {
      widget.oCliente = ClienteObject.fromJson(jsonDecode(data));
      if (widget.oCliente.CodigoServicio > 0) {
        widget.mensaje = "Grabado correctamente";
      }
      print(widget.oCliente);
    });
    return "Procesado";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Registro de clientes "),
          // actions: [
          //   IconButton(icon: Icon(Icons.save), onPressed: _grabarRegistro),
          // ],
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(" Código de cliente:" +
                  widget.oCliente.CodigoServicio.toString()),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Column(
                children: <Widget>[
                  TextField(
                      controller: _tfNombreCliente,
                      decoration: InputDecoration(
                        hintText: "Ingrese nombre cliente ",
                        labelText: "Nombre Cliente",
                        errorText: _tfNombreCliente.text.toString() == ""
                            ? "Falta ingresar la razón Social"
                            : null,
                      )),
                  TextField(
                      controller: _tfNumeroOrdenServicio,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        hintText: "Ingresar el Numero Orden Servicio ",
                        labelText: "Numero Orden Servicio",
                        errorText: _tfNumeroOrdenServicio.text.toString() == ""
                            ? "Falta ingresar el NumeroOrdenServicio"
                            : null,
                      )),
                  TextField(
                      controller: _tfFechaProgramada,
                      decoration: InputDecoration(
                        hintText: "Ingresar la Fecha",
                        labelText: "Fecha",
                      )),
                  TextField(
                      controller: _tfLinea,
                      decoration: InputDecoration(
                        hintText: "Ingresar la Linea",
                        labelText: "Linea",
                      )),
                  TextField(
                      controller: _tfObservaciones,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        hintText: "Ingresar  Observaciones",
                        labelText: "Observaciones",
                      )),
                  TextField(
                      controller: _tfEstado,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: false),
                      decoration: InputDecoration(
                        hintText: "Ingresar el Estado",
                        labelText: "Estado",
                      )),
                  RaisedButton(
                    color: Colors.greenAccent,
                    child: Text(
                      "Grabar",
                      style: TextStyle(fontSize: 18, fontFamily: "rbold"),
                    ),
                    onPressed: _grabarRegistro,
                  ),
                  Text("Mensaje:" + widget.mensaje),
                ],
              ),
            )
          ],
        ));
  }
}
