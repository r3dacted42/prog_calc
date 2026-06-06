import 'package:petitparser/petitparser.dart';

class Grammar {
  static Parser<BigInt> buildParser(String mode) {
    final int radix = getRadix(mode);
    final builder = ExpressionBuilder<BigInt>();

    final numberParser = _getPatternForRadix(
      radix,
    ).plus().flatten().map((value) => BigInt.parse(value, radix: radix));

    builder.primitive(
      numberParser
          .or(char('(').trim() & builder.loopback & char(')').trim())
          .map((value) {
            if (value is List) {
              return value[1] as BigInt;
            }
            return value as BigInt;
          }),
    );

    builder.group()
      ..left(string('<<').trim(), (a, op, b) => a << b.toInt())
      ..left(string('>>').trim(), (a, op, b) => a >> b.toInt());

    builder.group()
      ..left(char('*').trim(), (a, op, b) => a * b)
      ..left(char('/').trim(), (a, op, b) => (a ~/ b))
      ..left(char('%').trim(), (a, op, b) => a % b);

    builder.group()
      ..left(char('+').trim(), (a, op, b) => a + b)
      ..left(char('-').trim(), (a, op, b) => a - b);

    return builder.build().end();
  }

  static int getRadix(String mode) {
    switch (mode) {
      case 'bin':
        return 2;
      case 'oct':
        return 8;
      case 'hex':
        return 16;
      default:
        return 10;
    }
  }

  static Parser _getPatternForRadix(int radix) {
    switch (radix) {
      case 2:
        return pattern('01');
      case 8:
        return pattern('0-7');
      case 16:
        return pattern('0-9a-fA-F');
      default:
        return pattern('0-9');
    }
  }
}
