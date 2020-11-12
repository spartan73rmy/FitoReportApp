class EtapaFenologica {
  int id;
  String nombre;
  EtapaFenologica({this.id, this.nombre});

  factory EtapaFenologica.fromJSON(Map<String, dynamic> item) {
    return EtapaFenologica(id: item['id'], nombre: item['nombre']);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id ?? -1,
      "nombre": this.nombre,
    };
  }
}

class EtapaFList {
  List<EtapaFenologica> etapas;

  EtapaFList({this.etapas});

  List<EtapaFenologica> toList(EtapaFList lista) {
    return lista.etapas;
  }

  Map<String, dynamic> toJson() {
    return {
      'etapaFenologica': this.etapas,
    };
  }

  factory EtapaFList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['etapaFenologica'] as List;
    List<EtapaFenologica> etapas =
        list.map((i) => EtapaFenologica.fromJSON(i)).toList();
    return EtapaFList(etapas: etapas);
  }
}
