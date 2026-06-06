import 'package:petitparser/petitparser.dart';
import 'package:prog_calc/engine/grammar.dart';

class Evaluator {
  static String evaluate(String input, String inputMode) {
    if (input.trim().isEmpty) return '';

    if (RegExp(r'[%\*\-\+\/><(]$').hasMatch(input.trim())) {
      return "...";
    }

    try {
      final parser = Grammar.buildParser(inputMode);
      final result = parser.parse(input.trim());

      switch (result) {
        case Success(:final value):
          return value.toRadixString(Grammar.getRadix(inputMode));
        case Failure():
          return "invalid";
      }
    } catch (e) {
      print(e);
      return "overflow";
    }
  }
}
