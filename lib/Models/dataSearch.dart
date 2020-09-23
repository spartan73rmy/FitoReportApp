class DataSearch {
  int idReport;
  String productor;
  String lugar;
  String predio;
  String ubicacion;
  DateTime fecha;

  DataSearch(
      {this.idReport,
      this.productor,
      this.lugar,
      this.predio,
      this.ubicacion,
      this.fecha});

  factory DataSearch.fromJSON(Map<String, dynamic> item) {
    return DataSearch(
        idReport: item['idReport'],
        productor: item["productor"],
        lugar: item['lugar'],
        predio: item['predio'],
        ubicacion: item["ubicacion"],
        fecha: DateTime.parse(item['fecha']));
  }
}

class DataSearchList {
  List<DataSearch> busqueda;

  DataSearchList({this.busqueda});

  factory DataSearchList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['busqueda'] as List;
    List<DataSearch> busqueda =
        list.map((i) => DataSearch.fromJSON(i)).toList();

    return DataSearchList(busqueda: busqueda);
  }
}
