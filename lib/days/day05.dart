import '../main.dart';

class Day05 extends Day {
  @override
  bool get completed => false;

  List<SetOfRules> setOfRules = [];
  List<int> seeds = [];

  @override
  void init() {
    List<Rule> rules = [];
    for (var line in inputList) {
      if (line.startsWith("seeds: ")) {
        seeds = line.substring(7).split(" ").map((e) => int.parse(e)).toList();
      }
      if (!line.contains(":") && line != "") {
        var parts = line.split(" ");
        var dest = int.parse(parts[0]);
        var source = int.parse(parts[1]);
        var range = int.parse(parts[2]);
        rules.add(Rule(dest, source, range));
      } else if (rules.isNotEmpty) {
        setOfRules.add(SetOfRules(rules));
        rules = [];
      }
    }
    if (rules.isNotEmpty) {
      setOfRules.add(SetOfRules(rules));
      rules = [];
    }
  }

  @override
  part1() {
    return process();
  }

  process() {
    int min = 1000000000;
    for (var seed in seeds) {
      for (var rule in setOfRules) {
        var newVal = rule.applyRules(seed);
        if (newVal != seed) {
          seed = newVal;
        }
      }
      if (seed < min) {
        min = seed;
      }
    }
    return min;
  }

  @override
  part2() {
    return inverseApproach();
  }

  int inverseApproach() {
    List<(int, int)> ranges = [];
    for (var line in inputList) {
      if (line.startsWith("seeds: ")) {
        var seedData =
            line.substring(7).split(" ").map((e) => int.parse(e)).toList();
        for (int i = 0; i < seedData.length / 2; i++) {
          var range = seedData[i * 2 + 1];
          var from = seedData[i * 2];
          ranges.add((from, from + range));
        }
      }
    }

    int i = 1;
    while (true) {
      var seed = i;
      for (var rule in setOfRules.reversed) {
        var newVal = rule.inverseRules(seed);
        seed = newVal;
      }
      for (var range in ranges) {
        if (seed >= range.$1 && seed <= range.$2) {
          return i;
        }
      }
      i++;
    }
  }
}

class Rule {
  int dest;
  int source;
  int range;

  Rule(this.dest, this.source, this.range);

  @override
  String toString() {
    return "Rule: $dest = $source + $range";
  }
}

class SetOfRules {
  List<Rule> rules = [];

  SetOfRules(this.rules);

  int applyRules(int seed) {
    for (var rule in rules) {
      if (seed >= rule.source && seed <= rule.source + rule.range) {
        return seed + (rule.dest - rule.source);
      }
    }
    return seed;
  }

  int inverseRules(int seed) {
    for (var rule in rules) {
      if (seed >= rule.dest && seed <= rule.dest + rule.range) {
        return seed + (rule.source - rule.dest);
      }
    }
    return seed;
  }

  @override
  String toString() {
    return rules.join("\n");
  }
}
