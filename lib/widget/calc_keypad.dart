import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CalcKeypad extends StatelessWidget {
  final Function(String) onKeyPress;
  final String mode;

  const CalcKeypad({super.key, required this.onKeyPress, required this.mode});

  Widget _space({double width = 8.0, double height = 9.0}) {
    return SizedBox(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Top Row: Radix Selectors
            SizedBox(
              height: 40.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "dec",
                    onKeyPressed: onKeyPress,
                    isActive: mode == "dec",
                  ),
                  _space(),
                  KeypadButton(
                    label: "bin",
                    onKeyPressed: onKeyPress,
                    isActive: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(
                    label: "oct",
                    onKeyPressed: onKeyPress,
                    isActive: mode == "oct",
                  ),
                  _space(),
                  KeypadButton(
                    label: "hex",
                    onKeyPressed: onKeyPress,
                    isActive: mode == "hex",
                  ),
                ],
              ),
            ),
            _space(height: 16),

            // Keypad Grid
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "a",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(),
                  KeypadButton(label: "<<", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: ">>", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: "clr", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: "bksp", onKeyPressed: onKeyPress),
                ],
              ),
            ),
            _space(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "b",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(),
                  KeypadButton(label: "(", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: ")", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: "%", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(label: "/", onKeyPressed: onKeyPress),
                ],
              ),
            ),
            _space(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "c",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(),
                  KeypadButton(
                    label: "7",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(
                    label: "8",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin" || mode == "oct",
                  ),
                  _space(),
                  KeypadButton(
                    label: "9",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin" || mode == "oct",
                  ),
                  _space(),
                  KeypadButton(label: "*", onKeyPressed: onKeyPress),
                ],
              ),
            ),
            _space(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "d",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(),
                  KeypadButton(
                    label: "4",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(
                    label: "5",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(
                    label: "6",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(label: "-", onKeyPressed: onKeyPress),
                ],
              ),
            ),
            _space(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "e",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(),
                  KeypadButton(label: "1", onKeyPressed: onKeyPress),
                  _space(),
                  KeypadButton(
                    label: "2",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(
                    label: "3",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode == "bin",
                  ),
                  _space(),
                  KeypadButton(label: "+", onKeyPressed: onKeyPress),
                ],
              ),
            ),
            _space(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "f",
                    onKeyPressed: onKeyPress,
                    isDisabled: mode != 'hex',
                  ),
                  _space(), const KeypadButton(), // Empty spacer
                  _space(), KeypadButton(label: "0", onKeyPressed: onKeyPress),
                  _space(), const KeypadButton(), // Empty spacer
                  _space(),
                  KeypadButton(label: "mem+", onKeyPressed: onKeyPress),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KeypadButton extends StatelessWidget {
  final String? label;
  final Function(String)? onKeyPressed;
  final bool isActive;
  final bool isDisabled;

  const KeypadButton({
    super.key,
    this.label,
    this.onKeyPressed,
    this.isActive = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (label == null || onKeyPressed == null) {
      return Expanded(child: Container());
    }

    final colorScheme = Theme.of(context).colorScheme;

    // Determine Modern Colors
    Color bgColor = colorScheme.surface;
    Color fgColor = colorScheme.primary;

    if (isDisabled) {
      bgColor = colorScheme.surfaceContainerHighest;
      fgColor = colorScheme.onSurfaceVariant.withAlpha(0);
    } else if (isActive) {
      bgColor = colorScheme.primary;
      fgColor = colorScheme.onPrimary;
    }

    return Expanded(
      child: TextButton(
        focusNode: FocusNode(canRequestFocus: false),
        onPressed: isDisabled ? null : () => onKeyPressed!(label!),
        style: ButtonStyle(
          shape: WidgetStatePropertyAll(
            // Fixed M3 Deprecation
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
              side: BorderSide(width: 1, color: colorScheme.outlineVariant),
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(bgColor),
          foregroundColor: WidgetStatePropertyAll(fgColor),
          overlayColor: WidgetStatePropertyAll(
            colorScheme.primary.withAlpha(50),
          ),
        ),
        child: AutoSizeText(
          label!,
          maxLines: 1,
          minFontSize: 15,
          maxFontSize: 30,
          overflow: TextOverflow.visible,
          style: const TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
