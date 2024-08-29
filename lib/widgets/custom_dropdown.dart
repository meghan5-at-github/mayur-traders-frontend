import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final List<String> options;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final Function(String? newValue) onChange;

  const CustomDropdown({
    required this.label,
    required this.controller,
    this.isRequired = false,
    this.options = const ['OK', 'NOK'],
    this.focusNode,
    this.nextFocusNode,
    Key? key,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          DropdownButtonFormField<String>(
            value: controller.text.isEmpty
                ? null
                : controller.text == "Select"
                ? null
                : controller.text,
            style: TextStyle(fontSize: 12, color: Colors.black),
            onChanged: onChange,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Select'),
              ),
              ...options.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList()
            ],
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            validator: (value) {
              if (isRequired && (value == null || value.isEmpty)) {
                return 'Please select an option';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}