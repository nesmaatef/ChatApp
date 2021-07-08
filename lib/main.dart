// @dart=2.9

import 'dart:convert';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/welcome_screen/Welcome_screen.dart';
import 'const/const.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  runApp(ProviderScope(
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "App",
    home: MyApp(app: app),
  )));
}

class MyApp extends StatelessWidget {
  FirebaseApp app;

  MyApp({this.app});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            Image.asset("assets/images/welcome_image.png"),
            Spacer(flex: 3),
            Text(
              "Welcome to our freedom \nmessaging app",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.blueAccent),
            ),
            Spacer(),
            Text(
              "Freedom talk any person of your \nmother language.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
            ),
            Spacer(flex: 3),
            FittedBox(
              child: TextButton(
                  onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Welcome(),
                        ),
                      ),
                  child: Row(
                    children: [
                      Text("Skip",
                          style: TextStyle(fontSize: 15.0, color: Colors.red)),
                      SizedBox(width: kDefaultPadding / 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red,
                        size: 16,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
