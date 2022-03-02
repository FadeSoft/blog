import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinderclone/auth.dart';
import 'package:tinderclone/main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController _emailInput = TextEditingController();
  final TextEditingController _nameInput = TextEditingController();
  final TextEditingController _passwordInput = TextEditingController();

  final AuthService _auth = AuthService();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff21254A),
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [
        _topImage(),
        _bottomImage(),
        Center(
          child: SizedBox(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "REGISTER!",
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        _emailTextField(),
                        _nameTextField(), 
                        _passwordTextField(),
                        _forgotPassword(),
                        const SizedBox(
                          height: 10,
                        ),
                        _registerButton(),
                        _loginButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _topImage() {
    return SizedBox(
      height: 150,
      child: Positioned(
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            image: DecorationImage(
              alignment: Alignment.topLeft,
              fit: BoxFit.fill,
              image: AssetImage('assets/images/1a.png'),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailTextField() {
    return SizedBox(
      height: 90,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'\s'),
          ),
        ],
        controller: _emailInput,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.purple,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hoverColor: Colors.white,
            border: UnderlineInputBorder(),
            labelText: 'Enter your mail',
            labelStyle: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _nameTextField() {
    return SizedBox(
      height: 90,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'\s'),
          ),
        ],
        controller: _nameInput,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.purple,
        decoration: const InputDecoration(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hoverColor: Colors.white,
            border: UnderlineInputBorder(),
            labelText: 'Enter your name',
            labelStyle: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _passwordTextField() {
    return SizedBox(
      height: 90,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.deny(
            RegExp(r'\s'),
          ),
        ],
        controller: _passwordInput,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.purple,
        obscureText: _isObscure,
        decoration: InputDecoration(
            suffixIcon: IconButton(
              color: Colors.white,
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
            hoverColor: Colors.white,
            border: const UnderlineInputBorder(),
            labelText: 'Enter your password',
            labelStyle: const TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _forgotPassword() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {},
        child: const Text(
          "Forgot your password ?",
          style: TextStyle(color: Colors.purple),
        ),
      ),
    );
  }

  Widget _registerButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 70),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(62), // <-- Radius
          ),
        ),
        onPressed: () {
          _auth.createPerson(_nameInput.text, _emailInput.text, _passwordInput.text).then(
            (value) {
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          );
        },
        child: const Text(
          'REGISTER',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _loginButton() {
    return SizedBox(
      height: 40,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
        },
        child: const Text(
          "Login",
          style: TextStyle(color: Colors.purple),
        ),
      ),
    );
  }

  Widget _bottomImage() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 90,
        alignment: Alignment.bottomCenter,
        decoration: const BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.topLeft,
            fit: BoxFit.fill,
            image: AssetImage('assets/images/asd.png'),
          ),
        ),
      ),
    );
  }
}
