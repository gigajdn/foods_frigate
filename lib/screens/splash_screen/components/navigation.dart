import 'package:flutter/material.dart';
import 'package:foods_frigate/models/theme.dart';
import 'package:provider/provider.dart';

import 'dot.dart';
import 'skip_button.dart';

class Navigation extends StatelessWidget {
  const Navigation({
    Key? key,
    required this.splashData,
    required this.currentPage,
    required this.size,
  }) : super(key: key);

  final List<Map<String, String>> splashData;
  final int currentPage;
  final Size size;

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => Dot(
                  index: index,
                  currentPage: currentPage,
                ),
              ),
            ),
            Spacer(),
            SkipButton(size: size),
            Checkbox(
              value: theme.isWhiteTheme,
              onChanged: (value) {
                theme.setWhiteTheme = value!;
              },
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
