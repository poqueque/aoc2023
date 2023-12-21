import '../main.dart';

List<(String, String, Pulse)> queue = [];
int counterHigh = 0;
int counterLow = 0;
bool continueLoop = true;
int loops = 0;
int tg = 0;
int kh = 0;
int lz = 0;
int hn = 0;

class Day20 extends Day {
  @override
  bool get completed => true;

  Map<String, Module> modules = {};

  @override
  part1() {
    List<String> destinations = [];
    for (var line in inputList) {
      var module = Module(line);
      modules[module.id] = module;
      for (var destination in module.destinations) {
        if (!destinations.contains(destination)) {
          destinations.add(destination);
        }
      }
    }
    for (var d in destinations) {
      if (!modules.containsKey(d)) {
        modules[d] = Module("$d ->");
      }
    }
    for (var module in modules.values) {
      for (var destination in module.destinations) {
        Module dest = modules[destination]!;
        dest.inputs[module.id] = Pulse.low;
      }
    }
    counterHigh = 0;
    counterLow = 0;
    for (int i = 0; i < 1000; i++) {
      push();
    }
//    print("High: $counterHigh, Low: $counterLow");
    return counterHigh * counterLow;
  }

  push() {
    queue.add(("", "broadcaster", Pulse.low));
    while (queue.isNotEmpty) {
      var data = queue.removeAt(0);
      var module = modules[data.$2]!;
      var pulse = data.$3;
      if (pulse == Pulse.high) {
        counterHigh++;
      } else {
        counterLow++;
      }
      if (data.$2 == "rx" && pulse == Pulse.low) {
        continueLoop = false;
        return;
      }
      module.process(data);
//      print("${data.$1} -${data.$3}-> ${data.$2}");
    }
  }

  @override
  part2() {
    modules.clear();
    List<String> destinations = [];
    for (var line in inputList) {
      var module = Module(line);
      modules[module.id] = module;
      for (var destination in module.destinations) {
        if (!destinations.contains(destination)) {
          destinations.add(destination);
        }
      }
    }
    for (var d in destinations) {
      if (!modules.containsKey(d)) {
        modules[d] = Module("$d ->");
      }
    }
    for (var module in modules.values) {
      for (var destination in module.destinations) {
        Module dest = modules[destination]!;
        dest.inputs[module.id] = Pulse.low;
      }
    }
    while (continueLoop) {
      loops++;
      if (loops % 1000000 == 0) print('${loops / 1000000}M');
      push();
      if (tg > 0 && kh > 0 && lz > 0 && hn > 0) {
        return tg * kh * lz * hn;
      }
    }
    return loops;
  }
}

class Module {
  late String id;
  List<String> destinations = [];
  late ModuleType type;
  ModuleState state = ModuleState.off;
  Map<String, Pulse> inputs = {};

  Module(String input) {
    var parts = input.split(" ");
    id = parts[0];
    if (parts[0].startsWith("%")) {
      type = ModuleType.flipFlop;
      id = id.substring(1);
    } else if (parts[0].startsWith("&")) {
      type = ModuleType.conjunction;
      id = id.substring(1);
    } else {
      type = ModuleType.broadcast;
    }
    for (var i = 2; i < parts.length; i++) {
      destinations.add(parts[i].replaceAll(",", ""));
    }
  }

  void process((String, String, Pulse) data) {
    String from = data.$1;
    Pulse pulse = data.$3;
    if (from.isNotEmpty) inputs[from] = pulse;
    if (type == ModuleType.flipFlop) {
      if (pulse == Pulse.low) {
        if (state == ModuleState.on) {
          state = ModuleState.off;
          for (var to in destinations) {
            queue.add((id, to, Pulse.low));
          }
        } else {
          state = ModuleState.on;
          for (var to in destinations) {
            queue.add((id, to, Pulse.high));
          }
        }
      }
    } else if (type == ModuleType.conjunction) {
      if (inputs.values.contains(Pulse.low)) {
        for (var to in destinations) {
//          if (id == "kh" || id == "lz" || id == "hn" || id == "tg") {
//            print("$id: $loops");
//          }
          if (id == "tg" && tg == 0) tg = loops;
          if (id == "kh" && kh == 0) kh = loops;
          if (id == "lz" && lz == 0) lz = loops;
          if (id == "hn" && hn == 0) hn = loops;
          queue.add((id, to, Pulse.high));
        }
      } else {
        for (var to in destinations) {
          queue.add((id, to, Pulse.low));
        }
      }
    } else {
      for (var to in destinations) {
        queue.add((id, to, pulse));
      }
    }
  }
}

enum ModuleType { flipFlop, conjunction, broadcast }

enum ModuleState { on, off }

enum Pulse { high, low }
