import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';

class Day01 extends Day {
  @override
  bool get completed => true;

  @override
  part1() {
    int total = 0;
    for (var element in inputList) {
      int firstNumber = 0;
      int lastNumber = 0;
      for (var element2 in element.chars) {
        if (int.tryParse(element2) != null) {
          lastNumber = int.parse(element2);
          if (firstNumber == 0) {
            firstNumber = lastNumber;
          }
        }
      }
      total = total + (firstNumber * 10 + lastNumber);
    }
    return total;
  }

  @override
  part2() {
    int total = 0;
    for (var element in inputList) {
      int firstNumber = 0;
      int lastNumber = 0;
      (firstNumber, lastNumber) = replaceNumbers(element);
      total = (total + int.parse("$firstNumber$lastNumber"));
    }
    return total;
  }

  (int, int) replaceNumbers(String element) {
    int? first;
    int last = 0;
    for (int i = 0; i < element.length; i++) {
      if (int.tryParse(element[i]) != null) {
        first ??= int.parse(element[i]);
        last = int.parse(element[i]);
      }
      var test = element.substring(i);
      if (test.startsWith('ten')) {
        first ??= 1;
        last = 0;
      }
      if (test.startsWith('eleven')) {
        first ??= 1;
        last = 1;
      }
      if (test.startsWith('twelve')) {
        first ??= 1;
        last = 2;
      }
      if (test.startsWith('thirteen')) {
        first ??= 1;
        last = 3;
      }
      if (test.startsWith('fourteen')) {
        first ??= 1;
        last = 4;
      }
      if (test.startsWith('fifteen')) {
        first ??= 1;
        last = 5;
      }
      if (test.startsWith('sixteen')) {
        first ??= 1;
        last = 6;
      }
      if (test.startsWith('seventeen')) {
        first ??= 1;
        last = 7;
      }
      if (test.startsWith('eighteen')) {
        first ??= 1;
        last = 8;
      }
      if (test.startsWith('nineteen')) {
        first ??= 1;
        last = 9;
      }
      if (test.startsWith('twenty')) {
        first ??= 2;
        last = 0;
      }
      if (test.startsWith('zero')) {
        first ??= 0;
        last = 0;
      }
      if (test.startsWith('one')) {
        first ??= 1;
        last = 1;
      }
      if (test.startsWith('two')) {
        first ??= 2;
        last = 2;
      }
      if (test.startsWith('three')) {
        first ??= 3;
        last = 3;
      }
      if (test.startsWith('four')) {
        first ??= 4;
        last = 4;
      }
      if (test.startsWith('five')) {
        first ??= 5;
        last = 5;
      }
      if (test.startsWith('six')) {
        first ??= 6;
        last = 6;
      }
      if (test.startsWith('seven')) {
        first ??= 7;
        last = 7;
      }
      if (test.startsWith('eight')) {
        first ??= 8;
        last = 8;
      }
      if (test.startsWith('nine')) {
        first ??= 9;
        last = 9;
      }
    }
    return (first!, last);
  }
}
