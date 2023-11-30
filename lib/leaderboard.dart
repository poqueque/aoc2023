import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;

void main() async {
  var year = 2023;
  print("Advent of Code $year - Leaderboard");
  String? textData;
  File file = File("_leaderboard_$year.txt");
  if (await file.exists()) {
    if (DateTime.now().millisecondsSinceEpoch -
            (await file.lastModified()).millisecondsSinceEpoch <
        900000) textData = file.readAsStringSync();
  }

  if (textData == null) {
    var response = await http.get(
        Uri.parse(
            "https://adventofcode.com/$year/leaderboard/private/view/637864.json"),
        headers: {
          "Cookie":
              "session=53616c7465645f5ffa8df43c1552ef50ffb4d3093206e4984c3d36c84176a2a33c2364dff16c00ea046e47b6f1907521a115ba9364e6a602092221752cdc49fc"
        });
    textData = response.body;
    print(textData);
    File("_leaderboard_$year.txt").writeAsStringSync(textData);
  }

  var leaderboard = jsonDecode(textData);
  var completedDays = <String, int>{};
  var totalTime = <String, int>{};
  var maxDays = 0;
  if (leaderboard != null) {
    year = int.parse(leaderboard['event']);
    var members = (leaderboard['members'] as Map<String, dynamic>).length;
    var standings = <String, int>{};
    var lastDay = <String, int>{};
    print("Leaderboard $year");
    for (var day = 1; day <= 25; day++) {
      var calendar = DateTime(year, 12, day);
      var millis = calendar.millisecondsSinceEpoch + 6 * 3600000;

      var dayPoints = <String, int>{};
      var clasif1 = <String, int>{};
      var clasif2 = <String, int>{};
      var membersList = leaderboard['members'].values.toList();

      for (var member in membersList) {
        if (member["completion_day_level"].containsKey(day.toString())) {
          var name = member['name'] ?? "<Unknown ${member['id']}>";
          var value1 = member["completion_day_level"][day.toString()]?['1']
                      ?['get_star_ts']
                  ?.toInt() ??
              0;
          var value2 = member["completion_day_level"][day.toString()]?['2']
                      ?['get_star_ts']
                  ?.toInt() ??
              0;
          if (value1 != 0) clasif1[name] = min(value1 - millis ~/ 1000, 86400);
          if (value2 != 0) clasif2[name] = min(value2 - millis ~/ 1000, 86400);
        }
      }
      var sortedClasif1 = Map.fromEntries(clasif1.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)));
      var sortedClasif2 = Map.fromEntries(clasif2.entries.toList()
        ..sort((e1, e2) => e1.value.compareTo(e2.value)));

      if (sortedClasif1.isNotEmpty || sortedClasif2.isNotEmpty) {
        var points = members;
        for (var it in sortedClasif1.entries) {
          standings[it.key] = (standings[it.key] ?? 0) + points;
          dayPoints[it.key] = points;
          points--;
        }
        points = members;
        for (var it in sortedClasif2.entries) {
          standings[it.key] = (standings[it.key] ?? 0) + points;
          dayPoints[it.key] = (dayPoints[it.key] ?? 0) + points;
          points--;
        }
        lastDay = dayPoints;
      }

      if (sortedClasif1.isNotEmpty || sortedClasif2.isNotEmpty) {
        print("Day $day");
        print("======");
        print("");
        print("[First Star]");
        for (var it in sortedClasif1.entries) {
          print("${it.key} - ${humanReadable(it.value)}");
          var cd = (completedDays[it.key] ?? 0) + 1;
          completedDays[it.key] = cd;
          if (cd > maxDays) maxDays = cd;
          totalTime[it.key] = (totalTime[it.key] ?? 0) + it.value;
        }
        print("");
        print("[Second Star]");
        for (var it in sortedClasif2.entries) {
          print("${it.key} - ${humanReadable(it.value)}");
          var cd = (completedDays[it.key] ?? 0) + 1;
          completedDays[it.key] = cd;
          if (cd > maxDays) maxDays = cd;
          totalTime[it.key] = (totalTime[it.key] ?? 0) + it.value;
        }
        print("");
      }
    }

    //Official
    var sortedOfficial = Map.fromEntries(standings.entries.toList()
      ..sort((e1, e2) => -e1.value.compareTo(e2.value)));
    print("OFFICIAL");
    for (var it in sortedOfficial.entries) {
      if (completedDays[it.key] == maxDays) {
        print("${it.key} - ${it.value} (${lastDay[it.key] ?? 0})");
      } else {
        print(
            "${it.key} - ${it.value} [-${maxDays - (completedDays[it.key] ?? 0)}]");
      }
    }

    print("");

    //General
    var sortedGeneral = Map.fromEntries(totalTime.entries.toList()
      ..sort((e1, e2) => e1.value.compareTo(e2.value)));
    print("GENERAL");
    for (var it in sortedGeneral.entries) {
      if (completedDays[it.key] == maxDays) {
        print("${it.key} - ${humanReadable(it.value)}");
      }
      if (completedDays[it.key] == maxDays - 1) {
        print("${it.key} - ${humanReadable(it.value)} [-1]");
      }
      if (completedDays[it.key] == maxDays - 2) {
        print("${it.key} - ${humanReadable(it.value)} [-2]");
      }
    }
  }
}

String humanReadable(int spent) {
  var sec = spent;
  var min = spent ~/ 60;
  sec -= min * 60;
  var hour = min ~/ 60;
  min -= hour * 60;
  var retVal = "";
  if (hour > 0) retVal += "$hour:";
  retVal += "${min.toString().padLeft(2, '0')}:";
  retVal += sec.toString().padLeft(2, '0');
  return retVal;
}
