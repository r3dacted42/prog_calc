import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'calc_keypad.dart';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class MemoryItem {
  String input = "";
  String output = "";

  Widget makeListTile(
    BuildContext context,
    Function(String, String) onPressed,
    Function() onDelete,
  ) {
    return ListTile(
      title: Text(input),
      subtitle: Text("=$output"),
      titleTextStyle: Theme.of(context).textTheme.bodyMedium,
      subtitleTextStyle: Theme.of(context).textTheme.titleLarge,
      trailing: IconButton(
        icon: const Icon(Icons.close),
        onPressed: onDelete,
      ),
      onTap: () => onPressed(input, output),
    );
  }
}

class _CalculatorState extends State<Calculator> {
  var input = "";
  var output = "";
  var memory = <MemoryItem>[];

  final inputController = TextEditingController();
  final inputFocusNode = FocusNode();
  var inputMode = 'dec';

  final scaffoldKey = GlobalKey();

  @override
  void initState() {
    inputController.text = input;
    super.initState();
  }

  @override
  void dispose() {
    inputController.dispose();
    inputFocusNode.dispose();
    super.dispose();
  }

  void _keyPressed(String key) {
    if (key == "mem+") {
      if (input.isNotEmpty && output.isNotEmpty) {
        setState(() {
          memory.insert(
              0,
              MemoryItem()
                ..input = input
                ..output = output);
        });
      }
    } else if (key == "dec" || key == "bin" || key == "oct" || key == "hex") {
      setState(() {
        inputMode = key;
      });
    } else if (key == "bksp") {
      if (input.isEmpty) return;
      if (inputController.selection.isValid) {
        var idxStart = inputController.selection.start;
        var idxEnd = inputController.selection.end;
        var cursorPos = 0;
        if (idxStart != idxEnd) {
          cursorPos = idxStart;
          if (idxStart > 0 &&
              idxStart < input.length &&
              '<>'.contains(input[idxStart - 1])) {
            cursorPos = --idxStart;
          }
          if (idxEnd < input.length && '<>'.contains(input[idxEnd])) {
            idxEnd++;
          }
          input = input.substring(0, idxStart) + input.substring(idxEnd);
        } else {
          cursorPos = idxStart - 1;
          var spl = false;
          if (idxStart < input.length &&
              '<>'.contains(input[idxStart]) &&
              '<>'.contains(input[idxStart - 1])) {
            // middle
            cursorPos = --idxStart;
            idxEnd++;
            spl = true;
          }
          if (idxStart > 0 && '<>'.contains(input[idxStart - 1])) {
            // end
            idxStart -= 2;
            cursorPos = idxStart;
            spl = true;
          }
          if (!spl) {
            idxStart--;
          }
          var before = input.substring(0, idxStart);
          var after = input.substring(min(idxEnd, input.length));
          input = '$before$after';
        }
        inputController.text = input;
        inputFocusNode.requestFocus();
        Future.delayed(const Duration(microseconds: 0)).then((value) {
          inputController.selection =
              TextSelection.collapsed(offset: cursorPos);
        });
      } else {
        if (input.endsWith('<') || input.endsWith('>')) {
          input = input.substring(0, input.length - 2);
        } else {
          input = input.substring(0, input.length - 1);
        }
        inputController.text = input;
      }
      eval();
    } else if (key == "clr") {
      if (input.isEmpty) return;
      input = "";
      inputController.text = "";
      inputFocusNode.unfocus();
      setState(() {
        output = "";
      });
    } else {
      if (inputController.selection.isValid) {
        var idxStart = inputController.selection.start;
        var idxEnd = inputController.selection.end;
        var cursorPos = idxStart + key.length;
        if (idxStart == idxEnd) {
          if (key == '(') key = '()';
          String before = input.substring(0, idxStart);
          String after = input.substring(idxStart);
          input = '$before$key$after';
        } else {
          if (key == '(') {
            String before = input.substring(0, idxStart);
            String inside = input.substring(idxStart, idxEnd);
            String after = input.substring(idxEnd);
            input = '$before($inside)$after';
            cursorPos = idxEnd + 1;
          } else {
            String before = input.substring(0, idxStart);
            String after = input.substring(idxEnd);
            input = '$before$key$after';
          }
        }
        inputController.text = input;
        inputFocusNode.requestFocus();
        Future.delayed(const Duration(microseconds: 0)).then((value) {
          inputController.selection =
              TextSelection.collapsed(offset: cursorPos);
        });
      } else {
        input = input + key;
        inputController.text = input;
        if (key == '(') {
          input += ')';
          inputController.text = input;
          inputFocusNode.requestFocus();
          Future.delayed(const Duration(microseconds: 0)).then((value) {
            inputController.selection =
                TextSelection.collapsed(offset: input.length - 1);
          });
        }
      }
      eval();
    }
  }

  bool _isNum(String c) {
    final numRegEx = RegExp(r'^[a-fA-F0-9]+$');
    return numRegEx.hasMatch(c);
  }

  bool _isOp(String c) {
    final opRegEx = RegExp(r'^[%\*\-\+\/<>]$');
    return opRegEx.hasMatch(c);
  }

  int _getRadix() {
    if (inputMode == 'dec') return 10;
    if (inputMode == 'bin') return 2;
    if (inputMode == 'oct') return 8;
    return 16;
  }

  int? _parseNum(String n) {
    return int.tryParse(n, radix: _getRadix());
  }

  int _precedence(String op) {
    if (op == '<<' || op == '>>') return 3;
    if (op == '*' || op == '/' || op == '%') return 2;
    if (op == '+' || op == '-') return 1;
    return -1;
  }

  int _solve(int num1, int num2, String operator) {
    if (operator == '+') {
      return (num1 + num2);
    } else if (operator == '-') {
      return (num2 - num1);
    } else if (operator == '/') {
      return ((num2 / num1).floor());
    } else if (operator == '*') {
      return (num1 * num2);
    } else if (operator == '<<') {
      return (num2 << num1);
    } else if (operator == '>>') {
      return (num2 >> num1);
    } else {
      return (num2 % num1);
    }
  }

  String _conv(int dec) {
    return dec.toRadixString(_getRadix());
  }

  void eval() {
    var i = "$input#";
    var op = <String>[], num = <int>[];
    var last = '';
    try {
      while (i.isNotEmpty) {
        var c = i[0];
        i = i.substring(1);
        if (_isNum(c)) {
          if (_isNum(last)) {
            var n = num.last * _getRadix() + (_parseNum(c) ?? 0);
            num.removeAt(num.length - 1);
            num.add(n);
          } else {
            num.add(_parseNum(c) ?? 0);
          }
        } else if (_isOp(c)) {
          if (last == '<' || last == '>') {
            c = op.last + c;
            op.removeAt(op.length - 1);
          }
          if ('<>'.contains(c) ||
              op.isEmpty ||
              _precedence(c) > _precedence(op.last)) {
            op.add(c);
          } else {
            // print('solving due to lower or same preced last = $last c = $c');
            var num1 = num.removeLast();
            var num2 = num.removeLast();
            var operator = op.removeLast();
            num.add(_solve(num1, num2, operator));
            // print('popped $num1 and $num2, op = $operator, giving ${num.last}');
            op.add(c);
          }
        } else if (c == '(') {
          op.add(c);
        } else if (c == ')') {
          // print('solving due to )');
          if (num.length > 1) {
            while (op.last != '(' && num.length > 1) {
              var num1 = num.removeLast();
              var num2 = num.removeLast();
              var operator = op.removeLast();
              num.add(_solve(num1, num2, operator));
              // print('popped $num1, $num2, $operator = ${num.last}');
            }
            op.removeLast(); // remove the (
          }
        } else if (c == '#' && num.length > 1) {
          // print('solving after reaching EOI');
          while (op.isNotEmpty) {
            var num1 = num.removeLast();
            var num2 = num.removeLast();
            var operator = op.removeLast();
            num.add(_solve(num1, num2, operator));
            // print('popped $num1, $num2, $operator = ${num.last}');
          }
        }
        last = c;
      }
      setState(() {
        if (op.isEmpty || op.every((e) => '()'.contains(e))) {
          output = num.isNotEmpty ? _conv(num.last) : "";
        } else {
          output = "...";
        }
      });
    } catch (e) {
      print(e);
      setState(() {
        output = "invalid";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text("PROG_CALC"),
        actions: [
          IconButton(
            icon: const Icon(Icons.memory),
            onPressed: () {
              (scaffoldKey.currentState! as ScaffoldState).openEndDrawer();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text('PROG_CALC'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.onetwothree),
              title: const Text('NUM_SYS_CONV'),
              onTap: () {},
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              Text(
                'memory',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Expanded(
                child: (memory.isNotEmpty)
                    ? ListView.builder(
                        itemCount: memory.length,
                        itemBuilder: (context, index) {
                          return memory[index].makeListTile(
                            context,
                            (inp, out) {
                              _keyPressed(out);
                              (scaffoldKey.currentState! as ScaffoldState)
                                  .closeEndDrawer();
                            },
                            () {
                              setState(() {
                                memory.removeAt(index);
                              });
                            },
                          );
                        },
                      )
                    : const Center(
                        child: Text('nothing here yet'),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          CalcInput(
            label: 'INPUT',
            controller: inputController,
            focusNode: inputFocusNode,
            mode: inputMode,
          ),
          CalcOutput(
            label: 'OUTPUT',
            value: output,
          ),
          CalcKeypad(
            onKeyPress: _keyPressed,
            mode: inputMode,
          ),
        ],
      ),
    );
  }
}

class CalcInput extends StatelessWidget {
  const CalcInput({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    required this.mode,
  });

  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String mode;

  @override
  Widget build(BuildContext context) {
    var regExp = RegExp(r'^[0-9\/\-\*\+\%><()]*$');
    if (mode == 'bin') regExp = RegExp(r'^[0-1\/\-\*\+\%><()]*$');
    if (mode == 'oct') regExp = RegExp(r'^[0-7\/\-\*\+\%><()]*$');
    if (mode == 'hex') regExp = RegExp(r'^[0-9a-fA-F\/\-\*\+\%><()]*$');

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: TextInputType.none,
              textAlign: TextAlign.end,
              decoration: const InputDecoration.collapsed(
                hintText: '',
              ),
              style: const TextStyle(
                height: 1.5,
                fontSize: 48,
              ),
              inputFormatters: [FilteringTextInputFormatter.allow(regExp)],
            ),
          ),
        ),
      ],
    );
  }
}

class CalcOutput extends StatelessWidget {
  const CalcOutput({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.secondary,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: SelectableText(
                value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 48,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
