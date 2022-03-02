import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinderclone/auth.dart';
import 'package:tinderclone/main-page.dart';
import 'package:tinderclone/main.dart';
import 'package:tinderclone/register-page.dart';
import 'package:firebase_core/firebase_core.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPassword createState() => _ResetPassword();
}

class _ResetPassword extends State<ResetPassword> {
  bool _isObscure = true;

  final emailInput = TextEditingController();
  AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff21254A),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 150,
            child: Stack(
              children: [
                Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: Alignment.topLeft,
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/1a.png'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Reset Your Password",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 90,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'\s'),
                      ),
                    ],
                    controller: emailInput,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.purple,
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hoverColor: Colors.white,
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your mail',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 70),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(62), // <-- Radius
                      ),
                    ),
                    onPressed: () {auth.resetPassword(emailInput.text);},
                    child: const Text(
                      'Send Email Verification',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: 40,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ));
                    },
                    child: new Text(
                      "Login",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
          ),
          Container(
            child: Expanded(
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          alignment: Alignment.topLeft,
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/asd.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
