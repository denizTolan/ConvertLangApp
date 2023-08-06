import 'ContentModel.dart';

class ChatModel {
  DateTime createdOn;
  List<Content> messages;
  String userId;

  ChatModel({required this.createdOn, required this.messages, required this.userId});

  Map<String, dynamic> toMap() {
    return {
      'createdOn': createdOn,
      'messages': messages.map((content) => content.toMap()).toList(),
      'userId': userId,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      createdOn: map['createdOn'].toDate(),
      messages: List<Content>.from(map['messages'].map((contentMap) => Content.fromMap(contentMap))),
      userId: map['userId'],
    );
  }
}
