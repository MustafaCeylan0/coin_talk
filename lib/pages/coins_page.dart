import 'dart:io';
import 'dart:math';

import 'package:coin_talk/constants.dart';
import 'package:coin_talk/models/coin.dart';
import 'package:coin_talk/pages/coins_detail_page.dart';
import 'package:coin_talk/pages/login_screen.dart';
import 'package:coin_talk/repositories/coin_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../theme_changer.dart';
import '../widgets/graphic_history.dart';

class CoinsPage extends StatelessWidget {
  late List<Coin> table;
  late CoinRepository coins;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: '\$');
  List<Coin> selected = [];
  final _auth = FirebaseAuth.instance;
  var math = Random();

  showDetails(Coin coin, var context) {
    print(coin.name);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CoinsDetailPage(coin: coin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> blocked = [
      "Tether",
      "USD Coin",
      "Ethereum 2",
      "TerraUSD",
      "Dai",
      "SHIBA INU",
      "Binance USD",
      'Ethereum Classic',
      'Wrapped Bitcoin',
    ];
    coins = context.watch<CoinRepository>();
    table = coins.table;
    for (int i = 0; i < table.length; i++) {
      if (blocked.contains(table[i].name)) {
        table.removeAt(i);
        i--;
      }
    }

    @override
    void didChangeDependencies() {
      // TODO: implement initState
      Locale myLocale = Localizations.localeOf(context);
      //print("country code is ${myLocale.languageCode}");
      String? languageCode = myLocale.languageCode;
      UserData.setLanguageCode(languageCode);
    }

    Future<bool> _onBackPressed() async {
      return (await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12.0),
                ),
              ),
              backgroundColor: ThemeProvider.themeOf(context).id == '2'
                  ? darkSecondary
                  : lightSecondary,
              title: new Text('${UserData.getText(UiTexts.are_you_sure)}',
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == '2'
                          ? Colors.white
                          : Colors.black)),
              content: new Text('${UserData.getText(UiTexts.do_you_want_to_exit)}',
                  style: TextStyle(
                      color: ThemeProvider.themeOf(context).id == '2'
                          ? Colors.white
                          : Colors.black)),
              actions: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: Text("${UserData.getText(UiTexts.no)}",
                      style: TextStyle(
                          color: ThemeProvider.themeOf(context).id == '2'
                              ? Colors.white
                              : Colors.black)),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => exit(0),
                  child: Text(
                    "${UserData.getText(UiTexts.yes)}",
                    style: TextStyle(
                        color: ThemeProvider.themeOf(context).id == '2'
                            ? Colors.white
                            : Colors.black),
                  ),
                ),
                SizedBox(
                  width: 5,
                  height: 25,
                )
              ],
            ),
          ) ??
          false);
    }

    void logOutPres() {}
    return ThemeConsumer(
      child: WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Center(child: Text("${UserData.getText(UiTexts.coins)}", textAlign: TextAlign.center)),
              actions: <Widget>[
                PopupMenuButton(
                    onSelected: (v) {
                      if (v == 1) {
                        //Navigator push not working from on tap function of popup menu item
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                        UserData.logOut();
                      } else {
                        if (ThemeProvider.themeOf(context).id == '1') {
                          ThemeProvider.controllerOf(context).setTheme('2');
                        } else {
                          ThemeProvider.controllerOf(context).setTheme('1');
                        }
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    color: ThemeProvider.themeOf(context).id == '1'
                        ? Colors.white
                        : darkBackground,
                    elevation: 40,
                    itemBuilder: (context) => [
                          PopupMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        child: Text("${UserData.userName[0]}"),
                                        radius: 13,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        UserData.userName,
                                        style: TextStyle(fontSize: 13),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 26.0),
                                    child: Text(
                                      UserData.userMail,
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 26.0),
                                    child: Text(
                                      "Log Out",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            value: 1,
                            onTap: logOutPres,
                          ),
                          PopupMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                textBaseline: TextBaseline.ideographic,
                                children: [
                                  Text(
                                    "${UserData.getText(UiTexts.theme)} : ${ThemeProvider.themeOf(context).id == '1' ? "${UserData.getText(UiTexts.dark)}" : "${UserData.getText(UiTexts.light)}"}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "${UserData.getText(UiTexts.change_theme)}",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          ThemeProvider.themeOf(context).id ==
                                                  '2'
                                              ? Colors.white
                                              : darkBackground,
                                    ),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.start,
                              ),
                            ),
                            value: 2,
                            onTap: () async {
                              /*await _themeProvider.setTheme(
                                  _themeProvider.getTheme == lightTheme
                                      ? darkTheme
                                      : lightTheme);*/
                            },
                          ),
                        ]),
              ],
            ),
            body: RefreshIndicator(
              onRefresh: () => coins.checkPrice(),
              child: ListView.separated(
                  itemBuilder: (BuildContext context, int coin) {
                    Widget graphic = Container();
                    bool graphicLoaded = false;

                    getGraphic(Coin coin) {
                      if (!graphicLoaded) {
                        graphic = GraphicHistory(
                          coin: coin,
                          isDetailed: false,
                        );
                        graphicLoaded = true;
                      }
                      return graphic;
                    }

                    return ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      leading: selected.contains(table[coin])
                          ? CircleAvatar(
                              child: Icon(Icons.check),
                            )
                          : SizedBox(
                              child: Image.network(table[coin].icon),
                              width: 40,
                            ),
                      title: Row(
                        children: [
                          Flexible(
                            flex: 30,
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        table[coin].name,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "%${(table[coin].changeDay * 100).toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: table[coin]
                                                        .changeDay
                                                        .toDouble() >
                                                    0
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                                getGraphic(table[coin]),
                              ],
                            ),
                          ),
                          Flexible(flex: 1, child: Container()),
                          Flexible(
                            flex: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              textBaseline: TextBaseline.alphabetic,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    real.format(table[coin].price),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            Colors.red.withOpacity(0),
                                        child: Image.asset(
                                          "images/bull.png",
                                          width: 40,
                                          height: 40,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: CircleAvatar(
                                          radius: 17,
                                          backgroundColor: Colors.green,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        '1'
                                                    ? Colors.white
                                                    : darkBackground,
                                            child: Text(
                                              "${math.nextInt(100)}",
                                              style: TextStyle(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          '2'
                                                      ? Colors.white
                                                      : darkBackground,
                                                  fontSize: 14),
                                            ),
                                            radius: 15,
                                          )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                        backgroundColor:
                                            Colors.red.withOpacity(0),
                                        child: Image.asset(
                                          "images/bear.png",
                                          width: 40,
                                          height: 40,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 4),
                                      child: CircleAvatar(
                                          radius: 17,
                                          backgroundColor: Colors.green,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        '1'
                                                    ? Colors.white
                                                    : darkBackground,
                                            child: Text(
                                              "${math.nextInt(100)}",
                                              style: TextStyle(
                                                  color: ThemeProvider.themeOf(
                                                                  context)
                                                              .id ==
                                                          '2'
                                                      ? Colors.white
                                                      : darkBackground,
                                                  fontSize: 14),
                                            ),
                                            radius: 15,
                                          )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      selected: selected.contains(table[coin]),
                      onTap: () => showDetails(table[coin], context),
                    );
                  },
                  padding: EdgeInsets.all(16),
                  separatorBuilder: (_, __) => Divider(),
                  itemCount: table.length),
            ),
          )),
    );
  }
}
