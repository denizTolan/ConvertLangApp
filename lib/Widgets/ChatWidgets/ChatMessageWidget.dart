import 'dart:io';

import 'package:convert_lang_app/Widgets/ChatWidgets/WaveBubbleWidget.dart';
import 'package:convert_lang_app/Widgets/HelperWidgets/ColorChangingIconButtonWidget.dart';
import 'package:convert_lang_app/Widgets/SpeechWidgets/TextToSpeechButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSender;
  final DateTime sentDate;
  final bool isAudio;
  final Directory appDirectory;

  ChatMessage(
      {required this.text,
      required this.isSender,
      required this.sentDate,
      required this.isAudio,
      required this.appDirectory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        !isAudio
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: isSender ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Container(
                    constraints: BoxConstraints(
                      maxWidth: 300, // Set the desired maximum width
                    ),
                    child:Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: text,
                                  style: TextStyle(
                                    color: isSender ? Colors.white : Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if(!isSender)
                          TextToSpeechButton(text: text)
                      ],
                    )
            )
        )
            : WaveBubble(
                path: this.text,
                isSender: true,
                appDirectory: appDirectory,
              ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            DateFormat('HH:mm').format(DateTime.now()),
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey[400],
            ),
          ),
        ),
      ],
    );
  }
}
