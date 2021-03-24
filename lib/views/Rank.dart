import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/models/pdf/RankPdf.dart';
import 'package:share/share.dart';

class Rank extends StatefulWidget {
  const Rank(this.date, this.user);
  final String date;
  final String user;

  @override
  _RankState createState() => _RankState();
}

class _RankState extends State<Rank> {
  final _controller = StreamController.broadcast();
  PdfPageFormat format;
  bool _buildFeita = false;
  bool _simples = true;
  List<IgrejaModel> igrejas = [];
  List<Distrito> distritos = [];
  bool _print = false;
  int _total = 0;

  pdf({bool rank = true}) {
    return rank
        ? buildPdf(distritos, _total, widget.date, _simples)
        : igrejas.isNotEmpty ? buildPdf2(igrejas, widget.date) : null;
  }

  Stream<QuerySnapshot> _rank() {
    Stream<QuerySnapshot> distritos = db
        .collection("distritos")
        .orderBy("faltam")
        .orderBy("data")
        .snapshots();

    distritos.listen((event) {
      _controller.add(event);
    });

    db
        .collection("igrejas")
        .where("marcado", isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        igrejas.add(IgrejaModel(
          element['nome'],
          element['distrito'],
        ));
      });
    });

    return null;
  }

  @override
  void initState() {
    super.initState();
    _rank();
  }

  Future _shareFile() async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    final file = File('$dir/Rank Atualizado.pdf');
    await file.writeAsBytesSync(await pdf());
    Share.shareFile(file);
  }

  void func() {
    Printing.sharePdf(
      bytes: pdf(),
      filename: 'Rank Atualizado.pdf',
    );
    Printing.layoutPdf(
      name: 'Faltas Rank',
      onLayout: (PdfPageFormat format) {
        return pdf(rank: false);
      },
    );
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirmar"),
          content: Text("Você deseja fechar o mapa?"),
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
                db.collection("distritos").get().then((value) {
                  value.docs.forEach((element) async {
                    db
                        .collection("igrejas")
                        .where("distrito", isEqualTo: element.id)
                        .get()
                        .then((value) {
                      db
                          .collection("distritos")
                          .doc(element.id)
                          .update({"faltam": value.docs.length});
                    });
                  });
                });
                db.collection("igrejas").get().then((value) {
                  value.docs.forEach((element) {
                    db
                        .collection("igrejas")
                        .doc(element.id)
                        .update({"marcado": false, "data": null});
                  });
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            "Data: ${widget.date}",
          ),
        ),
        actions: [
          Row(
            children: [
              widget.user == 'gerenciador'
                  ? IconButton(
                      icon: Icon(kIsWeb ? Icons.close : Icons.share),
                      onPressed: () {
                        kIsWeb ? func() : _shareFile();
                      })
                  : Container(),
              widget.user == 'gerenciador'
                  ? IconButton(
                      icon: Icon(Icons.people),
                      onPressed: () {
                        setState(() {
                          _simples = !_simples;
                        });
                      })
                  : Container(),
              IconButton(
                  icon: Icon(Icons.print),
                  onPressed: () {
                    Printing.layoutPdf(
                      name: 'Rank Atualizado ${widget.date}',
                      onLayout: (PdfPageFormat format) {
                        return pdf();
                      },
                    );
                  }),
            ],
          )
        ],
      ),
      body: Container(
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              QuerySnapshot querySnapshot = snapshot.data;
              if (_buildFeita == false) {
                for (var i = 0; i < querySnapshot.docs.length; i++) {
                  _total += querySnapshot.docs[i]["faltam"];
                  distritos.add(
                    Distrito(
                      querySnapshot.docs[i].id,
                      querySnapshot.docs[i]["pastor"],
                      querySnapshot.docs[i]["faltam"].toString(),
                      querySnapshot.docs[i]["faltam"] == 0
                          ? querySnapshot.docs[i]["data"]
                          : 'Falta',
                    ),
                  );
                  if (i == querySnapshot.docs.length - 1) {
                    _buildFeita = true;
                  }
                }
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        List<DocumentSnapshot> distritos =
                            querySnapshot.docs.toList();
                        DocumentSnapshot documentSnapshot = distritos[index];
                        String data = documentSnapshot['data'];
                        return Container(
                          padding:
                              _print ? EdgeInsets.all(0) : EdgeInsets.all(10),
                          color: index.isOdd
                              ? Colors.grey[400]
                              : Colors.transparent,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  documentSnapshot.id,
                                  style: TextStyle(fontSize: _print ? 10 : 16),
                                ),
                              ),
                              !_simples
                                  ? Expanded(
                                      child: Text(
                                        documentSnapshot["pastor"],
                                        style: TextStyle(
                                            fontSize: _print ? 10 : 16),
                                      ),
                                    )
                                  : Container(),
                              Align(
                                alignment: FractionalOffset.centerRight,
                                child: Text(
                                  documentSnapshot["faltam"].toString(),
                                  style: TextStyle(fontSize: _print ? 10 : 16),
                                ),
                              ),
                              documentSnapshot["faltam"].toString() == "0"
                                  ? Align(
                                      alignment: FractionalOffset.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          data,
                                          style: TextStyle(
                                              fontSize: _print ? 11 : 16),
                                        ),
                                      ))
                                  : Container()
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    child: Center(
                      child: Text(
                        "Total:   $_total",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    color: Colors.blue,
                  )
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}
