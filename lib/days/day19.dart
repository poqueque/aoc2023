import '../main.dart';

class Day19 extends Day {
  @override
  bool get completed => true;

  Map<String, WorkFlow> workflows = {};
  List<Part> parts = [];

  @override
  init() {
    for (var line in inputList) {
      if (line.startsWith("{")) {
        parts.add(Part(line));
      } else if (line.isNotEmpty) {
        var w = WorkFlow(line);
        workflows[w.id] = w;
      }
    }
  }

  @override
  part1() {
    var xs = 0;
    var ms = 0;
    var as = 0;
    var ss = 0;
    var total = 0;
    for (var part in parts) {
      var workflow = workflows["in"]!;
      var dest = "";
      while (dest != "A" && dest != "R") {
        dest = workflow.get(part);
        if (dest == "A") {
          xs += part.x;
          ms += part.m;
          as += part.a;
          ss += part.s;
          total = xs + ms + as + ss;
        } else if (dest != "R") {
          workflow = workflows[dest]!;
        }
      }
    }
    return total;
  }

  @override
  part2() {
    WorkFlow workflow;
    PartRange range = PartRange();
    List<(PartRange, String)> toProcess = [(range, "in")];
    var totalA = 0;
    var totalR = 0;
    while (toProcess.isNotEmpty) {
      var (r, w) = toProcess.removeAt(0);
      workflow = workflows[w]!;
      List<(PartRange, String)> ranges = workflow.getRanges(r);
      for (var (r, w) in ranges) {
        if (w == "A") {
          totalA += r.total;
        } else if (w == "R") {
          totalR += r.total;
        } else {
          toProcess.add((r, w));
        }
      }
    }
    return totalA;
  }
}

class Part {
  late int x, m, a, s;

  Part(line) {
    var parts = line.split(",");
    x = int.parse(
        parts[0].replaceAll("x", "").replaceAll("=", "").replaceAll("{", ""));
    m = int.parse(parts[1].replaceAll("m", "").replaceAll("=", ""));
    a = int.parse(parts[2].replaceAll("a", "").replaceAll("=", ""));
    s = int.parse(
        parts[3].replaceAll("s", "").replaceAll("=", "").replaceAll("}", ""));
  }
}

class PartRange {
  int x0 = 1;
  int x1 = 4000;
  int m0 = 1;
  int m1 = 4000;
  int a0 = 1;
  int a1 = 4000;
  int s0 = 1;
  int s1 = 4000;

  int get total =>
      (x1 - x0 + 1) * (m1 - m0 + 1) * (a1 - a0 + 1) * (s1 - s0 + 1);

  (PartRange, PartRange) splitX(int value) {
    var r1 = PartRange();
    var r2 = PartRange();
    r1.x0 = x0;
    r1.x1 = value;
    r2.x0 = value + 1;
    r2.x1 = x1;
    r1.m0 = m0;
    r1.m1 = m1;
    r2.m0 = m0;
    r2.m1 = m1;
    r1.a0 = a0;
    r1.a1 = a1;
    r2.a0 = a0;
    r2.a1 = a1;
    r1.s0 = s0;
    r1.s1 = s1;
    r2.s0 = s0;
    r2.s1 = s1;
    return (r1, r2);
  }

  (PartRange, PartRange) splitM(int value) {
    var r1 = PartRange();
    var r2 = PartRange();
    r1.x0 = x0;
    r1.x1 = x1;
    r2.x0 = x0;
    r2.x1 = x1;
    r1.m0 = m0;
    r1.m1 = value;
    r2.m0 = value + 1;
    r2.m1 = m1;
    r1.a0 = a0;
    r1.a1 = a1;
    r2.a0 = a0;
    r2.a1 = a1;
    r1.s0 = s0;
    r1.s1 = s1;
    r2.s0 = s0;
    r2.s1 = s1;
    return (r1, r2);
  }

  (PartRange, PartRange) splitA(int value) {
    var r1 = PartRange();
    var r2 = PartRange();
    r1.x0 = x0;
    r1.x1 = x1;
    r2.x0 = x0;
    r2.x1 = x1;
    r1.m0 = m0;
    r1.m1 = m1;
    r2.m0 = m0;
    r2.m1 = m1;
    r1.a0 = a0;
    r1.a1 = value;
    r2.a0 = value + 1;
    r2.a1 = a1;
    r1.s0 = s0;
    r1.s1 = s1;
    r2.s0 = s0;
    r2.s1 = s1;
    return (r1, r2);
  }

  (PartRange, PartRange) splitS(int value) {
    var r1 = PartRange();
    var r2 = PartRange();
    r1.x0 = x0;
    r1.x1 = x1;
    r2.x0 = x0;
    r2.x1 = x1;
    r1.m0 = m0;
    r1.m1 = m1;
    r2.m0 = m0;
    r2.m1 = m1;
    r1.a0 = a0;
    r1.a1 = a1;
    r2.a0 = a0;
    r2.a1 = a1;
    r1.s0 = s0;
    r1.s1 = value;
    r2.s0 = value + 1;
    r2.s1 = s1;
    return (r1, r2);
  }

  @override
  String toString() {
    return "x: $x0-$x1, m: $m0-$m1, a: $a0-$a1, s: $s0-$s1";
  }
}

class WorkFlow {
  late String id;
  late List<Rule> rules = [];
  late String elseRule;

  WorkFlow(String line) {
    var parts = line.split("{");
    id = parts[0];
    var parts2 = parts[1].replaceAll("}", "").split(",");
    for (var i = 0; i < parts2.length - 1; i++) {
      rules.add(Rule(parts2[i]));
    }
    elseRule = parts2[parts2.length - 1];
  }

  String get(Part part) {
    for (var rule in rules) {
      var dest = getRule(rule, part);
      if (dest != null) {
        return dest;
      }
    }
    return elseRule;
  }

  String? getRule(Rule rule, Part part) {
    if (rule.category == "x") {
      if (rule.comparison == "<") {
        if (part.x < rule.value) {
          return rule.to;
        }
      } else if (rule.comparison == ">") {
        if (part.x > rule.value) {
          return rule.to;
        }
      }
    } else if (rule.category == "m") {
      if (rule.comparison == "<") {
        if (part.m < rule.value) {
          return rule.to;
        }
      } else if (rule.comparison == ">") {
        if (part.m > rule.value) {
          return rule.to;
        }
      }
    } else if (rule.category == "a") {
      if (rule.comparison == "<") {
        if (part.a < rule.value) {
          return rule.to;
        }
      } else if (rule.comparison == ">") {
        if (part.a > rule.value) {
          return rule.to;
        }
      }
    } else if (rule.category == "s") {
      if (rule.comparison == "<") {
        if (part.s < rule.value) {
          return rule.to;
        }
      } else if (rule.comparison == ">") {
        if (part.s > rule.value) {
          return rule.to;
        }
      }
    }
    return null;
  }

  List<(PartRange, String)> getRanges(PartRange r) {
    var ranges = <(PartRange, String)>[];
    for (var rule in rules) {
      if (rule.category == "x" && rule.comparison == "<") {
        var splittedRanges = r.splitX(rule.value - 1);
        ranges.add((splittedRanges.$1, rule.to));
        r = splittedRanges.$2;
      }
      if (rule.category == "x" && rule.comparison == ">") {
        var splittedRanges = r.splitX(rule.value);
        ranges.add((splittedRanges.$2, rule.to));
        r = splittedRanges.$1;
      }
      if (rule.category == "m" && rule.comparison == "<") {
        var splittedRanges = r.splitM(rule.value - 1);
        ranges.add((splittedRanges.$1, rule.to));
        r = splittedRanges.$2;
      }
      if (rule.category == "m" && rule.comparison == ">") {
        var splittedRanges = r.splitM(rule.value);
        ranges.add((splittedRanges.$2, rule.to));
        r = splittedRanges.$1;
      }
      if (rule.category == "a" && rule.comparison == "<") {
        var splittedRanges = r.splitA(rule.value - 1);
        ranges.add((splittedRanges.$1, rule.to));
        r = splittedRanges.$2;
      }
      if (rule.category == "a" && rule.comparison == ">") {
        var splittedRanges = r.splitA(rule.value);
        ranges.add((splittedRanges.$2, rule.to));
        r = splittedRanges.$1;
      }
      if (rule.category == "s" && rule.comparison == "<") {
        var splittedRanges = r.splitS(rule.value - 1);
        ranges.add((splittedRanges.$1, rule.to));
        r = splittedRanges.$2;
      }
      if (rule.category == "s" && rule.comparison == ">") {
        var splittedRanges = r.splitS(rule.value);
        ranges.add((splittedRanges.$2, rule.to));
        r = splittedRanges.$1;
      }
    }
    ranges.add((r, elseRule));
    return ranges;
  }
}

class Rule {
  late String category;
  late String comparison;
  late int value;
  late String to;

  Rule(String line) {
    var parts = line.split(":");
    to = parts[1];
    var parts2 = parts[0].split("<");
    if (parts2.length == 2) {
      category = parts2[0];
      comparison = "<";
      value = int.parse(parts2[1]);
    }
    parts2 = parts[0].split(">");
    if (parts2.length == 2) {
      category = parts2[0];
      comparison = ">";
      value = int.parse(parts2[1]);
    }
  }
}
