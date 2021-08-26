import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/Button.dart';
import 'package:remessa/models/widgets/consts.dart';

class ConfigReconciliacao extends StatefulWidget {
  final String gerenciador;
  const ConfigReconciliacao(this.gerenciador);

  @override
  _ConfigReconciliacaoState createState() => _ConfigReconciliacaoState();
}

class _ConfigReconciliacaoState extends State<ConfigReconciliacao> {
  List nodes = List.generate(12, (index) => FocusNode());
  TextEditingController historicoController = TextEditingController();
  TextEditingController contaCredController = TextEditingController();
  TextEditingController contaDepController = TextEditingController();
  TextEditingController subContaCredController = TextEditingController();
  TextEditingController subContaDepController = TextEditingController();
  TextEditingController departCredController = TextEditingController();
  TextEditingController departDepController = TextEditingController();
  TextEditingController tipoCredController = TextEditingController();
  TextEditingController tipoDepController = TextEditingController();
  TextEditingController fundoCredController = TextEditingController();
  TextEditingController fundoDepController = TextEditingController();
  TextEditingController avisoController = TextEditingController();
  int focus = 0;

  @override
  void dispose() {
    super.dispose();
    historicoController.dispose();
    contaCredController.dispose();
    contaDepController.dispose();
    subContaCredController.dispose();
    subContaDepController.dispose();
    departCredController.dispose();
    departDepController.dispose();
    tipoCredController.dispose();
    tipoDepController.dispose();
    fundoCredController.dispose();
    fundoDepController.dispose();
    avisoController.dispose();
  }

  void limparCampos() {
    historicoController.clear();
    contaCredController.clear();
    contaDepController.clear();
    subContaCredController.clear();
    subContaDepController.clear();
    departCredController.clear();
    departDepController.clear();
    tipoCredController.clear();
    tipoDepController.clear();
    fundoCredController.clear();
    fundoDepController.clear();
    avisoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool showCentered = MediaQuery.of(context).size.width > 1110;
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;

    return Scaffold(
      appBar: AppBar(
        title: Text("Configuração Reconciliação"),
        actions:
            mobile ? null : actions(widget.gerenciador, context, 'rec_config'),
      ),
      body: Container(
        child: Row(
          children: [
            showCentered
                ? Expanded(
                    child: Container(),
                    flex: 1,
                  )
                : Container(),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Flexible(
                    child: TextField(
                      controller: historicoController,
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
                                  controller: contaCredController,
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
                                  controller: subContaCredController,
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
                                  controller: departCredController,
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
                                  controller: tipoCredController,
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
                                  controller: fundoCredController,
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
                                  controller: contaDepController,
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
                                  controller: subContaDepController,
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
                                  controller: departDepController,
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
                                  controller: tipoDepController,
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
                                  controller: fundoDepController,
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
                      controller: avisoController,
                      decoration: inputDecoration.copyWith(
                        labelText: "Aviso",
                      ),
                      focusNode: nodes[11],
                      onSubmitted: (value) {
                        focus = 0;
                        db.collection("contabeis").add({
                          'historico': historicoController.text,
                          'contaCred': contaCredController.text,
                          'contaDep': contaDepController.text,
                          'subContaCred': subContaCredController.text,
                          'subContaDep': subContaDepController.text,
                          'departCred': departCredController.text,
                          'departDep': departDepController.text,
                          'tipoCred': tipoCredController.text,
                          'tipoDep': tipoDepController.text,
                          'fundoCred': fundoCredController.text,
                          'fundoDep': fundoDepController.text,
                          'aviso': avisoController.text,
                        });
                        limparCampos();
                        FocusScope.of(context).requestFocus(nodes[focus]);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Button.blue10(
                    label: "Adicionar",
                    onPressed: () {
                      db.collection("contabeis").add({
                        'historico': historicoController.text,
                        'contaCred': contaCredController.text,
                        'contaDep': contaDepController.text,
                        'subContaCred': subContaCredController.text,
                        'subContaDep': subContaDepController.text,
                        'departCred': departCredController.text,
                        'departDep': departDepController.text,
                        'tipoCred': tipoCredController.text,
                        'tipoDep': tipoDepController.text,
                        'fundoCred': fundoCredController.text,
                        'fundoDep': fundoDepController.text,
                        'aviso': avisoController.text,
                      });
                      limparCampos();
                    },
                  ),
                ],
              ),
            ),
            showCentered
                ? Expanded(
                    child: Container(),
                    flex: 1,
                  )
                : Container(),
          ],
        ),
      ),
      drawer: mobile ? drawer(widget.gerenciador, context, 'rec_config') : null,
    );
  }
}
