import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final String currentSection;
  final Function(String) sectionChange;
  final VoidCallback toggleSettings;
  final VoidCallback toggleList;

  BottomNavBar({
    required this.currentSection,
    required this.sectionChange,
    required this.toggleSettings,
    required this.toggleList,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/fridge_icon.png',
            width: 24,
            height: 34,
          ),
          label: 'Fridge',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/freezer_icon.png',
            width: 25,
            height: 34,
          ),
          label: 'Freezer',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: toggleList,
            child: Image.asset(
              'assets/list_icon.png',
              width: 30,
              height: 34,
            ),
          ),
          label: 'Shopping List',
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: toggleSettings,
            child: Image.asset(
              'assets/settings_icon.png',
              width: 32,
              height: 34,
            ),
          ),
          label: 'Settings',
        ),
      ],
      currentIndex: currentSection == 'fridge'
          ? 0
          : currentSection == 'freezer'
              ? 1
              : 2,
      onTap: (index) {
        if (index == 0) {
          sectionChange('fridge');
        } else if (index == 1) {
          sectionChange('freezer');
        }
      },
    );
  }
}

class SideNavBar extends StatelessWidget {
  final String currentSection;
  final Function(String) sectionChange;
  final VoidCallback toggleSettings;
  final VoidCallback toggleList;

  SideNavBar({
    required this.currentSection,
    required this.sectionChange,
    required this.toggleSettings,
    required this.toggleList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavButton(
          iconPath: 'assets/fridge_icon.png',
          label: 'Fridge',
          isActive: currentSection == 'fridge',
          onTap: () => sectionChange('fridge'),
        ),
        NavButton(
          iconPath: 'assets/freezer_icon.png',
          label: 'Freezer',
          isActive: currentSection == 'freezer',
          onTap: () => sectionChange('freezer'),
        ),
        NavButton(
          iconPath: 'assets/list_icon.png',
          label: 'Shopping List',
          onTap: toggleList,
        ),
        NavButton(
          iconPath: 'assets/settings_icon.png',
          label: 'Settings',
          onTap: toggleSettings,
        ),
      ],
    );
  }
}

class NavButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  NavButton({
    required this.iconPath,
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: isActive ? Colors.blue : Colors.transparent,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: 24,
              height: 34,
            ),
            SizedBox(width: 8.0),
            Text(label),
          ],
        ),
      ),
    );
  }
}
