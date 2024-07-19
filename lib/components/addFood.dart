import 'package:flutter/material.dart';

class AddFood extends StatelessWidget {
  final VoidCallback onClick;

  AddFood({required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 15),
      child: ElevatedButton(
        onPressed: onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor, // Use your theme or specific color
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          textStyle: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/add-icon.png',
              height: 24,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10),
            Text('Add a new item'),
          ],
        ),
      ),
    );
  }
}
