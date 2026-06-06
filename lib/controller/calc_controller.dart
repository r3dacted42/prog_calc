import 'package:flutter/material.dart';
import 'package:prog_calc/engine/grammar.dart';
import 'package:prog_calc/models/memory_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../engine/evaluator.dart'; // Ensure this matches your actual file name

class CalculatorController extends ChangeNotifier {
  String _output = "";
  String _inputMode = "dec";
  List<MemoryItem> _memory = [];

  final TextEditingController textController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  String get input => textController.text;
  String get output => _output;
  String get inputMode => _inputMode;
  List<MemoryItem> get memory => _memory;

  CalculatorController() {
    _loadMemoryFromDisk();
  }

  void setInputMode(String mode) {
    if (_inputMode == mode) return;
    _inputMode = mode;
    _updateEvaluation();
    notifyListeners();
  }

  void handleKeyPress(String key) {
    if (key == "clr") {
      _clear();
      return;
    }

    if (key == "bksp") {
      _backspace();
      return;
    }

    String currentText = textController.text;
    final selection = textController.selection;

    int start = selection.isValid && selection.start >= 0
        ? selection.start
        : currentText.length;
    int end = selection.isValid && selection.end >= 0
        ? selection.end
        : currentText.length;

    String updatedText;
    int newCursorPosition;

    if (key == "(") {
      if (start == end) {
        updatedText = currentText.replaceRange(start, end, "()");
        newCursorPosition = start + 1;
      } else {
        String selectedText = currentText.substring(start, end);
        updatedText = currentText.replaceRange(start, end, "($selectedText)");
        newCursorPosition = start + selectedText.length + 1;
      }
    } else {
      updatedText = currentText.replaceRange(start, end, key);
      newCursorPosition = start + key.length;
    }

    _updateTextField(
      updatedText,
      TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void _backspace() {
    if (textController.text.isEmpty) return;

    String currentText = textController.text;
    final selection = textController.selection;

    int start = selection.isValid && selection.start >= 0
        ? selection.start
        : currentText.length;
    int end = selection.isValid && selection.end >= 0
        ? selection.end
        : currentText.length;

    String updatedText = currentText;
    int newCursorPosition = currentText.length;

    if (start != end) {
      updatedText = currentText.replaceRange(start, end, "");
      newCursorPosition = start;
    } else if (start > 0) {
      int deletionLength = 1;
      if (start >= 2 &&
          (currentText.substring(start - 2, start) == "<<" ||
              currentText.substring(start - 2, start) == ">>")) {
        deletionLength = 2;
      }
      updatedText = currentText.replaceRange(start - deletionLength, start, "");
      newCursorPosition = start - deletionLength;
    }

    _updateTextField(
      updatedText,
      TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  void _clear() {
    _output = "";
    textController.clear();
    notifyListeners();
  }

  void _updateTextField(String text, TextSelection selection) {
    if (!focusNode.hasFocus) focusNode.requestFocus();
    Future.microtask(() {
      textController.value = TextEditingValue(text: text, selection: selection);
      _updateEvaluation();
      notifyListeners();
    });
  }

  Future<void> _loadMemoryFromDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedItems = prefs.getStringList('calc_memory');

    if (savedItems != null) {
      _memory = savedItems.map((item) => MemoryItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveMemoryToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> encodedItems = _memory
        .map((item) => item.toJson())
        .toList();
    await prefs.setStringList('calc_memory', encodedItems);
  }

  bool addToMemory() {
    if (textController.text.isNotEmpty &&
        _output.isNotEmpty &&
        _output != "invalid" &&
        _output != "...") {
      _memory.insert(
        0,
        MemoryItem(
          input: textController.text,
          output: _output,
          mode: _inputMode,
        ),
      );
      _saveMemoryToDisk();
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeFromMemory(int index) {
    _memory.removeAt(index);
    _saveMemoryToDisk();
    notifyListeners();
  }

  void loadFromMemory(MemoryItem item) {
    int originalRadix = Grammar.getRadix(item.mode);
    BigInt? parsedValue = BigInt.tryParse(item.output, radix: originalRadix);

    if (parsedValue != null) {
      int currentRadix = Grammar.getRadix(_inputMode);
      String convertedValue = parsedValue.toRadixString(currentRadix);
      handleKeyPress(convertedValue);
    }
  }

  void _updateEvaluation() {
    _output = Evaluator.evaluate(textController.text, _inputMode);
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
