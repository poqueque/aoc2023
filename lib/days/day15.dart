import '../main.dart';

class Day15 extends Day {
  @override
  bool get completed => false;

  List<String> data = [];

  @override
  void init() {
    data = inputString.split(",");
  }

  @override
  part1() {
    var total = 0;
    for (var d in data) {
      total += hashFunction(d);
    }
    return total;
  }

  @override
  part2() {
    Map<int, List<(String, int)>> map = {};
    for (var d in data) {
      if (d.contains("=")) {
        var split = d.split("=");
        var code = split[0];
        var value = int.parse(split[1]);
        var box = hashFunction(code);
        map[box] ??= [];
        bool replaced = false;
        for (var i in map[box]!) {
          if (i.$1 == code) {
            map[box]![map[box]!.indexOf(i)] = (code, value);
            replaced = true;
            break;
          }
        }
        if (!replaced) {
          map[box]!.add((code, value));
        }
      }
      if (d.contains("-")) {
        var split = d.split("-");
        var code = split[0];
        var box = hashFunction(code);
        map[box] ??= [];
        for (var i in map[box]!) {
          if (i.$1 == code) {
            map[box]!.removeAt(map[box]!.indexOf(i));
            break;
          }
        }
      }
    }
    int total = 0;
    for (var i in map.keys) {
      var list = map[i]!;
      for (var j = 0; j < list.length; j++) {
        total += (1 + i) * (j + 1) * (list[j].$2);
      }
    }
    return total;
  }

  int hashFunction(String inputList) {
    var h = 0;
    for (var i = 0; i < inputList.length; i++) {
      h += inputList.codeUnitAt(i);
      h *= 17;
      h %= 256;
    }
    return h;
  }
}
