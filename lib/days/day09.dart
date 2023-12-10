import '../main.dart';

class Day09 extends Day {
  @override
  bool get completed => true;

  List<List<int>> histories = [];

  @override
  void init() {
    for (var line in inputList) {
      histories.add(line.split(" ").map((e) => int.parse(e)).toList());
    }
  }

  @override
  part1() {
    var total = 0;
    for (var history in histories) {
      List<List<int>> differences = [];
      List<int> diffs = history.toList();
      while (diffs.any((element) => element != 0)) {
        differences.add(diffs);
        diffs = [];
        for (var i = 1; i < differences.last.length; i++) {
          diffs.add(differences.last[i] - differences.last[i - 1]);
        }
      }
      var toAdd = 0;
      for (var diff in differences.reversed) {
        toAdd += diff.last;
        diff.add(toAdd);
      }
      total += toAdd;
    }
    return total;
  }

  @override
  part2() {
    var total = 0;
    for (var history in histories) {
      List<List<int>> differences = [];
      List<int> diffs = history.toList();
      while (diffs.any((element) => element != 0)) {
        differences.add(diffs);
        diffs = [];
        for (var i = 1; i < differences.last.length; i++) {
          diffs.add(differences.last[i] - differences.last[i - 1]);
        }
      }
      var toAdd = 0;
      for (var diff in differences.reversed) {
        toAdd = diff.first - toAdd;
        diff.add(toAdd);
      }
      total += toAdd;
    }
    return total;
  }
}
