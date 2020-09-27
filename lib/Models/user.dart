class User {
  String email;
  String userName;
  String pass;
  String nombre;
  String aPaterno;
  String aMaterno;
  int type;
  bool aproved;

  User(
      {this.email,
      this.userName,
      this.pass,
      this.aMaterno,
      this.aPaterno,
      this.nombre,
      this.type,
      this.aproved});

  factory User.fromJSON(Map<String, dynamic> item) {
    return User(
        email: item['email'],
        userName: item['nombreUsuario'],
        pass: item['password'],
        aMaterno: item['apellidoMaterno'],
        aPaterno: item['apellidoPaterno'],
        nombre: item['nombre'],
        type: item['tipoUsuario'],
        aproved: item['confirmado']);
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
      "confirmado": this.aproved
    };
  }
}

class UserList {
  List<User> usuarios;

  UserList({this.usuarios});

  List<User> toList(UserList lista) {
    return lista.usuarios;
  }

  factory UserList.fromJSON(Map<String, dynamic> parsedJson) {
    var list = parsedJson['usuarios'] as List;
    List<User> usuarios = list.map((i) => User.fromJSON(i)).toList();
    return UserList(usuarios: usuarios);
  }
}
