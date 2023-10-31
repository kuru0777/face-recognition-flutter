import 'package:face_detector/Model/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Controller/userController.dart';
import 'package:lottie/lottie.dart';
import 'loginPage.dart';

class RegisterPage extends StatelessWidget {
  bool isRegistered = false;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final UserController userController = UserController();

  RegisterPage({Key? key}) : super(key: key);

  Future<void> signUp() async {
    String username = usernameController.text;
    String password = passwordController.text;
    String email = emailController.text;
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;

    UserModel userModel = UserModel(
      id: '',
      email: email,
      userName: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );

    User? user = await userController.signUp(userModel);
    if (user != null) {
      isRegistered = true;
      print('Kayıt başarılı: ${user.email}');
    } else {
      print('Kayıt başarısız');
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToLogin() async {
      await signUp();
      if (isRegistered) {
        Navigator.pushNamed(context, '/login');
      } else {
        print('kayıt: $isRegistered');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'Assets/face_r.json',
                    repeat: false,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Kullanıcı Adı',
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-posta',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Ad',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Soyad',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: navigateToLogin,
                child: Text('Kayıt Ol'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
