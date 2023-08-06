import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convert_lang_app/Widgets/FireBaseLibrary/DatabaseModel/ChatModel.dart';
import 'package:convert_lang_app/Widgets/FireBaseLibrary/DatabaseModel/ContentModel.dart';

class FireBaseHelper {

  static void setChatMessage(String message,String? userId) {
    CollectionReference collection = FirebaseFirestore.instance.collection('Chat');

    ChatModel tableData = ChatModel(
      createdOn: DateTime.now(),
      messages: [
        Content(contentText: message, createdOn: DateTime.now()),
      ],
      userId: userId!,
    );

    Map<String, dynamic> data = tableData.toMap();

    collection.add(data)
        .then((value) => print("Data added to Firestore with ID: ${value.id}"))
        .catchError((error) => print("Failed to add data: $error"));
  }
}
