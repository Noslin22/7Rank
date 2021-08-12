import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class Auth {
  final FirebaseAuth auth;
  Auth({required this.auth});
  
  ValueNotifier<FirebaseAuthException?> _error =
      ValueNotifier<FirebaseAuthException?>(null);
  FirebaseAuthException? get error => _error.value;
  set error(FirebaseAuthException? error) => _error.value = error;

  Stream<User?> get user => auth.authStateChanges();

  Future<User?> signIn(
      {required String email, String? senha, required String tipo}) async {
    if (email.contains(" ")) {
      email = email.trimRight().replaceAll(" ", "_").toLowerCase();
    }
    if (senha != null) {
      try {
        Future<UserCredential> result = auth.signInWithEmailAndPassword(
            email: tipo == "pastor"
                ? '$email@pastor.com'
                : tipo == "gerenciador"
                    ? '$email@gerenciador.com'
                    : '$email@adm.com',
            password: senha);
        User? user;
        await result.then((value) {
          user = value.user;
        });
        return user;
      } catch (e) {
        error = e as FirebaseAuthException?;
      }
    }
  }

  Future<User?> register(
      {required String email, String? senha, required String? tipo}) async {
    if (email.contains(" ")) {
      email = email.trimRight().replaceAll(" ", "_").toLowerCase();
    }
    if (senha != null) {
      try {
      Future<UserCredential> result = auth.createUserWithEmailAndPassword(
          email: tipo == 'pastor'
              ? '$email@pastor.com'
              : tipo == 'gerenciador'
                  ? '$email@gerenciador.com'
                  : '$email@adm.com',
          password: senha);
      User? user;
      await result.then((value) {
        user = value.user;
      });
      return user;
      } catch (e) {
        error = e as FirebaseAuthException?;
      }
    }
  }

  removerAcentos(String texto) {
    String comAcentos = "ÄÅÁÂÀÃäáâàãÉÊËÈéêëèÍÎÏÌíîïìÖÓÔÒÕöóôòõÜÚÛüúûùÇç";
    String semAcentos = "AAAAAAaaaaaEEEEeeeeIIIIiiiiOOOOOoooooUUUuuuuCc";

    for (int i = 0; i < comAcentos.length; i++) {
      texto =
          texto.replaceAll(comAcentos[i].toString(), semAcentos[i].toString());
    }
    return texto;
  }

  Future signOut() async {
    return await auth.signOut();
  }
}
