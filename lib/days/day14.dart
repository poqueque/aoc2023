import '../main.dart';
import '../utils/coor.dart';

class Day14 extends Day {
  @override
  bool get completed => true;

  Map<Coor, String> grid = {};
  int maxX = 0;
  int maxY = 0;
  List weights2 = [];
  List weights = [];

  @override
  void init() {
    maxY = inputList.length;
    maxX = inputList[0].length;
    for (int j = 0; j < maxY; j++) {
      String line = inputList[j];
      for (int i = 0; i < maxX; i++) {
        grid[Coor(i, j)] = line[i];
      }
    }
  }

  @override
  part1() {
    tilt(Direction.up);
    print('');
    return weight();
  }

  @override
  part2() {
    CoorMap coorMap = CoorMap(grid);
    weights2.add(weight2());
    weights.add(weight());
    for (int i = 0; i < 1000000000; i++) {
      tilt(Direction.up);
      tilt(Direction.left);
      tilt(Direction.down);
      tilt(Direction.right);
      String w2 = weight2();
      int w = weight();
      print('$i: $w');
      int wPos2 = weights2.indexOf(w2);
      int wPos = weights.indexOf(w);
      if (weights2.contains(w2) && weights.contains(w) && wPos2 == wPos) {
        print('Found a loop at $i');
        int loopStart = weights2.indexOf(weight2());
        int loopLength = weights2.length - loopStart;
        int loopIndex = (1000000000 - i - 1) % loopLength;
        print('Loop start: $loopStart');
        print('Loop length: $loopLength');
        print('Loop index: $loopIndex');
        return weights[loopStart + loopIndex];
      }
      weights.add(w);
      weights2.add(w2);
    }
    coorMap.printMap(spaces: false);
    return weight();
  }

  tilt(Direction direction) {
    for (int k = 0; k < maxY; k++) {
      for (int j = 0; j < maxY; j++) {
        for (int i = 0; i < maxX; i++) {
          if (direction == Direction.up) {
            if (j > 0 &&
                grid[Coor(i, j - 1)] == "." &&
                grid[Coor(i, j)] == "O") {
              grid[Coor(i, j)] = ".";
              grid[Coor(i, j - 1)] = "O";
            }
          }
          if (direction == Direction.down) {
            if (j < maxY - 1 &&
                grid[Coor(i, j + 1)] == "." &&
                grid[Coor(i, j)] == "O") {
              grid[Coor(i, j)] = ".";
              grid[Coor(i, j + 1)] = "O";
            }
          }
          if (direction == Direction.left) {
            if (i > 0 &&
                grid[Coor(i - 1, j)] == "." &&
                grid[Coor(i, j)] == "O") {
              grid[Coor(i, j)] = ".";
              grid[Coor(i - 1, j)] = "O";
            }
          }
          if (direction == Direction.right) {
            if (i < maxX - 1 &&
                grid[Coor(i + 1, j)] == "." &&
                grid[Coor(i, j)] == "O") {
              grid[Coor(i, j)] = ".";
              grid[Coor(i + 1, j)] = "O";
            }
          }
        }
      }
    }
  }

  int weight() {
    int w = 0;
    for (int j = 0; j < maxY; j++) {
      for (int i = 0; i < maxX; i++) {
        if (grid[Coor(i, j)] == "O") {
          w += maxY - j;
        }
      }
    }
    return w;
  }

  String weight2() {
    String w = "";
    for (int j = 0; j < maxY; j++) {
      for (int i = 0; i < maxX; i++) {
        if (grid[Coor(i, j)] == "O") {
          w += "$i,$j.";
        }
      }
    }
    return w;
  }
}
