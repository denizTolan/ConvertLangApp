class Content {
  String contentText;
  DateTime createdOn;

  Content({required this.contentText, required this.createdOn});

  Map<String, dynamic> toMap() {
    return {
      'contentText': contentText,
      'createdOn': createdOn,
    };
  }

  factory Content.fromMap(Map<String, dynamic> map) {
    return Content(
      contentText: map['contentText'],
      createdOn: map['createdOn'].toDate(),
    );
  }
}