import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    Key? key,
    required this.context,
    required this.message,
    required this.title,
    required this.onPressed,
  }) : super(key: key);

  final BuildContext context;
  final String message, title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () => onPressed,
        )
      ],
    );
  }
}
