import 'package:aoc2023/extensions/extensions.dart';

import '../main.dart';

class Day13 extends Day {
  @override
  bool get completed => true;

  @override
  void init() {}

  @override
  part1() {
    List<String> data = [];
    List<String> dataT = [];
    int total = 0;
    for (var line in inputList) {
      if (line.isEmpty) {
        var mirror = getMirror(data, dataT, -1);
        total += mirror;
        data = [];
        dataT = [];
        continue;
      }
      data.add(line);
      if (dataT.isEmpty) {
        dataT = line.split('');
      }
      List<String> s = line.chars;
      for (var i = 0; i < s.length; i++) {
        dataT[i] += s[i];
      }
    }
    return total;
  }

  @override
  part2() {
    List<String> data = [];
    List<String> dataT = [];
    int total = 0;
    for (var line in inputList) {
      if (line.isEmpty) {
        var mirror = getMirror(data, dataT, -1);
        var smudgeMirror = 0;
        for (var i = 0; i < data.length; i++) {
          for (var j = 0; j < data[i].length; j++) {
            var dataS = data.toList();
            var dataST = dataT.toList();
            if (data[i].chars[j] == '#') {
              dataS[i] = dataS[i].changeAt(j, '.');
              dataST[j] = dataST[j].changeAt(i, '.');
            } else {
              dataS[i] = dataS[i].changeAt(j, '#');
              dataST[j] = dataST[j].changeAt(i, '#');
            }
            var sm = getMirror(dataS, dataST, mirror);
            if (sm > 0 && sm != mirror) {
              smudgeMirror = sm;
            }
          }
        }
        total += smudgeMirror;
        data = [];
        dataT = [];
        continue;
      }
      data.add(line);
      if (dataT.isEmpty) {
        dataT = line.split('');
      } else {
        List<String> s = line.chars;
        for (var i = 0; i < s.length; i++) {
          dataT[i] += s[i];
        }
      }
    }
    return total;
  }

  int getMirror(List<String> data, List<String> dataT, int notValid) {
    var total = 0;
    for (int i = 0; i < data.length; i++) {
      bool found = true;
      int eq = 0;
      for (int j = 0; j <= i; j++) {
        if (data.length > i + j + 1) {
          eq++;
          if (data[i - j] != data[i + j + 1]) {
            found = false;
            break;
          }
        }
      }
      if (found && eq > 0 && (100 * (i + 1) != notValid)) {
        return 100 * (i + 1);
      }
    }

    for (int i = 0; i < dataT.length; i++) {
      bool found = true;
      int eq = 0;
      for (int j = 0; j <= i; j++) {
        if (dataT.length > i + j + 1) {
          eq++;
          if (dataT[i - j] != dataT[i + j + 1]) {
            found = false;
            break;
          }
        }
      }
      if (found && eq > 0 && (i + 1 != notValid)) {
        total += i + 1;
      }
    }
    return total;
  }
}

int getMirrorSmudge(List<String> data, List<String> dataT) {
  var total = 0;
  for (int i = 0; i < data.length; i++) {
    bool found = true;
    int eq = 0;
    for (int j = 0; j <= i; j++) {
      if (data.length > i + j + 1) {
        eq++;
        if (data[i - j] != data[i + j + 1] &&
            !differInOne(data[i - j], data[i + j + 1])) {
          found = false;
          break;
        }
      }
    }
    if (found && eq > 0) {
      total += 100 * (i + 1);
    }
  }

  for (int i = 0; i < dataT.length; i++) {
    bool found = true;
    int eq = 0;
    for (int j = 0; j <= i; j++) {
      if (dataT.length > i + j + 1) {
        eq++;
        if (dataT[i - j] != dataT[i + j + 1] &&
            !differInOne(dataT[i - j], dataT[i + j + 1])) {
          found = false;
          break;
        }
      }
    }
    if (found && eq > 0) {
      total += i + 1;
    }
  }
  return total;
}

//Check if the difference is only one
bool differInOne(String a, String b) {
  int diff = 0;
  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      diff++;
    }
  }
  return diff == 1;
}
