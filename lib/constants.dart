import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Enums, Lists
enum Screens {
  welcome_screen,
  login_screen,
  register_screen,
  coin_dashboard,
  chat_screen,
  home_page
}
enum HeroTags {
  circle_avatar,
  email_input_field,
  password_input_field,
  enter_button,
  already_text,
  dear,
  coin_image_kk,
  graph
}

enum UiTexts {
  coins,
  log_out,
  theme,
  dark,
  light,
  change_theme,
  type_your_message_here,
  hour,
  day,
  month,
  year,
  all,
  enter_your_mail_or_nickname,
  enter_your_password,
  welcome_to_coin_talk,
  log_in,
  dont_have_an_account,
  register,
  already_have_an_account,
  mail_field_cannot_be_empty,
  password_field_cannot_be_empty,
  please_enter_a_valid_email,
  password_length_must_be_greater_than_6,
  processing_data,
  nickname_field_cannot_be_empty,
  enter_your_nickname,
  enter_your_mail,
  there_is_already_an_account_with_this_mail,
  are_you_sure,
  yes,
  no,
  do_you_want_to_exit,
  start_chat,
}

enum SPkeys {
  //Shared preferences key values
  name, //String, user's nickname
  mail, //String, user's mail address
  logStatus, //Boolean, if the user already logged in or not
}
enum KTheme { light, dark, system }

List<String> coinNames = [
  "Bitcoin",
  "Ethereum",
  "BNB",
  "XRP",
  "Cardano",
  "Terra",
  "Solana",
  "Avalanche",
  "Polkadot",
  "Dogecoin",
];

//Decoration & Styles
const kTextFieldDecoration = InputDecoration(
  fillColor: Colors.white10,
  hintText: 'Enter a value...',
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: binanceYellowDLT, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: binanceYellowDLT, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
  ),
);

var kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: '${UserData.getText(UiTexts.type_your_message_here)}',
  border: InputBorder.none,
);

const kSendButtonTextStyle = TextStyle(
  color: binanceYellowDLT,
  fontSize: 18.0,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: binanceYellowDLT, width: 2.0),
  ),
);

//Colors
const binanceYellowDLT = Color(0xffF0B90B);
const binanceYellowSecondaryDLT = Color(0xff45370a);
var background = Color(0xff0C0E12);
var secondary = (Color(0xff1c1e24));

const lightBackground = Colors.white70;
const lightSecondary = Colors.white;

const darkBackground = Color(0xff0C0E12);
const darkSecondary = (Color(0xff1c1e24));

//graph color gradient
List<Color> positiveGraphColors = [
  Colors.green,
  Colors.cyan,
  Colors.greenAccent,
  Colors.green,
];
List<Color> negativeGraphColors = [
  Colors.red,
  Colors.purple,
  Colors.pink,
  Colors.red,
];

//TextStyles
const welcomeTextStyle =
    TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700);

Map tr_texts = {
  UiTexts.coins.toString(): 'Coinler',
  UiTexts.log_out.toString(): 'Çıkış Yap',
  UiTexts.theme.toString(): 'Tema',
  UiTexts.dark.toString(): 'Karanlık',
  UiTexts.light.toString(): 'Aydınlık',
  UiTexts.change_theme.toString(): 'Temayı Değiştir',
  UiTexts.type_your_message_here.toString(): 'Mesajınızı buraya girin',
  UiTexts.hour.toString(): 'S',
  UiTexts.day.toString(): 'D',
  UiTexts.month.toString(): 'A',
  UiTexts.year.toString(): 'Y',
  UiTexts.all.toString(): 'Toplam',
  UiTexts.enter_your_mail_or_nickname.toString():
      'Mail adresi veya kullanıcı adı girin.',
  UiTexts.enter_your_password.toString(): 'Şifrenizi girin.',
  UiTexts.welcome_to_coin_talk.toString(): 'CoinTalk\'a Hoşgeldiniz sayın,',
  UiTexts.log_in.toString(): 'Giriş yap.',
  UiTexts.dont_have_an_account.toString(): 'Bir hesabınız yok mu?',
  UiTexts.register.toString(): 'Kayıt ol',
  UiTexts.already_have_an_account.toString(): 'Zaten bir hesabınız var mı?',
  UiTexts.mail_field_cannot_be_empty.toString(): 'Mail alanı boş bırakılamaz.',
  UiTexts.password_field_cannot_be_empty.toString():
      'Şifre alanı boş bırakılamaz',
  UiTexts.please_enter_a_valid_email.toString():
      'Lütfen geçerli bi mail adresi girin',
  UiTexts.password_length_must_be_greater_than_6.toString():
      'Şifre uzunluğu 6 karakterden fazla olmalıdır',
  UiTexts.processing_data.toString(): 'Bilgiler işleniyor...',
  UiTexts.nickname_field_cannot_be_empty.toString():
      'İsim alanı boş bırakılamaz.',
  UiTexts.enter_your_nickname.toString(): 'Kullanıcı adını girin.',
  UiTexts.enter_your_mail.toString(): 'Mail adresi girin.',
  UiTexts.there_is_already_an_account_with_this_mail.toString():
      'Girdiğiniz mail adresi başka bir hesaba ait.',
  UiTexts.are_you_sure.toString(): 'Emin misiniz?',
  UiTexts.yes.toString(): 'Evet',
  UiTexts.no.toString(): 'Hayır',
  UiTexts.do_you_want_to_exit.toString():
      'Uygulamadan çıkmak mı istiyorsunuz?.',
  UiTexts.start_chat.toString(): 'Konuşmayı Başlat',
};
Map en_texts = {
  UiTexts.coins.toString(): 'Coins',
  UiTexts.log_out.toString(): 'Log Out',
  UiTexts.theme.toString(): 'Theme',
  UiTexts.dark.toString(): 'Dark',
  UiTexts.light.toString(): 'Light',
  UiTexts.change_theme.toString(): 'Change Theme',
  UiTexts.type_your_message_here.toString(): 'Type your message here.',
  UiTexts.hour.toString(): 'H',
  UiTexts.day.toString(): 'D',
  UiTexts.month.toString(): 'M',
  UiTexts.year.toString(): 'Y',
  UiTexts.all.toString(): 'All',
  UiTexts.enter_your_mail_or_nickname.toString():
      'enter your mail or nickname.',
  UiTexts.enter_your_password.toString(): 'Enter your password.',
  UiTexts.welcome_to_coin_talk.toString(): 'Welcome to coin talk dear,',
  UiTexts.log_in.toString(): 'Log In',
  UiTexts.dont_have_an_account.toString(): 'Don\'t have an account?',
  UiTexts.register.toString(): 'Register',
  UiTexts.already_have_an_account.toString(): 'Already have an account?',
  UiTexts.mail_field_cannot_be_empty.toString(): 'Mail field cannot be empty.',
  UiTexts.password_field_cannot_be_empty.toString():
      'Password field cannot be empty.',
  UiTexts.please_enter_a_valid_email.toString(): 'Please enter a valid email.',
  UiTexts.password_length_must_be_greater_than_6.toString():
      'Password length must be greater than 6.',
  UiTexts.processing_data.toString(): 'Processing Data...',
  UiTexts.nickname_field_cannot_be_empty.toString():
      'Nickname field cannot be empty.',
  UiTexts.enter_your_nickname.toString(): 'Enter nickname.',
  UiTexts.enter_your_mail.toString(): 'Enter your mail.',
  UiTexts.there_is_already_an_account_with_this_mail.toString():
      'There is already an account with this mail.',
  UiTexts.are_you_sure.toString(): 'Are you sure?',
  UiTexts.yes.toString(): 'Yes',
  UiTexts.no.toString(): 'No',
  UiTexts.do_you_want_to_exit.toString(): 'Do you want to exit?',
  UiTexts.start_chat.toString(): 'Start Chat',
};

//User Information
class UserData {
  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  static String languageCode = "en";
  static String userMail = "";
  static String userName = "";
  static bool isLoggedIn = false;
  static KTheme currTheme = KTheme.dark;

  static void setLanguageCode(String newLanguageCode) {
    languageCode = newLanguageCode;
  }

  static String getText(UiTexts uiText) {
    Map currTextMap = en_texts;

    switch (languageCode) {
      case 'en':
        currTextMap = en_texts;
        break;
      case 'tr':
        currTextMap = tr_texts;
        break;
    }
    switch (uiText) {
      case UiTexts.coins:
        return currTextMap[UiTexts.coins.toString()];
      case UiTexts.log_out:
        return currTextMap[UiTexts.log_out.toString()];

      case UiTexts.theme:
        return currTextMap[UiTexts.theme.toString()];

      case UiTexts.dark:
        return currTextMap[UiTexts.dark.toString()];

      case UiTexts.light:
        return currTextMap[UiTexts.light.toString()];

      case UiTexts.change_theme:
        return currTextMap[UiTexts.change_theme.toString()];

      case UiTexts.type_your_message_here:
        return currTextMap[UiTexts.type_your_message_here.toString()];

      case UiTexts.hour:
        return currTextMap[UiTexts.hour.toString()];

      case UiTexts.day:
        return currTextMap[UiTexts.day.toString()];

      case UiTexts.month:
        return currTextMap[UiTexts.month.toString()];

      case UiTexts.year:
        return currTextMap[UiTexts.year.toString()];

      case UiTexts.all:
        return currTextMap[UiTexts.all.toString()];

      case UiTexts.enter_your_mail_or_nickname:
        return currTextMap[UiTexts.enter_your_mail_or_nickname.toString()];

      case UiTexts.enter_your_password:
        return currTextMap[UiTexts.enter_your_password.toString()];

      case UiTexts.welcome_to_coin_talk:
        return currTextMap[UiTexts.welcome_to_coin_talk.toString()];

      case UiTexts.log_in:
        return currTextMap[UiTexts.log_in.toString()];

      case UiTexts.dont_have_an_account:
        return currTextMap[UiTexts.dont_have_an_account.toString()];
      case UiTexts.register:
        return currTextMap[UiTexts.register.toString()];

      case UiTexts.already_have_an_account:
        return currTextMap[UiTexts.already_have_an_account.toString()];

      case UiTexts.mail_field_cannot_be_empty:
        return currTextMap[UiTexts.mail_field_cannot_be_empty.toString()];

      case UiTexts.password_field_cannot_be_empty:
        return currTextMap[UiTexts.password_field_cannot_be_empty.toString()];

      case UiTexts.please_enter_a_valid_email:
        return currTextMap[UiTexts.please_enter_a_valid_email.toString()];

      case UiTexts.password_length_must_be_greater_than_6:
        return currTextMap[
            UiTexts.password_length_must_be_greater_than_6.toString()];

      case UiTexts.processing_data:
        return currTextMap[UiTexts.processing_data.toString()];
      case UiTexts.nickname_field_cannot_be_empty:
        return currTextMap[UiTexts.nickname_field_cannot_be_empty.toString()];
      case UiTexts.enter_your_nickname:
        return currTextMap[UiTexts.enter_your_nickname.toString()];
      case UiTexts.enter_your_mail:
        return currTextMap[UiTexts.enter_your_mail.toString()];
      case UiTexts.are_you_sure:
        return currTextMap[UiTexts.are_you_sure.toString()];
      case UiTexts.yes:
        return currTextMap[UiTexts.yes.toString()];
      case UiTexts.no:
        return currTextMap[UiTexts.no.toString()];
      case UiTexts.do_you_want_to_exit:
        return currTextMap[UiTexts.do_you_want_to_exit.toString()];
      case UiTexts.start_chat:
        return currTextMap[UiTexts.start_chat.toString()];
    }
    return "no text";
  }

  //Gets: user name, user mail, login status
  //Sets: user name, user mail, login status
  //Actions: log in, log out

  static Future<String> getName() async {
    if (userName.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      userName = (await prefs.getString(SPkeys.name.toString()))!;
    }
    return userName;
  }

  static Future<String> getMail() async {
    if (userMail.isEmpty) {
      final prefs = await SharedPreferences.getInstance();
      userMail = (await prefs.getString(SPkeys.mail.toString()))!;
    }
    return userMail;
  }

  static Future<bool> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = await prefs.getBool(SPkeys.logStatus.toString());
    return isLoggedIn ?? false;
  }

  static Future<void> setName(String name) async {
    userName = name;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPkeys.name.toString(), name);
  }

  static Future<void> setMail(String mail) async {
    userMail = mail;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SPkeys.mail.toString(), mail);
  }

  static Future<void> setLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SPkeys.logStatus.toString(), true);
  }

  static Future<void> logOut() async {
    final prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
    await prefs.setBool(SPkeys.logStatus.toString(), false);
    await prefs.remove(SPkeys.name.toString());
    await prefs.remove(SPkeys.mail.toString());
  }

  static Future<void> logIn(String mail) async {
    setMail(mail);
    var collection = _firestore.collection('user_profiles');
    var docSnapshot =
        await collection.where('user_mail', isEqualTo: mail).get();
    QuerySnapshot<Map<String, dynamic>> data = docSnapshot;
    var name = data.docs.first["user_name"];
    setName(name);
    setLoggedIn();
  }

  static Future<String?> retrieveMailFromName(String userName) async {
    try {
      var collection = _firestore.collection('user_profiles');
      var docSnapshot =
          await collection.where('user_name', isEqualTo: userName).get();
      QuerySnapshot<Map<String, dynamic>> data = docSnapshot;
      var mailR = data.docs.first["user_mail"];
      print("------------------>$mailR");
      return mailR;
    } catch (e) {
      print("from retrieve email");
      print(e);
    }
  }

  static Future<void> register(String mail, String name) async {
    setName(name);
    setMail(mail);
    _firestore
        .collection("user_profiles")
        .add({"user_mail": mail, "user_name": name});

    setLoggedIn();
  }

  static Future<void> SetUpPrefs() async {
    isLoggedIn = await getLoginStatus();
    if (isLoggedIn) {
      await setName(await getName());
      await setMail(await getMail());
    }
  }

  static Future<KTheme> setTheme(KTheme th) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", th.toString());
    if (th != KTheme.system) {
      if (th == KTheme.dark) {
        currTheme = KTheme.dark;
        background = darkBackground;
        secondary = darkSecondary;
      } else if (th == KTheme.light) {
        currTheme = KTheme.light;
        background = lightBackground;
        secondary = lightSecondary;
      }
    } else {
      var brightness = SchedulerBinding.instance!.window.platformBrightness;
      bool isDarkMode = brightness == Brightness.dark;

      if (isDarkMode) {
        setTheme(KTheme.dark);
      } else {
        setTheme(KTheme.light);
      }
    }
    return currTheme;
  }
}
