class Plaga {
  int id;
  String nombre;
  bool selected;
  Plaga({this.id, this.nombre, this.selected = false});

  factory Plaga.fromJSON(Map<String, dynamic> item) {
    return Plaga(id: item['id'], nombre: item['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id ?? -1,
      "nombre": this.nombre ?? "",
    };
  }
}

class PlagaList {
  List<Plaga> plagas;

  PlagaList({this.plagas});

  List<Plaga> toList(PlagaList lista) {
    return lista.plagas;
  }

  Map<String, dynamic> toJson() {
    return {
      "plagas": this.plagas,
    };
  }

  factory PlagaList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['plagas'] as List;
    List<Plaga> plagas = list.map((i) => Plaga.fromJSON(i)).toList();
    return PlagaList(plagas: plagas);
  }
}
