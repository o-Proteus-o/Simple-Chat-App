import 'package:chat_app/model/message.dart';
import 'package:chat_app/widgets/chatbuble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});
  static const String routname = "/room";
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  CollectionReference messages = FirebaseFirestore.instance.collection(
    "messages",
  );
  TextEditingController messagecontroller = TextEditingController();
  final controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('Created at', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: ListTile(
                leading: Icon(Icons.chat, size: 28),
                title: Text("Chat Room"),
                subtitle: Row(
                  children: [
                    Icon(Icons.offline_bolt, size: 13),
                    SizedBox(width: 2),
                    Text("Offline", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              backgroundColor: Colors.grey,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].id == null
                          ? ChatBuble(message: messagesList[index])
                          : ChatBubbleFromFriend(message: messagesList[index]);
                    },
                  ),
                ),
                TextField(
                  onSubmitted: (value) {
                    messages.add({
                      "message": value,
                      "Created at": DateTime.now(),
                      "id": email,
                    });
                    messagecontroller.clear();
                    controller.animateTo(
                      0,
                      duration: Duration(microseconds: 100),
                      curve: Curves.easeIn,
                    );
                  },

                  controller: messagecontroller,
                  decoration: InputDecoration(
                    prefixIcon: Card(
                      color: Colors.grey,
                      shape: CircleBorder(),
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.add_box_outlined),
                      ),
                    ),
                    suffixIcon: Card(
                      color: Colors.grey,
                      shape: CircleBorder(),
                      child: IconButton(
                        onPressed: () {
                          if (messagecontroller.text.isNotEmpty) {
                            FirebaseFirestore.instance
                                .collection('messages')
                                .add({
                                  "message": messagecontroller.text,
                                  "Created at": DateTime.now(),
                                  "id": email,
                                })
                                .then((value) {
                                  messagecontroller.clear();
                                  controller.animateTo(
                                    0,
                                    duration: Duration(microseconds: 300),
                                    curve: Curves.easeIn,
                                  );
                                });
                          }
                        },
                        icon: Icon(Icons.send),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: Text(
                "Error Loading...",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
          );
        }
      },
    );
  }
}
