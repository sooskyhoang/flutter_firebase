import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/models/user.dart';
import 'package:flutter_firebase/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on UserCredential
  CustomUser? _userFromUserCredential(User? user) {
    return user != null ? CustomUser(uid: user.uid): null;
  }

  // auth change user stream
  Stream<CustomUser?> get user {
    return _auth.authStateChanges()
      // .map((User? user) => _userFromUserCredential(user));
      .map(_userFromUserCredential);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      return _userFromUserCredential(userCredential.user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email, password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return _userFromUserCredential(userCredential.user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email, password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      
      // create a new document for new user with the uid
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData('0', 'new member', 100);
      }
    
      return _userFromUserCredential(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out 
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}
