import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foods_frigate/models/theme.dart';
import 'package:foods_frigate/themes.dart';
import 'package:provider/provider.dart';

import 'models/products.dart';
import 'models/transactions.dart';
import 'screens/home_sreen.dart';
import 'screens/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAHWLhLLloEQBEtGRc1YRCLuTgMMFWWLFs",
            authDomain: "flutter-tekmob.firebaseapp.com",
            projectId: "flutter-tekmob",
            storageBucket: "flutter-tekmob.appspot.com",
            messagingSenderId: "446115919205",
            appId: "1:446115919205:web:687845f3c477fc34735d8c"));
  } else {
    await Firebase.initializeApp();
    FirebaseDatabase.instance.setLoggingEnabled(true);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeChangeProvider = new ThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
    themeChangeProvider.addListener(() {
      setState(() {});
    });
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.setWhiteTheme =
        await themeChangeProvider.themePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => new Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => new Transactions(),
        ),
        ChangeNotifierProvider(
          create: (_) => themeChangeProvider,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Styles.themeData(themeChangeProvider.isWhiteTheme, context),
        home: HomeScreen(),
        initialRoute: '/splash_screen',
        routes: {
          '/home_screen': (ctx) => HomeScreen(),
          '/splash_screen': (ctx) => SplashScreen(),
        },
      ),
    );
  }
}
