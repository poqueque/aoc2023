import '../main.dart';
import '../utils/coor3.dart';

class Day24 extends Day {
  @override
  bool get completed => true;

  List<(Coor3, Coor3)> stones = [];

  @override
  void init() {
    for (int j = 0; j < inputList.length; j++) {
      String line = inputList[j];
      var parts = line.split("@");
      Coor3 p0 = Coor3.fromString(parts[0].trim());
      Coor3 v = Coor3.fromString(parts[1].trim());
      stones.add((p0, v));
    }
  }

  @override
  part1() {
    var b0 = 200000000000000;
    var b1 = 400000000000000;
    var count = 0;
    for (int i = 0; i < stones.length; i++) {
      var s1 = stones[i];
      for (int j = i + 1; j < stones.length; j++) {
        var s2 = stones[j];
        var p1 = s1.$1;
        var v1 = s1.$2;
        var p2 = s2.$1;
        var v2 = s2.$2;
        var t1 = (p1.x * v1.y - p1.y * v1.x - p2.x * v1.y + p2.y * v1.x) /
            (v2.x * v1.y - v2.y * v1.x);
        var t2 = (p2.x * v2.y - p2.y * v2.x - p1.x * v2.y + p1.y * v2.x) /
            (v1.x * v2.y - v1.y * v2.x);

        var x = p2.x + t1 * v2.x;
        var y = p2.y + t1 * v2.y;
        // if (t1 < 0 || t2 < 0) {
        //   print("in the past: $t1 $t2");
        // } else {
        //   print("$x $y (t1=$t1)");
        // }
        if (t1 >= 0 && t2 >= 0 && x >= b0 && x <= b1 && y >= b0 && y <= b1) {
          // print("inside: $x $y");
          count++;
        }
      }
    }
    return count;
  }

  @override
  part2() {
    String equations = "";
    for (int i = 0; i < 3; i++) {
      String t = "t$i";
      equations +=
          "${stones[i].$1.x} + ${stones[i].$2.x} * $t == x + vx * $t, ";
      equations +=
          "${stones[i].$1.y} + ${stones[i].$2.y} * $t == y + vy * $t, ";
      equations +=
          "${stones[i].$1.z} + ${stones[i].$2.z} * $t == z + vz * $t, ";
    }
    equations = equations.substring(0, equations.length - 2);
    String sendToSageMath = "var ('x,y,z,vx,vy,vz,t0,t1,t2') \n"
        "solve([$equations], x,y,z,vx,vy,vz,t0,t1,t2)";
    print(sendToSageMath);
    //Returned by SageMath:
    int xval = 419848807765291;
    int yval = 391746659362922;
    int zval = 213424530058607;
    return xval + yval + zval;
  }
}
