import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:remessa/models/IgrejaFirebase.dart';
import 'package:remessa/models/widgets/consts.dart';

class CheckBoxTile extends StatefulWidget {
  const CheckBoxTile(this.item, this.doc, this.pastor);

  final Igreja item;
  final DocumentSnapshot doc;
  final String pastor;

  @override
  _CheckboxTileState createState() => _CheckboxTileState();
}

class _CheckboxTileState extends State<CheckBoxTile> {
  @override
  Widget build(BuildContext context) {
    String _dataPronta = formatDate(date: widget.item.data, dateTime: false);
    DateTime _dateTime = formatDate(date: widget.item.data);
    Future<void> _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateTime == null ? DateTime.now() : _dateTime,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
      );
      if (picked != null && picked != _dateTime) {
        setState(() {
          _dateTime = picked;
          _dataPronta = DateFormat("dd/MM/yyyy").format(_dateTime);
          widget.item.data = _dataPronta != null
              ? _dataPronta
              : _dateTime != null
                  ? DateFormat("dd/MM/yyyy").format(_dateTime)
                  : null;
        });
        Igreja.save("data", widget.item);
      }
    }

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Checkbox(
              value: widget.item.marcado,
              onChanged: widget.pastor == "gerenciador"
                  ? (value) {
                      setState(() {
                        widget.item.marcado = value;
                      });
                      Igreja.save(
                        "marcado",
                        widget.item,
                      );
                    }
                  : null,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: 6,
                top: 15,
                right: 20,
              ),
              child: Text(widget.item.nome),
            ),
            flex: 4,
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 15),
                child: GestureDetector(
                  onLongPress: widget.pastor == "gerenciador"
                      ? () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Confirmar"),
                                content: Text(
                                    "Você deseja limpar a data de ${widget.item.nome}?"),
                                actions: [
                                  FlatButton(
                                    child: new Text("Não"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  FlatButton(
                                    child: new Text("Sim"),
                                    onPressed: () {
                                      db
                                          .collection("igrejas")
                                          .doc(widget.doc.id)
                                          .update({"data": null});
                                      db
                                          .collection("distritos")
                                          .doc(widget.item.distrito)
                                          .update({"data": null});
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      : null,
                  child: Text(widget.item.data == null ? "" : widget.item.data),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: IconButton(
                icon: Icon(
                  Icons.calendar_today,
                ),
                onPressed: widget.pastor == "gerenciador"
                    ? () {
                        if (widget.item.marcado) {
                          _selectDate(context);
                        } else {
                          final snackBar = SnackBar(
                            content: Text('Primeiro Marque'),
                            duration: Duration(seconds: 2),
                          );
                          Scaffold.of(context).showSnackBar(snackBar);
                        }
                      }
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
