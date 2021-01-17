import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class DeletarIgreja extends StatefulWidget {
  @override
  _DeletarIgrejaState createState() => _DeletarIgrejaState();
}

class _DeletarIgrejaState extends State<DeletarIgreja> {
  final _controllerIgrejas = StreamController.broadcast();
  final _formKey = GlobalKey<FormState>();
  String antigaIgreja;

  getData() {
    Stream<QuerySnapshot> igrejas =
        db.collection("igrejas").orderBy('nome').snapshots();

    igrejas.listen((event) {
      _controllerIgrejas.add(event);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: _controllerIgrejas.stream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<DropdownMenuItem> igrejas = [
                            DropdownMenuItem(
                              child: Text(
                                "Igreja",
                              ),
                            ),
                          ];
                          for (var i = 0; i < snapshot.data.docs.length; i++) {
                            igrejas.add(
                              DropdownMenuItem(
                                value: snapshot.data.docs[i]['nome'],
                                child: Text(
                                  snapshot.data.docs[i]['nome'],
                                ),
                              ),
                            );
                          }
                          return DropdownButtonFormField(
                            decoration: inputDecoration,
                            onChanged: (value) {
                              setState(() {
                                antigaIgreja = value;
                              });
                            },
                            hint: Text("Igrejas"),
                            onSaved: (newValue) {},
                            items: igrejas,
                            value: antigaIgreja,
                            validator: (value) {
                              if (value == null) {
                                return "Escolha alguma igreja";
                              }
                              return null;
                            },
                          );
                        }
                        return Container();
                      }),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Builder(
              builder: (context) {
                return RaisedButton(
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    if (_formKey.currentState != null &&
                        _formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      db
                          .collection("igrejas")
                          .where('nome', isEqualTo: antigaIgreja)
                          .get()
                          .then((value) {
                        db
                            .collection('igrejas')
                            .doc(value.docs.first.id)
                            .delete();
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Igreja $antigaIgreja foi deletada com sucesso"}"));
                      Scaffold.of(context).showSnackBar(snackbar);
                      Timer(Duration(seconds: 6), () {
                        Navigator.pushReplacementNamed(context, 'home');
                      });
                    }
                  },
                  color: Colors.blue,
                  child: Text(
                    "Deletar",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
