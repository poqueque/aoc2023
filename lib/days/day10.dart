import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day10 extends Day {
  @override
  bool get completed => true;

  Map<Coor, String> map = {};
  Map<Coor, String> cleanMap = {};
  Coor cursor = Coor(0, 0);
  Coor start = Coor(0, 0);
  Direction direction = Direction.down;

  @override
  void init() {
    for (var j = 0; j < inputList.length; j++) {
      var line = inputList[j].chars;
      for (var i = 0; i < line.length; i++) {
        map[Coor(i, j)] = line[i];
        if (line[i] == "S") {
          start = Coor(i, j);
        }
      }
    }
    direction = Direction.down;
  }

  @override
  part1() {
    cursor = start;
    direction = Direction.down;
    cleanMap[cursor] = map[cursor]!;
    var steps = 0;
    do {
      cursor = cursor.move(direction);
      cleanMap[cursor] = map[cursor]!;
      steps++;
      if (map[cursor] == "L" && direction == Direction.down) {
        direction = Direction.right;
        cleanMap[cursor.move(Direction.down)] ??= "R";
        cleanMap[cursor.move(Direction.left)] ??= "R";
        cleanMap[cursor.move(Direction.leftDown)] ??= "R";
      }
      if (map[cursor] == "L" && direction == Direction.left) {
        direction = Direction.up;
        cleanMap[cursor.move(Direction.rightUp)] ??= "R";
      }
      if (map[cursor] == "J" && direction == Direction.right) {
        direction = Direction.up;
        cleanMap[cursor.move(Direction.right)] ??= "R";
        cleanMap[cursor.move(Direction.rightDown)] ??= "R";
        cleanMap[cursor.move(Direction.down)] ??= "R";
      }
      if (map[cursor] == "J" && direction == Direction.down) {
        direction = Direction.left;
        cleanMap[cursor.move(Direction.leftUp)] ??= "R";
      }
      if (map[cursor] == "7" && direction == Direction.right) {
        direction = Direction.down;
        cleanMap[cursor.move(Direction.leftDown)] ??= "R";
      }
      if (map[cursor] == "7" && direction == Direction.up) {
        direction = Direction.left;
        cleanMap[cursor.move(Direction.right)] ??= "R";
        cleanMap[cursor.move(Direction.rightUp)] ??= "R";
        cleanMap[cursor.move(Direction.up)] ??= "R";
      }
      if (map[cursor] == "F" && direction == Direction.up) {
        direction = Direction.right;
        cleanMap[cursor.move(Direction.rightDown)] ??= "R";
      }
      if (map[cursor] == "F" && direction == Direction.left) {
        direction = Direction.down;
        cleanMap[cursor.move(Direction.up)] ??= "R";
        cleanMap[cursor.move(Direction.leftUp)] ??= "R";
        cleanMap[cursor.move(Direction.left)] ??= "R";
      }
      if (map[cursor] == "-" && direction == Direction.left) {
        cleanMap[cursor.move(Direction.up)] ??= "R";
      }
      if (map[cursor] == "-" && direction == Direction.right) {
        cleanMap[cursor.move(Direction.down)] ??= "R";
      }
      if (map[cursor] == "|" && direction == Direction.up) {
        cleanMap[cursor.move(Direction.right)] ??= "R";
      }
      if (map[cursor] == "|" && direction == Direction.down) {
        cleanMap[cursor.move(Direction.left)] ??= "R";
      }
    } while (cursor != start);
    return steps / 2;
  }

  @override
  part2() {
    part1();
    CoorMap coorMap = CoorMap(cleanMap);
    cursor = Coor(0, 0);
    var maxX = coorMap.bounds(Direction.right);
    var maxY = coorMap.bounds(Direction.down);
    List<Coor> queue = [cursor];
    while (queue.isNotEmpty) {
      cursor = queue.removeAt(0);
      if (coorMap.map[cursor] == null) {
        coorMap.map[cursor] = "O";
        queue.addAll(cursor.neighbours().where((element) =>
            coorMap.map[element] == null &&
            element.x >= -1 &&
            element.y >= -1 &&
            element.x <= maxX + 1 &&
            element.y <= maxY + 1));
      }
    }
    var inner = 0;
    for (var i = 0; i < coorMap.bounds(Direction.down); i++) {
      String? last = "";
      for (var j = 0; j < coorMap.bounds(Direction.right); j++) {
        if (coorMap.map[Coor(j, i)] == null) {
          if (last != "R") {
            coorMap.map[Coor(j, i)] = "I";
            inner++;
          } else {
            coorMap.map[Coor(j, i)] = "R";
          }
        }
        last = coorMap.map[Coor(j, i)];
      }
    }
    return inner;
  }
}
