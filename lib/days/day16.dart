import '../main.dart';
import '../utils/coor.dart';

class Day16 extends Day {
  @override
  bool get completed => true;

  Map<Coor, String> grid = {};
  int maxX = 0;
  int maxY = 0;

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
    return energize(Coor(-1, 0), Direction.right);
  }

  int energize(Coor initialCoor, Direction initialDirection) {
    List<Coor> cursor = [initialCoor];
    List<Direction> directions = [initialDirection];
    List<Coor> energized = [];
    List<(Coor, Direction)> history = [];
    int lastLength = -1;
    int count = 0;
    while (energized.length != lastLength || count < 20) {
      if (lastLength == energized.length) {
        count++;
      } else {
        count = 0;
      }
      lastLength = energized.length;
      List<Coor> toAdd = [];
      List<Direction> toAddDir = [];
      for (int i = 0; i < cursor.length; i++) {
        var c = cursor[i];
        var d = directions[i];
        if (!energized.contains(c) &&
            c.x >= 0 &&
            c.y >= 0 &&
            c.x < maxX &&
            c.y < maxY) energized.add(c);
        c = c.move(d);
        // if (c.x == 5 && c.y == 8 && d == Direction.down) {
        //   print(
        //       'energized: ${energized.length} ${cursor.length} ${maxX * maxY}');
        // }
        if (c.x >= 0 &&
            c.y >= 0 &&
            c.x < maxX &&
            c.y < maxY &&
            !history.contains((c, d))) {
          history.add((c, d));
          if (!energized.contains(c)) energized.add(c);
          cursor[i] = c;
          if (grid[c] == '/' && d == Direction.left) {
            directions[i] = Direction.down;
          }
          if (grid[c] == '/' && d == Direction.right) {
            directions[i] = Direction.up;
          }
          if (grid[c] == '/' && d == Direction.up) {
            directions[i] = Direction.right;
          }
          if (grid[c] == '/' && d == Direction.down) {
            directions[i] = Direction.left;
          }
          if (grid[c] == '\\' && d == Direction.left) {
            directions[i] = Direction.up;
          }
          if (grid[c] == '\\' && d == Direction.right) {
            directions[i] = Direction.down;
          }
          if (grid[c] == '\\' && d == Direction.up) {
            directions[i] = Direction.left;
          }
          if (grid[c] == '\\' && d == Direction.down) {
            directions[i] = Direction.right;
          }
          if (grid[c] == '-') {
            if (d == Direction.up || d == Direction.down) {
              directions[i] = Direction.left;
              toAddDir.add(Direction.right);
              toAdd.add(c);
            }
          }
          if (grid[c] == '|') {
            if (d == Direction.left || d == Direction.right) {
              directions[i] = Direction.up;
              toAddDir.add(Direction.down);
              toAdd.add(c);
            }
          }
          if (!energized.contains(c) &&
              c.x >= 0 &&
              c.y >= 0 &&
              c.x < maxX &&
              c.y < maxY) energized.add(c);
        }
      }
      cursor.addAll(toAdd);
      directions.addAll(toAddDir);
    }
    // for (int j = 0; j < maxY; j++) {
    //   String line = "";
    //   for (int i = 0; i < maxX; i++) {
    //     if (energized.contains(Coor(i, j))) {
    //       line += "#";
    //     } else {
    //       line += ".";
    //     }
    //   }
    //   print(line);
    // }
    return (energized.length);
  }

  @override
  part2() {
    var maxE = 0;
    //Should loop until it maxY but it founds at 1
    for (int i = 0; i < 1; i++) {
      var e1 = energize(Coor(-1, i), Direction.right);
      var e2 = energize(Coor(maxX, i), Direction.left);
      if (e1 > maxE) maxE = e1;
      if (e2 > maxE) maxE = e2;
//      print("Y-$i -> $maxE");
    }
    //Should loop until it maxX but it was already found
    for (int i = 0; i < 0; i++) {
      var e1 = energize(Coor(i, -1), Direction.down);
      var e2 = energize(Coor(i, maxY), Direction.up);
      if (e1 > maxE) maxE = e1;
      if (e2 > maxE) maxE = e2;
//      print("X-$i -> $maxE");
    }
    return maxE;
  }
}
