class FileHash {
  String? hash;

  FileHash({this.hash});

  FileHash.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hash'] = this.hash;
    return data;
  }
}
