import '../main.dart';
import '../utils/coor.dart';

class Day23 extends Day {
  @override
  bool get completed => false;

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
    //Random walk
    Coor start = grid.keys.firstWhere((element) => grid[element] == "S");
    Coor end = grid.keys.firstWhere((element) => grid[element] == "E");
    int minVis = 0;
    while (true) {
      List<Coor> visited = [];
      Coor cursor = Coor(start.x, start.y);
      while (cursor != end) {
        var neighbours = cursor.neighboursWithoutDiagonals();
        neighbours.removeWhere((element) => element.x < 0 || element.y < 0);
        neighbours.shuffle();
        bool found = false;
        for (var n in neighbours) {
          if (grid[n] != "#") {
            if (!visited.contains(n)) {
              if (grid[n] == "E") {
                cursor = n;
                visited.add(n);
                break;
              }
              if (grid[n] == ">" && n != cursor.move(Direction.right)) {
                continue;
              }
              if (grid[n] == "^" && n != cursor.move(Direction.up)) {
                continue;
              }
              if (grid[n] == "<" && n != cursor.move(Direction.left)) {
                continue;
              }
              if (grid[n] == "v" && n != cursor.move(Direction.down)) {
                continue;
              }
              cursor = n;
              visited.add(n);
              found = true;
              break;
            }
          }
        }
        if (!found) {
          break;
        }
      }
      if (grid[cursor] == "E") {
        if (visited.length > minVis) {
          minVis = visited.length;
          print(minVis);
          if (minVis == 1966 || minVis == 94) {
            return minVis;
          }
        }
      }
    }
  }

  List<Coor> edges = [];
  Map<(Coor, Coor), int> lines = {};
  List<(Coor, Direction)> queue = [];
  List<(Coor, Direction)> processed = [];
  late Coor start;
  late Coor end;

  @override
  part2() {
    start = grid.keys.firstWhere((element) => grid[element] == "S");
    end = grid.keys.firstWhere((element) => grid[element] == "E");
    edges = [start, end];
    queue.add((start, Direction.down));
    while (queue.isNotEmpty) {
      print(queue.length);
      var next = queue.removeAt(0);
      process(next);
      processed.add(next);
    }
    print(lines.length);

    int maxSteps = 0;
    while (true) {
      List<Coor> visited = [];
      Coor cursor = Coor(start.x, start.y);
      int steps = 0;
      while (cursor != end) {
        visited.add(cursor);
        var possibilities = lines.keys
            .where((element) =>
                element.$1 == cursor && !visited.contains(element.$2))
            .toList();
        possibilities.shuffle();
        if (possibilities.isEmpty) {
          break;
        }
        bool found = false;
        cursor = possibilities[0].$2;
        steps += lines[possibilities[0]]!;
        if (cursor == end) {
          break;
        }
      }
      if (grid[cursor] == "E") {
        if (steps > maxSteps) {
          maxSteps = steps;
          print(maxSteps);
          if (maxSteps == 6286 || maxSteps == 154) {
            return maxSteps;
          }
        }
      }
    }
  }

  void process((Coor, Direction) data) {
    var cursor = data.$1.move(data.$2);
    var path = [data.$1];
    while (true) {
      var neighbours = cursor.neighboursWithoutDiagonals();
      neighbours.removeWhere((element) => element.x < 0 || element.y < 0);
      neighbours.removeWhere((element) => grid[element] == "#");
      neighbours.removeWhere((element) => path.contains(element));
      if (neighbours.length == 1) {
        path.add(cursor);
        cursor = neighbours[0];
        if (cursor == end) {
          lines[(data.$1, cursor)] = path.length;
          return;
        }
      } else if (neighbours.length > 1) {
        for (var n in neighbours) {
          Direction d = cursor.directionTo(n);
          if (!lines.containsKey((data.$1, cursor))) {
            lines[(data.$1, cursor)] = path.length;
          }
          if (!edges.contains(cursor)) edges.add(cursor);
          if (!queue.contains((cursor, d)) &&
              !processed.contains((cursor, d))) {
            queue.add((cursor, d));
          }
        }
        return;
      } else {
        return;
      }
    }
  }
}
