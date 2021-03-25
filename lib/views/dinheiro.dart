import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/consts.dart';

class Dinheiro extends StatefulWidget {
  @override
  _DinheiroState createState() => _DinheiroState();
}

class _DinheiroState extends State<Dinheiro> {
  TextEditingController text200 = TextEditingController();
  TextEditingController text100 = TextEditingController();
  TextEditingController text50 = TextEditingController();
  TextEditingController text20 = TextEditingController();
  TextEditingController text10 = TextEditingController();
  TextEditingController text5 = TextEditingController();
  TextEditingController text2 = TextEditingController();
  TextEditingController text1 = TextEditingController();
  TextEditingController text050 = TextEditingController();
  TextEditingController text025 = TextEditingController();
  TextEditingController text010 = TextEditingController();
  TextEditingController text05 = TextEditingController();
  FocusNode myFocusNode;
  int focus = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dinheiro"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text("Notas"),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: text200,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 200"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: text100,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 100"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: text50,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 50"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: text20,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 20"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: text10,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 10"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: text5,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 5"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: text2,
                      decoration: inputDecoration.copyWith(labelText: "R\$ 2"),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text("Moedas"),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: text1,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 1,00"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: text050,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 0,50"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: text025,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 0,25"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: text010,
                            decoration:
                                inputDecoration.copyWith(labelText: "R\$ 0,10"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: text05,
                      decoration:
                          inputDecoration.copyWith(labelText: "R\$ 0,05"),
                    ),
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
