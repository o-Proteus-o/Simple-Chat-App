import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/auth/login.dart';
import 'package:chat_app/screens/auth/register.dart';
import 'package:chat_app/screens/ui/chat_room.dart';
import 'package:chat_app/screens/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.routname: (context) => LoginPage(),
        RegisterPage.routname: (context) => RegisterPage(),
        HomePage.routname: (context) => HomePage(),
        ChatRoom.routname: (context) => ChatRoom(),
      },
      initialRoute: LoginPage.routname,
    );
  }
}
