import 'package:collection/collection.dart';

import '../main.dart';

class Day07 extends Day {
  @override
  bool get completed => true;

  List<Hand> hands = [];
  List<HandJ> handsJ = [];

  @override
  void init() {
    for (var line in inputList) {
      hands.add(Hand(line));
      handsJ.add(HandJ(line));
    }
  }

  @override
  part1() {
    hands.sort();
    int winnings = 0;
    for (int i = 0; i < hands.length; i++) {
      var hand = hands[i];
      winnings += hand.bid * (i + 1);
    }
    return winnings;
  }

  @override
  part2() {
    handsJ.sort();
    int winnings = 0;
    for (int i = 0; i < handsJ.length; i++) {
      var hand = handsJ[i];
      winnings += hand.bid * (i + 1);
    }
    return winnings;
  }
}

class Hand implements Comparable<Hand> {
  late String cards;
  late int bid;
  late int handType;

  static const int highCard = 0;
  static const int pair = 1;
  static const int twoPair = 2;
  static const int threeOfAKind = 3;
  static const int fullHouse = 4;
  static const int fourOfAKind = 5;
  static const int fiveOfAKind = 6;

  Hand(String line) {
    var split = line.split(' ');
    cards = split[0];
    cards = cards.replaceAll("T", "B");
    cards = cards.replaceAll("J", "C");
    cards = cards.replaceAll("Q", "D");
    cards = cards.replaceAll("K", "E");
    cards = cards.replaceAll("A", "F");
    bid = int.parse(split[1]);
    var orderedHand = cards.split('').toList()..sort();
    var lastCard = '';
    var repeated = 1;
    var groups = [];

    for (var card in orderedHand) {
      if (card == lastCard) {
        repeated++;
      } else {
        if (repeated > 1) groups.add(repeated);
        repeated = 1;
      }
      lastCard = card;
    }
    if (repeated > 1) {
      groups.add(repeated);
    }
    groups.sort();
    Function eq = const ListEquality().equals;
    if (eq(groups, [2])) {
      handType = pair;
    } else if (eq(groups, [2, 2])) {
      handType = twoPair;
    } else if (eq(groups, [3])) {
      handType = threeOfAKind;
    } else if (eq(groups, [2, 3])) {
      handType = fullHouse;
    } else if (eq(groups, [4])) {
      handType = fourOfAKind;
    } else if (eq(groups, [5])) {
      handType = fiveOfAKind;
    } else {
      handType = highCard;
    }
  }

  @override
  int compareTo(Hand other) {
    if (handType > other.handType) {
      return 1;
    } else if (handType < other.handType) {
      return -1;
    } else {
      return cards.compareTo(other.cards);
    }
  }
}

class HandJ implements Comparable<HandJ> {
  late String cards;
  late int bid;
  late int handType;

  static const int highCard = 0;
  static const int pair = 1;
  static const int twoPair = 2;
  static const int threeOfAKind = 3;
  static const int fullHouse = 4;
  static const int fourOfAKind = 5;
  static const int fiveOfAKind = 6;

  HandJ(String line) {
    var split = line.split(' ');
    cards = split[0];
    cards = cards.replaceAll("T", "B");
    cards = cards.replaceAll("J", "1");
    cards = cards.replaceAll("Q", "D");
    cards = cards.replaceAll("K", "E");
    cards = cards.replaceAll("A", "F");
    bid = int.parse(split[1]);
    var orderedHand = cards.split('').toList()..sort();
    var lastCard = '';
    var repeated = 1;
    var groups = [];
    var jokers = 0;

    for (var card in orderedHand) {
      if (card == "1") {
        jokers++;
      }
      if (card == lastCard) {
        repeated++;
      } else {
        if (repeated > 1 && lastCard != "1") groups.add(repeated);
        repeated = 1;
      }
      lastCard = card;
    }
    if (repeated > 1 && lastCard != "1") {
      groups.add(repeated);
    }
    Function eq = const ListEquality().equals;
    if (jokers > 0) {
      if (eq(groups, [2])) {
        groups = [2 + jokers];
      } else if (eq(groups, [2, 2])) {
        groups = [2 + jokers, 2];
      } else if (eq(groups, [3])) {
        groups = [3 + jokers];
      } else if (eq(groups, [2, 3])) {
        groups = [2, 3 + jokers];
      } else if (eq(groups, [4])) {
        groups = [4 + jokers];
      } else if (eq(groups, [5])) {
        groups = [5 + jokers];
      } else if (jokers == 5) {
        groups = [jokers];
      } else {
        groups = [jokers + 1];
      }
    }
    groups.sort();
    if (eq(groups, [2])) {
      handType = pair;
    } else if (eq(groups, [2, 2])) {
      handType = twoPair;
    } else if (eq(groups, [3])) {
      handType = threeOfAKind;
    } else if (eq(groups, [2, 3])) {
      handType = fullHouse;
    } else if (eq(groups, [4])) {
      handType = fourOfAKind;
    } else if (eq(groups, [5])) {
      handType = fiveOfAKind;
    } else {
      handType = highCard;
    }
  }

  @override
  int compareTo(HandJ other) {
    if (handType > other.handType) {
      return 1;
    } else if (handType < other.handType) {
      return -1;
    } else {
      return cards.compareTo(other.cards);
    }
  }
}
