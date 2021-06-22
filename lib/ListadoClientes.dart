import 'package:flutter/material.dart';
import './ServicioModel.dart';
import './ListadoClientes.dart';
import 'package:http/http.dart' as http;

import './NuevoCliente.dart';
import './ClienteObject.dart';
import 'dart:async' show Future;
import 'dart:convert';
import 'package:json_table/json_table.dart';

class ListadoClientes extends StatefulWidget {
  List<ClienteObject> oListClientes = [];
  int codigoClienteSeleccionado = 0;
  String urlGeneral = "http://wscibertec2021.somee.com";
  String urlController = "/Servicio/";
  String urlRegistraModifica =
      "/RegistraModifica?Accion=N&CodigoServicio=0&NombreCliente=UNMA2Q%20S.A.&NumeroOrdenServicio=ORD-2016-001&Fechaprogramada=20161104&Linea=KING%20OCEAN%20SERVICES&Estado=Aprobado&Observaciones=Ninguno";
  String urlListado = "Listar?CodigoServicio=";
  String jSonClientes =
      '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 2,"DescripcionError": "","MensajeError":"" }]';
  String titulo;
  ListadoClientes(this.titulo);

  @override
  _ListadoClientes createState() => _ListadoClientes();
}

class _ListadoClientes extends State<ListadoClientes> {
  final _tfNombreCliente = TextEditingController();
  final _tfCodigoServicio = TextEditingController();
  bool toggle = true;

  void initState() {
    super.initState();
    // widget.oServicioModel.limpiarPropiedades();
    // widget.jSonServicio = '[${widget.oServicioModel.toModelString()}]';
  }

  void _nuevoRegistro() async {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return new NuevoCliente("Nuevo Registro de Cliente", 0);
    }));
  }

  void _verRegistro() async {
    Navigator.of(context)
        .push(new MaterialPageRoute<Null>(builder: (BuildContext pContexto) {
      return new NuevoCliente("Modificar Cliente", 0);
    }));
  }

  Future<String> _consultarClientes() async {
    print("Iniciando");
    String urlListaClientes = "";
    urlListaClientes = widget.urlGeneral +
        widget.urlController +
        widget.urlListado +
        _tfCodigoServicio.text.toString() +
        '&NombreCliente=' +
        _tfNombreCliente.text.toString();

    var respuesta = await http.get(Uri.parse(urlListaClientes));
    print(respuesta.body);

    var data = respuesta.body;
    var oListaClientetmp = List<ClienteObject>.from(
        json.decode(data).map((x) => ClienteObject.fromJson(x)));

    for (ClienteObject oClienteObject in oListaClientetmp) {
      print("Nombres: " + oClienteObject.NombreCliente);
    }

    setState(() {
      widget.oListClientes = oListaClientetmp;
      widget.jSonClientes = data;
    });

    return "procesado";
  }

  @override
  Widget build(BuildContext context) {
    var json = jsonDecode(widget.jSonClientes);
    print("ejecutado");
    return Scaffold(
      appBar: AppBar(
        title: Text("Consulta de clientes"),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.search), onPressed: _consultarRegistros),
        //   IconButton(
        //       icon: Icon(Icons.assignment_outlined),
        //       onPressed: _nuevoRegistro),
        // ],
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Container(
              child: toggle
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextField(
                            controller: _tfNombreCliente,
                            decoration: InputDecoration(
                                hintText: "Ingrese Nombre Cliente",
                                labelText: "Nombre Cliente")),
                        TextField(
                            controller: _tfCodigoServicio,
                            decoration: InputDecoration(
                                hintText: "Ingrese Codigo Servicio",
                                labelText: "Codigo Servicio")),
                        Text("Se econtraron " +
                            widget.oListClientes.length.toString() +
                            " Clientes"),
                        new Table(children: [
                          TableRow(children: [
                            Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: RaisedButton(
                                color: Colors.greenAccent,
                                child: Text(
                                  "Consultar",
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: "rbold"),
                                ),
                                onPressed: _consultarClientes,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(right: 10.0),
                              child: RaisedButton(
                                color: Colors.greenAccent,
                                child: Text(
                                  "Nuevo",
                                  style: TextStyle(
                                      fontSize: 10, fontFamily: "rbold"),
                                ),
                                onPressed: _nuevoRegistro,
                              ),
                            )
                          ])
                        ]),
                        JsonTable(
                          json,
                          showColumnToggle: true,
                          allowRowHighlight: true,
                          rowHighlightColor:
                              Colors.yellow[500].withOpacity(0.7),
                          paginationRowCount: 10,
                          onRowSelect: (index, map) {
                            widget.codigoClienteSeleccionado =
                                int.parse(map["CodigoServicio"].toString());
                            print("demo" + map["CodigoServicio"].toString());
                            _verRegistro();
                            print(index);
                            print(map);
                          },
                        ),
                        SizedBox(
                          height: 80.0,
                        ),
                        Text("Para consultar debe ingresar nombre cliente",
                            style: TextStyle(fontSize: 10, fontFamily: "rbold"))
                        // TextField(
                        //     controller: _tfNombreCliente,
                        //     decoration: InputDecoration(
                        //       hintText: "Ingrese NombreCliente ",
                        //       labelText: "NombreCliente",
                        //     )),
                        // TextField(
                        //     controller: _tfNumeroOrdenServicio,
                        //     decoration: InputDecoration(
                        //       hintText: "Ingrese NumeroOrdenServicio ",
                        //       labelText: "NumeroOrdenServicio",
                        //     )),
                        // Text(
                        //   "Se encontraron " +
                        //       widget.oListaServicio.length.toString() +
                        //       " Servicios",
                        //   style: TextStyle(fontSize: 9),
                        // ),
/*              new Table(children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      color: Colors.greenAccent,
                      child: Text(
                        "Consultar",
                        style: TextStyle(fontSize: 10, fontFamily: "rbold"),
                      ),
                      onPressed: _consultarRegistros,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 10.0),
                    child: RaisedButton(
                      color: Colors.greenAccent,
                      child: Text(
                        "Nuevo",
                        style: TextStyle(fontSize: 10, fontFamily: "rbold"),
                      ),
                      onPressed: _nuevoRegistro,
                    ),
                  ),
                ])
              ]),*/
                        // JsonTable(
                        //   json,
                        //   columns: [
                        //     JsonTableColumn("CodigoServicio", label: "CodigoServicio"),
                        //     JsonTableColumn("NombreCliente", label: "NombreCliente"),
                        //     JsonTableColumn("NumeroOrdenServicio",
                        //         label: "NumeroOrdenServicio"),
                        //     JsonTableColumn("FechaProgramada", label: "FechaProgramada"),
                        //     JsonTableColumn("Linea", label: "Linea"),
                        //     JsonTableColumn("Estado", label: "Estado"),
                        //     JsonTableColumn("Observaciones", label: "Observaciones"),
                        //   ],
                        //   showColumnToggle: false,
                        //   allowRowHighlight: true,
                        //   rowHighlightColor: Colors.yellow[500].withOpacity(0.7),
                        //   paginationRowCount: 10,
                        //   onRowSelect: (index, map) {
                        //     _verRegistro(int.parse(map["CodigoServicio"].toString()));
                        //   },
                        // ),
                      ],
                    )
                  : Center(
                      child: Text(
                        getPrettyJSONString(widget.jSonClientes),
                        style: TextStyle(fontSize: 10),
                      ),
                    ))),
    );
  }

  String getPrettyJSONString(jsonObject) {
    JsonEncoder encoder = new JsonEncoder.withIndent('  ');
    String jsonString = encoder.convert(json.decode(jsonObject));
    return jsonString;
  }
}
