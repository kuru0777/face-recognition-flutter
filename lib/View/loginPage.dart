import 'package:face_detector/Model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Controller/userController.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Controller/userController.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final UserController userController = UserController();

  LoginPage({super.key});

  void signIn() async {
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await userController.signIn(email, password);

    if (user != null) {
      print('Giriş başarılı: ${user.displayName}');
    } else {
      print('Giriş başarısız');
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToCamera() async {
      var isLoginSuccessful = false; // Başlangıçta başarısız kabul edelim

      User? user = await userController.signIn(
          emailController.text, passwordController.text);

      if (user != null) {
        isLoginSuccessful = true;
        Navigator.pushNamed(context, '/camera');
      } else {
        isLoginSuccessful = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Image.network(
                      'https://www.asisonline.org/globalassets/security-management/security-technology/2021/december/1221-megan-gates-facial-recognition-freeze-frame2.jpg'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: (() {
                      Navigator.pushNamed(context, '/register');
                    }),
                    child: Text('Kayıt Ol'),
                  ),
                  ElevatedButton(
                    onPressed: navigateToCamera,
                    child: Text('Giriş Yap'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
