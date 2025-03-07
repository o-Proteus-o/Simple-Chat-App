class Message {
  final String message;
  final String? id;
  Message(this.message, this.id);

  factory Message.fromJson(dynamic json) {
    return Message(json['message'], json['id']);
  }
}
