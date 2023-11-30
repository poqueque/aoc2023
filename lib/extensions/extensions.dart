extension StringExtensions on String {
  List<String> get chars =>
      runes.map((int rune) => String.fromCharCode(rune)).toList();

  String changeAt(int pos, String val) =>
      substring(0, pos) + val + substring(pos + 1);
}
