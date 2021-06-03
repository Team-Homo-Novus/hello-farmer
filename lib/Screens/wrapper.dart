import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Screens/loader.dart';
import 'package:hellofarmer/authHandler/loginScreen.dart';
import 'package:hellofarmer/homeUi/homeScreen.dart';
import 'package:hellofarmer/services/auth.dart';

class ScreenWrapper extends StatefulWidget {
  @override
  _ScreenWrapperState createState() => _ScreenWrapperState();
}

class _ScreenWrapperState extends State<ScreenWrapper> {
  Auth _auth = new Auth();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<Object?>(
          stream: _auth.userAuthStream,
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingScreen();
            } else if (snapshot.data == null) {
              return LoginScreen();
            } else
              return HomeScreen(user: snapshot.data as User?);
          }),
    );
  }
}
