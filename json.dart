import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA7dyDfFXnNGnQIxH2vI_y91tSeGRWILnA",
      authDomain: "igreja-4019a.firebaseapp.com",
      databaseURL: "https://igreja-4019a.firebaseio.com",
      projectId: "igreja-4019a",
      storageBucket: "igreja-4019a.appspot.com",
      messagingSenderId: "776069113661",
      appId: "1:776069113661:web:541360069c876b03268754",
      measurementId: "G-P1RZDCB84R",
    ),
  );
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final List<Widget> pages = [Export(), Import(), Excluir()];

  bool hover = false;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            MouseRegion(
              child: NavigationRail(
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.file_upload_outlined),
                    label: Text("Exportar"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.file_download_outlined),
                    label: Text("Importar"),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.delete),
                    label: Text("Excluir"),
                  ),
                ],
                extended: hover,
                onDestinationSelected: (i) {
                  setState(() {
                    index = i;
                  });
                },
                selectedIndex: index,
              ),
              onExit: (_) {
                setState(() {
                  hover = false;
                });
              },
              onHover: (_) {
                setState(() {
                  hover = true;
                });
              },
            ),
            Expanded(
              child: pages[index],
            ),
          ],
        ),
      ),
    );
  }
}

class Export extends StatelessWidget {
  Export({Key? key}) : super(key: key);
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text("Exportar Igrejas"),
            onPressed: () async {
              final List<Map<String, dynamic>> igrejas = [];
              await db.collection("igrejas").orderBy("cod").get().then((value) {
                value.docs.forEach((value) {
                  igrejas.add(value.data());
                });
              });
              Clipboard.setData(ClipboardData(text: json.encode(igrejas)));
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text("Exportar Distritos"),
            onPressed: () async {
              final List<Map<String, dynamic>> distritos = [];
              await db.collection("distritos").get().then((value) {
                value.docs.forEach((value) {
                  distritos.add(value.data());
                });
              });
              Clipboard.setData(
                  ClipboardData(text: json.encode(distritos.toString())));
            },
          ),
        ],
      ),
    );
  }
}

class Import extends StatelessWidget {
  Import({Key? key}) : super(key: key);
  final Map<String, int> numDistritos = {};
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text("Importar Igrejas"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                PlatformFile file = result.files.single;

                String raw = File.fromRawPath(file.bytes!).path;
                List<String> lines = raw.split("\r\n");
                lines = lines.getRange(1, lines.length).toList();
                for (var line in lines) {
                  List<String> values = line.split("	");
                  db.collection("igrejas").add({
                    "cod": values[1],
                    "distrito": values[0],
                    "nome": values[2],
                    "data": "14/07/2022",
                    "marcado": false,
                    "contrato": "",
                    "matricula": "",
                  });
                }
              }
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text("Importar Distritos"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();
              if (result != null) {
                PlatformFile file = result.files.single;

                String raw = File.fromRawPath(file.bytes!).path;
                List<String> lines = raw.split("\r\n");
                lines = lines.getRange(1, lines.length).toList();
                for (var line in lines) {
                  List<String> values = line.split("	");
                  db.collection("distritos").doc(values[0]).set({
                    "faltam": numDistritos[values[0]],
                    "data": Timestamp.now(),
                    "pastor": "",
                    "regiao": null,
                  });
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class Excluir extends StatelessWidget {
  Excluir({Key? key}) : super(key: key);
  final Map<String, int> numDistritos = {};
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            child: const Text("Excluir Igrejas"),
            onPressed: ()  {
              db.collection("igrejas").get().then((value) {
                value.docs.forEach((element) => element.reference.delete());
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            child: const Text("Excluir Distritos"),
            onPressed: ()  {
              db.collection("distritos").get().then((value) {
                value.docs.forEach((element) => element.reference.delete());
              });},
          ),
        ],
      ),
    );
  }
}
