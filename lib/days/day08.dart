import '../main.dart';

class Day08 extends Day {
  @override
  bool get completed => true;

  String instructions = "";
  Map<String, (String, String)> moves = {};

  @override
  void init() {
    instructions = inputList[0];
    for (var line in inputList) {
      if (line.contains("=")) {
        var node = line.split("=")[0].trim();
        var move =
            line.split("=")[1].trim().replaceAll("(", "").replaceAll(")", "");
        var listMoves = move.split(",");
        moves[node] = (listMoves[0].trim(), listMoves[1].trim());
      }
    }
  }

  @override
  part1() {
    var steps = 0;
    var node = "AAA";
    while (node != "ZZZ") {
      var move = moves[node]!;
      var direction = instructions[steps % instructions.length];
      if (direction == "R") {
        node = move.$2;
      } else if (direction == "L") {
        node = move.$1;
      }
      steps++;
    }
    return steps;
    //return 0;
  }

  @override
  part2() {
    var nodes = <String>[];
    for (var node in moves.keys) {
      if (node.endsWith("A")) {
        nodes.add(node);
      }
    }
    var stepList = <int>[];

    for (var i = 0; i < nodes.length; i++) {
      var steps = 0;
      var node = nodes[i];
      while (!node.endsWith("Z")) {
        var move = moves[node]!;
        var direction = instructions[steps % instructions.length];
        if (direction == "R") {
          node = move.$2;
        } else if (direction == "L") {
          node = move.$1;
        }
        steps++;
      }
      stepList.add(steps);
    }
    return lcm(stepList);
  }
}

// Encuentra el mínimo común múltiplo de una lista de enteros
int lcm(List<int> numbers) {
  int result = numbers[0];
  for (int i = 1; i < numbers.length; i++) {
    result = (result * numbers[i]) ~/ gcd(result, numbers[i]);
  }
  return result;
}

// Encuentra el máximo común divisor de dos enteros
int gcd(int a, int b) {
  if (a == 0) return b;
  return gcd(b % a, a);
}
