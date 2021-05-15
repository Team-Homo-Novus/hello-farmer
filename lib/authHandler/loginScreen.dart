import 'package:flutter/material.dart';
import 'package:hellofarmer/Screens/loader.dart';
import 'package:hellofarmer/services/auth.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  Function tglLogin;
  Function authFun;
  @override
  LoginScreen({Key key, this.tglLogin, this.authFun}) : super(key: key);
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = new GlobalKey<FormState>();
  String email = '';
  String pass = '';
  String authMsg = '';
  Auth _auth = new Auth();
  bool isRegistered = true;
  bool hidePass = true;
  bool isloaded = true;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(offstage: isloaded, child: LoadingScreen()),
        Offstage(
          offstage: !isloaded,
          child: Scaffold(
            backgroundColor: Colors.black87,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  appHeaderContainer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Welcome, Please ${isRegistered ? 'login' : 'register'}',
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
                  ),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: TextFormField(
                            autofocus: true,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.purpleAccent,
                                ),
                                labelText: 'email',
                                labelStyle:
                                    TextStyle(color: Colors.purpleAccent)),
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(color: Colors.white60),
                            validator: (value) {
                              if (!value.contains('@') ||
                                  !value.contains('.')) {
                                return 'Please enter valid email';
                              } else
                                return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(
                                  Icons.lock_outline,
                                  color: Colors.purpleAccent,
                                ),
                                suffixIcon: IconButton(
                                    icon: Icon(hidePass
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined),
                                    onPressed: () {
                                      setState(() {
                                        hidePass = !hidePass;
                                      });
                                    }),
                                labelText: 'Password',
                                labelStyle:
                                    TextStyle(color: Colors.purpleAccent)),
                            keyboardType: TextInputType.visiblePassword,
                            style: TextStyle(color: Colors.white60),
                            validator: (value) {
                              if (value.length < 8) {
                                return 'Please enter valid password';
                              } else
                                return null;
                            },
                            obscureText: hidePass,
                            onChanged: (value) {
                              setState(
                                () {
                                  pass = value;
                                },
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_formkey.currentState.validate()) {
                                setState(() {
                                  isloaded = false;
                                });
                                try {
                                  isRegistered
                                      ? await _auth.signInWithEmailPass(
                                          email: email, pass: pass)
                                      : await _auth.createNewUser(
                                          email: email, pass: pass);
                                } catch (e) {
                                  setState(() {
                                    authMsg = e.toString();
                                    isloaded = true;
                                  });
                                }
                              }
                            },
                            icon: Icon(Icons.keyboard_arrow_right),
                            label: Text(isRegistered ? 'Login' : 'Register'),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      thickness: 1,
                      color: Colors.white70,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.black),
                    ),
                    onPressed: () async {
                      setState(() {
                        isloaded = false;
                      });
                      authMsg = await _auth.signInWithGoogle();
                      setState(() {
                        isloaded = true;
                        authMsg = authMsg;
                      });
                    },
                    icon: Image.asset(
                      'assets/Icons/google.png',
                      width: 25,
                      height: 25,
                    ),
                    label: Text('Sign in with Google'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Divider(
                      thickness: 1,
                      color: Colors.white70,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRegistered = !isRegistered;
                      });
                    },
                    child: Text(
                      isRegistered ? 'Register here' : 'Login here',
                      style: TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  Text(
                    authMsg.length < 15
                        ? authMsg
                        : authMsg.substring(0, 10) + '...',
                    style: TextStyle(color: Colors.red),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: non_constant_identifier_names
ClipPath appHeaderContainer() {
  return ClipPath(
    clipper: MyCustomClipper(),
    child: Container(
      width: double.infinity,
      height: 200.0,
      padding: EdgeInsets.all(25.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyanAccent, Colors.purpleAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Image.asset(
              'assets/Images/Farmer.png',
            ),
          ),
          Expanded(
            child: Text(
              'Go greeen\n but digital',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, (3 * size.height) / 4);
    path.quadraticBezierTo(
        size.width / 2, size.height * 1.2, size.width, (3 * size.height) / 4);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
