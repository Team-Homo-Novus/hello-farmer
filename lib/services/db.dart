import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hellofarmer/services/auth.dart';

class Db {
  Auth _auth = Auth();
  late List streamData;
  CollectionReference dbHandler =
      FirebaseFirestore.instance.collection('/userData');
  late User user;
  late Stream<DocumentSnapshot> fireDataStream;
  Db({required this.user}) {
    fireDataStream = dbHandler.doc(this.user.uid).snapshots();
  }
  Future createUserData() async {
    try {
      var res = await dbHandler.doc(this.user.uid).get();

      if (!res.exists) {
        await dbHandler.doc(this.user.uid).set({
          "Name": user.displayName ?? user.email!.split('@')[0],
          'predictions': []
        });
      }
    } catch (e) {
      _auth.signout();
    }
  }

  Future addPredsToDb(List<Map> preds) async {
    dbHandler.doc(this.user.uid).set(
        {"predictions": FieldValue.arrayUnion(preds)}, SetOptions(merge: true));
  }
}
