import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';
import '../utils/coor.dart';

class Day18 extends Day {
  @override
  bool get completed => true;

  List<Coor> vertices = [];

  //https://es.wikipedia.org/wiki/F%C3%B3rmula_del_%C3%A1rea_de_Gauss
  //We also need to add the border / 2 + 1 because the border is not counted

  @override
  part1() {
    Coor cursor = Coor(0, 0);
    var border = 0;
    vertices.add(cursor);
    for (var line in inputList) {
      var split = line.split(" ");
      Direction dir = switch (split[0]) {
        "U" => Direction.up,
        "D" => Direction.down,
        "L" => Direction.left,
        "R" => Direction.right,
        String() => Direction.up,
      };
      int distance = int.parse(split[1]);
      for (int i = 0; i < distance; i++) {
        cursor = cursor.move(dir);
        border++;
      }
      vertices.add(cursor);
    }
    var sum = 0;
    for (int i = 0; i < vertices.length - 1; i += 1) {
      var v1 = vertices[i];
      var v2 = vertices[i + 1];
      sum += (v1.x * v2.y) - (v1.y * v2.x);
    }

    return sum ~/ 2 + border ~/ 2 + 1;
  }

  @override
  part2() {
    Coor cursor = Coor(0, 0);
    var border = 0;

    vertices.add(cursor);
    for (var line in inputList) {
      var split = line.split(" ");
      String color = split[2].replaceAll("(", "").replaceAll(")", "");
      color = color.replaceAll("#", "");
      Direction dir = switch (color.chars.last) {
        "3" => Direction.up,
        "1" => Direction.down,
        "2" => Direction.left,
        "0" => Direction.right,
        String() => Direction.up,
      };
      var distance = int.parse(color.substring(0, color.length - 1), radix: 16);

      for (int i = 0; i < distance; i++) {
        cursor = cursor.move(dir);
        border++;
      }
      vertices.add(cursor);
    }
    var sum = 0;
    for (int i = 0; i < vertices.length - 1; i += 1) {
      var v1 = vertices[i];
      var v2 = vertices[i + 1];
      sum += (v1.x * v2.y) - (v1.y * v2.x);
    }

    return sum ~/ 2 + border / 2 + 1;
  }
}
