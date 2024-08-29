import 'package:flutter/material.dart';

class KeyValueRow extends StatelessWidget {
  final String keyText;
  final String valueText;
  final Color? keyColor;

  const KeyValueRow(
      {super.key,
      required this.keyText,
      required this.valueText,
      this.keyColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              keyText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: keyColor, //Colors.blue,
                fontSize: 16,
              ),
            ),
          ),
          const Expanded(
              flex: 1,
              child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.w800),
              )),
          Expanded(
            flex: 3,
            child: Text(
              valueText,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black,
                fontSize: 14,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
