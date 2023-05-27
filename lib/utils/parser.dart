class Parser {
  static int toInt(String value) {
    if (value == '') return 0;
    try {
      return int.parse(value);
    } on Error catch (_) {
      return 0;
    }
  }

  static double toDouble(String value) {
    if (value == '') return 0;
    try {
      return double.parse(value);
    } on Error catch (_) {
      return 0;
    }
  }
}
