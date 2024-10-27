import 'package:flutter/material.dart';
import 'package:todolist_app/widgets/AuthVerify.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //await FirebaseAuth.instance.signOut();

  runApp(
    MaterialApp(
      theme: ThemeData(
         appBarTheme: const AppBarTheme(elevation: 0),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.purple)
            .copyWith(background: Color.fromARGB(255, 150, 6, 30)),
        scaffoldBackgroundColor: Color.fromARGB(255, 126, 126, 126)
      ),
      home: const AuthVerify(),
    ),
  );
}