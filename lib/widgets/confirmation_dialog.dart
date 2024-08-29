import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;

  const ConfirmationDialog({
    super.key,
    required this.title,
    this.content = '',
    this.confirmText = 'Yes',
    this.cancelText = 'No',
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String content = '',
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          cancelText: cancelText,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: content.isNotEmpty ? Text(content) : null,
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false); // User pressed 'No'
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(true); // User pressed 'Yes'
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
