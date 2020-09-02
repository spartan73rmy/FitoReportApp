class Enfermedad {
  int id;
  String nombre;

  Enfermedad({this.id, this.nombre});

  factory Enfermedad.fromJSON(Map<String, dynamic> item) {
    return Enfermedad(id: item['id'], nombre: item["nombre"]);
  }
}

class EnfermedadList {
  List<Enfermedad> plagas;

  EnfermedadList({this.plagas});

  factory EnfermedadList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['enfermedades'] as List;
    List<Enfermedad> plagas = list.map((i) => Enfermedad.fromJSON(i)).toList();

    return EnfermedadList(plagas: plagas);
  }
}
