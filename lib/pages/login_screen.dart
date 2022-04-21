import 'package:coin_talk/pages/coins_page.dart';
import 'package:coin_talk/theme_changer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:theme_provider/theme_provider.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

bool _saving = false;
final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  String mail_or_name = " ";
  String password = " ";
  final _formKey = GlobalKey<FormState>();

  void changeDear(newNickname) {
    setState(() {
      mail_or_name = newNickname;
    });
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
                                  "${UserData.getText(UiTexts.welcome_to_coin_talk)} $mail_or_name.",
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
                                        onChanged: (value) {
                                          changeDear(value);
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return '${UserData.getText(UiTexts.mail_field_cannot_be_empty)}';
                                          }
                                          mail_or_name = value;

                                          return null;
                                        },
                                        decoration: kTextFieldDecoration.copyWith(
                                            hintText:
                                                "${UserData.getText(UiTexts.enter_your_mail_or_nickname)}"),
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
                                          }else if(value.length <6){
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
                                    padding: const EdgeInsets.only(
                                        left: 40.0, right: 40, top: 30),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: binanceYellowDLT,
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                               SnackBar(
                                                  content:
                                                      Text('${UserData.getText(UiTexts.processing_data)}')),
                                            );

                                            //Log in stuff
                                            setState(() {
                                              _saving = true;
                                            });

                                            try {
                                              //try to find the nickname in the user profiles
                                              String? emailFromName =
                                                  await UserData
                                                      .retrieveMailFromName(
                                                          mail_or_name);
                                              print("retrieved email is ${emailFromName ?? 'no name'}");
                                              if (emailFromName != null) {
                                                mail_or_name = emailFromName;
                                              }
                                            } catch (e) {}

                                            try {
                                              final user = await _auth
                                                  .signInWithEmailAndPassword(
                                                      email: mail_or_name,
                                                      password: password);
                                              if (user != null) {
                                                await UserData.logIn(
                                                    mail_or_name);
                                                ScaffoldMessenger.of(context)
                                                    .clearSnackBars();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          CoinsPage(),
                                                    ));
                                              } else {
                                                setState(() {
                                                  _saving = false;
                                                });
                                              }
                                            } catch (e) {
                                              setState(() {
                                                _saving = false;
                                              });
                                              print(e);
                                            }
                                            setState(() {
                                              _saving = false;
                                            });
                                          }
                                        },
                                        child: Text(
                                          "${UserData.getText(UiTexts.log_in)}",
                                          style: TextStyle(
                                            color:
                                                ThemeProvider.themeOf(context)
                                                            .id ==
                                                        '2'
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        )),
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
                                      //go to register page
                                      Navigator.pushNamed(context,
                                          Screens.register_screen.toString());
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                        style: TextStyle(
                                          color: ThemeProvider.themeOf(context)
                                                      .id ==
                                                  '1'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                              style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        '2'
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              text: UserData.getText(UiTexts
                                                  .dont_have_an_account)),
                                          TextSpan(
                                            style: TextStyle(
                                                color: ThemeProvider.themeOf(
                                                                context)
                                                            .id ==
                                                        '2'
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.bold),
                                            text:' ${UserData.getText(UiTexts.register)}.',
                                          ),
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
