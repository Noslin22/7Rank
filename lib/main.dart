import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/User.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/views/wrappers/Wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Uid>.value(
      value: Auth().user,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: Wrapper(),
        title: "7Rank",
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: [const Locale('pt', 'BR')],
      ),
    );
  }
}
