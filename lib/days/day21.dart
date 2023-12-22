import '../main.dart';
import '../utils/coor.dart';

class Day21 extends Day {
  @override
  bool get completed => false;

  Map<Coor, String> grid = {};
  Map<Coor, int> grid2 = {};
  int maxX = 0;
  int maxY = 0;
  int total = 0;

  @override
  void init() {
    maxY = inputList.length;
    maxX = inputList[0].length;
    for (int j = 0; j < maxY; j++) {
      String line = inputList[j];
      for (int i = 0; i < maxX; i++) {
        grid[Coor(i, j)] = line[i];
        grid2[Coor(i, j)] = line[i] == "#" ? -1 : 9999;
      }
    }
  }

  @override
  part1() {
    Coor cursor = grid.keys.firstWhere((element) => grid[element] == "S");
    List<Coor> positions = [cursor];
    for (var steps = 0; steps < 64; steps++) {
      List<Coor> newPositions = [];
      for (var p in positions) {
        var neighbours = p.neighboursWithoutDiagonals();
        for (var n in neighbours) {
          if (grid[n] != "#") {
            if (!newPositions.contains(n)) newPositions.add(n);
          }
        }
      }
      positions = newPositions;
    }
    return positions.length;
  }

  Map<(Coor, int), Set<Coor>> cache = {};
  List<(Coor, int)> queue = [];

  //Adapted from reddit answer :(
  @override
  int part2() {
    int maxSteps = 26501365;
    Coor start = grid.keys.firstWhere((element) => grid[element] == "S");
    final open = [start];
    final visited = <Coor>{};
    final steps = <Coor, int>{};
    steps[start] = -1;
    var stepCountCurrent = -1;
    var lastCount = 0;
    var lastDiff = 0;
    var diffDiff = 0;
    var cycleStart = 0;
    final cycleLength = maxX * 2;
    final gridOffsets = <Coor>{};
    while (open.isNotEmpty && cycleStart == 0) {
      final current = open.removeAt(0);
      final currentSteps = steps[current]!;
      if (currentSteps != stepCountCurrent) {
        if (maxSteps % cycleLength == currentSteps % cycleLength) {
          var count = 0;
          for (final c in visited) {
            final distance = (start.x - c.x).abs() + (start.y - c.y).abs();
            final cell = grid[Coor(c.x % maxX, c.y % maxY)];
            if (distance <= maxSteps &&
                distance % 2 == maxSteps % 2 &&
                cell != '#') {
              count++;
            }
          }
          if ((count - lastCount) - lastDiff == diffDiff) {
            cycleStart = currentSteps;
          }
          diffDiff = (count - lastCount) - lastDiff;
          lastDiff = count - lastCount;
          lastCount = count;
        }
        stepCountCurrent++;
      }
      final nextSteps = currentSteps + 1;
      if (currentSteps <= maxSteps) {
        if (visited.add(Coor(current.x, current.y))) {
          for (final direction in [
            Direction.left,
            Direction.right,
            Direction.up,
            Direction.down
          ]) {
            final next = current.move(direction);
            final nextMod = Coor(next.x % maxX, next.y % maxY);
            if (!visited.contains(Coor(next.x, next.y)) &&
                grid[nextMod] != '#') {
              open.add(next);
              steps[next] = nextSteps;
              gridOffsets.add(
                Coor(
                  next.x < 0 ? next.x ~/ maxX - 1 : next.x ~/ maxX,
                  next.y < 0 ? next.y ~/ maxY - 1 : next.y ~/ maxY,
                ),
              );
            }
          }
        }
      } else {
        break;
      }
    }
    var count = 0;
    final cycles = (maxSteps - cycleStart) ~/ cycleLength;
    final checkUpTo = cycleStart;
    for (final c in visited) {
      final distance = (start.x - c.x).abs() + (start.y - c.y).abs();
      final cell = grid[Coor(c.x % maxX, c.y % maxY)];
      if (distance <= checkUpTo &&
          distance % 2 == maxSteps % 2 &&
          cell != '#') {
        count++;
      }
    }
    var add = lastDiff + diffDiff;
    for (var i = 0; i < cycles; i++) {
      count += add;
      add += diffDiff;
    }

    return count;
  }

  int part2c() {
    var start = DateTime.now();
    print(26501365 % 266);
    Coor cursor = grid.keys.firstWhere((element) => grid[element] == "S");
    Set<Coor> t = {cursor};
    var totalReached = 0;
    List<int> totals = [];
    List<int> deltas = [];
    List<int> deltaDeltas = [];
    var index = 0;
    for (var i = 1; i < 1000; i++) {
      index++;
      if (i % 10 == 0 || i < 10) print("$i: ${t.length}");
      Set<Coor> t2 = {};
      for (var p in t) {
        var neighbours = getValidNeighbours(p);
        for (var n in neighbours) {
          t2.add(n);
        }
      }
      if (index % 2 == 1) {
        totalReached += t2.length;
        if (index % 262 == 65) {
          totals.add(totalReached);
          int currTotals = totals.length;
          if (currTotals > 1) {
            deltas.add(totals[currTotals - 1] - totals[currTotals - 2]);
          }
          int currDeltas = deltas.length;
          if (currDeltas > 1) {
            deltaDeltas.add(deltas[currDeltas - 1] - deltas[currDeltas - 2]);
          }
          if (deltaDeltas.length > 1) {
            break;
          }
        }
      }
      t = t2;
    }
    int neededLoopCount = 26501365 ~/ 262 - 1;
    int currentLoopCount = index ~/ 262 - 1;
    int deltaLoopCount = neededLoopCount - currentLoopCount;
    int deltaLoopCountTriangular =
        (neededLoopCount * (neededLoopCount + 1)) ~/ 2 -
            (currentLoopCount * (currentLoopCount + 1)) ~/ 2;
    int deltaDelta = deltaDeltas[deltaDeltas.length - 1];
    int initialDelta = deltas[0];
    return (deltaDelta * deltaLoopCountTriangular +
        initialDelta * deltaLoopCount +
        totalReached);
  }

  part2a() {
    var start = DateTime.now();
    Coor cursor = grid.keys.firstWhere((element) => grid[element] == "S");
    for (int i = 0; i <= 500; i++) {
      var t = get(cursor, i);
      if (i % 113 == 0) {
        print("----$i: ${t.length}");
      } else {
        print("$i: ${t.length}");
      }
    }
    print(DateTime.now().difference(start));
    return 0;
  }

  part2b() {
    var start = DateTime.now();
    Coor cursor = grid.keys.firstWhere((element) => grid[element] == "S");
    List<int> p = [];
    List<int> d1 = [0];
    List<int> d2 = [0, 0];
    for (int i = 0; i < 300; i++) {
      p.add(process(cursor, i).length);
      if (i > 0) d1.add(p[i] - p[i - 1]);
      if (i > 1) d2.add(d1[i] - d1[i - 1]);
      if (i % 131 == 0) {
        print("----$i: ${p[i]} ${d1[i]} ${d2[i]}");
      } else {
        print("$i: ${p[i]} ${d1[i]} ${d2[i]}");
      }
    }
    var t = process(cursor, 100).length;
    print(DateTime.now().difference(start));
    return t;
  }

  Set<Coor> process(Coor point, int remaining) {
    if (cache[(point, remaining)] != null) return cache[(point, remaining)]!;
    if (remaining == 0) {
      return {point};
    }
    var neighbours = getValidNeighbours(point);
    Set<Coor> t = {};
    for (var n in neighbours) {
      t.addAll(process(n, remaining - 1));
    }
    cache[(point, remaining)] = t;
    return t;
  }

  Set<Coor> get(Coor point, int steps) {
    Set<Coor> t = {point};
    for (var i = 0; i < steps; i++) {
      Set<Coor> t2 = {};
      for (var p in t) {
        var neighbours = getValidNeighbours(p);
        for (var n in neighbours) {
          t2.add(n);
        }
      }
      t = t2;
    }
    return t;
  }

  getValidNeighbours(Coor point) {
    List<Coor> nbs = point.neighboursWithoutDiagonals();
    List<Coor> validNbs = [];
    for (var n in nbs) {
      var n2 = Coor(n.x % maxX, n.y % maxY);
      if (grid[n2] != "#") {
        validNbs.add(n);
      }
    }
    return validNbs;
  }
}
