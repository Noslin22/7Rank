import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/pages/SignModel.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:provider/provider.dart';
import 'package:remessa/views/Home.dart';

class SignPage extends StatefulWidget {
  final SignModel model;
  SignPage({
    required this.model,
  });
  @override
  _SignState createState() => _SignState();
}

class _SignState extends State<SignPage> {
  final _formKey = GlobalKey<FormState>();
  FocusNode? myFocusNode;
  String senha = '';
  String type = '';
  String nome = '';
  int focus = 0;
  FirebaseAuthException? code;

  void captalize(String tipo) {
    List<String> letters = tipo.split('');
    letters[0] = letters[0].toUpperCase();
    type = letters.join();
  }

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
  void initState() {
    super.initState();
    code = widget.model.code;
  }

  @override
  Widget build(BuildContext context) {
    Auth _auth = context.read<Auth>();
    captalize(widget.model.type);
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            code != null
                ? SizedBox(
                    height: 20,
                  )
                : Container(),
            alert(_auth),
            SizedBox(
              height: 20,
            ),
            AutofillGroup(
              child: Column(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value == null || value == '') {
                        return "Digite o Nome do $type";
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
                    autofillHints: [AutofillHints.newUsername],
                    onChanged: (newValue) {
                      setState(() => nome = _auth.removerAcentos(newValue));
                    },
                    decoration:
                        inputDecoration.copyWith(labelText: "Nome $type"),
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
                        TextInput.finishAutofillContext();
                        widget.model.carregar(true);
                        User? result = await _auth.signIn(
                            email: nome, senha: senha, tipo: widget.model.type);

                        Timer(Duration(seconds: 3), () {
                          widget.model.carregar(false);
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
                    autofillHints: [AutofillHints.password],
                    obscureText: true,
                    decoration: inputDecoration.copyWith(
                      labelText: "Senha",
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Button(
              onPressed: () async {
                if (_formKey.currentState != null &&
                    _formKey.currentState!.validate()) {
                  widget.model.carregar(true);
                  User? result;

                  if (widget.model.register) {
                    print('register');
                    result = await _auth.register(
                        email: nome, senha: senha, tipo: widget.model.type);
                  } else {
                    print('login');
                    result = await _auth.signIn(
                        email: nome, senha: senha, tipo: widget.model.type);
                  }

                  Timer(Duration(seconds: 3), () {
                    widget.model.carregar(false);
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
              label: !widget.model.register ? 'Login' : 'Registrar',
            ),
          ],
        ),
      ),
    );
  }
}
