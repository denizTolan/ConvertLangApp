import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_lang_app/Providers/UserProviders.dart';
import 'package:convert_lang_app/Widgets/ChatWidgets/ChatMessageBox.dart';
import 'package:convert_lang_app/Widgets/ChatWidgets/ChatMessageWidget.dart';
import 'package:convert_lang_app/Widgets/FireBaseLibrary/FireBaseHelper.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen();

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [];
  User? user = null;

  void _onUserWriteMessage(String message,bool isAudio,bool isSender) async {
    _sendMessage(message,isAudio,isSender);

    final fakerFa = Faker(provider: FakerDataProvider());

    _sendMessage(fakerFa.lorem.sentence(),false,false);
  }

  void _sendMessage(String message,bool isAudio,bool isSender) async {
    final appDir = await getApplicationDocumentsDirectory();

    var user = Provider.of<UserProvider>(context).user;

    FireBaseHelper.setChatMessage(message.trim(), user!.uid);

    setState(() {
      messages.add(ChatMessage(
        text: message.trim(),
        isSender: isSender,
        sentDate: DateTime.now(),
        isAudio: isAudio,
        appDirectory: appDir,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          Container(
            color: Colors.grey[200], // Set the background color to gray
            padding: EdgeInsets.only(bottom: 50.0), // Add desired padding value
            child: ChatMessageBox(onUserWriteMessage: _onUserWriteMessage),
          ),
        ],
      ),
    );
  }
}
