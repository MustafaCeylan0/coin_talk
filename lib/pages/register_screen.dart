import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:coin_talk/constants.dart';
import 'package:theme_provider/theme_provider.dart';

import '../theme_changer.dart';
import 'coins_page.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _auth = FirebaseAuth.instance;
  bool _saving = false;
  String mail = "";
  String password = "";
  String nickname = "";
  final _formKey = GlobalKey<FormState>();

  void changeDear(newNickname) {
    setState(() {
      nickname = newNickname;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement initState
    Locale myLocale = Localizations.localeOf(context);
    //print("country code is ${myLocale.languageCode}");
    String? languageCode = myLocale.languageCode;
    UserData.setLanguageCode(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return ThemeConsumer(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: _saving,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Hero(
                            tag: HeroTags.circle_avatar.toString(),
                            child: Material(
                              color: Colors.red.withOpacity(0),
                              child: Padding(
                                padding: EdgeInsets.only(top: 100),
                                child: CircleAvatar(
                                  backgroundColor:
                                      ThemeProvider.themeOf(context).id == '2'
                                          ? Colors.white
                                          : Colors.black26,
                                  child: Icon(
                                    Icons.person,
                                    size: 95,
                                    color: background,
                                  ),
                                  radius: 80,
                                ),
                              ),
                            ),
                          ),
                          Hero(
                            tag: HeroTags.dear,
                            child: Material(
                              color: Colors.red.withOpacity(0),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  "${UserData.getText(UiTexts.welcome_to_coin_talk)} $nickname.",
                                  style: welcomeTextStyle.copyWith(
                                    color:
                                        ThemeProvider.themeOf(context).id == '2'
                                            ? Colors.white
                                            : Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5.0, right: 20, bottom: 5, left: 20),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      changeDear(value);
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return '${UserData.getText(UiTexts.nickname_field_cannot_be_empty)}';
                                      }

                                      nickname = value;

                                      return null;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: "${UserData.getText(UiTexts.enter_your_nickname)}"),
                                  ),
                                ),
                                Hero(
                                  tag: HeroTags.email_input_field,
                                  child: Material(
                                    color: Colors.red.withOpacity(0),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 5.0,
                                          right: 20,
                                          bottom: 5,
                                          left: 20),
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '${UserData.getText(UiTexts.mail_field_cannot_be_empty)}';
                                          }
                                          bool emailValid = RegExp(
                                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(value);
                                          if (!emailValid) {
                                            return '${UserData.getText(UiTexts.please_enter_a_valid_email)} ';
                                          }
                                          mail = value;

                                          return null;
                                        },
                                        decoration: kTextFieldDecoration.copyWith(
                                            hintText:
                                                "${UserData.getText(UiTexts.enter_your_mail)}"),
                                      ),
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: HeroTags.password_input_field,
                                  child: Material(
                                    color: Colors.red.withOpacity(0),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 5,
                                          right: 20,
                                          bottom: 10,
                                          left: 20),
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '${UserData.getText(UiTexts.password_field_cannot_be_empty)}';
                                          } else if (value.length < 6) {
                                            return '${UserData.getText(UiTexts.password_length_must_be_greater_than_6)}';
                                          }
                                          password = value;

                                          return null;
                                        },
                                        decoration:
                                            kTextFieldDecoration.copyWith(
                                                hintText:
                                                    "${UserData.getText(UiTexts.enter_your_password)}"),
                                      ),
                                    ),
                                  ),
                                ),
                                Material(
                                  color: Colors.red.withOpacity(0),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: binanceYellowDLT,
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              _saving = true;
                                            });

                                            try {
                                              final newUser = await _auth
                                                  .createUserWithEmailAndPassword(
                                                      email: mail,
                                                      password: password);
                                              if (newUser != null) {
                                                UserData.register(
                                                    mail, nickname);
                                                Navigator.pushNamed(
                                                    context,
                                                    Screens.coin_dashboard
                                                        .toString());
                                              } else {}
                                            } catch (e) {
                                              String snackMessage =
                                                  '${UserData.getText(UiTexts.please_enter_a_valid_email)}';
                                              if (e.toString().split("] ")[1] ==
                                                  "The email address is already in use by another account.") {
                                                snackMessage =
                                                    "${UserData.getText(UiTexts.there_is_already_an_account_with_this_mail)}";
                                              }
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content:
                                                        Text(snackMessage)),
                                              );
                                              print(" e is $e");
                                            }
                                            setState(() {
                                              _saving = false;
                                            });
                                          }
                                        },
                                        child: Text("Register")),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Hero(
                          tag: HeroTags.already_text,
                          child: Material(
                            color: Colors.red.withOpacity(0),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Divider(color: Colors.grey),
                                  GestureDetector(
                                    onTap: () {
                                      //go to login page
                                      Navigator.pushNamed(context,
                                          Screens.login_screen.toString());
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: 'Already have an account?',
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        '2'
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                          TextSpan(
                                              text: ' Log in.',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        '2'
                                                    ? Colors.white
                                                    : Colors.black,
                                              )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/*

 */
