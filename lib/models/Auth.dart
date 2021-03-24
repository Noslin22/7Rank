import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:remessa/models/User.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Uid _userFromFirebase(User user) {
    return user != null ? Uid(user.uid) : null;
  }

  Stream<Uid> get user {
    return _auth.idTokenChanges().map(_userFromFirebase);
  }

  Future signIn({String email, String senha, String tipo}) async {
    if (email.contains(" ")) {
      email = email.trimRight().replaceAll(" ", "_").toLowerCase();
    }
    if (email != null && senha != null) {
      Future<UserCredential> result = _auth.signInWithEmailAndPassword(
          email: tipo == "pastor"
              ? '$email@pastor.com'
              : tipo == "gerenciador"
                  ? '$email@gerenciador.com'
                  : '$email@adm.com',
          password: senha);
      User user;
      await result.then((value) {
        user = value.user;
      });
      return _userFromFirebase(user);
    }
  }

  Future register({String email, String senha, String tipo}) async {
    if (email.contains(" ")) {
      email = email.trimRight().replaceAll(" ", "_").toLowerCase();
    }
    if (email != null && senha != null) {
      Future<UserCredential> result = _auth.createUserWithEmailAndPassword(
          email: tipo == 'pastor'
              ? '$email@pastor.com'
              : tipo == 'gerenciador'
                  ? '$email@gerenciador.com'
                  : '$email@adm.com',
          password: senha);
      User user;
      await result.then((value) {
        user = value.user;
      });
      return _userFromFirebase(user);
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
    return await _auth.signOut();
  }
}
