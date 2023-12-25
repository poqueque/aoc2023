import '../main.dart';

class Day25 extends Day {
  @override
  bool get completed => false;

  List<(String, String)> connections = [];
  List<String> nodes = [];

  @override
  part1() {
    for (int i = 0; i < inputList.length; i++) {
      String line = inputList[i];
      var parts = line.split(":").map((e) => e.trim()).toList();
      if (nodes.contains(parts[0]) == false) nodes.add(parts[0]);
      var left = parts[1].split(" ");
      for (var l in left) {
        if (nodes.contains(l) == false) nodes.add(l);
        if (parts[0].compareTo(l) < 0) {
          connections.add((parts[0], l));
        } else {
          connections.add((l, parts[0]));
        }
      }
    }
    for (var c in connections) {
      print("${c.$1} -> ${c.$2} [label=\"${c.$1}${c.$2}\"];");
    }
    nodes.sort();
    print(nodes.length);
    var conn1 = connections.toList();
    conn1.remove(("mrd", "rjs"));
    conn1.remove(("gsk", "ncg"));
    conn1.remove(("gmr", "ntx"));
    (int, int) s = findConnexGreups(conn1);
    print(s);

    return s.$2;
  }

  part1b() {
    for (int i = 0; i < inputList.length; i++) {
      String line = inputList[i];
      var parts = line.split(":").map((e) => e.trim()).toList();
      if (nodes.contains(parts[0]) == false) nodes.add(parts[0]);
      var left = parts[1].split(" ");
      for (var l in left) {
        if (nodes.contains(l) == false) nodes.add(l);
        if (parts[0].compareTo(l) < 0) {
          connections.add((parts[0], l));
        } else {
          connections.add((l, parts[0]));
        }
      }
    }
    nodes.sort();
    print(nodes.length);
    for (int i0 = 0; i0 < nodes.length; i0++) {
      for (int i1 = i0 + 1; i1 < nodes.length; i1++) {
        print("$i0 $i1");
        for (int i2 = 0; i2 < nodes.length; i2++) {
          for (int i3 = i2 + 1; i3 < nodes.length; i3++) {
            for (int i4 = 0; i4 < nodes.length; i4++) {
              for (int i5 = i4 + 1; i5 < nodes.length; i5++) {
                if (i0 == i2 || i0 == i3 || i0 == i4 || i0 == i5) continue;
                if (i1 == i2 || i1 == i3 || i1 == i4 || i1 == i5) continue;
                if (i2 == i4 || i2 == i5) continue;
                if (i3 == i4 || i3 == i5) continue;
                var c1 = (nodes[i0], nodes[i1]);
                var c2 = (nodes[i2], nodes[i3]);
                var c3 = (nodes[i4], nodes[i5]);
                if (connections.contains(c1) &&
                    connections.contains(c2) &&
                    connections.contains(c3)) {
                  var conn1 = connections.toList();
                  conn1.remove(c1);
                  conn1.remove(c2);
                  conn1.remove(c3);
                  (int, int) s = findConnexGreups(conn1);
                  if (s.$1 > 1) return s.$2;
                }
              }
            }
          }
        }
      }
    }
    return 'Not found';
  }

  @override
  part2() {
    return "Merry Christmas!";
  }

  bool isConnex(List<(String, String)> connections) {
    List<String> found = [connections.first.$1, connections.first.$2];
    for (var connection in connections) {
      if (found.contains(connection.$1) && !found.contains(connection.$2)) {
        found.add(connection.$2);
      }
      if (found.contains(connection.$2) && !found.contains(connection.$1)) {
        found.add(connection.$1);
      }
    }
    return found.length == nodes.length;
  }

  (int, int) findConnexGreups(List<(String, String)> connections) {
    List<Set<String>> groups = [];
    List<String> toRemove = nodes.toList();
    while (toRemove.isNotEmpty) {
      var group = {toRemove.first};
      var len = -1;
      while (len != group.length) {
        len = group.length;
        for (var c in connections) {
          if (group.contains(c.$1) && !group.contains(c.$2)) {
            group.add(c.$2);
          }
          if (group.contains(c.$2) && !group.contains(c.$1)) {
            group.add(c.$1);
          }
        }
      }
      groups.add(group);
      for (var g in group) {
        toRemove.remove(g);
      }
    }
    var p = 1;
    for (var g in groups) p *= g.length;
    return (groups.length, p);
  }
}
