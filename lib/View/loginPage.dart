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
      var isLoginSuccessful = false;

      User? user = await userController.signIn(
          emailController.text, passwordController.text);

      if (user != null) {
        isLoginSuccessful = true;
        Navigator.pushNamed(context, '/camera');
        print('Giriş başarılı: ${user.email}');
      } else {
        isLoginSuccessful = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giriş Yap'),
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
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
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
                    child: const Text('Kayıt Ol'),
                  ),
                  ElevatedButton(
                    onPressed: navigateToCamera,
                    child: const Text('Giriş Yap'),
                    onLongPress: () {
                      Navigator.pushNamed(context, '/camera');
                    },
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
