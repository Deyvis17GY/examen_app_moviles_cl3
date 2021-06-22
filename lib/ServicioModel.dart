import 'dart:convert';

class ServicioModel {
  int CodigoServicio;
  String NombreCliente;
  String NumeroOrdenServicio;
  String FechaProgramada;
  String Linea;
  String Estado;
  String Observaciones;

  ServicioModel({
    this.CodigoServicio,
    this.NombreCliente,
    this.NumeroOrdenServicio,
    this.FechaProgramada,
    this.Linea,
    this.Estado,
    this.Observaciones,
  });

  void limpiarPropiedades() {
    this.CodigoServicio = 0;
    this.NombreCliente = "";
    this.NumeroOrdenServicio = "";
    this.FechaProgramada = "";
    this.Linea = "";
    this.Estado = "";
    this.Observaciones = "";
  }

  String toModelString() {
    return '{"CodigoServicio":"${this.CodigoServicio.toString()}",' +
        '"NombreCliente":"${this.NombreCliente.toString()}",' +
        '"NumeroOrdenServicio":"${this.NumeroOrdenServicio.toString()}",' +
        '"FechaProgramada":"${this.FechaProgramada.toString()}",' +
        '"Linea":"${this.Linea.toString()}",' +
        '"Estado":"${this.Estado.toString()}",' +
        '"Observaciones":"${this.Observaciones.toString()}"' +
        '}';
  }

  factory ServicioModel.fromJson(Map<String, dynamic> json) {
    return ServicioModel(
        CodigoServicio: json["CodigoServicio"],
        NombreCliente: json["NombreCliente"],
        NumeroOrdenServicio: json["NumeroOrdenServicio"],
        FechaProgramada: json["FechaProgramada"],
        Linea: json["Linea"],
        Estado: json["Estado"],
        Observaciones: json["Observaciones"]);
  }
  Map<String, dynamic> toJson() => {
        "CodigoServicio": CodigoServicio,
        "NombreCliente": NombreCliente,
        "NumeroOrdenServicio": NumeroOrdenServicio,
        "FechaProgramada": FechaProgramada,
        "Linea": Linea,
        "Estado": Estado,
        "Observaciones": Observaciones,
      };
  String toParameter() {
    return "CodigoServicio=${this.CodigoServicio.toString()}" +
        "&NombreCliente=${this.NombreCliente.toString()}" +
        "&NumeroOrdenServicio=${this.NumeroOrdenServicio.toString()}" +
        "&FechaProgramada=${this.FechaProgramada.toString()}" +
        "&Linea=${this.Linea.toString()}" +
        "&Estado=${this.Estado.toString()}" +
        "&Observaciones=${this.Observaciones.toString()}";
  }
}
