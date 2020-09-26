class User {
  String email;
  String userName;
  String pass;
  String nombre;
  String aPaterno;
  String aMaterno;
  int type;

  User(
      {this.email,
      this.userName,
      this.pass,
      this.aMaterno,
      this.aPaterno,
      this.nombre,
      this.type});

  factory User.fromJSON(Map<String, dynamic> item) {
    return User(
        email: item['email'],
        userName: item['nombreUsuario'],
        pass: item['password'],
        aMaterno: item['apellidoMaterno'],
        aPaterno: item['apellidoPaterno'],
        nombre: item['nombre'],
        type: int.parse(item['tipoUsuario']) ?? 0);
  }

  Map<String, dynamic> toJson() {
    return {
      "nombreUsuario": this.userName,
      "email": this.email,
      "password": this.pass,
      "nombre": this.nombre,
      "apellidoPaterno": this.aPaterno,
      "apellidoMaterno": this.aMaterno,
      "tipoUsuario": this.type,
    };
  }
}
