import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  FirebaseFirestore dbHandler = FirebaseFirestore.instance;
  User? user;
  Db({this.user});

  Stream getAllChannels() async* {
    var collection = dbHandler.collection('/');

    yield collection.get();
  }
}

class User {
  User();
  Future<void> createUserDocument() async {}
}
