import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pdf/DistritoPdf.dart';
import 'package:remessa/models/pdf/MalotePdf.dart';
import 'package:remessa/models/widgets/consts.dart';

class Dinheiro extends StatefulWidget {
  @override
  _DinheiroState createState() => _DinheiroState();
}

class _DinheiroState extends State<Dinheiro> {
  TextEditingController controller200 = TextEditingController();
  TextEditingController controller100 = TextEditingController();
  TextEditingController controller050 = TextEditingController();
  TextEditingController controller025 = TextEditingController();
  TextEditingController controller010 = TextEditingController();
  TextEditingController controller50 = TextEditingController();
  TextEditingController controller20 = TextEditingController();
  TextEditingController controller10 = TextEditingController();
  TextEditingController controller05 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controllerCheque1 = TextEditingController();
  TextEditingController controllerCheque2 = TextEditingController();
  TextEditingController controllerCheque3 = TextEditingController();
  TextEditingController controllerCheque4 = TextEditingController();
  TextEditingController controllerCheque5 = TextEditingController();
  var formatRm = new MaskTextInputFormatter(
    mask: '##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  List<List<String>> protocolo = [];
  Map<String, String> igrejas = {};
  String total = "R\$ 0,00";
  List<String> datas = [
    "",
    "",
    "",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "0",
    "R\$ 0,00"
  ];
  FocusNode myFocusNode;
  double text200 = 0.0;
  double text100 = 0.0;
  double text050 = 0.0;
  double text025 = 0.0;
  double text010 = 0.0;
  double text50 = 0.0;
  double text20 = 0.0;
  double text10 = 0.0;
  double text05 = 0.0;
  double text5 = 0.0;
  double text2 = 0.0;
  double text1 = 0.0;
  double cheque1 = 0.0;
  double cheque2 = 0.0;
  double cheque3 = 0.0;
  double cheque4 = 0.0;
  double cheque5 = 0.0;
  String cod = "";
  String rem = "";
  int focus;

  String _format(double dou) {
    return NumberFormat.currency(locale: 'pt_BR', decimalDigits: 2, name: "R\$")
        .format(dou);
  }

  double _value() {
    return (text200 +
        text100 +
        text50 +
        text20 +
        text10 +
        text5 +
        text2 +
        text1 +
        text050 +
        text025 +
        text010 +
        text05 +
        cheque1 +
        cheque2 +
        cheque3 +
        cheque4 +
        cheque5);
  }

  _pegarDados() {
    db.collection("igrejas").orderBy('nome').get().then((value) {
      value.docs.forEach((doc) {
        igrejas[doc["cod"].toString()] = doc['nome'].toString();
      });
    });
  }

  _clearForm() {
    total = "R\$ 0,00";
    text200 = 0.0;
    text100 = 0.0;
    text050 = 0.0;
    text025 = 0.0;
    text010 = 0.0;
    text50 = 0.0;
    text20 = 0.0;
    text10 = 0.0;
    text05 = 0.0;
    text5 = 0.0;
    text2 = 0.0;
    text1 = 0.0;
    controller200.text = "";
    controller100.text = "";
    controller050.text = "";
    controller025.text = "";
    controller010.text = "";
    controller50.text = "";
    controller20.text = "";
    controller10.text = "";
    controller05.text = "";
    controller5.text = "";
    controller2.text = "";
    controller1.text = "";
    cod = "";
    rem = "";
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _pegarDados();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protocolo Caixa"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                ),
                Container(
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        _clearForm();
                        cod = value;
                        focus = 1;
                        datas[0] = value;
                        datas[1] = igrejas[value];
                      });
                      myFocusNode = FocusNode();
                      myFocusNode.requestFocus();
                    },
                    focusNode: focus == 0 ? myFocusNode : null,
                    textAlign: TextAlign.center,
                    decoration:
                        inputDecoration.copyWith(labelText: "Código da Igreja"),
                  ),
                  width: 180,
                ),
                SizedBox(
                  width: 30,
                ),
                Text(cod != "" ? igrejas[cod] : "Nome da Igreja"),
                SizedBox(
                  width: 70,
                ),
                Container(
                  child: TextField(
                    onSubmitted: (value) {
                      setState(() {
                        rem = value;
                        focus = 2;
                        datas[2] = value;
                      });
                      myFocusNode = FocusNode();
                      myFocusNode.requestFocus();
                    },
                    focusNode: focus == 1 ? myFocusNode : null,
                    textAlign: TextAlign.center,
                    inputFormatters: [formatRm],
                    decoration: inputDecoration.copyWith(labelText: "Remessa"),
                  ),
                  width: 130,
                ),
              ],
            ),
            SizedBox(
              height: 35,
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 70,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Cédulas"),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text200 = (int.parse(text) * 200.00);
                                    focus = 3;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[3] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller200,
                                focusNode: focus == 2 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 200,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text200)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text100 = (int.parse(text) * 100.00);
                                    focus = 4;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[4] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller100,
                                focusNode: focus == 3 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 100,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text100)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text50 = (int.parse(text) * 50.00);
                                    focus = 5;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[5] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller50,
                                focusNode: focus == 4 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 50,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text50)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text20 = (int.parse(text) * 20.00);
                                    focus = 6;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[6] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller20,
                                focusNode: focus == 5 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 20,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text20)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text10 = (int.parse(text) * 10.00);
                                    focus = 7;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[7] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller10,
                                focusNode: focus == 6 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 10,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text10)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text5 = (int.parse(text) * 5.00);
                                    focus = 8;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[8] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller5,
                                focusNode: focus == 7 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 5,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text5)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text2 = (int.parse(text) * 2.00);
                                    focus = 9;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[9] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller2,
                                focusNode: focus == 8 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 2,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text2)),
                          ],
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Moedas"),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text1 = (int.parse(text) * 1.00);
                                    focus = 10;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[10] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller1,
                                focusNode: focus == 9 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 1,00"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(_format(text1)),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text050 = (int.parse(text) * 0.5);
                                    focus = 11;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[11] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller050,
                                focusNode: focus == 10 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 0,50"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _format(text050),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text025 = (int.parse(text) * 0.25);
                                    focus = 12;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[12] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller025,
                                focusNode: focus == 11 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 0,25"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _format(text025),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text010 = (int.parse(text) * 0.1);
                                    focus = 13;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[13] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller010,
                                focusNode: focus == 12 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 0,10"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _format(text010),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    text05 = (int.parse(text) * 0.05);
                                    focus = 14;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[14] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controller05,
                                focusNode: focus == 13 ? myFocusNode : null,
                                decoration: inputDecoration.copyWith(
                                    labelText: "R\$ 0,05"),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              _format(text05),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Text(
                              total,
                              style: TextStyle(
                                  fontSize: 38, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  protocolo.add([cod, igrejas[cod], total]);
                                });
                              },
                              child: Text(
                                "Gravar",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.deepOrange,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Printing.layoutPdf(
                                  name: 'Malote',
                                  onLayout: (format) {
                                    print(datas[0]);
                                    print(datas[1]);
                                    print(datas[2]);
                                    print(datas[3]);
                                    print(datas[4]);
                                    print(datas[5]);
                                    print(datas[6]);
                                    print(datas[7]);
                                    print(datas[8]);
                                    print(datas[9]);
                                    print(datas[10]);
                                    print(datas[11]);
                                    print(datas[12]);
                                    print(datas[13]);
                                    print(datas[14]);
                                    return buildPdfMalote(datas);
                                  },
                                );
                              },
                              child: Text(
                                "Malote",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.indigo,
                            ),
                            RaisedButton(
                              onPressed: () {
                                Printing.layoutPdf(
                                  name: 'Protocolo Caixa',
                                  onLayout: (format) {
                                    return buildPdfDistrito(
                                      protocolos: protocolo,
                                      protocolo: true,
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Imprimir",
                                style: TextStyle(color: Colors.white),
                              ),
                              color: Colors.lightGreen,
                            ),
                          ],
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text("Cheques"),
                            SizedBox(
                              width: 40,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text("1º"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    cheque1 = (double.parse(
                                      text.replaceAll(
                                        ",",
                                        ".",
                                      ),
                                    ));
                                    focus = 15;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[16] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controllerCheque1,
                                focusNode: focus == 14 ? myFocusNode : null,
                                decoration: inputDecoration,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text("2º"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    cheque2 = (double.parse(
                                      text.replaceAll(
                                        ",",
                                        ".",
                                      ),
                                    ));
                                    focus = 16;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[17] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controllerCheque2,
                                focusNode: focus == 15 ? myFocusNode : null,
                                decoration: inputDecoration,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text("3º"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    cheque3 = (double.parse(
                                      text.replaceAll(
                                        ",",
                                        ".",
                                      ),
                                    ));
                                    focus = 17;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[18] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controllerCheque3,
                                focusNode: focus == 16 ? myFocusNode : null,
                                decoration: inputDecoration,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text("4º"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    cheque4 = (double.parse(
                                      text.replaceAll(
                                        ",",
                                        ".",
                                      ),
                                    ));
                                    focus = 18;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[19] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controllerCheque4,
                                focusNode: focus == 17 ? myFocusNode : null,
                                decoration: inputDecoration,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text("5º"),
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 100,
                              child: TextField(
                                style: TextStyle(color: Colors.red),
                                onSubmitted: (text) {
                                  setState(() {
                                    cheque5 = (double.parse(
                                      text.replaceAll(
                                        ",",
                                        ".",
                                      ),
                                    ));
                                    focus = 0;
                                    total = _format(_value());
                                    datas[15] = total;
                                    datas[20] = text;
                                  });
                                  myFocusNode = FocusNode();
                                  myFocusNode.requestFocus();
                                },
                                textAlign: TextAlign.center,
                                controller: controllerCheque5,
                                focusNode: focus == 18 ? myFocusNode : null,
                                decoration: inputDecoration,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    flex: 1,
                  ),
                  SizedBox(
                    width: 48,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.blue,
                          height: 60.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(4.0),
                                width: 100.0,
                                child: Text(
                                  "Cod",
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(4.0),
                                width: 100.0,
                                child: Text(
                                  "Igreja",
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                color: Colors.blue,
                                padding: EdgeInsets.all(4.0),
                                width: 100.0,
                                child: Text(
                                  "Valor",
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: protocolo.length,
                            itemBuilder: (context, index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      width: 100.0,
                                      child: Text(
                                        protocolo[index][0],
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      width: 300.0,
                                      child: Text(
                                        protocolo[index][1],
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(4.0),
                                      width: 150.0,
                                      child: Text(
                                        protocolo[index][2],
                                        style: TextStyle(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    flex: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
