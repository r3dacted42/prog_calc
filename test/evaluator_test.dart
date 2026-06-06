import 'package:flutter_test/flutter_test.dart';
import 'package:prog_calc/engine/evaluator.dart';

void main() {
  group('ExpressionEvaluator - Decimal Mode Tests', () {
    test('Should handle basic arithmetic with correct precedence', () {
      expect(Evaluator.evaluate('2+3*4', 'dec'), equals('14'));
      expect(Evaluator.evaluate('(2+3)*4', 'dec'), equals('20'));
      expect(Evaluator.evaluate('10-4/2', 'dec'), equals('8'));
    });

    test('Should handle integer division floor and modulo', () {
      expect(Evaluator.evaluate('7/2', 'dec'), equals('3'));
      expect(Evaluator.evaluate('7%2', 'dec'), equals('1'));
    });

    test('Should show waiting state for incomplete expressions', () {
      expect(Evaluator.evaluate('2+', 'dec'), equals('...'));
      expect(Evaluator.evaluate('(2+3', 'dec'), equals('...'));
    });

    test('Should handle empty inputs', () {
      expect(Evaluator.evaluate('', 'dec'), equals(''));
    });
  });

  group('ExpressionEvaluator - Programmer Base Modes', () {
    test('Binary Mode: should parse inputs and output in base 2', () {
      // 1011 (11) + 101 (5) = 10000 (16)
      expect(Evaluator.evaluate('1011+101', 'bin'), equals('10000'));
    });

    test('Octal Mode: should parse inputs and output in base 8', () {
      // 10 (8) * 7 (7) = 70 (56)
      expect(Evaluator.evaluate('10*7', 'oct'), equals('70'));
    });

    test(
      'Hexadecimal Mode: should parse case-insensitive inputs and output in base 16',
      () {
        // A (10) + f (15) = 19 (25)
        expect(Evaluator.evaluate('A+f', 'hex'), equals('19'));
      },
    );
  });

  group('ExpressionEvaluator - Bitwise Shift Operations', () {
    test('Should handle left shifts (<<)', () {
      // Decimal: 1 << 3 = 8
      expect(Evaluator.evaluate('1<<3', 'dec'), equals('8'));
      // Hex: 2 << 4 = 32 (which is 20 in Hex)
      expect(Evaluator.evaluate('2<<4', 'hex'), equals('20'));
    });

    test('Should handle right shifts (>>)', () {
      // Decimal: 16 >> 2 = 4
      expect(Evaluator.evaluate('16>>2', 'dec'), equals('4'));
    });
  });
}
