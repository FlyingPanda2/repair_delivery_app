import 'package:flutter/material.dart';

class CodeInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const CodeInputField({
    super.key,
    this.length = 4,
    required this.onCompleted,
  });

  @override
  State<CodeInputField> createState() => _CodeInputFieldState();
}

class _CodeInputFieldState extends State<CodeInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in _controllers) controller.dispose();
    for (var node in _focusNodes) node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 56,
          height: 56,
          child: TextField(
            controller: _controllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
              ),
            ),
            onChanged: (value) {
              if (value.length == 1 && index < widget.length - 1) {
                _focusNodes[index + 1].requestFocus();
              }
              _checkCompletion();
            },
            onSubmitted: (_) {
              if (index == widget.length - 1) _checkCompletion();
            },
          ),
        );
      }),
    );
  }

  void _checkCompletion() {
    String code = _controllers.map((e) => e.text).join('');
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }
}