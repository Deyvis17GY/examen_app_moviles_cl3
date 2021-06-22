import 'package:flutter/material.dart';
import './ServicioModel.dart';
import './ServicioProvider.dart';
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
  String urlListado = "Listar?NombreCliente=";
  String jSonClientes =
      '[{"CodigoServicio": 0,"NombreCliente": "","NumeroOrdenServicio": "","FechaProgramada": "","Linea": "","Estado": "","Observaciones": "","Eliminado": false,"CodigoError": 2,"DescripcionError": "","MensajeError":"" }]';
  String titulo;

  // final _provider = new ServicioProvider();
  // List<ServicioModel> oListaServicio = [];
  // int codigoServicioSeleccionado = 0;
  // ServicioModel oServicioModel = ServicioModel();
  // String jSonServicio = "";
  ListadoClientes(this.titulo);

  @override
  _ListadoClientes createState() => _ListadoClientes();
}

class _ListadoClientes extends State<ListadoClientes> {
  final _tfNombreCliente = TextEditingController();
  bool toggle = true;
  // final _tfCodigoServicio = TextEditingController();
  // final _tfNombreCliente = TextEditingController();
  // final _tfNumeroOrdenServicio = TextEditingController();
  // final _tfFechaProgramada = TextEditingController();
  // final _tfLinea = TextEditingController();
  // final _tfEstado = TextEditingController();
  // final _tfObservaciones = TextEditingController();

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
    // ServicioModel pServicioModel = new ServicioModel();
    // pServicioModel.limpiarPropiedades();
    // //pServicioModel.CodigoServicio = _tfCodigoServicio.text;
    // pServicioModel.NombreCliente = _tfNombreCliente.text;
    // pServicioModel.NumeroOrdenServicio = _tfNumeroOrdenServicio.text;
    // pServicioModel.FechaProgramada = _tfFechaProgramada.text;
    // pServicioModel.Linea = _tfLinea.text;
    // pServicioModel.Estado = _tfEstado.text;
    // pServicioModel.Observaciones = _tfObservaciones.text;
    // var oListaServicioTmp = await widget._provider.listar(pServicioModel);
    // print(oListaServicioTmp);
    // setState(() {
    //   widget.oListaServicio = oListaServicioTmp;
    //   widget.jSonServicio = widget._provider.jsonResultado;
    //   if (widget.oListaServicio.length == 0) {
    //     widget.jSonServicio = '[${widget.oServicioModel.toModelString()}]';
    //   }
    // });
    //return "Procesado";
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
