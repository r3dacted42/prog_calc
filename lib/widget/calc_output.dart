import 'package:flutter/material.dart';

class CalcOutput extends StatefulWidget {
  final String label;
  final String value;

  const CalcOutput({super.key, required this.label, required this.value});

  @override
  State<CalcOutput> createState() => _CalcOutputState();
}

class _CalcOutputState extends State<CalcOutput> {
  final ScrollController _scrollController = ScrollController();
  late final TextEditingController _textController;

  bool _isOverflowingLeft = false;
  bool _isOverflowingRight = false;

  @override
  void initState() {
    super.initState();
    // Initialize the text controller with a space fallback for height preservation
    _textController = TextEditingController(
      text: widget.value.isEmpty ? " " : widget.value,
    );
    _scrollController.addListener(_checkOverflow);
  }

  @override
  void didUpdateWidget(CalcOutput oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.value != widget.value) {
      _textController.text = widget.value.isEmpty ? " " : widget.value;

      // Wait one frame for the layout to update, then jump to the right edge (newest digit)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          _checkOverflow();
        }
      });
    }
  }

  void _checkOverflow() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    // Because it is a normal LTR TextField aligned to the end:
    // - If pixels > 0, we have scrolled right, meaning the LEFT side of text is hidden.
    // - If pixels < maxScrollExtent, we are not at the right edge, meaning the RIGHT side is hidden.
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
    _textController.dispose();
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
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withAlpha(100),
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
                    // ... your existing gradient stops logic stays exactly the same ...
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

                  // --- FIX IS HERE ---
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) {
                      // This forces the UI to update the arrows even during text selection drags!
                      _checkOverflow();
                      return false; // Return false to let the scroll propagate naturally
                    },
                    child: TextField(
                      controller: _textController,
                      scrollController: _scrollController,
                      readOnly: true,
                      showCursor: false,
                      maxLines: 1,
                      textAlign: TextAlign.end,
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
