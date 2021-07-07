import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:provider/provider.dart';
import '../../../Home.dart';

class LoginAdm extends StatefulWidget {
  final Function carregar;
  
  final String? code;
  LoginAdm(this.carregar, {required this.code});
  @override
  _LoginAdmState createState() => _LoginAdmState();
}

class _LoginAdmState extends State<LoginAdm> {
  final _formKey = GlobalKey<FormState>();
  FocusNode? myFocusNode;
  String nome = '';
  String senha = '';
  int focus = 0;
  String? code;

Widget alert(Auth auth) {
    if (code != null) {
      return Container(
        padding: EdgeInsets.all(15),
        color: Colors.amber,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Icon(
                Icons.info_outline,
              ),
            ),
            Expanded(
              child: Text(
                "A senha ou o usuário estão incorretos. Verifique ou tente novamente mais tarde.",
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      auth.error = null;
                      code = null;
                    });
                  }),
            ),
          ],
        ),
      );
    }
    return Container(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = context.read<Auth>();
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            code!= null ? SizedBox(
              height: 20,
            ) : Container(),
            alert(_auth),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value == '') {
                  return "Digite o Nome do Adm";
                }
                return null;
              },
              focusNode: focus == 0 ? myFocusNode : null,
              onFieldSubmitted: (value) {
                setState(() {
                  focus++;
                });
                myFocusNode = FocusNode();
                myFocusNode!.requestFocus();
              },
              onChanged: (newValue) {
                setState(() => nome = _auth.removerAcentos(newValue));
              },
              decoration: inputDecoration.copyWith(labelText: "Nome Adm"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value == '') {
                  return "Digite a senha";
                }
                return null;
              },
              onChanged: (newValue) {
                setState(() => senha = newValue);
              },
              focusNode: focus == 1 ? myFocusNode : null,
              onFieldSubmitted: (value) async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  widget.carregar(true);
                  User? result = await _auth.signIn(
                      email: nome, senha: senha, tipo: "adm");

                  Timer(Duration(seconds: 3), () {
                      widget.carregar(false);
                    if (result != null) {
                      Navigator.of(navigatorKey.currentContext!)
                          .pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }
                  });
                }
              },
              obscureText: true,
              decoration: inputDecoration.copyWith(
                labelText: "Senha",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  widget.carregar(true);
                  User? result = await _auth.signIn(
                      email: nome, senha: senha, tipo: "adm");

                      widget.carregar(false);
                  Timer(Duration(seconds: 3), () {
                    if (result != null) {
                      Navigator.of(navigatorKey.currentContext!)
                          .pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }
                  });
                }
              },
              color: Colors.blue,
              label: 'Login',
            ),
          ],
        ),
      ),
    );
  }
}
