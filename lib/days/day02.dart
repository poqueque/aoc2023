import '../main.dart';

class Day02 extends Day {
  @override
  bool get completed => true;

  @override
  part1() {
    var total = 0;
    for (var line in inputList) {
      CubeGame game = CubeGame(line);
      if (game.isValid(12, 13, 14)) total += game.id;
    }
    return total;
  }

  @override
  part2() {
    var total = 0;
    for (var line in inputList) {
      CubeGame game = CubeGame(line);
      total += game.power();
    }
    return total;
  }
}

class CubeGame {
  late int id;
  List<(int, int, int)> cubes = [];

  CubeGame(String input) {
    var parts = input.split(":");
    id = int.parse(parts[0].split(" ").last);
    var games = parts[1].split(";");
    for (var game in games) {
      int r = 0, g = 0, b = 0;
      var gameParts = game.split(",");
      for (var part in gameParts) {
        var partParts = part.trim().split(" ");
        var color = partParts[1];
        var value = int.parse(partParts[0]);
        switch (color) {
          case "blue":
            b = value;
            break;
          case "green":
            g = value;
            break;
          case "red":
            r = value;
            break;
        }
      }
      cubes.add((r, g, b));
    }
  }

  (int, int, int) max() {
    var r = 0, g = 0, b = 0;
    for (var cube in cubes) {
      if (cube.$1 > r) r = cube.$1;
      if (cube.$2 > g) g = cube.$2;
      if (cube.$3 > b) b = cube.$3;
    }
    return (r, g, b);
  }

  int power() {
    var (r, g, b) = max();
    return r * g * b;
  }

  bool isValid(int i, int j, int k) {
    for (var cube in cubes) {
      if (cube.$1 > i) return false;
      if (cube.$2 > j) return false;
      if (cube.$3 > k) return false;
    }
    return true;
  }
}
