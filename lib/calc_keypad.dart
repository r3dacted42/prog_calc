import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CalcKeypad extends StatelessWidget {
  const CalcKeypad({
    super.key,
    required this.onKeyPress,
    required this.mode,
  });

  final Function(String) onKeyPress;
  final String mode;

  Widget _space({double? width, double? height}) {
    return SizedBox(
      width: width ?? 8.0,
      height: height ?? 9.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 40.0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "dec",
                    onKeyPressed: onKeyPress,
                    isActive: (mode == "dec"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "bin",
                    onKeyPressed: onKeyPress,
                    isActive: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "oct",
                    onKeyPressed: onKeyPress,
                    isActive: (mode == "oct"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "hex",
                    onKeyPressed: onKeyPress,
                    isActive: (mode == "hex"),
                  ),
                ],
              ),
            ),
            _space(height: 16),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KeypadButton(
                    label: "a",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  KeypadButton(
                    label: "<<",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: ">>",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: "clr",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: "bksp",
                    onKeyPressed: onKeyPress,
                  ),
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
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  KeypadButton(
                    label: "(",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: ")",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: "%",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: "/",
                    onKeyPressed: onKeyPress,
                  ),
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
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  KeypadButton(
                    label: "7",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "8",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin" || mode == "oct"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "9",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin" || mode == "oct"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "*",
                    onKeyPressed: onKeyPress,
                  ),
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
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  KeypadButton(
                    label: "4",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "5",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "6",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "-",
                    onKeyPressed: onKeyPress,
                  ),
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
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  KeypadButton(
                    label: "1",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  KeypadButton(
                    label: "2",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "3",
                    onKeyPressed: onKeyPress,
                    isDisabled: (mode == "bin"),
                  ),
                  _space(),
                  KeypadButton(
                    label: "+",
                    onKeyPressed: onKeyPress,
                  ),
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
                    isDisabled: (mode != 'hex'),
                  ),
                  _space(),
                  const KeypadButton(),
                  _space(),
                  KeypadButton(
                    label: "0",
                    onKeyPressed: onKeyPress,
                  ),
                  _space(),
                  const KeypadButton(),
                  _space(),
                  KeypadButton(
                    label: "mem+",
                    onKeyPressed: onKeyPress,
                  ),
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
  const KeypadButton({
    super.key,
    this.label,
    this.onKeyPressed,
    this.isActive,
    this.isDisabled,
  });

  final String? label;
  final Function(String)? onKeyPressed;
  final bool? isActive;
  final bool? isDisabled;

  @override
  Widget build(BuildContext context) {
    var bgColor = Theme.of(context).colorScheme.background;
    var fgColor = Theme.of(context).colorScheme.primary;
    var hasAction = !((isDisabled ?? false) || (isActive ?? false));

    if (isDisabled ?? false) {
      bgColor = Theme.of(context).colorScheme.secondary;
      fgColor = Theme.of(context).colorScheme.secondary;
    }
    if (isActive ?? false) {
      bgColor = Theme.of(context).colorScheme.primary;
      fgColor = Theme.of(context).colorScheme.onPrimary;
    }

    if (label != null && onKeyPressed != null) {
      return Expanded(
        child: TextButton(
          onPressed: hasAction ? () => onKeyPressed!(label!) : null,
          style: ButtonStyle(
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            backgroundColor: MaterialStatePropertyAll(bgColor),
            foregroundColor: MaterialStatePropertyAll(fgColor),
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
    return Expanded(child: Container());
  }
}
