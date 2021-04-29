import 'package:flutter/material.dart';
import 'package:hellofarmer/Screens/errorScreen.dart';
import 'package:hellofarmer/Screens/loader.dart';
import 'package:hellofarmer/Screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              ErrorScreen(
                errorMsg: snapshot.error.toString(),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              return ScreenWrapper();
            }
            return LoadingScreen();
          }),
    );
  }
}
