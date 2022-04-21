// ignore_for_file: prefer_const_constructors

import 'package:coin_talk/pages/coins_page.dart';
import 'package:coin_talk/pages/login_screen.dart';
import 'package:coin_talk/pages/register_screen.dart';
import 'package:coin_talk/pages/welcome_screen.dart';
import 'package:coin_talk/theme_changer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import 'constants.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


    return ThemeProvider(
      loadThemeOnInit: true,
      saveThemesOnChange: true,
      defaultThemeId: '2',
      themes: [
        AppTheme(
            id: '2',
            data: ThemeData.dark().copyWith(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }),
                scaffoldBackgroundColor: background,
                appBarTheme: AppBarTheme(color: binanceYellowDLT),
                secondaryHeaderColor: background,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: binanceYellowDLT)),
            description: 'dark theme'),
        AppTheme(
            id: '1',
            data: ThemeData.light().copyWith(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(color: binanceYellowDLT),
                secondaryHeaderColor: Colors.white38,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: binanceYellowDLT)),
            description: 'light theme'),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeData.light().copyWith(
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                }),
                scaffoldBackgroundColor: Colors.white,
                appBarTheme: AppBarTheme(color: binanceYellowDLT),
                secondaryHeaderColor: Colors.white38,
                bottomNavigationBarTheme: BottomNavigationBarThemeData(
                    backgroundColor: binanceYellowDLT)),
              title: 'CoinTalk',
              debugShowCheckedModeBanner: false,
              home: UserData.isLoggedIn ? CoinsPage() : RegisterScreen(),
              routes: {
                Screens.register_screen.toString(): (context) =>
                    RegisterScreen(),
                Screens.welcome_screen.toString(): (context) => WelcomeScreen(),
                Screens.login_screen.toString(): (context) => LoginScreen(),
                Screens.coin_dashboard.toString(): (context) => CoinsPage(),
              },
              initialRoute: UserData.isLoggedIn
                  ? Screens.coin_dashboard.toString()
                  : Screens.register_screen.toString()),
        ),
      ),
    );
  }
}
