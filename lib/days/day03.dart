import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day03 extends Day {
  @override
  bool get completed => true;

  List<int> numbers = [];
  List<List<Coor>> positions = [];
  List<String> specialChar = [];
  List<Coor> specialCharPos = [];
  List<Coor> specialCharPosNeighbours = [];

  @override
  init() {
    int y = 0;
    for (var line in inputList) {
      int n = 0;
      int x = 0;
      List<Coor> pos = [];
      for (var char in line.chars) {
        if (['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'].contains(char)) {
          n = n * 10 + int.parse(char);
          pos.add(Coor(x, y));
        } else if (char == '.') {
          if (n != 0) {
            numbers.add(n);
            n = 0;
            positions.add(pos);
            pos = [];
          }
        } else {
          if (n != 0) {
            numbers.add(n);
            n = 0;
            positions.add(pos);
            pos = [];
          }
          //Special char
          specialChar.add(char);
          specialCharPos.add(Coor(x, y));
          specialCharPosNeighbours.addAll(Coor(x, y).neighbours());
        }
        x++;
      }
      if (n != 0) {
        numbers.add(n);
        n = 0;
        positions.add(pos);
        pos = [];
      }
      y++;
    }
  }

  @override
  part1() {
    var sum = 0;
    for (var i = 0; i < numbers.length; i++) {
      if (isPartNumber(i)) {
        sum += numbers[i];
      }
    }
    return sum;
  }

  @override
  part2() {
    var sum = 0;
    for (var i = 0; i < specialChar.length; i++) {
      List<int> numbersNeighbour = [];
      if (specialChar[i] == '*') {
        for (var j = 0; j < numbers.length; j++) {
          if (positions[j].any(
              (element) => specialCharPos[i].neighbours().contains(element))) {
            numbersNeighbour.add(numbers[j]);
          }
        }
        if (numbersNeighbour.length == 2) {
          sum += numbersNeighbour[0] * numbersNeighbour[1];
        }
      }
    }
    return sum;
  }

  bool isPartNumber(int i) {
    List<Coor> pos = positions[i];
    for (Coor p in pos) {
      if (specialCharPosNeighbours.contains(p)) {
        return true;
      }
    }
    return false;
  }
}
