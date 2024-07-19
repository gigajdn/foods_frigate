import 'package:flutter/material.dart';

class Dot extends StatelessWidget {
  const Dot({Key? key, required this.currentPage, required this.index})
      : super(key: key);

  final int currentPage;
  final int index;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 6,
      width: currentPage == index ? 20 : 6,
      margin: EdgeInsets.only(right: 5),
      duration: Duration(seconds: 1),
      decoration: BoxDecoration(
        color: currentPage == index
            ? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
