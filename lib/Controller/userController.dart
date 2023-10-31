import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Model/userModel.dart';

class UserController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUp(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      User? user = userCredential.user;

      await _firestore
          .collection('users')
          .doc(user!.uid)
          .set(userModel.toMap());
      Fluttertoast.showToast(
        msg: "Kayıt Başarılı",
      );
      return user;
    } on FirebaseAuthException catch (e) {
      var errors;
      if (e.code == 'weak-password') {
        errors = 'Şifre çok zayıf.';
        print(errors);
      } else if (e.code == 'email-already-in-use') {
        errors = 'Bu e-posta adresi zaten kullanılıyor.';
        print(errors);
      }
      Fluttertoast.showToast(
        msg: errors,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      print("Giriş Başarılı ${user!.email}");
      Fluttertoast.showToast(
        msg: "Giriş Başarılı ${user.email}",
      );
      return user;
    } catch (e) {
      var errors;
      if (e is FirebaseAuthException) {
        if (e.code == 'invalid-email') {
          errors = 'Geçersiz e-posta adresi';
          print(errors);
        } else if (e.code == 'invalid-password') {
          errors = 'Geçersiz şifre';
          print(errors);
        } else if (e.code == 'user-not-found') {
          errors = 'Kullanıcı bulunamadı veya silinmiş';
          print(errors);
        }
        Fluttertoast.showToast(
          msg: "Giriş Başarısız: ${errors}",
        );
      } else {
        print('Giriş başarısız: $e');
      }

      return null;
    }
  }
}
