import '../main.dart';

class Day06 extends Day {
  @override
  bool get completed => false;
  List<int> times = [];
  List<int> distances = [];

  @override
  init() {
    times = inputList[0].split(' ').map((e) => int.parse(e)).toList();
    distances = inputList[1].split(' ').map((e) => int.parse(e)).toList();
  }

  @override
  part1() {
    int product = 1;
    for (int i = 0; i < times.length; i++) {
      int waysToWin = 0;
      int time = times[i];
      int distance = distances[i];
      for (int j = 0; j < time; j++) {
        int speed = j;
        int distanceTraveled = speed * (time - j);
        if (distanceTraveled > distance) {
          waysToWin++;
        }
      }
      product *= waysToWin;
    }
    return product;
  }

  @override
  part2() {
    int waysToWin = 0;
    int time = 47847467;
    int distance = 207139412091014;
    for (int j = 0; j < time; j++) {
      int speed = j;
      int distanceTraveled = speed * (time - j);
      if (distanceTraveled > distance) {
        waysToWin++;
      }
    }
    return waysToWin;
  }
}
