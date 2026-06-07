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
      return "overflow";
    }
  }

  static String convertExpression(
    String expression,
    String oldMode,
    String newMode,
  ) {
    if (expression.isEmpty) return expression;

    int oldRadix = Grammar.getRadix(oldMode);
    int newRadix = Grammar.getRadix(newMode);

    String pattern = Grammar.getPatternForRadix(oldRadix);

    return expression.replaceAllMapped(RegExp('[$pattern]+'), (match) {
      String numStr = match.group(0)!;
      BigInt? parsed = BigInt.tryParse(numStr, radix: oldRadix);

      if (parsed != null) {
        return parsed.toRadixString(newRadix);
      }
      return numStr;
    });
  }
}
