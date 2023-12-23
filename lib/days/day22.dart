import 'dart:math';

import '../main.dart';
import '../utils/coor3.dart';

class Day22 extends Day {
  @override
  bool get completed => true;

  List<List<Coor3>> bricks = [];

  @override
  void init() {
    bricks = [];
    for (var line in inputList) {
      var parts = line.split("~");
      var c1 = Coor3.fromString(parts[0]);
      var c2 = Coor3.fromString(parts[1]);
      int axis = 0;
      List<Coor3> b = [];
      if (c1.x < c2.x) {
        for (int i = c1.x; i <= c2.x; i++) {
          b.add(Coor3(i, c1.y, c1.z));
        }
        axis++;
      }
      if (c1.x > c2.x) {
        for (int i = c2.x; i <= c1.x; i++) {
          b.add(Coor3(i, c1.y, c1.z));
        }
        axis++;
      }
      if (c1.y < c2.y) {
        for (int i = c1.y; i <= c2.y; i++) {
          b.add(Coor3(c1.x, i, c1.z));
        }
        axis++;
      }
      if (c1.y > c2.y) {
        for (int i = c2.y; i <= c1.y; i++) {
          b.add(Coor3(c1.x, i, c1.z));
        }
        axis++;
      }
      if (c1.z < c2.z) {
        for (int i = c1.z; i <= c2.z; i++) {
          b.add(Coor3(c1.x, c1.y, i));
        }
        axis++;
      }
      if (c1.z > c2.z) {
        for (int i = c2.z; i <= c1.z; i++) {
          b.add(Coor3(c1.x, c1.y, i));
        }
        axis++;
      }
      if (axis == 0) {
        b.add(Coor3(c1.x, c1.y, c1.z));
      }
      bricks.add(b);
    }
    bricks.sort((a, b) {
      var minZa =
          a.map((e) => e.z).reduce((value, element) => min(value, element));
      var minZb =
          b.map((e) => e.z).reduce((value, element) => min(value, element));
      return minZa.compareTo(minZb);
    });
  }

  @override
  part1() {
    List<List<Coor3>> fallenBricks;
    (fallenBricks, _) = fall(bricks);
    var cancellable = 0;
    print("fallen");

    for (int i = 0; i < fallenBricks.length; i++) {
      if (i % 50 == 0) print(i);
      List<List<Coor3>> newBricks = fallenBricks.toList();
      newBricks.removeAt(i);
      int moves = 0;
      (_, moves) = fall(newBricks);
      if (moves == 0) {
        cancellable++;
      }
    }
    return cancellable;
  }

  @override
  part2() {
    List<List<Coor3>> fallenBricks;
    (fallenBricks, _) = fall(bricks);

    int totalMoves = 0;

    for (int i = 0; i < fallenBricks.length; i++) {
      List<List<Coor3>> newBricks = fallenBricks.toList();
      newBricks.removeAt(i);
      int moves = 0;
      (_, moves) = fall(newBricks);
      totalMoves += moves;
    }
    return totalMoves;
  }

  (List<List<Coor3>>, int) fall(List<List<Coor3>> inputBricks) {
    List<List<Coor3>> fallen = [];
    List<Coor3> brickList = [];
    List<List<Coor3>> blocksFallen = [];
    int total = 0;
    for (var b in inputBricks) {
      List<Coor3> newBlock = [];
      for (var f in b) {
        var newBrick = Coor3(f.x, f.y, f.z);
        newBlock.add(newBrick);
        if (brickList.contains(newBrick)) {
          print("brick: $newBrick already added");
        }
        brickList.add(newBrick);
        total++;
      }
      fallen.add(newBlock);
    }

    if (total != brickList.length)
      print("total: $total - brickList: ${brickList.length}");

//    print(brickList.length);
    var moves = 999;
    while (moves > 0) {
      moves = 0;
      outerLoop:
      for (var i = 0; i < fallen.length; i++) {
        var block = fallen[i];
        for (var brick in block) {
          // if (brick.x == 0 && brick.y == 1 && brick.z == 4) {
          //   print("found");
          // }
          var below = brick.move(Direction.back);
          if (below.z <= 0) continue outerLoop;
          if (!block.contains(below) && brickList.contains(below)) {
            continue outerLoop;
          }
        }
        moves++;
//        print(block);
        for (var brick in block) {
          brick.z--;
        }
//        print("-> $block");
        if (!blocksFallen.contains(block)) blocksFallen.add(block);
      }
    }
//    print(fallen);
    fallen.sort((a, b) {
      var minZa =
          a.map((e) => e.z).reduce((value, element) => min(value, element));
      var minZb =
          b.map((e) => e.z).reduce((value, element) => min(value, element));
      return minZa.compareTo(minZb);
    });
    return (fallen, blocksFallen.length);
  }
}
