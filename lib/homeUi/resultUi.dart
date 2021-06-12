import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hellofarmer/Screens/errorScreen.dart';
import 'package:hellofarmer/services/db.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ResultScreen extends StatefulWidget {
  User user;
  ResultScreen({required this.user, key}) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late Db _db;
  void initState() {
    super.initState();
    _db = Db(user: widget.user);
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<DocumentSnapshot>(
        stream: _db.fireDataStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasError) {
              return ErrorScreen(
                errorMsg: 'Error at firestore',
              );
            } else {
              List listItems = snapshot.data!.data()!["predictions"];
              return Column(
                children: listItems
                    .map(
                      (data) => InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Colors.grey[800],
                                  title: Text(
                                    'Solution',
                                    style: TextStyle(
                                      fontSize: 25,
                                      foreground: Paint()
                                        ..shader = LinearGradient(
                                          colors: <Color>[
                                            Colors.cyanAccent,
                                            Colors.purpleAccent
                                          ],
                                        ).createShader(
                                          Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                        ),
                                    ),
                                  ),
                                  content: Text(
                                    data!['solution'] ??
                                        'No solution in DB, Maybe these are older results',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white70),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Okie dokie'),
                                    )
                                  ],
                                );
                              });
                        },
                        child: Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[700],
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            minVerticalPadding: 5,
                            leading: Icon(
                              Icons.bug_report_sharp,
                              color: data["confidence"] <= 0.6
                                  ? Colors.redAccent
                                  : data["confidence"] <= 0.7
                                      ? Colors.amberAccent
                                      : data["confidence"] <= 0.9
                                          ? Colors.blueAccent
                                          : Colors.greenAccent,
                              size: 30,
                            ),
                            title: Text(
                              "Confidence : " + data["confidence"].toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              'Result : ${data["result"]}\nTimestamp : ${readTimestamp(data["ts"].toInt())}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList()
                    .reversed
                    .toList(),
              );
            }
          } else {
            return Container(
              child: SpinKitChasingDots(
                color: Colors.deepPurpleAccent,
              ),
            );
          }
        },
      ),
    );
  }
}
