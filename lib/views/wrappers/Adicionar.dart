import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remessa/models/widgets/BottomNavigator.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/views/Tabs/Adicionar/Distritos/AdiciconarDistrito.dart';
import 'package:remessa/views/Tabs/Adicionar/Distritos/AtualizarDistrito.dart';
import 'package:remessa/views/Tabs/Adicionar/Distritos/DeletarDistrito.dart';
import 'package:remessa/views/Tabs/Adicionar/Igrejas/AdiciconarIgreja.dart';
import 'package:remessa/views/Tabs/Adicionar/Igrejas/AtualizarIgreja.dart';
import 'package:remessa/views/Tabs/Adicionar/Igrejas/DeletarIgreja.dart';

class Adicionar extends StatefulWidget {
  final String gerenciador;
  Adicionar(this.gerenciador);
  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  bool igreja = true;
  int tabIndex = 0;
  List<Widget> listScreens = [
    AdicionarIgreja(),
    AtualizarIgreja(),
    DeletarIgreja(),
  ];
  List<String> listNames = [
    'Adicionar Igreja',
    'Atualizar Igreja',
    'Deletar Igreja',
  ];

  void setDistrito() {
    setState(() {
      igreja = !igreja;
    });
  }

  void setAtualizar() {
    setDistrito();
    listScreens = igreja
        ? [
            AdicionarIgreja(),
            AtualizarIgreja(),
            DeletarIgreja(),
          ]
        : [
            AdicionarDistrito(),
            AtualizarDistrito(),
            DeletarDistrito(),
          ];
    listNames = igreja
        ? [
            'Adicionar Igreja',
            'Atualizar Igreja',
            'Deletar Igreja',
          ]
        : [
            'Adicionar Distrito',
            'Atualizar Distrito',
            'Deletar Distrito',
          ];
  }

  void setIndex(value) {
    setState(() {
      tabIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(listNames[tabIndex]),
        centerTitle: true,
        actions: kIsWeb
            ? actions(widget.gerenciador, context, 'adicionar',
                setDistrito: setAtualizar, igreja: igreja, kisWeb: kIsWeb)
            : [
                Tooltip(
                  message: igreja ? 'Igreja' : 'Distrito',
                  child: IconButton(
                      icon:
                          Icon(igreja ? Icons.account_balance : Icons.business),
                      onPressed: () {
                        setDistrito();
                        listScreens = igreja
                            ? [
                                AdicionarIgreja(),
                                AtualizarIgreja(),
                                DeletarIgreja(),
                              ]
                            : [
                                AdicionarDistrito(),
                                AtualizarDistrito(),
                                DeletarDistrito(),
                              ];
                        listNames = igreja
                            ? [
                                'Adicionar Igreja',
                                'Atualizar Igreja',
                                'Deletar Igreja',
                              ]
                            : [
                                'Adicionar Distrito',
                                'Atualizar Distrito',
                                'Deletar Distrito',
                              ];
                      }),
                )
              ],
      ),
      drawer: kIsWeb ? null : drawer(widget.gerenciador, context, 'adicionar'),
      bottomNavigationBar: BottomNavigator(
        tabIndex,
        setIndex,
        ['Adicionar', 'Atualizar', 'Deletar'],
        [Icons.add, Icons.edit, Icons.remove],
      ),
      body: listScreens[tabIndex],
    );
  }
}
