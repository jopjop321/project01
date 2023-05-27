class Parser {
  static int toInt(String value) {
    if (value == '') return 0;
    return int.parse(value);
  }

  static double toDouble(String value) {
    if (value == '') return 0;
    return double.parse(value);
  }
}
