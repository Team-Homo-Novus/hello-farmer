import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    } catch (e) {
      throw e.toString();
    }
  }

  Future createNewUser({email, pass}) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      _logger.logError(error: e.code.toString());
      throw e.code;
    } catch (e) {
      throw e.code.toString();
    }
  }

  Future<String> signInWithGoogle() async {
    var user;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      try {
        user = await _auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        return e.code.toString();
      } catch (e) {
        return e.code.toString();
      }
    }

    return user != null ? "Success" : "Canceled";
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
