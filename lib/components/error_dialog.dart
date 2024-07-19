import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.context,
    required this.message,
  }) : super(key: key);

  final BuildContext context;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('An error occurred'),
      content: Text(message),
      actions: [
        TextButton(
          child: Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    );
  }
}
