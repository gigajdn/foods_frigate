import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloseButton extends StatelessWidget {
  final VoidCallback click;
  final bool isDark;

  CloseButton({required this.click, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: click,
      icon: SvgPicture.asset(
        isDark ? 'assets/close-white.svg' : 'assets/close-black.svg',
      ),
    );
  }
}

class BaseBigButton extends StatelessWidget {
  final VoidCallback onClick;
  final String text;
  final String icon;
  final Color backgroundColor;
  final Color textColor;
  final bool isRemoving;

  BaseBigButton({
    required this.onClick,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    this.isRemoving = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isRemoving ? null : onClick,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 12,
            height: 9,
            color: textColor,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback click;
  final bool isRemoving;
  final String mode;

  SaveButton(
      {required this.click, required this.isRemoving, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BaseBigButton(
      onClick: click,
      text: mode == 'edit' ? 'Save' : 'Add item',
      icon: 'assets/yes.svg',
      backgroundColor: Color(0xFF00C851), // var(--saveButton)
      textColor: Colors.white,
      isRemoving: isRemoving,
    );
  }
}

class CancelButton extends StatelessWidget {
  final VoidCallback click;
  final bool isRemoving;
  final bool isDark;

  CancelButton(
      {required this.click, required this.isRemoving, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return BaseBigButton(
      onClick: click,
      text: 'Cancel',
      icon: isDark ? 'assets/no-white.svg' : 'assets/no-green.svg',
      backgroundColor: Colors.transparent,
      textColor: Color(0xFFff4444), // var(--cancelButton)
      isRemoving: isRemoving,
    );
  }
}

class RemoveButton extends StatelessWidget {
  final VoidCallback click;
  final bool isRemoving;
  final String mode;

  RemoveButton(
      {required this.click, required this.isRemoving, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BaseBigButton(
      onClick: click,
      text: 'Remove',
      icon: 'assets/trash.svg',
      backgroundColor: Color(0xFFff4444), // var(--removeButton)
      textColor: Colors.white,
      isRemoving: !isRemoving,
    );
  }
}

class CancelRemovalButton extends StatelessWidget {
  final VoidCallback click;
  final bool isRemoving;
  final String mode;

  CancelRemovalButton(
      {required this.click, required this.isRemoving, required this.mode});

  @override
  Widget build(BuildContext context) {
    return BaseBigButton(
      onClick: click,
      text: 'Keep it',
      icon: 'assets/no-white.svg',
      backgroundColor: Colors.transparent,
      textColor: Color(0xFFff4444), // var(--removeCancelButton)
      isRemoving: isRemoving,
    );
  }
}

class RemovePromptButton extends StatelessWidget {
  final VoidCallback click;
  final bool isRemoving;
  final String mode;

  RemovePromptButton(
      {required this.click, required this.isRemoving, required this.mode});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: click,
      child: Text(
        isRemoving ? 'This action cannot be undone.' : 'Remove this item',
        style: TextStyle(
          color: Color(0xFFff4444), // var(--removeButton)
          decoration: TextDecoration.underline,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SaveSettingsButton extends StatelessWidget {
  final VoidCallback click;

  SaveSettingsButton({required this.click});

  @override
  Widget build(BuildContext context) {
    return BaseBigButton(
      onClick: click,
      text: 'Save and close',
      icon: 'assets/yes.svg',
      backgroundColor: Color(0xFF00C851), // var(--saveButton)
      textColor: Colors.white,
    );
  }
}

class DataResetButton extends StatelessWidget {
  final VoidCallback click;
  final String type;

  DataResetButton({required this.click, required this.type});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: click,
      style: ElevatedButton.styleFrom(
        foregroundColor: type == 'load' ? Color(0xFFff4444) : Colors.white,
        backgroundColor: type == 'load'
            ? Colors.white
            : Color(0xFFff4444), // var(--removeButton)
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        side: BorderSide(color: Color(0xFFff4444)), // var(--removeButton)
      ),
      child: Text(
        type == 'load' ? 'Load sample data' : 'Delete everything',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
