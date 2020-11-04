class IdGen {
  static int getId() {
    DateTime now = DateTime.now();
    String id =
        "${now.month}${now.day}${now.minute}${now.second}${now.millisecond}";
    print(id);
    print(int.parse(id));
    return int.parse(id);
  }
}
