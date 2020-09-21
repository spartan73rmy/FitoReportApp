class Enfermedad {
  int id;
  String nombre;

  Enfermedad({this.id, this.nombre});

  factory Enfermedad.fromJSON(Map<String, dynamic> item) {
    return Enfermedad(id: item['id'], nombre: item["nombre"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "nombre": this.nombre,
    };
  }
}

class EnfermedadList {
  List<Enfermedad> enfermedades;

  EnfermedadList({this.enfermedades});

  factory EnfermedadList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['enfermedades'] as List;
    List<Enfermedad> enfermedades =
        list.map((i) => Enfermedad.fromJSON(i)).toList();

    return EnfermedadList(enfermedades: enfermedades);
  }
}
