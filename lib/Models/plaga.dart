import 'package:hive/hive.dart';

part 'plaga.g.dart';

@HiveType(typeId: 1)
class Plaga extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? serverId;

  @HiveField(2)
  String? nombre;

  @HiveField(3)
  bool selected = false;

  Plaga({this.id, this.serverId, this.nombre, this.selected = false});

  factory Plaga.fromJSON(Map<String, dynamic> item) {
    return Plaga(serverId: item['id'], nombre: item['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {"id": serverId ?? -1, "nombre": nombre ?? ""};
  }
}

class PlagaList {
  List<Plaga>? plagas;

  PlagaList({this.plagas});

  factory PlagaList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['plagas'] as List;
    List<Plaga> plagas =
        list.map((i) => Plaga.fromJSON(i as Map<String, dynamic>)).toList();
    return PlagaList(plagas: plagas);
  }
}
