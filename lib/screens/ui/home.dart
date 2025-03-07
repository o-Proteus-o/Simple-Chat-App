import 'package:chat_app/screens/ui/chat_room.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String routname = "/home";
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.chat_bubble, size: 28),
            Lottie.asset(
              "assets/lottie/Animation - 1741294919520.json",
              width: 80,
              height: 80,
            ),
            SizedBox(width: 5),
            Text(
              "Chat Members",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    ChatRoom.routname,
                    arguments: email,
                  );
                },
                child: Card(
                  color: Colors.grey,
                  child: ListTile(
                    leading: Icon(Icons.group_work, size: 30),
                    title: Text("Group One"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
