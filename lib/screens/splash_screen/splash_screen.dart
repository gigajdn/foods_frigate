import 'package:flutter/material.dart';
import 'package:foods_frigate/components/background.dart';
import 'package:foods_frigate/components/logo.dart';
import '../../themes.dart';
import 'components/navigation.dart';
import 'components/splash_content.dart';

class SplashScreen extends StatelessWidget {
  static String routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int currentPage = 0;
  final List<Map<String, String>> splashData = [
    {
      "title": "Monitor your food",
      "text": "Always know what's in your fridge",
    },
    {
      "title": "Understand your consumption",
      "text":
          "You'll find out which resources you use the most.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Background(),
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Spacer(),
                Logo(),
                SizedBox(height: 40),
                Image.asset(
                  Theme.of(context).primaryColor == AppColors.YELLOW_n119
                      ? 'assets/images/fridge-white.png'
                      : 'assets/images/fridge-green.png',
                  width: 230,
                ),
                Expanded(
                  flex: 1,
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      text: splashData[index]["text"]!,
                      title: splashData[index]["title"]!,
                    ),
                  ),
                ),
                Navigation(
                  splashData: splashData,
                  currentPage: currentPage,
                  size: size,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
