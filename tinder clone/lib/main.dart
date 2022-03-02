import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinderclone/auth.dart';
import 'package:tinderclone/reset-password.dart';
import 'package:tinderclone/main-page.dart';
import 'package:tinderclone/register-page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: LoginScreen(),
  ));
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isObscure = true;

  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  AuthService auth = AuthService();
  
  void _buildErrorMessage(String text) {
    Fluttertoast.showToast(
        msg: text,
        timeInSecForIosWeb: 2,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[600],
        textColor: Colors.red,
        fontSize: 14);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                  "Welcome Back!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
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
                Container(
                  height: 90,
                  child: TextField(
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(
                        RegExp(r'\s'),
                      ),
                    ],
                    controller: passwordInput,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.purple,
                    obscureText: _isObscure,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.white,
                          icon: Icon(_isObscure
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        hoverColor: Colors.white,
                        border: UnderlineInputBorder(),
                        labelText: 'Enter your password',
                        labelStyle: TextStyle(color: Colors.white)),
                  ),
                ),
                Container(
                  height: 40,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResetPassword()));
                    },
                    child: new Text(
                      "Forgot your password ?",
                      style: TextStyle(color: Colors.purple),
                    ),
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
                    onPressed: () {
                      auth
                          .signIn(emailInput.text, passwordInput.text)
                          .then((value) {
                        return Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainPage()));
                      });
                    },
                    child: const Text(
                      'LOGIN',
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
                            builder: (context) => RegisterScreen(),
                          ));
                    },
                    child: new Text(
                      "Register",
                      style: TextStyle(color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 80,
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
