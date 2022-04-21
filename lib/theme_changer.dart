import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

var darkTheme = ThemeData.dark().copyWith(
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(color: binanceYellowDLT),
    secondaryHeaderColor: background,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: binanceYellowDLT));
var lightTheme = ThemeData.light().copyWith(
    pageTransitionsTheme: PageTransitionsTheme(builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    }),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(color: binanceYellowDLT),
    secondaryHeaderColor: Colors.white38,
    bottomNavigationBarTheme:
        BottomNavigationBarThemeData(backgroundColor: binanceYellowDLT));










