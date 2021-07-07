import 'dart:async';
import 'package:flutter/material.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';
import '../../../Home.dart';
    import 'package:provider/provider.dart';

class RegistroGerenciador extends StatefulWidget {
  final Function carregar;
  RegistroGerenciador(this.carregar);
  @override
  _RegistroGerenciadorState createState() => _RegistroGerenciadorState();
}

class _RegistroGerenciadorState extends State<RegistroGerenciador> {
  final _formKey = GlobalKey<FormState>();
  FocusNode? myFocusNode;
  String nome = '';
  String senha = '';
  String erro = '';
  int focus = 0;
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
              focusNode: focus == 1 ? myFocusNode : null,
              onFieldSubmitted: (value) async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  widget.carregar(true);
                  dynamic result = await _auth.signIn(
                      email: nome, senha: senha, tipo: "gerenciador");
                  Timer(Duration(seconds: 5), () {
                    if (result == null) {
                      widget.carregar(false);
                    }
                    if (result != null) {
                      widget.carregar(false);
                      Navigator.of(navigatorKey.currentContext!).pushReplacement(
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
                  dynamic result = await _auth.register(
                      email: nome, senha: senha, tipo: "gerenciador");
                  Timer(Duration(seconds: 3), () {
                    if (result == null) {
                      widget.carregar(false);
                    }
                  });
                  Timer(Duration(seconds: 2), () {
                    if (result != null) {
                      Navigator.of(navigatorKey.currentContext!)
                          .pushReplacementNamed('home');
                    }
                  });
                }
              },
              color: Colors.blue,
              label: 
                'Registrar',
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
