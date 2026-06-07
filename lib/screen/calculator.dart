import 'package:flutter/material.dart';
import 'package:prog_calc/widget/memory_drawer.dart';
import '../controller/calc_controller.dart';
import '../widget/calc_input.dart';
import '../widget/calc_output.dart';
import '../widget/calc_keypad.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final CalculatorController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CalculatorController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "PROG_CALC",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.memory),
                    tooltip: 'Open Memory',
                    onPressed: () {
                      Scaffold.of(context).openEndDrawer();
                    },
                  );
                },
              ),
            ],
          ),
          endDrawer: MemoryDrawer(controller: _controller),

          body: Builder(
            builder: (innerContext) {
              return Column(
                children: [
                  CalcInput(label: 'INPUT', controller: _controller),
                  CalcOutput(label: 'OUTPUT', value: _controller.output),
                  CalcKeypad(
                    mode: _controller.inputMode,
                    onKeyPress: (key) {
                      if (['dec', 'bin', 'oct', 'hex'].contains(key)) {
                        _controller.setInputMode(key);
                      } else if (key == 'mem+') {
                        bool wasAdded = _controller.addToMemory();
                        if (wasAdded) {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Saved to memory.'),
                              duration: const Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'VIEW',
                                onPressed: () {
                                  Scaffold.of(innerContext).openEndDrawer();
                                },
                              ),
                            ),
                          );
                        }
                      } else {
                        _controller.handleKeyPress(key);
                      }
                    },
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
