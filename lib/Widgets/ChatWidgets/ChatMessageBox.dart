import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatMessageBox extends StatefulWidget {
  final Function(String,bool,bool) onUserWriteMessage;

  ChatMessageBox({required this.onUserWriteMessage});

  @override
  _ChatMessageBoxState createState() => _ChatMessageBoxState();
}

class _ChatMessageBoxState extends State<ChatMessageBox> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  bool _isRecordingVisible = true;
  bool _isRecordingStarted = false;
  bool _isMessageBoxWrittingVisible = false;
  bool _isKeyboardVisible = false;
  late Directory appDir;

  FlutterSoundRecorder? _recorder;
  late String? filePath;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initRecorder();
    KeyboardVisibilityController().onChange.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await Permission.microphone.request();
    appDir = await getApplicationDocumentsDirectory();
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.request().isGranted) {
      filePath = '${appDir.path}/recording_${DateTime.now()}.aac';
      setState(() {
        _isRecording = true;

        _isRecordingVisible = false;
        _isRecordingStarted = true;
      });

      await _recorder!.openRecorder();
      await _recorder!.startRecorder(toFile: filePath, codec: Codec.aacADTS);
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isRecording = false;

      _isRecordingVisible = true;
      _isRecordingStarted = false;
      this.widget.onUserWriteMessage(filePath!,true,true);
    });
    await _recorder!.stopRecorder();
    await _recorder!.closeRecorder();
  }

  void _deleteRecording() async {
    if (_isRecordingStarted) {
      setState(() {
        _isRecordingVisible = true;
        _isRecordingStarted = false;
      });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    _recorder?.closeRecorder();
    super.dispose();
  }

  void _handleSendMessage() {
    String message = _textEditingController.text.trim();
    if (message.isNotEmpty) {
      widget.onUserWriteMessage(message,false,true);
      _textEditingController.clear();
      _focusNode.unfocus();
      setState(() {
        _isRecordingVisible = true;
        _isMessageBoxWrittingVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isKeyboardVisible ? null : 56.0,
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Set the background color to a soft gray shade
                  borderRadius: BorderRadius.circular(20.0), // Set the border radius to make it rounded
                ),
                child: TextField(
                  controller: _textEditingController,
                  onTap: () {
                    setState(() {
                      _isRecordingVisible = false;
                      _isMessageBoxWrittingVisible = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: _isRecording ? 'Recording...' :'Type a message...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0), // Add horizontal padding within the text field
                  ),
                  focusNode: _focusNode,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !_isRecordingVisible && _isMessageBoxWrittingVisible,
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: _handleSendMessage,
            ),
          ),
          Visibility(
            visible: _isRecordingVisible,
            child: IconButton(
              icon: Icon(Icons.mic),
              onPressed: _startRecording,
            ),
          ),
          Visibility(
            visible: !_isMessageBoxWrittingVisible && !_isRecordingVisible && _isRecordingStarted,
            child: IconButton(
              icon: Icon(Icons.stop),
              onPressed: _stopRecording,
            ),
          ),
          Visibility(
            visible: !_isMessageBoxWrittingVisible && !_isRecordingVisible && _isRecordingStarted,
            child: IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteRecording,
            ),
          )
        ],
      ),
    );
  }
}
