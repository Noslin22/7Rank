import 'package:firebase_auth/firebase_auth.dart';

class SignModel {
  final Function carregar;
  final bool register;
  final FirebaseAuthException? code;
  final String type;
  SignModel({
    required this.carregar,
    required this.register,
    required this.code,
    required this.type,
  });
}
