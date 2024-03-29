import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 6, 12),
      body: Center(
        widthFactor: double.maxFinite,
        child: SpinKitWave(
          color: Colors.deepPurpleAccent,
        ),
      ),
    );
  }
}
