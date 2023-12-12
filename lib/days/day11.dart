import 'dart:math';

import '../main.dart';
import '../utils/coor.dart';

class Day11 extends Day {
  @override
  bool get completed => true;

  Map<Coor, String> universe = {};
  List<Coor> galaxies = [];
  List<int> xGaps = [];
  List<int> yGaps = [];

  void initData() {
    //Solution used in part 1
    var expandRatio = 1;
    List<String> expandedList = [];
    universe.clear();
    galaxies.clear();
    for (var line in inputList) {
      expandedList.add(line);
      if (!line.contains("#")) {
        xGaps.add(expandedList.length - 1);
        for (var i = 1; i < expandRatio; i++) {
          expandedList.add(line);
        }
      }
    }
    //Transpose matrix
    List<String> expandedList2 = [];
    for (var i = 0; i < expandedList[0].length; i++) {
      String line = "";
      for (var j = 0; j < expandedList.length; j++) {
        line += expandedList[j][i];
      }
      expandedList2.add(line);
      if (!line.contains("#")) {
        for (var k = 1; k < expandRatio; k++) {
          expandedList2.add(line);
        }
      }
    }
    expandedList = [];
    for (var i = 0; i < expandedList2[0].length; i++) {
      String line = "";
      for (var j = 0; j < expandedList2.length; j++) {
        line += expandedList2[j][i];
      }
      expandedList.add(line);
    }
    for (var i = 0; i < expandedList.length; i++) {
      for (var j = 0; j < expandedList[i].length; j++) {
        universe[Coor(j, i)] = expandedList[i][j];
        if (expandedList[i][j] == "#") {
          galaxies.add(Coor(j, i));
        }
      }
    }
  }

  @override
  init() {
    xGaps = List.generate(inputList[0].length, (index) => index);
    for (var i = 0; i < inputList.length; i++) {
      if (!inputList[i].contains("#")) {
        yGaps.add(i);
      }
      for (var j = 0; j < inputList[i].length; j++) {
        universe[Coor(j, i)] = inputList[i][j];
        if (inputList[i][j] == "#") {
          galaxies.add(Coor(j, i));
          xGaps.remove(j);
        }
      }
    }
  }

  @override
  part1() {
    return getDistance(1);
  }

  @override
  part2() {
    return getDistance(999999);
  }

  int getDistance(int expandRatio) {
    //Find all pairs of galaxies
    List<(Coor, Coor)> pairs = [];
    for (var i = 0; i < galaxies.length; i++) {
      for (var j = i + 1; j < galaxies.length; j++) {
        pairs.add((galaxies[i], galaxies[j]));
      }
    }
    var total = 0;
    for (var p in pairs) {
      var d = p.$1.manhattanDistance(p.$2);
      var totalXGaps = 0;
      var totalYGaps = 0;
      var minX = min(p.$1.x, p.$2.x);
      var maxX = max(p.$1.x, p.$2.x);
      var minY = min(p.$1.y, p.$2.y);
      var maxY = max(p.$1.y, p.$2.y);

      for (var i = minX; i <= maxX; i++) {
        if (xGaps.contains(i)) {
          totalXGaps++;
        }
      }
      for (var i = minY; i <= maxY; i++) {
        if (yGaps.contains(i)) {
          totalYGaps++;
        }
      }
      d = d +
          totalYGaps * (expandRatio).toInt() +
          totalXGaps * (expandRatio).toInt();
      total += d;
    }
    return total;
  }
}
