import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isRequired;
  final bool isDateField;
  final bool isTimeField;
  final bool isPasswordField;
  bool? obscureText;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final IconData? icon;
  final TextInputType? inputType;
  Function(dynamic query)? onChanged;
  final double? minHeight;  // Add this
  final double? minWidth;   // Add this

  CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.isRequired,
    this.isDateField = false,
    this.isTimeField = false,
    this.obscureText = false,
    this.focusNode,
    this.nextFocusNode,
    this.icon,
    this.inputType,
    this.isPasswordField = false,
    this.onChanged,
    this.minHeight,  // Initialize this
    this.minWidth,   // Initialize this
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  void _onControllerChange() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

 /* @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Reduced vertical padding
      child: TextFormField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        obscureText: widget.obscureText ?? false,
        keyboardType: widget.inputType ?? TextInputType.text,
        textInputAction: widget.nextFocusNode != null
            ? TextInputAction.next
            : TextInputAction.done,
        onFieldSubmitted: (_) {
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        },
        onChanged: (val) {
          _onControllerChange();
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            vertical: 12.0, // Reduced vertical padding inside the text field
            horizontal: 10.0, // Reduced horizontal padding
          ),
          labelText: widget.label,
          labelStyle: const TextStyle(fontSize: 14), // Smaller font size for the label
          border: const OutlineInputBorder(),
          icon: widget.icon != null ? Icon(widget.icon, size: 20) : null, // Adjusted icon size
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.isPasswordField)
                IconButton(
                  icon: Icon(
                    widget.obscureText!
                        ? Icons.visibility
                        : Icons.visibility_off,
                    size: 18, // Adjusted icon size
                  ),
                  onPressed: () {
                    setState(() {
                      widget.obscureText = !widget.obscureText!;
                    });
                  },
                ),
              IconButton(
                icon: const Icon(Icons.clear, size: 18), // Adjusted icon size
                onPressed: () {
                  widget.controller.clear();
                  _onControllerChange();
                },
              ),
            ],
          ),
        ),
        style: const TextStyle(fontSize: 14), // Smaller font size for the input text
        validator: (value) =>
            _validator(value, widget.label, widget.isRequired),
        readOnly: widget.isDateField || widget.isTimeField,
        onTap: () async {
          if (widget.isDateField) {
            widget.controller.text = await _selectDate(context);
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          } else if (widget.isTimeField) {
            widget.controller.text = await _selectTime(context);
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          }
        },
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 16),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: widget.minHeight ?? 0,  // Apply constraints
          minWidth: widget.minWidth ?? 0,    // Apply constraints
        ),
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          obscureText: widget.obscureText ?? false,
          keyboardType: widget.inputType ?? TextInputType.text,
          textInputAction: widget.nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (widget.nextFocusNode != null) {
              FocusScope.of(context).requestFocus(widget.nextFocusNode);
            }
          },
          onChanged: (val) {
            _onControllerChange();
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(2),
            labelText: widget.label,
            border: const OutlineInputBorder(),
            icon: widget.icon != null ? Icon(widget.icon) : null,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.isPasswordField)
                  IconButton(
                    icon: Icon(
                      widget.obscureText!
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.obscureText = !widget.obscureText!;
                      });
                    },
                  ),
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    widget.controller.clear();
                    _onControllerChange();
                  },
                ),
              ],
            ),
          ),
          validator: (value) =>
              _validator(value, widget.label, widget.isRequired),
          readOnly: widget.isDateField || widget.isTimeField,
          onTap: () async {
            if (widget.isDateField) {
              widget.controller.text = await _selectDate(context);
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
            } else if (widget.isTimeField) {
              widget.controller.text = await _selectTime(context);
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
            }
          },
        ),
      ),
    );
  }

  String? _validator(String? value, String label, bool isRequired) {
    if (isRequired && (value == null || value.isEmpty)) {
      return '$label is required';
    }
    return null;
  }

  Future<String> _selectDate(BuildContext context) async {
    String formattedDate = "";
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().add(const Duration(days: 1800)),
    );

    if (pickedDate != null) {
      formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
    }
    return formattedDate;
  }

  Future<String> _selectTime(BuildContext context) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      return selectedTime.format(context);
    }
    return '';
  }
}
