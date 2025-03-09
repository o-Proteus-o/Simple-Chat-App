import 'package:chat_app/screens/ui/home.dart';
import 'package:chat_app/widgets/custom_botton.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String routname = "/register";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isloading,
      child: Scaffold(
        // appBar: AppBar(),
        backgroundColor: Colors.blue,
        body: Form(
          key: formkey,
          child: Column(
            children: [
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 95),
                    Text(
                      "Sing Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 34,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomTextFormField(
                            onChanged: (data) {
                              if (data != null) {
                                email = data;
                              }
                            },
                            hintText: "Enter Your Email",
                            icons: Icon(Icons.email, color: Colors.blue),
                          ),
                          SizedBox(height: 20),
                          CustomTextFormField(
                            onChanged: (data) {
                              if (data != null) {
                                password = data;
                              }
                            },
                            obscure: true,
                            hintText: "Enter your Password",
                            icons: Icon(Icons.password, color: Colors.blue),
                          ),
                          SizedBox(height: 15),
                          CustomBotton(
                            signChild: "Sing Up",
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                isloading = true;
                                setState(() {});
                                try {
                                  await createAuth();
                                  Navigator.pushNamed(
                                    context,
                                    HomePage.routname,
                                    arguments: email,
                                  );
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showSnackBar(
                                      context,
                                      "The password provided is too weak.",
                                    );
                                  } else if (e.code == 'email-already-in-use') {
                                    showSnackBar(
                                      context,
                                      'The account already exists for that email.',
                                    );
                                  }
                                } catch (e) {
                                  showSnackBar(context, "${e}");
                                  print(e);
                                }
                                isloading = false;
                                setState(() {});
                              }
                            },
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                "Already have acount?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Sing In",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> createAuth() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
