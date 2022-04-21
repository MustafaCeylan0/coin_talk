// ignore_for_file: prefer_const_constructors

import 'package:coin_talk/repositories/coin_repository.dart';
import 'package:coin_talk/theme_changer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'constants.dart';
import 'my_app.dart';

Future<void> main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();


  // Initialize Firebase
  await UserData.SetUpPrefs();
  await UserData.setTheme(KTheme.dark);



  runApp(

    MultiProvider(
      providers: [

        ChangeNotifierProvider(create: (context) => CoinRepository()),

      ],
      child: MyApp(),
    ),
  );
}
