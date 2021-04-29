import 'package:firebase_auth/firebase_auth.dart';

import 'logging.dart';

class Auth {
  FirebaseAuth _auth;
  Logger _logger = new Logger();
  Stream userAuthStream;
  Auth() {
    _auth = FirebaseAuth.instance;
    userAuthStream = _auth.authStateChanges();
  }
  dynamic signInWithEmailPass({email, pass}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      _logger.logError(error: e.code.toString());
      throw e.code;
    }
  }

  Future createNewUser({email, pass}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      _logger.logError(error: e.code.toString());
      throw e.code;
    }
  }

  Future signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.logError(error: e.toString());
      throw e;
    }
  }
}
