import 'dart:convert';

class MemoryItem {
  final String input;
  final String output;
  final String mode; // 'dec', 'bin', 'oct', 'hex'

  const MemoryItem({
    required this.input,
    required this.output,
    required this.mode,
  });

  Map<String, dynamic> toMap() {
    return {'input': input, 'output': output, 'mode': mode};
  }

  factory MemoryItem.fromMap(Map<String, dynamic> map) {
    return MemoryItem(
      input: map['input'],
      output: map['output'],
      mode: map['mode'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MemoryItem.fromJson(String source) =>
      MemoryItem.fromMap(json.decode(source));
}
