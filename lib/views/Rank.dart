import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/widgets/Button.dart';
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
  PdfPageFormat? format;
  bool _buildFeita = false;
  bool _simples = true;
  List<IgrejaModel> igrejas = [];
  List<Distrito> distritos = [];
  bool _print = false;
  int _total = 0;
  int total = 0;

  pdf({bool rank = true}) {
    return rank
        ? buildPdf(distritos, _total, widget.date, _simples)
        : igrejas.isNotEmpty
            ? buildPdf2(igrejas, widget.date)
            : null;
  }

  Future<Stream<QuerySnapshot>?> _rank() async {
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
        .orderBy("distrito")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        igrejas.add(IgrejaModel(
          element['nome'],
          element['distrito'],
        ));
      });
    });

    await db.collection("igrejas").get().then((value) {
      setState(() {
        total = value.docs.length;
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
    file.writeAsBytesSync(await pdf());
    Share.shareFiles([file.path]);
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
            Button(
              label: "Não",
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Button(
              label: "Sim",
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
              QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
              if (_buildFeita == false) {
                for (var i = 0; i < querySnapshot.docs.length; i++) {
                  _total += querySnapshot.docs[i]["faltam"] as int;
                  if (i == querySnapshot.docs.length - 1) {
                    _buildFeita = true;
                  }
                }
                Future.wait(querySnapshot.docs.map((e) async {
                  distritos.add(
                    Distrito(
                      id: e.id,
                      pastor: e["pastor"],
                      faltam: e["faltam"],
                      data: DateFormat("dd/MM/yyyy").format(e["data"].toDate()),
                    ),
                  );
                }));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: querySnapshot.docs.length,
                      itemBuilder: (context, index) {
                        Distrito distrito = distritos[index];
                        String? data = distrito.data;
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
                                  distrito.id!,
                                  style: TextStyle(fontSize: _print ? 10 : 16),
                                ),
                              ),
                              !_simples
                                  ? Expanded(
                                      child: Text(
                                        distrito.pastor!,
                                        style: TextStyle(
                                            fontSize: _print ? 10 : 16),
                                      ),
                                    )
                                  : Container(),
                              Align(
                                alignment: FractionalOffset.centerRight,
                                child: Text(
                                  distrito.faltam.toString(),
                                  style: TextStyle(fontSize: _print ? 10 : 16),
                                ),
                              ),
                              distrito.faltam.toString() == "0"
                                  ? Align(
                                      alignment: FractionalOffset.centerRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                          data!,
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
                        "Total:  $_total  de  $total",
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
