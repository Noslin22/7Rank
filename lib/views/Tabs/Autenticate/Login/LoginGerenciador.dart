import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/widgets/consts.dart';

import '../../../Home.dart';

class LoginGerenciador extends StatefulWidget {
  final Function carregar;
  LoginGerenciador(this.carregar);
  @override
  _LoginGerenciadorState createState() => _LoginGerenciadorState();
}

class _LoginGerenciadorState extends State<LoginGerenciador> {
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
                  return "Digite o Nome do Gerenciador";
                }
                return null;
              },
              onChanged: (newValue) {
                setState(() => nome = _auth.removerAcentos(newValue));
              },
              decoration:
                  inputDecoration.copyWith(labelText: "Nome Gerenciador"),
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
                      email: nome, senha: senha, tipo: "gerenciador");
                  Timer(Duration(seconds: 5), () {
                    if (result == null) {
                      widget.carregar(false);
                    }
                    if (result != null) {
                      widget.carregar(false);
                      Navigator.of(navigatorKey.currentContext)
                          .pushReplacement(MaterialPageRoute(
                      builder: (context) => Home(),
                    ),);
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