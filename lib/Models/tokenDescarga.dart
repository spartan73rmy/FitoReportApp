class TokenDescarga {
  String hashArchivo;

  TokenDescarga(this.hashArchivo);

  TokenDescarga.fromJson(Map<String, dynamic> json) {
    hashArchivo = json['hashArchivo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hashArchivo'] = this.hashArchivo;
    return data;
  }
}

class TokenHashDescarga {
  String tokenDescarga;
  String hash;
  TokenHashDescarga(this.tokenDescarga, {this.hash});

  TokenHashDescarga.fromJson(Map<String, dynamic> json) {
    tokenDescarga = json['tokenDescarga'];
  }

  Map<String, dynamic> toJson() {
    // return {'hashArchivo': "cdscs213", 'tokenDescarga': "123vd"};
    return {'hashArchivo': this.hash, 'tokenDescarga': this.tokenDescarga};
  }
}
