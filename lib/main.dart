import 'package:flutter/material.dart';
import 'package:flutter_app/scr/provider/google_sign_in.dart';
import 'package:flutter_app/scr/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    ),
  );
}
