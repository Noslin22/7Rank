import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/theme/ButtonColors.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class ConfigReconciliacao extends StatefulWidget {
  final String gerenciador;
  const ConfigReconciliacao(this.gerenciador);

  @override
  _ConfigReconciliacaoState createState() => _ConfigReconciliacaoState();
}

class _ConfigReconciliacaoState extends State<ConfigReconciliacao> {
  List<TextEditingController> controllers = List.generate(
    12,
    (index) => TextEditingController(),
  );
  List nodes = List.generate(12, (index) => FocusNode());
  String lancamento = "";
  int size = 0;
  int focus = 0;

  @override
  void dispose() {
    super.dispose();
    controllers.forEach(
      (element) => element.dispose(),
    );
  }

  void limparCampos() {
    controllers.forEach(
      (element) => element.clear(),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;

    return Scaffold(
      appBar: AppBar(
        title: Text("Configuração Reconciliação"),
        actions:
            mobile ? null : actions(widget.gerenciador, context, 'rec_config'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Flexible(
                    child: TextField(
                      controller: controllers[0],
                      decoration: inputDecoration.copyWith(
                        labelText: "Historíco",
                      ),
                      autofocus: true,
                      focusNode: nodes[0],
                      onSubmitted: (value) {
                        focus = 1;
                        FocusScope.of(context).requestFocus(nodes[focus]);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: controllers[1],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Conta Cred.",
                                  ),
                                  focusNode: nodes[1],
                                  onSubmitted: (value) {
                                    focus = 2;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[2],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Sub-Conta Cred.",
                                  ),
                                  focusNode: nodes[2],
                                  onSubmitted: (value) {
                                    focus = 3;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[3],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Departamento Cred.",
                                  ),
                                  focusNode: nodes[3],
                                  onSubmitted: (value) {
                                    focus = 4;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[4],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Tipo Cred.",
                                  ),
                                  focusNode: nodes[4],
                                  onSubmitted: (value) {
                                    focus = 5;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[5],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Fundo Cred.",
                                  ),
                                  focusNode: nodes[5],
                                  onSubmitted: (value) {
                                    focus = 6;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: controllers[6],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Conta Dep.",
                                  ),
                                  focusNode: nodes[6],
                                  onSubmitted: (value) {
                                    focus = 7;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[7],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Sub-Conta Dep.",
                                  ),
                                  focusNode: nodes[7],
                                  onSubmitted: (value) {
                                    focus = 8;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[8],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Departamento Dep.",
                                  ),
                                  focusNode: nodes[8],
                                  onSubmitted: (value) {
                                    focus = 9;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[9],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Tipo Dep.",
                                  ),
                                  focusNode: nodes[9],
                                  onSubmitted: (value) {
                                    focus = 10;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                              SizedBox(height: 10),
                              Flexible(
                                child: TextField(
                                  controller: controllers[10],
                                  decoration: inputDecoration.copyWith(
                                    labelText: "Fundo Dep.",
                                  ),
                                  focusNode: nodes[10],
                                  onSubmitted: (value) {
                                    focus = 11;
                                    FocusScope.of(context)
                                        .requestFocus(nodes[focus]);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Flexible(
                    child: TextField(
                      controller: controllers[11],
                      decoration: inputDecoration.copyWith(
                        labelText: "Aviso",
                      ),
                      focusNode: nodes[11],
                      onSubmitted: (value) {
                        focus = 0;

                        Future<QuerySnapshot> query = db
                            .collection("contabeis")
                            .where("historico", isEqualTo: lancamento)
                            .get();

                        query.then((value) => size = value.size);
                        if (size == 0) {
                          db.collection("contabeis").add({
                            'historico': controllers[0].text,
                            'contaCred': controllers[1].text,
                            'contaDep': controllers[6].text,
                            'subContaCred': controllers[2].text,
                            'subContaDep': controllers[7].text,
                            'departCred': controllers[3].text,
                            'departDep': controllers[8].text,
                            'tipoCred': controllers[4].text,
                            'tipoDep': controllers[9].text,
                            'fundoCred': controllers[5].text,
                            'fundoDep': controllers[10].text,
                            'aviso': controllers[11].text,
                          });
                        } else {
                          String doc = "";
                          query.then((value) => doc = value.docs.first.id);
                          db.collection("contabeis").doc(doc).update({
                            'historico': controllers[0].text,
                            'contaCred': controllers[1].text,
                            'contaDep': controllers[6].text,
                            'subContaCred': controllers[2].text,
                            'subContaDep': controllers[7].text,
                            'departCred': controllers[3].text,
                            'departDep': controllers[8].text,
                            'tipoCred': controllers[4].text,
                            'tipoDep': controllers[9].text,
                            'fundoCred': controllers[5].text,
                            'fundoDep': controllers[10].text,
                            'aviso': controllers[11].text,
                          });
                        }
                        setState(() {});
                        limparCampos();
                        FocusScope.of(context).requestFocus(nodes[focus]);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Button.blue10(
                    label: "Adicionar",
                    onPressed: () async {
                      focus = 0;

                      Future<QuerySnapshot> query = db
                          .collection("contabeis")
                          .where("historico", isEqualTo: lancamento)
                          .get();

                      await query.then((value) => size = value.size);
                      if (size == 0) {
                        db.collection("contabeis").add({
                          'historico': controllers[0].text,
                          'contaCred': controllers[1].text,
                          'contaDep': controllers[6].text,
                          'subContaCred': controllers[2].text,
                          'subContaDep': controllers[7].text,
                          'departCred': controllers[3].text,
                          'departDep': controllers[8].text,
                          'tipoCred': controllers[4].text,
                          'tipoDep': controllers[9].text,
                          'fundoCred': controllers[5].text,
                          'fundoDep': controllers[10].text,
                          'aviso': controllers[11].text,
                        });
                      } else {
                        String doc = "";
                        await query.then((value) => doc = value.docs.first.id);
                        db.collection("contabeis").doc(doc).update({
                          'historico': controllers[0].text,
                          'contaCred': controllers[1].text,
                          'contaDep': controllers[6].text,
                          'subContaCred': controllers[2].text,
                          'subContaDep': controllers[7].text,
                          'departCred': controllers[3].text,
                          'departDep': controllers[8].text,
                          'tipoCred': controllers[4].text,
                          'tipoDep': controllers[9].text,
                          'fundoCred': controllers[5].text,
                          'fundoDep': controllers[10].text,
                          'aviso': controllers[11].text,
                        });
                      }
                      setState(() {});
                      limparCampos();
                      FocusScope.of(context).requestFocus(nodes[focus]);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: db.collection("contabeis").get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Houve um erro, tente novamente mais tarde");
                    } else if (snapshot.hasData) {
                      List<QueryDocumentSnapshot> configs = snapshot.data!.docs;
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          var document = configs[index];
                          String historico = document["historico"];
                          return ListTile(
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(historico),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    lancamento = document["historico"];
                                    controllers[0].text = document["historico"];
                                    controllers[1].text = document["contaCred"];
                                    controllers[6].text = document["contaDep"];
                                    controllers[2].text =
                                        document["subContaCred"];
                                    controllers[7].text =
                                        document["subContaDep"];
                                    controllers[3].text =
                                        document["departCred"];
                                    controllers[8].text = document["departDep"];
                                    controllers[4].text = document["tipoCred"];
                                    controllers[9].text = document["tipoDep"];
                                    controllers[5].text = document["fundoCred"];
                                    controllers[10].text = document["fundoDep"];
                                    controllers[11].text = document["aviso"];
                                  },
                                  style: orangeColor,
                                  icon: Icon(Icons.edit),
                                  label: Text("Editar"),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    db
                                        .collection("contabeis")
                                        .doc(document.id)
                                        .delete();
                                    setState(() {});
                                  },
                                  style: redColor,
                                  icon: Icon(Icons.delete),
                                  label: Text("Excluir"),
                                ),
                              ],
                            ),
                          );
                        },
                        itemCount: configs.length,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
      drawer: mobile ? drawer(widget.gerenciador, context, 'rec_config') : null,
    );
  }
}
