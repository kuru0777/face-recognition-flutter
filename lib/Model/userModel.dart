import '../Controller/userController.dart';

class UserModel {
  final String id;
  final String email;
  final String userName;
  final String password;
  final String firstName;
  final String lastName;

  UserModel({
    required this.id,
    required this.email,
    required this.userName,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    if (data == null) {
      return UserModel(
          id: id,
          email: '',
          userName: '',
          password: '',
          firstName: '',
          lastName: '');
    }
    return UserModel(
      id: id,
      email: data['email'] ?? '',
      userName: data['userName'] ?? '',
      password: data['password'] ?? '',
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'userName': userName,
      'password': password,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
