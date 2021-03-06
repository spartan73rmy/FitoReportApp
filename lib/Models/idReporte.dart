class IdReporte {
  List<int> id;

  IdReporte({this.id});

  IdReporte.fromJson(Map<String, dynamic> json) {
    id = json['id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
