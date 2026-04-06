import 'package:hive/hive.dart';

part 'enfermedad.g.dart';

@HiveType(typeId: 2)
class Enfermedad extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? serverId;

  @HiveField(2)
  String? nombre;

  Enfermedad({this.id, this.serverId, this.nombre});

  factory Enfermedad.fromJSON(Map<String, dynamic> item) {
    return Enfermedad(serverId: item['id'], nombre: item["nombre"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": serverId ?? -1, "nombre": nombre ?? ""};
  }
}

class EnfermedadList {
  List<Enfermedad>? enfermedades;

  EnfermedadList({this.enfermedades});

  factory EnfermedadList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['enfermedades'] as List;
    List<Enfermedad> enfermedades = list
        .map((i) => Enfermedad.fromJSON(i as Map<String, dynamic>))
        .toList();

    return EnfermedadList(enfermedades: enfermedades);
  }
}
