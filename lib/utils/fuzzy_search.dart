import 'dart:collection';

import 'package:flutter/cupertino.dart';

@immutable
class FuzzySearch<T> {
  const FuzzySearch({
    required this.data,
    this.elementToString,
    this.minimumScore = 2,
  });
  final List<T> data;
  final String Function(T)? elementToString;
  final int minimumScore;

  List<String> whiteSpaceTokenizer(String s) =>
      s.toLowerCase().split(RegExp('\\s+'))
        ..removeWhere((element) => element.isEmpty);

  Iterable<T> search(String term) {
    if (term.isEmpty) {
      return <T>[];
    }

    List<String> searchTerms = whiteSpaceTokenizer(term);

    // Store our results with their score
    Map<T, int> results = <T, int>{};
    for (T element in data) {
      String elementText = elementToString?.call(element) ?? element.toString();
      List<String> elementTerms = whiteSpaceTokenizer(elementText);
      for (String term in searchTerms) {
        for (String key in elementTerms) {
          int score = _searchWord(key, term);
          if (score > 0) {
            int currentScore = results[element] ?? 0;
            results[element] = currentScore + score;
          }
        }
      }
    }

    results.removeWhere((key, value) => value < minimumScore);

    var sortedKeys = results.keys.toList(growable: false)
      ..sort((k1, k2) => results[k2]!.compareTo(results[k1]!));
    LinkedHashMap<T, int> sortedMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => results[k]!);
    return sortedMap.keys;
  }

  int _searchWord(String key, String term) {
    int ti = 0; // Number of matching letters in term
    for (int si = 0; si < key.length; si++) {
      if (term[ti] == key[si]) {
        ti++;
        if (ti == term.length) {
          return ti;
        }
      }
    }
    return 0;
  }
}
