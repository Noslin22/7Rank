import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/widgets/consts.dart';

class LoginPastor extends StatefulWidget {
  final Function carregar;
  LoginPastor(this.carregar);
  @override
  _LoginPastorState createState() => _LoginPastorState();
}

class _LoginPastorState extends State<LoginPastor> {
  final _formKey = GlobalKey<FormState>();
  Auth _auth = Auth();
  String nome = '';
  String senha = '';
  String erro = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 20,
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value == '') {
                  return "Digite o Nome do Pastor";
                }
                return null;
              },
              onChanged: (newValue) {
                setState(() => nome = _auth.removerAcentos(newValue));
              },
              decoration: inputDecoration.copyWith(labelText: "Nome Pastor"),
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
              obscureText: true,
              decoration: inputDecoration.copyWith(
                labelText: "Senha",
              ),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState.validate()) {
                  widget.carregar(true);
                  dynamic result = await _auth.signIn(
                      email: nome, senha: senha, tipo: "pastor");
                  Timer(Duration(seconds: 3), () {
                    if (result == null) {
                      widget.carregar(false);
                    }
                  });
                  Timer(Duration(seconds: 2), () {
                    if (result != null) {
                      Navigator.of(navigatorKey.currentContext)
                          .pushReplacementNamed('home');
                    }
                  });
                }
              },
              color: Colors.blue,
              child: Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              erro,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
