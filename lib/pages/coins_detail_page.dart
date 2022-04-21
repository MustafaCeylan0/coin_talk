// ignore_for_file: prefer_const_constructors, unused_local_variable, avoid_unnecessary_containers

import 'dart:math';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_talk/models/coin.dart';
import 'package:coin_talk/theme_changer.dart';
import 'package:coin_talk/widgets/graphic_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_particle_bg/flutter_particle_bg.dart';
import 'package:intl/intl.dart';
import 'package:particles_flutter/particles_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../constants.dart' as constants;
import '../constants.dart';

// ignore: must_be_immutable
class CoinsDetailPage extends StatefulWidget {
  Coin coin;

  CoinsDetailPage({Key? key, required this.coin}) : super(key: key);

  @override
  _CoinsDetailPageState createState() => _CoinsDetailPageState();
}

class _CoinsDetailPageState extends State<CoinsDetailPage> {
  //CHAT

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String messageText;

  @override
  void initState() {
    getCurrUser();
  }

  void getCurrUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        //print("----||| logged in user: ${loggedInUser.email}");
      }
    } catch (e) {
      print(e);
    }
  }

  /*void getMessages() async{

    final messages = await _firestore.collection("main_chat_messages").get();
    for(var message in messages.docs){
      print(message.data());
    }
  }*/



  //CHAT

  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: '\$');

  double amount = 0;
  Widget graphic = Container();
  bool graphicLoaded = false;

  getGraphic() {
    if (!graphicLoaded) {
      graphic = GraphicHistory(
        coin: widget.coin,
        isDetailed: true,
      );
      graphicLoaded = true;
    }
    return graphic;
  }

  @override
  Widget build(BuildContext context) {
    var detailGraph = getGraphic();

    return ThemeConsumer(
      child: Scaffold(
        backgroundColor: ThemeProvider.themeOf(context).id == '1'
            ? Color(0xfff3f0e9)
            : constants.darkBackground,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(widget.coin.name),
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
          ),
          child: Column(
            children: [
              detailGraph,
              (amount > 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        child: Text(
                          '$amount ${widget.coin.initials}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.teal,
                          ),
                        ),
                        margin: EdgeInsets.only(bottom: 24),
                        padding: EdgeInsets.all(12),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: Colors.teal.withOpacity(0.06)),
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.only(bottom: 24),
                    ),
              Expanded(
                child: MooooooBackground(
                  linewidth: 1,
                  pointnumber: 25,
                  pointspeed: 0.2,
                  linecolor: constants.binanceYellowDLT,
                  backgroundcolor: Colors.red.withOpacity(0),
                  pointcolor: ThemeProvider.themeOf(context).id == '2'
                      ? Colors.white
                      : Colors.black,
                  pointsize: ThemeProvider.themeOf(context).id == '2' ? 4 : 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChatStreamBuilder(
                          firestore: _firestore, cName: widget.coin.name),
                      SafeArea(
                        child: Container(
                          decoration: constants.kMessageContainerDecoration,

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: TextField(
                                  controller: messageEditController,
                                  onChanged: (value) {
                                    //Do something with the user input.

                                    messageText = value;
                                  },
                                  decoration:
                                      constants.kMessageTextFieldDecoration,
                                ),
                              ),
                              TextButton(
                                onPressed: () async {
                                  //Implement send functionality.
                                  try {
                                    if (messageText != null &&
                                        !messageText.isEmpty) {
                                      _firestore
                                          .collection(
                                              "${widget.coin.name}_chat_messages")
                                          .add({
                                        "sender": loggedInUser.email,
                                        "text": messageText,
                                        'timestamp': new DateTime.now(),
                                        'sender_name':
                                            await constants.UserData.getName(),
                                        // Added timestamp.
                                      });

                                      //Clear the entry box
                                      messageEditController.clear();
                                      messageText = "";
                                    }
                                  } catch (e) {}
                                },
                                child: Icon(
                                  Icons.send_outlined,
                                  color: constants.binanceYellowDLT,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

final messageEditController = TextEditingController();
late User loggedInUser;

class ChatStreamBuilder extends StatelessWidget {
  final String cName;

  const ChatStreamBuilder(
      {Key? key, required FirebaseFirestore firestore, required this.cName})
      : _firestore = firestore,
        super(key: key);

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("${cName}_chat_messages")
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlue,
              ),
            );
          }

          final messages = snapshot.data?.docs.reversed;
          List<Widget> messageWidgets = [];
          for (var message in messages!) {
            final messageText = message["text"];
            final messageSender = message["sender"];
            final messageTime = message["timestamp"];
            String? senderName;
            try {
              senderName = message['sender_name'];
            } catch (e) {
              senderName = 'noname';
            }
            final currUserMail = loggedInUser.email;

            messageWidgets.add(MessageBubble(
              messageSender: messageSender,
              messageText: messageText,
              isFromCurr: currUserMail == messageSender,
              messageTime: messageTime,
              senderName: senderName,
            ));
          }
          return Expanded(
              child: messageWidgets.isEmpty
                  ? Center(
                      child: Text("${UserData.getText(UiTexts.start_chat)}"),
                    )
                  : ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      children: messageWidgets));
        });
  }
}

class MessageBubble extends StatelessWidget {
  static List<String> usersInChat = [];
  static List<Color> userColorsInChat = [];
  List<Color> colors = [
    Colors.green,
    Colors.purple,
    Colors.cyan,
    Colors.pink,
  ];

  MessageBubble(
      {Key? key,
      required this.isFromCurr,
      required this.messageSender,
      required this.messageText,
      required this.messageTime,
      required this.senderName})
      : super(key: key);

  final messageSender;
  final senderName;
  final messageText;
  final isFromCurr;
  final Timestamp messageTime;

  void resetColors() {
    colors = [
      Colors.green,
      Colors.purple,
      Colors.cyan,
      Colors.pink,
    ];
  }

  Color getNameColor(String userName) {
    if (usersInChat.contains(userName)) {
      return userColorsInChat[usersInChat.indexOf(userName)];
    } else {
      Random random = new Random();
      int rand = random.nextInt(colors.length);
      usersInChat.add(userName);
      userColorsInChat.add(colors[rand]);
      colors.removeAt(rand);
      if (colors.length == 0) {
        resetColors();
      }
      return getNameColor(userName);
    }
  }

  double getWidthConstrain(int textLength, int userNameLength) {
    int decider = textLength > userNameLength ? textLength : userNameLength;
    if (decider < 45) {
      return 0.2 + (decider - 10) * 0.016;
    } else {
      return 0.7;
    }
  }

  @override
  Widget build(BuildContext context) {
    int textCount = messageText.toString().length;
    int nameCount = senderName.toString().length;

    return Column(
      crossAxisAlignment:
          isFromCurr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width *
                    getWidthConstrain(textCount, nameCount)),
            decoration: BoxDecoration(
              borderRadius: isFromCurr
                  ? BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topLeft: Radius.circular(12))
                  : BorderRadius.only(
                      bottomRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
              color: isFromCurr
                  ? constants.binanceYellowDLT
                  : (ThemeProvider.themeOf(context).id == '1'
                      ? Colors.white
                      : constants.secondary),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                !isFromCurr
                    ? Padding(
                        padding: const EdgeInsets.only(left: 5, top: 5),
                        child: Text(
                          "$senderName",
                          style: TextStyle(
                              color: getNameColor(senderName),
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    : Material(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10, top: 6),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: isFromCurr
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            '$messageText',
                            style: TextStyle(
                              color: ThemeProvider.themeOf(context).id == '2'
                                  ? Colors.white
                                  : darkBackground,
                            ),
                            maxLines: 200,
                            softWrap: true,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "${messageTime.toDate().hour}. ${messageTime.toDate().minute}",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

