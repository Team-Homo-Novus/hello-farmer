import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/homeUi/homeComponent.dart';
import 'package:hellofarmer/services/auth.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  User? user;

  @override
  HomeScreen({Key? key, this.user}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var initIndex = 0;
  Auth _auth = new Auth();
  List<Widget> screens = [
    Home(),
    Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          'Sorry for inconvenience. We are working on it =_=',
          style: TextStyle(
            fontSize: 25,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[Colors.cyanAccent, Colors.purpleAccent],
              ).createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
      ),
    ),
    Center(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(
          'Sorry for inconvenience. We are working on it :(',
          style: TextStyle(
            fontSize: 25,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[Colors.cyanAccent, Colors.purpleAccent],
              ).createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 6, 12),
        title: Text(
          widget.user!.displayName ?? widget.user!.email!.split('@')[0],
          style: TextStyle(
            fontSize: 25,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: <Color>[Colors.cyanAccent, Colors.purpleAccent],
              ).createShader(
                Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
              ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.purpleAccent,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: Colors.grey[800],
                          title: Text(
                            'Logout?',
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
                            'Do you want to logout?',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('No'),
                            ),
                            TextButton(
                              onPressed: () async {
                                await _auth.signout();
                                Navigator.pop(context);
                              },
                              child: Text('Yes'),
                            )
                          ],
                        );
                      });
                }),
          )
        ],
      ),
      body: Stack(
        children: screens
            .asMap()
            .map(
              (i, screens) => MapEntry(
                i,
                Offstage(offstage: initIndex != i, child: screens),
              ),
            )
            .values
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: initIndex,
        onTap: (i) => setState(() {
          initIndex = i;
        }),
        backgroundColor: Color.fromARGB(255, 0, 6, 12),
        selectedItemColor: Colors.deepPurpleAccent,
        unselectedItemColor: Colors.blueGrey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Resource',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            activeIcon: Icon(Icons.help),
            label: 'Help',
          ),
        ],
      ),
    );
  }
}
