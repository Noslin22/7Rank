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
  late FocusNode focusNode;
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
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

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
                      focusNode: focus == 0 ? focusNode : null,
                      onSubmitted: (value) {
                        setState(() {
                          focus = 1;
                        });
                        focusNode = FocusNode();
                        focusNode.nextFocus();
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
                                  focusNode: focus == 1 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 2;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 2 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 3;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 3 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 4;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 4 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 5;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 5 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 6;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 6 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 7;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 7 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 8;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 8 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 9;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 9 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 10;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                                  focusNode: focus == 10 ? focusNode : null,
                                  onSubmitted: (value) {
                                    setState(() {
                                      focus = 11;
                                    });
                                    focusNode = FocusNode();
                                    focusNode.nextFocus();
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
                      focusNode: focus == 11 ? focusNode : null,
                      onSubmitted: (value) {
                        setState(() {
                          focus = 0;
                        });
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
                        focusNode = FocusNode();
                        focusNode.nextFocus();
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Button.blue10(
                    label: "Adicionar",
                    onPressed: () {
                      db.collection("contabeis").add({
                        'Controller.te': historicoController.text,
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
