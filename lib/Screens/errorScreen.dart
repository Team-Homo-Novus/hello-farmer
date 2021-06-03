import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ErrorScreen extends StatelessWidget {
  String? errorMsg;
  ErrorScreen({this.errorMsg});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: double.infinity,
          ),
          Icon(
            Icons.dangerous,
            size: 50,
            color: Colors.redAccent,
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Center(
              child: Text(
                errorMsg!,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
