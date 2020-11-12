class IdGen {
  static int getId() {
    DateTime now = DateTime.now();
    String id = "${now.month}${now.day}${now.minute}${now.second}";
    return int.parse(id);
  }
}
