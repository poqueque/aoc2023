import 'dart:io';

import 'package:aoc2023/extensions/extensions.dart';

import 'days/day01.dart';
import 'days/day02.dart';
import 'days/day03.dart';
import 'days/day04.dart';
import 'days/day05.dart';
import 'days/day06.dart';
import 'days/day07.dart';
import 'days/day08.dart';
import 'days/day09.dart';
import 'days/day10.dart';
import 'days/day11.dart';
import 'days/day12.dart';
import 'days/day13.dart';
import 'days/day14.dart';
import 'days/day15.dart';
import 'days/day16.dart';
import 'days/day17.dart';
import 'days/day18.dart';
import 'days/day19.dart';
import 'days/day20.dart';
import 'days/day21.dart';
import 'days/day22.dart';
import 'days/day23.dart';
import 'days/day24.dart';
import 'days/day25.dart';
import 'utils/coor.dart';

abstract class Day {
  late final List<String> inputList;
  late final String inputString;
  bool completed = false;

  void init() {}

  dynamic part1();

  dynamic part2();

  String get dataFileName => "${runtimeType.toString().toLowerCase()}.txt";

  (Map<Coor, T>, int, int) readGrid<T>() {
    Map<Coor, T> grid = {};
    int maxY = inputList.length;
    int maxX = inputList[0].length;
    for (int j = 0; j < maxY; j++) {
      String line = inputList[j];
      for (int i = 0; i < maxX; i++) {
        if (T is int) {
          grid[Coor(i, j)] = int.parse(line[i]) as T;
        } else if (T is String) {
          grid[Coor(i, j)] = line.chars[i] as T;
        } else {
          print(T.runtimeType.toString());
          throw Exception("Type not supported");
        }
      }
    }
    return (grid, maxX, maxY);
  }

  void main() async {
    inputList = await File("data/$dataFileName").readAsLines();
    inputString = inputList[0];
    init();
    print(part1());
    print(part2());
  }

  Future<void> run1() async {
    inputList = await File("data/$dataFileName").readAsLines();
    inputString = inputList[0];
    init();
    print(part1());
  }

  Future<void> run2() async {
    inputList = await File("data/$dataFileName").readAsLines();
    inputString = inputList[0];
    init();
    print(part2());
  }
}

void main() async {
  print('Advent Of Code 2022 - Dart');
  List<Day> days1 = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
    Day11(),
    Day12(),
    Day13(),
    Day14(),
    Day15(),
    Day16(),
    Day17(),
    Day18(),
    Day19(),
    Day20(),
    Day21(),
    Day22(),
    Day23(),
    Day24(),
    Day25(),
  ];
  List<Day> days2 = [
    Day01(),
    Day02(),
    Day03(),
    Day04(),
    Day05(),
    Day06(),
    Day07(),
    Day08(),
    Day09(),
    Day10(),
    Day11(),
    Day12(),
    Day13(),
    Day14(),
    Day15(),
    Day16(),
    Day17(),
    Day18(),
    Day19(),
    Day20(),
    Day21(),
    Day22(),
    Day23(),
    Day24(),
    Day25(),
  ];
  var dayToRun1 = days1.firstWhere((day) => !day.completed);
  print("Running ${dayToRun1.runtimeType.toString()}");
  await dayToRun1.run1();
  //To avoid error for not resetting the state, we create a new object for each part;
  var dayToRun2 = days2.firstWhere((day) => !day.completed);
  await dayToRun2.run2();
}
