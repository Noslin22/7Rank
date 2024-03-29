import 'package:dcache/dcache.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:printing/printing.dart';
import 'package:remessa/models/pdf/DistritoPdf.dart';
import 'package:remessa/models/pdf/MalotePdf.dart';
import 'package:remessa/models/widgets/consts.dart';

class Dinheiro extends StatefulWidget {
  final SimpleCache<String, List<List<String?>>?> cache;
  final SimpleCache<String, double> totalCache;
  Dinheiro(this.cache, this.totalCache);
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
  TextEditingController controllerRm = TextEditingController();
  TextEditingController controllerCod = TextEditingController();
  TextEditingController controllerCheque1 = TextEditingController();
  TextEditingController controllerCheque2 = TextEditingController();
  TextEditingController controllerCheque3 = TextEditingController();
  TextEditingController controllerCheque4 = TextEditingController();
  TextEditingController controllerCheque5 = TextEditingController();

  var formatRm = new MaskTextInputFormatter(
    mask: '##/####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  List<List<String?>> protocolo = [];
  double totalAmostra = 0;

  Map<String, String> igrejas = {};
  String total = "R\$ 0,00";
  List<String?> datas = [
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
  FocusNode? myFocusNode;
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
  int? focus;

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
    if (widget.cache.get("protocolo") != null) {
      protocolo = widget.cache.get("protocolo")!;
    }
    if (widget.totalCache.get("total") != null) {
      totalAmostra = widget.totalCache.get("total")!;
    }
    igrejas["3"] = "ABaC";
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
    cheque1 = 0.0;
    cheque2 = 0.0;
    cheque3 = 0.0;
    cheque4 = 0.0;
    cheque5 = 0.0;
    totalAmostra = 0;
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
    controllerRm.text = "";
    controllerCod.text = "";
    controllerCheque1.text = "";
    controllerCheque2.text = "";
    controllerCheque3.text = "";
    controllerCheque4.text = "";
    controllerCheque5.text = "";
    cod = "";
    rem = "";
    datas = [
      "",
      "",
      rem,
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
      "R\$ 0,00",
      "",
      "",
      "",
      "",
      "",
    ];
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    _pegarDados();
  }

  @override
  void dispose() {
    myFocusNode!.dispose();
    controller200.dispose();
    controller100.dispose();
    controller50.dispose();
    controller20.dispose();
    controller10.dispose();
    controller5.dispose();
    controller2.dispose();
    controller1.dispose();
    controller050.dispose();
    controller025.dispose();
    controller010.dispose();
    controller05.dispose();
    controllerCheque1.dispose();
    controllerCheque2.dispose();
    controllerCheque3.dispose();
    controllerCheque4.dispose();
    controllerCheque5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Protocolo Caixa"),
        actions: actions('gerenciador', context, 'dinheiro'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      child: TextField(
                        onSubmitted: (value) {
                          setState(() {
                            _clearForm();
                            cod = value;
                            controllerCod.text = cod;
                            focus = 1;
                            datas[0] = value;
                            datas[1] = igrejas[value];
                          });
                          myFocusNode = FocusNode();
                          myFocusNode!.requestFocus();
                        },
                        controller: controllerCod,
                        focusNode: focus == 0 ? myFocusNode : null,
                        textAlign: TextAlign.center,
                        decoration: inputDecoration.copyWith(
                            labelText: "Código da Igreja"),
                      ),
                      width: 180,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      cod != ""
                          ? igrejas[cod] ?? "Não existe igreja com este código"
                          : "Código da igreja",
                    ),
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
                          myFocusNode!.requestFocus();
                        },
                        controller: controllerRm,
                        focusNode: focus == 1 ? myFocusNode : null,
                        textAlign: TextAlign.center,
                        inputFormatters: [formatRm],
                        decoration:
                            inputDecoration.copyWith(labelText: "Remessa"),
                      ),
                      width: 130,
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    _clearForm();
                    widget.cache.get("protocolo")!.clear();
                    setState(() {
                      protocolo = [];
                    });
                    widget.cache.set("protocolo", protocolo);
                    widget.totalCache.set("total", 0);
                  },
                  child: Text(
                    "Novo Protocolo",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.yellow[700]!.withOpacity(0.7);
                        }
                        return Colors.yellow[700];
                      },
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.all(10),
                    ),
                  ),
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                            TextButton(
                              onPressed: () {
                                if (igrejas[cod] != null) {
                                  double valor = double.parse(total
                                      .replaceAll("R\$", "")
                                      .replaceAll(".", "")
                                      .replaceAll(",", "."));
                                  setState(() {
                                    protocolo.add([cod, igrejas[cod], total]);
                                    widget.cache.set("protocolo", protocolo);
                                    totalAmostra += valor;

                                    widget.totalCache
                                        .set("total", totalAmostra);
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Não existe igreja com este código",
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "Gravar",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.deepOrange.withOpacity(0.7);
                                    }
                                    return Colors.deepOrange;
                                  },
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Printing.layoutPdf(
                                  name: 'Malote',
                                  onLayout: (format) {
                                    return buildPdfMalote(datas);
                                  },
                                );
                              },
                              child: Text(
                                "Malote",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.indigo.withOpacity(0.7);
                                    }
                                    return Colors.indigo;
                                  },
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Printing.layoutPdf(
                                  name: 'Protocolo Caixa',
                                  onLayout: (format) {
                                    return buildPdfDistrito(
                                      protocolos: protocolo,
                                      protocolo: true,
                                      data: DateFormat("dd/MM/yyyy")
                                          .format(DateTime.now()),
                                    );
                                  },
                                );
                              },
                              child: Text(
                                "Imprimir",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith(
                                  (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return Colors.lightGreen.withOpacity(0.7);
                                    }
                                    return Colors.lightGreen;
                                  },
                                ),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.all(10),
                                ),
                              ),
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                                  myFocusNode!.requestFocus();
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
                          height: 40.0,
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
                          child: Column(
                            children: [
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
                                              protocolo[index][0]!,
                                              style: TextStyle(fontSize: 20),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4.0),
                                            width: 300.0,
                                            child: Text(
                                              protocolo[index][1]!,
                                              style: TextStyle(fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(4.0),
                                            width: 150.0,
                                            child: Text(
                                              protocolo[index][2]!,
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
                              Container(
                                width: double.infinity,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    "Total:  ${_format(totalAmostra)}",
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                color: Colors.blue,
                              )
                            ],
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
