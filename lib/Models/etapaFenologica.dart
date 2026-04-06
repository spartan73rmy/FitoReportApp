import 'package:hive/hive.dart';

part 'etapaFenologica.g.dart';

@HiveType(typeId: 0)
class EtapaFenologica extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  int? serverId;

  @HiveField(2)
  String? nombre;

  EtapaFenologica({this.id, this.serverId, this.nombre});

  factory EtapaFenologica.fromJSON(Map<String, dynamic> item) {
    return EtapaFenologica(serverId: item['id'], nombre: item['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {"id": serverId ?? -1, "nombre": nombre};
  }
}

class EtapaFList {
  List<EtapaFenologica>? etapas;

  EtapaFList({this.etapas});

  factory EtapaFList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['etapaFenologica'] as List;
    List<EtapaFenologica> etapas = list
        .map((i) => EtapaFenologica.fromJSON(i as Map<String, dynamic>))
        .toList();
    return EtapaFList(etapas: etapas);
  }
}
