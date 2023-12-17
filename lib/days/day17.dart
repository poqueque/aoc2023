import '../main.dart';
import '../utils/coor.dart';

class Day17 extends Day {
  @override
  bool get completed => true;

  Map<Coor, int> grid = {};
  int maxX = 0;
  int maxY = 0;

  @override
  void init() {
    Map<Coor, int> grid = {};
    int maxX = 0;
    int maxY = 0;
    (grid, maxX, maxY) = readGrid<int>();
    this.grid = grid;
    this.maxX = maxX;
    this.maxY = maxY;
  }

  List<(Coor, Direction, int, int)> queue = [];
  Set<(Coor, Direction, int)> visited = {};
  int heat = 100000;

  @override
  part1() {
    var now = DateTime.now();
    Coor cursor = Coor(0, 0);
    queue.add((cursor, Direction.right, 0, 0));
    queue.add((cursor, Direction.down, 0, 0));
    while (queue.isNotEmpty) {
      queue.sort((a, b) => a.$4.compareTo(b.$4));
      process(queue.removeAt(0));
    }
    print(DateTime.now().difference(now));
    return heat;
  }

  void process((Coor, Direction, int, int) element) {
    var cursor = element.$1;
    var direction = element.$2;
    var times = element.$3;
    var count = element.$4;
    if (visited.contains((cursor, direction, times))) return;
    if (cursor.x == maxX - 1 && cursor.y == maxY - 1) {
      if (count < heat) {
        heat = count;
      }
    }
    visited.add((cursor, direction, times));
    if (times < 3) {
      var next = cursor.move(direction);
      if (grid[next] != null) {
        queue.add((next, direction, times + 1, count + grid[next]!));
      }
    }
    for (Direction d in [direction.toRight(), direction.toLeft()]) {
      var next = cursor.move(d);
      if (grid[next] != null) {
        queue.add((next, d, 1, count + grid[next]!));
      }
    }
  }

  @override
  part2() {
    var now = DateTime.now();
    heat = 1000000000;
    queue = [];
    visited = {};
    Coor cursor = Coor(0, 0);
    queue.add((cursor, Direction.right, 0, 0));
    queue.add((cursor, Direction.down, 0, 0));
    while (queue.isNotEmpty) {
      queue.sort((a, b) => a.$4.compareTo(b.$4));
      process2(queue.removeAt(0));
    }
    print(DateTime.now().difference(now));
    return heat;
  }

  void process2((Coor, Direction, int, int) element) {
    var cursor = element.$1;
    var direction = element.$2;
    var times = element.$3;
    var count = element.$4;
    if (visited.contains((cursor, direction, times))) return;
    if (cursor.x == maxX - 1 && cursor.y == maxY - 1) {
      if (count < heat) {
        heat = count;
      }
    }
    visited.add((cursor, direction, times));
    if (times < 10) {
      var next = cursor.move(direction);
      if (grid[next] != null) {
        queue.add((next, direction, times + 1, count + grid[next]!));
      }
    }
    if (times >= 4) {
      for (Direction d in [direction.toRight(), direction.toLeft()]) {
        var next = cursor.move(d);
        if (grid[next] != null) {
          queue.add((next, d, 1, count + grid[next]!));
        }
      }
    }
  }
}
