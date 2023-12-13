import 'dart:math';

import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';

class Day12 extends Day {
  @override
  bool get completed => true;

  List<String> records = [];
  List<List<int>> groups = [];

  void init1() {
    for (var line in inputList) {
      var data = line.split(" ");
      var r = data[0];
      var g = data[1].split(",").map((e) => int.parse(e)).toList();
      (r, g) = reduce(r, g);
      records.add(r);
      groups.add(g);
    }
  }

  void init2() {
    records.clear();
    groups.clear();
    for (var line in inputList) {
      var data = line.split(" ");
      var r = data[0];
      var g1 = data[1].split(",").map((e) => int.parse(e)).toList();
      r = "$r?$r?$r?$r?$r";
      List<int> g = [];
      g.addAll(g1);
      g.addAll(g1);
      g.addAll(g1);
      g.addAll(g1);
      g.addAll(g1);
      (r, g) = reduce(r, g);
      records.add(r);
      groups.add(g);
    }
  }

  @override
  part1() {
    init1();
    var totalArrangements = 0;
    for (int i = 0; i < groups.length; i++) {
      var arrangements = countArrangements2(records[i], null, groups[i]);
      totalArrangements += arrangements;
    }
    return totalArrangements;
  }

  @override
  part2() {
    init2();
    var totalArrangements = 0;
    for (int i = 0; i < groups.length; i++) {
      var arrangements = countArrangements2(records[i], null, groups[i]);
      totalArrangements += arrangements;
    }
    return totalArrangements;
  }

  int countArrangements(String record, List<int> group) {
    var qm = 0;
    for (var c in record.chars) {
      if (c == "?") qm++;
    }
    var total = 0;
    for (var i = 0; i < pow(2, qm); i++) {
      var possibility = getBase2(i, ".", "#", qm);
      var arrangement = record;
      for (var p in possibility.chars) {
        arrangement = arrangement.replaceFirst("?", p);
      }
      var count = [];
      var broken = 0;
      for (var a in arrangement.chars) {
        if (a == "#") {
          broken++;
        } else {
          if (broken > 0) count.add(broken);
          broken = 0;
        }
      }
      if (broken > 0) count.add(broken);
      if (count.length == group.length) {
        var valid = true;
        for (var j = 0; j < count.length; j++) {
          if (count[j] != group[j]) {
            valid = false;
            break;
          }
        }
        if (valid) total++;
      }
    }

    return total;
  }

  // function that returns a string in base 2
  String getBase2(int n, String zero, String one, length) {
    String result = "";
    while (n > 0) {
      result = (n % 2 == 0 ? zero : one) + result;
      n = n ~/ 2;
    }
    while (result.length < length) {
      result = zero + result;
    }
    return result;
  }

  (String, List<int>) reduce(String r, List<int> g) {
    var l = 100000;
    while (l > r.length && g.isNotEmpty) {
      l = r.length;
      if (r.startsWith("#")) {
        r = r.substring(g[0] + 1);
        g.removeAt(0);
      }
      if (r.endsWith("#")) {
        r = r.substring(0, r.length - g.last);
        if (r.isNotEmpty) r = r.substring(0, r.length - 1);
        g.removeLast();
      }
      while (r.startsWith(".")) {
        r = r.substring(1);
      }
      while (r.endsWith(".")) {
        r = r.substring(0, r.length - 1);
      }
      if (r.startsWith("?.") && g.isNotEmpty && g[0] > 1) {
        r = r.substring(2);
      }
      if (r.startsWith("??.") && g.isNotEmpty && g[0] > 2) {
        r = r.substring(3);
      }
      if (r.startsWith("???.") && g.isNotEmpty && g[0] > 3) {
        r = r.substring(4);
      }
      if (r.startsWith("????.") && g.isNotEmpty && g[0] > 4) {
        r = r.substring(5);
      }
      if (r.startsWith("?????.") && g.isNotEmpty && g[0] > 5) {
        r = r.substring(6);
      }
      if (r.startsWith("??????.") && g.isNotEmpty && g[0] > 6) {
        r = r.substring(7);
      }
      if (r.endsWith(".?") && g.isNotEmpty && g.last > 1) {
        r = r.substring(0, r.length - 2);
      }
      if (r.endsWith(".??") && g.isNotEmpty && g.last > 2) {
        r = r.substring(0, r.length - 3);
      }
      if (r.endsWith(".???") && g.isNotEmpty && g.last > 3) {
        r = r.substring(0, r.length - 4);
      }
      if (r.endsWith(".????") && g.isNotEmpty && g.last > 4) {
        r = r.substring(0, r.length - 5);
      }
      if (r.endsWith(".?????") && g.isNotEmpty && g.last > 5) {
        r = r.substring(0, r.length - 6);
      }
      if (r.endsWith(".??????") && g.isNotEmpty && g.last > 6) {
        r = r.substring(0, r.length - 7);
      }
    }
    return (r, g);
  }

  Map<(String, int?, String), int> cache = {};

  int countArrangements2(String record, int? withinRun, List<int> group) {
    if (cache.containsKey((record, withinRun, group.toString()))) {
      return cache[(record, withinRun, group.toString())]!;
    }
    if (record.isEmpty) {
      if (withinRun == null && group.isEmpty) return 1;
      if (withinRun != null && group.length == 1 && withinRun == group[0]) {
        return 1;
      }
      return 0;
    }
    var possibleMore = 0;
    for (var c in record.chars) {
      if (c == "#" || c == "?") {
        possibleMore++;
      }
    }
    if (withinRun != null && possibleMore + withinRun < sum(group)) return 0;
    if (withinRun == null && possibleMore < sum(group)) {
      return 0;
    }
    if (withinRun != null && group.isEmpty) return 0;
    var poss = 0;
    if (record.startsWith(".") && withinRun != null && withinRun != group[0]) {
      return 0;
    }
    if (record.startsWith(".") && withinRun != null) {
      poss += countArrangements2(record.substring(1), null, group.sublist(1));
    }
    if (record.startsWith("?") && withinRun != null && withinRun == group[0]) {
      poss += countArrangements2(record.substring(1), null, group.sublist(1));
    }
    if ((record.startsWith("?") || record.startsWith("#")) &&
        withinRun != null) {
      poss += countArrangements2(record.substring(1), withinRun + 1, group);
    }
    if ((record.startsWith("?") || record.startsWith("#")) &&
        withinRun == null) {
      poss += countArrangements2(record.substring(1), 1, group);
    }
    if ((record.startsWith("?") || record.startsWith(".")) &&
        withinRun == null) {
      poss += countArrangements2(record.substring(1), null, group);
    }
    cache[(record, withinRun, group.toString())] = poss;
    return poss;
  }

  int sum(List<int> group) {
    var s = 0;
    for (var g in group) {
      s += g;
    }
    return s;
  }
}
