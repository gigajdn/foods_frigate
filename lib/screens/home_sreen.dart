import 'package:flutter/material.dart';
import 'package:foods_frigate/components/background.dart';
import 'package:foods_frigate/components/logo.dart';
import 'package:foods_frigate/components/menu_button.dart';
import 'package:foods_frigate/themes.dart';

import 'fridge/fridge_content.dart';
import 'history/history_content.dart';
import 'top5/top_five_content.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    FridgeContent(),
    HistoryContent(),
    TopFiveContent(),
  ];

  _navigateTo(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget contentView() {
    return _children[_currentIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Background(),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  // header
                  Spacer(flex: 3),
                  Logo(),
                  SizedBox(height: 10),
                  buildMenu(),
                  Spacer(flex: 1),
                  contentView()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Row buildMenu() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        MenuButton(
          onPressed: () => _navigateTo(0),
          text: 'Firdge',
          svgSrc: 'assets/icons/fridge.svg',
          color: _currentIndex == 0
              ? Theme.of(context).primaryColor
              : AppColors.GRAY_n141.withOpacity(.5),
        ),
        SizedBox(width: 20),
        MenuButton(
          onPressed: () => _navigateTo(1),
          text: 'History',
          svgSrc: 'assets/icons/clock.svg',
          color: _currentIndex == 1
              ? Theme.of(context).primaryColor
              : AppColors.GRAY_n141.withOpacity(.5),
        ),
        SizedBox(width: 20),
        MenuButton(
          onPressed: () => _navigateTo(2),
          text: 'Top 5',
          svgSrc: 'assets/icons/star.svg',
          color: _currentIndex == 2
              ? Theme.of(context).primaryColor
              : AppColors.GRAY_n141.withOpacity(.5),
        ),
      ],
    );
  }
}
