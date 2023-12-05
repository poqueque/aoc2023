import '../main.dart';

class Day04 extends Day {
  @override
  bool get completed => true;

  var winingList = [];
  var ownedList = [];

  @override
  void init() {
    for (var line in inputList) {
      var data = line.split(":");
      var data2 = data[1].split("|");
      var wining = data2[0]
          .trim()
          .split(" ")
          .where((element) => element.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      var owned = data2[1]
          .trim()
          .split(" ")
          .where((element) => element.isNotEmpty)
          .map((e) => int.parse(e))
          .toList();
      winingList.add(wining);
      ownedList.add(owned);
    }
  }

  @override
  part1() {
    var sum = 0;
    for (int i = 0; i < ownedList.length; i++) {
      var points = 0;
      for (int j = 0; j < ownedList[i].length; j++) {
        if (winingList[i].contains(ownedList[i][j])) {
          if (points == 0) {
            points = 1;
          } else {
            points *= 2;
          }
        }
      }
      sum = sum + points;
    }
    return sum;
  }

  @override
  part2() {
    var copies = List.generate(ownedList.length, (index) => 1);
    for (int i = 0; i < ownedList.length; i++) {
      var points = 0;
      for (int j = 0; j < ownedList[i].length; j++) {
        if (winingList[i].contains(ownedList[i][j])) {
          points++;
        }
      }
      for (int j = 0; j < points; j++) {
        copies[i + j + 1] += copies[i];
      }
    }
    return copies.reduce((value, element) => value + element);
  }
}
