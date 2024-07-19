import 'package:flutter/material.dart';
import 'package:foods_frigate/themes.dart';

import 'filter_button.dart';

class ActionBar extends StatelessWidget {
  const ActionBar({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.onPressedMinus,
    required this.onPressedPlus,
  }) : super(key: key);

  final String text;
  final GestureTapCallback onPressed, onPressedMinus, onPressedPlus;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      child: Row(
        children: [
          FilterButton(
            icon: 'assets/icons/consume.svg',
            onPressed: onPressedMinus,
            iconColor: Theme.of(context).colorScheme.error,
            bgColor: AppColors.RED_n254,
          ),
          SizedBox(width: 18),
          FilterButton(
            icon: 'assets/icons/additive.svg',
            onPressed: onPressedPlus,
            iconColor: Theme.of(context).primaryColor,
            bgColor: Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
