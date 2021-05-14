import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:remessa/models/widgets/consts.dart';

class DeletarIgreja extends StatefulWidget {
  @override
  _DeletarIgrejaState createState() => _DeletarIgrejaState();
}

class _DeletarIgrejaState extends State<DeletarIgreja> {
  TextEditingController _controllerCod = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> igrejas = [];
  String igreja = "";

  void getIgrejas() {
    db.collection("igrejas").orderBy("cod").get().then((value) {
      List<String> values = value.docs
          .map((e) => "${e["cod"].toString()} - ${e["nome"].toString()}");
      igrejas.addAll(values);
    });
  }

  @override
  void initState() {
    super.initState();
    getIgrejas();
  }

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
            TypeAheadField<String>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _controllerCod,
                decoration: inputDecoration.copyWith(labelText: "Código"),
              ),
              debounceDuration: Duration(milliseconds: 600),
              suggestionsCallback: (pattern) {
                return igrejas.where((element) =>
                    element.toLowerCase().contains(pattern.toLowerCase()));
              },
              onSuggestionSelected: (suggestion) {
                _controllerCod.text = suggestion.split(" ")[0];
              },
              itemBuilder: (context, itemData) => ListTile(
                title: Text("$itemData"),
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
                          .where('cod',
                              isEqualTo: int.parse(_controllerCod.text))
                          .get()
                          .then((value) {
                        setState(() {
                          igreja = value.docs.first.data()["nome"];
                        });
                        db
                            .collection('igrejas')
                            .doc(value.docs.first.id)
                            .delete();
                      });
                      var snackbar = SnackBar(
                          content: Text(
                              "${"Igreja $igreja foi deletada com sucesso"}"));
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
