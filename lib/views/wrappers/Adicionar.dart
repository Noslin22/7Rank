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
  @override
  _AdicionarState createState() => _AdicionarState();
}

class _AdicionarState extends State<Adicionar> {
  bool igreja = true;
  int tabIndex = 0;

  void setDistrito() {
    setState(() {
      igreja = !igreja;
    });
  }

  void setIndex(value) {
    setState(() {
      tabIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool mobile = width <= 750;
    List<Widget> listScreens = igreja
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
    List<String> listNames = igreja
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
    return Scaffold(
      appBar: AppBar(
        title: Text(listNames[tabIndex]),
        centerTitle: true,
        actions: mobile
            ? [
                Tooltip(
                  message: igreja ? 'Igreja' : 'Distrito',
                  child: IconButton(
                      icon:
                          Icon(igreja ? Icons.account_balance : Icons.business),
                      onPressed: () {
                        setDistrito();
                      }),
                )
              ]
            : actions(
                'gerenciador',
                context,
                'adicionar',
                setDistrito: setDistrito,
                igreja: igreja,
              ),
      ),
      drawer: mobile
          ? drawer(
              'gerenciador',
              context,
              'adicionar',
            )
          : null,
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
