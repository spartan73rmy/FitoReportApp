class IdGen {
  static int getId() {
    DateTime now = DateTime.now();
    String id =
        "${now.year}${now.month}${now.day}${now.minute}${now.second}${now.millisecond}";
    print(id);
    return int.parse(id);
  }
}
