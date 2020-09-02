class Plaga {
  int id;
  String nombre;

  Plaga({this.id, this.nombre});

  factory Plaga.fromJSON(Map<String, dynamic> item) {
    return Plaga(id: item['id'], nombre: item['nombre']);
  }
}

class PlagaList {
  List<Plaga> plagas;

  PlagaList({this.plagas});

  factory PlagaList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['plagas'] as List;
    List<Plaga> plagas = list.map((i) => Plaga.fromJSON(i)).toList();

    return PlagaList(plagas: plagas);
  }
}
