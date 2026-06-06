import 'package:flutter/material.dart';
import '../controller/calc_controller.dart';

class CalcInput extends StatefulWidget {
  final String label;
  final CalculatorController controller;

  const CalcInput({super.key, required this.label, required this.controller});

  @override
  State<CalcInput> createState() => _CalcInputState();
}

class _CalcInputState extends State<CalcInput> {
  final ScrollController _scrollController = ScrollController();
  bool _isOverflowingLeft = false;
  bool _isOverflowingRight = false;
  String _lastText = "";

  @override
  void initState() {
    super.initState();
    _lastText = widget.controller.textController.text;

    // Listen for typing events to handle auto-scrolling
    widget.controller.textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final currentText = widget.controller.textController.text;

    if (currentText != _lastText) {
      _lastText = currentText;

      // Wait one frame for the text layout to physically expand
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          final selection = widget.controller.textController.selection;

          // Smart Auto-Scroll: Only jump to the end if the user's cursor is at the end.
          // This allows them to edit the middle of a long equation without the screen jumping away!
          if (selection.isValid && selection.end == currentText.length) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }

          _checkOverflow();
        }
      });
    }
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    double tolerance = 1.1;
    bool overLeft = position.pixels > tolerance;
    bool overRight = position.pixels < position.maxScrollExtent - tolerance;

    if (overLeft != _isOverflowingLeft || overRight != _isOverflowingRight) {
      setState(() {
        _isOverflowingLeft = overLeft;
        _isOverflowingRight = overRight;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    widget.controller.textController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              widget.label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            margin: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              // No background color here to distinguish the input from the output visually
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (Rect bounds) {
                    List<Color> colors = [];
                    List<double> stops = [];

                    if (_isOverflowingLeft) {
                      colors.addAll([Colors.transparent, Colors.black]);
                      stops.addAll([0.0, 0.1]);
                    } else {
                      colors.add(Colors.black);
                      stops.add(0.0);
                    }

                    if (_isOverflowingRight) {
                      colors.addAll([Colors.black, Colors.transparent]);
                      stops.addAll([0.9, 1.0]);
                    } else {
                      colors.add(Colors.black);
                      stops.add(1.0);
                    }

                    return LinearGradient(
                      colors: colors,
                      stops: stops,
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.dstIn,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      _checkOverflow();
                      return false;
                    },
                    child: TextField(
                      controller: widget.controller.textController,
                      focusNode: widget.controller.focusNode,
                      scrollController: _scrollController,
                      textAlign: TextAlign.end,
                      keyboardType: TextInputType.none,
                      showCursor: true,
                      autofocus: true,
                      maxLines: 1,
                      style: const TextStyle(height: 1.5, fontSize: 48),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                  ),
                ),

                // Left Arrow Indicator
                if (_isOverflowingLeft)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(100),
                      size: 24,
                    ),
                  ),

                // Right Arrow Indicator
                if (_isOverflowingRight)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_right,
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withAlpha(100),
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
