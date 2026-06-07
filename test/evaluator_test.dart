import 'package:flutter_test/flutter_test.dart';
import 'package:prog_calc/engine/evaluator.dart';

void main() {
  group('Evaluator - Decimal Mode Tests', () {
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

  group('Evaluator - Programmer Base Modes', () {
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

  group('Evaluator - Bitwise Shift Operations', () {
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

  group('Evaluator - Convert Expressions', () {
    test('Should handle DEC -> BIN', () {
      expect(Evaluator.convertExpression('5+2', 'dec', 'bin'), '101+10');
      expect(Evaluator.convertExpression('7', 'dec', 'bin'), '111');
    });

    test('Should handle BIN -> DEC', () {
      expect(Evaluator.convertExpression('101+10', 'bin', 'dec'), '5+2');
      expect(Evaluator.convertExpression('111', 'bin', 'dec'), '7');
    });

    test('Should handle DEC -> HEX', () {
      expect(Evaluator.convertExpression('255*16', 'dec', 'hex'), 'ff*10');
      expect(Evaluator.convertExpression('10+5', 'dec', 'hex'), 'a+5');
    });

    test('Should handle HEX -> DEC (Case Insensitive)', () {
      // Ensures that both lowercase and uppercase hex characters are parsed correctly
      expect(Evaluator.convertExpression('ff*10', 'hex', 'dec'), '255*16');
      expect(Evaluator.convertExpression('FF*A', 'hex', 'dec'), '255*10');
    });

    test('Should handle DEC -> OCT', () {
      expect(Evaluator.convertExpression('8+10', 'dec', 'oct'), '10+12');
      expect(Evaluator.convertExpression('64', 'dec', 'oct'), '100');
    });

    test('Should handle OCT -> BIN', () {
      expect(Evaluator.convertExpression('10+12', 'oct', 'bin'), '1000+1010');
    });

    test('Should strictly preserve brackets and bitwise operators', () {
      // Ensures the regex doesn't accidentally consume or break multi-character operators like <<
      expect(
        Evaluator.convertExpression('(10+5)<<2', 'dec', 'bin'),
        '(1010+101)<<10',
      );
      expect(Evaluator.convertExpression('15>>3', 'dec', 'hex'), 'f>>3');
    });

    test(
      'Should safely handle incomplete expressions (Trailing operators)',
      () {
        expect(Evaluator.convertExpression('10+', 'dec', 'bin'), '1010+');
        expect(Evaluator.convertExpression('(15*', 'dec', 'hex'), '(f*');
        expect(Evaluator.convertExpression('10<<', 'dec', 'oct'), '12<<');
      },
    );

    test('Should handle empty inputs', () {
      expect(Evaluator.convertExpression('', 'dec', 'bin'), '');
    });
  });
}
