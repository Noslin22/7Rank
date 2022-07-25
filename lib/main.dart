import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:remessa/models/Auth.dart';
import 'package:remessa/models/widgets/consts.dart';
import 'package:remessa/views/wrappers/Wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? initialUser;
    Auth(auth: FirebaseAuth.instance).user.single.then((value) {
      initialUser = value;
    });
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (context) => Auth(auth: FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<Auth>().user,
          initialData: initialUser,
        ),
      ],
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
