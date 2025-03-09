import 'package:chat_app/screens/auth/register.dart';
import 'package:chat_app/screens/ui/home.dart';
import 'package:chat_app/widgets/custom_botton.dart';
import 'package:chat_app/widgets/custom_text_form_field.dart';
import 'package:chat_app/widgets/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routname = "/login";
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  GlobalKey<FormState> formkey = GlobalKey();
  bool isloading = false;
  bool obscure = true;

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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sing In",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                ],
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
                          SizedBox(height: 120),
                          CustomTextFormField(
                            onChanged: (data) {
                              email = data;
                            },
                            hintText: "Enter Your Email",
                            icons: Icon(Icons.email, color: Colors.blue),
                          ),
                          SizedBox(height: 20),
                          CustomTextFormField(
                            obscure: true,
                            onChanged: (data) {
                              password = data;
                            },
                            hintText: "Enter your Password",
                            icons: Icon(Icons.password, color: Colors.blue),
                          ),
                          SizedBox(height: 15),
                          CustomBotton(
                            signChild: "Sing In",
                            onTap: () async {
                              if (formkey.currentState!.validate()) {
                                isloading = true;
                                setState(() {});
                                try {
                                  await signAuth();
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
                                "Don't have acount?",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RegisterPage.routname,
                                  );
                                },
                                child: Text(
                                  "Sing Up",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 60),
                          // google sign in botton
                          SignIngoogle(
                            onTap: () {
                              isloading = true;
                              Future<UserCredential> signInWithGoogle() async {
                                // Trigger the authentication flow
                                final GoogleSignInAccount? googleUser =
                                    await GoogleSignIn().signIn();

                                // Obtain the auth details from the request
                                final GoogleSignInAuthentication? googleAuth =
                                    await googleUser?.authentication;

                                // Create a new credential
                                final credential =
                                    GoogleAuthProvider.credential(
                                      accessToken: googleAuth?.accessToken,
                                      idToken: googleAuth?.idToken,
                                    );

                                // Once signed in, return the UserCredential
                                return await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                              }

                              isloading = false;
                            },
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

  Future<void> signAuth() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
