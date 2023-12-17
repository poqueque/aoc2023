import 'dart:math';

enum Direction {
  left,
  right,
  up,
  down,
  leftDown,
  leftUp,
  rightDown,
  rightUp;

  Direction toLeft() {
    switch (this) {
      case Direction.up:
        return Direction.left;
      case Direction.down:
        return Direction.right;
      case Direction.left:
        return Direction.down;
      case Direction.right:
        return Direction.up;
      case Direction.leftUp:
        return Direction.leftDown;
      case Direction.rightUp:
        return Direction.rightDown;
      case Direction.leftDown:
        return Direction.leftUp;
      case Direction.rightDown:
        return Direction.rightUp;
    }
  }

  Direction toRight() {
    switch (this) {
      case Direction.up:
        return Direction.right;
      case Direction.down:
        return Direction.left;
      case Direction.left:
        return Direction.up;
      case Direction.right:
        return Direction.down;
      case Direction.leftUp:
        return Direction.rightUp;
      case Direction.rightUp:
        return Direction.leftDown;
      case Direction.leftDown:
        return Direction.rightDown;
      case Direction.rightDown:
        return Direction.leftUp;
    }
  }
}

class Coor {
  late int x;
  late int y;

  Coor(this.x, this.y);

  Coor.fromString(String s) {
    var p = s.split(",");
    x = int.parse(p[0]);
    y = int.parse(p[1]);
  }

  Coor operator +(Coor d) {
    return Coor(x + d.x, y + d.y);
  }

  Coor operator -(Coor d) {
    return Coor(x - d.x, y - d.y);
  }

  Coor operator *(int i) {
    return Coor(x * i, y * i);
  }

  double mod() {
    return sqrt(x * x + y * y);
  }

  Coor move(Direction d) {
    switch (d) {
      case Direction.up:
        return Coor(x, y - 1);
      case Direction.down:
        return Coor(x, y + 1);
      case Direction.left:
        return Coor(x - 1, y);
      case Direction.right:
        return Coor(x + 1, y);
      case Direction.leftUp:
        return Coor(x - 1, y - 1);
      case Direction.rightUp:
        return Coor(x + 1, y - 1);
      case Direction.leftDown:
        return Coor(x - 1, y + 1);
      case Direction.rightDown:
        return Coor(x + 1, y + 1);
    }
  }

  bool hides(Coor d2) {
    var angle1 = atan2(y.toDouble(), x.toDouble());
    var angle2 = atan2(d2.y.toDouble(), d2.x.toDouble());
    var mod1 = sqrt(x.toDouble() * x.toDouble() + y.toDouble() * y.toDouble());
    var mod2 = sqrt(
        d2.x.toDouble() * d2.x.toDouble() + d2.y.toDouble() * d2.y.toDouble());
    return (angle1 == angle2 && mod1 < mod2);
  }

  @override
  bool operator ==(dynamic other) {
    return (x == other.x && y == other.y);
  }

  @override
  int get hashCode => "$x $y".hashCode;

  @override
  String toString() {
    return "[$x,$y]";
  }

  int manhattanDistance(Coor c) {
    return (x - c.x).abs() + (y - c.y).abs();
  }

  List<Coor> neighbours() {
    return [
      Coor(x - 1, y - 1),
      Coor(x - 1, y),
      Coor(x - 1, y + 1),
      Coor(x, y - 1),
      Coor(x, y + 1),
      Coor(x + 1, y - 1),
      Coor(x + 1, y),
      Coor(x + 1, y + 1),
    ];
  }

  List<Coor> neighboursWithoutDiagonals() {
    return [
      Coor(x - 1, y),
      Coor(x, y - 1),
      Coor(x, y + 1),
      Coor(x + 1, y),
    ];
  }

  List<Coor> pathTo(Coor c) {
    List<Coor> list = [];
    if (x == c.x) {
      if (y < c.y) {
        for (int i = y; i <= c.y; i++) {
          list.add(Coor(x, i));
        }
      }
      if (y > c.y) {
        for (int i = c.y; i <= y; i++) {
          list.add(Coor(x, i));
        }
      }
    }
    if (y == c.y) {
      if (x < c.x) {
        for (int i = x; i <= c.x; i++) {
          list.add(Coor(i, y));
        }
      }
      if (x > c.x) {
        for (int i = c.x; i <= x; i++) {
          list.add(Coor(i, y));
        }
      }
    }
    return list;
  }

  double distance(Coor b) {
    return sqrt(pow(x - b.x, 2) + pow(y - b.y, 2));
  }

  List<Coor> closestTo(double d) {
    List<Coor> list = [];
    for (int i = x - d.floor() - 1; i < x + d.floor() + 1; i++) {
      for (int j = y - d.floor() - 1; j < y + d.floor() + 1; j++) {
        if (distance(Coor(i, j)) <= d) list.add(Coor(i, j));
      }
    }
    return list;
  }

  Set<Coor> atManhattanDistance(int d) {
    Set<Coor> list = {};
    for (int i = 0; i < d; i++) {
      list.add(Coor(x - i, y - (d - i)));
      list.add(Coor(x - i, y + (d - i)));
      list.add(Coor(x + i, y - (d - i)));
      list.add(Coor(x + i, y + (d - i)));
    }
    return list;
  }

  Set<Coor> atManhattanDistanceCapped(int d, int min, int max) {
    Set<Coor> list = {};
    for (int i = 0; i < d; i++) {
      if (x - i >= min && y - (d - i) <= max) {
        list.add(Coor(x - i, y - (d - i)));
      }
      if (x - i >= min && y + (d - i) <= max) {
        list.add(Coor(x - i, y + (d - i)));
      }
      if (x + i >= min && y - (d - i) <= max) {
        list.add(Coor(x + i, y - (d - i)));
      }
      if (x + i >= min && y + (d - i) <= max) {
        list.add(Coor(x + i, y + (d - i)));
      }
    }
    return list;
  }

  Direction directionTo(Coor cursor) {
    if (cursor.x == x) {
      if (cursor.y < y) return Direction.up;
      if (cursor.y > y) return Direction.down;
    }
    if (cursor.y == y) {
      if (cursor.x < x) return Direction.left;
      if (cursor.x > x) return Direction.right;
    }
    if (cursor.x < x) {
      if (cursor.y < y) return Direction.leftUp;
      if (cursor.y > y) return Direction.leftDown;
    }
    if (cursor.x > x) {
      if (cursor.y < y) return Direction.rightUp;
      if (cursor.y > y) return Direction.rightDown;
    }
    return Direction.up;
  }
}

class CoorMap<T> {
  Map<Coor, T> map = {};

  CoorMap(this.map);

  int bounds(Direction direction) {
    var minX = 100000;
    var maxX = -100000;
    var minY = 100000;
    var maxY = -100000;
    for (var k in map.keys) {
      if (k.x < minX) minX = k.x;
      if (k.x > maxX) maxX = k.x;
      if (k.y < minY) minY = k.y;
      if (k.y > maxY) maxY = k.y;
    }
    switch (direction) {
      case Direction.up:
        return minY;
      case Direction.down:
        return maxY;
      case Direction.left:
        return minX;
      case Direction.right:
        return maxX;
      default:
        return 0;
    }
  }

  void printMap({bool spaces = true, String onNull = " "}) {
    String line = "";
    String s1 = spaces ? " " : "";
    String s2 = onNull;
    for (var y = bounds(Direction.up); y <= bounds(Direction.down); y++) {
      for (var x = bounds(Direction.left); x <= bounds(Direction.right); x++) {
        line += "$s1${map[Coor(x, y)] ?? s2}$s1";
      }
      print(line);
      line = "";
    }
  }
}
