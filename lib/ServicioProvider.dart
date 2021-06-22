import 'package:http/http.dart' as http;
import './ServicioModel.dart';
import 'dart:convert';
import './util.dart' as util;
import 'dart:async' show Future;

class ServicioProvider {
  String urlRegistraModifica = "RegistraModifica";
  String urlListado = "Listar";
  String urlListarKey = "Listarkey";
  String urlEliminar = "Eliminar";
  String jsonResultado = "";

  Future<List<ServicioModel>> listar(ServicioModel pServicioModel) async {
    final urlListadoServicio = '${util.urlBase}/${util.controlerServicio}/' +
        '${this.urlListado}?${pServicioModel.toParameter()}';
    print(urlListadoServicio);
    var respuesta = await http.get(Uri.parse(urlListadoServicio));
    var data = respuesta.body;
    jsonResultado = "[${ServicioModel().toModelString()}]";
    print(jsonResultado);
    List<ServicioModel> oListaServicio = List<ServicioModel>();
    if (data != '') {
      oListaServicio = List<ServicioModel>.from(
          json.decode(data).map((x) => ServicioModel.fromJson(x)));
      jsonResultado = data;
    }
    return oListaServicio;
  }

  Future<ServicioModel> listarKey(int pCodigoServicio) async {
    ServicioModel oServicioModel = ServicioModel();
    oServicioModel.limpiarPropiedades();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlListarKey +
        "?pCodigoServicio=${pCodigoServicio.toString()}";
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      oServicioModel = ServicioModel.fromJson(json.decode(data));
    }
    return oServicioModel;
  }

  Future<ServicioModel> registraModifica(
      ServicioModel pServicioModel, String pTipoTransaccion) async {
    ServicioModel oServicioModel = ServicioModel();
    oServicioModel.limpiarPropiedades();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        '${urlRegistraModifica}?' +
        pServicioModel.toParameter() +
        "&Accion=" +
        pTipoTransaccion;
    print(urlquery);
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      pServicioModel = ServicioModel.fromJson(json.decode(data));
    }
    return pServicioModel;
  }

  Future<ServicioModel> eliminar(int pCodigoServicio) async {
    ServicioModel oServicioModel = ServicioModel();
    oServicioModel.limpiarPropiedades();
    final urlquery = '${util.urlBase}/${util.controlerServicio}/' +
        urlEliminar +
        '?' +
        "&pCodigoServicio=" +
        pCodigoServicio.toString();
    final response = await http.get(Uri.parse(urlquery));
    final data = response.body;
    jsonResultado = data;
    if (data != '') {
      oServicioModel = ServicioModel.fromJson(json.decode(data));
    }
    return oServicioModel;
  }
}
