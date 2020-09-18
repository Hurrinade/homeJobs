import 'package:firebase_auth/firebase_auth.dart';
import 'package:homejobs/models/my_user.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  MyUser _tomyUser(User user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  //user auth stream, checks if user is registered or not, sends myUser(uid) through stream
  Stream<MyUser> get user {
    return _auth.authStateChanges().map(_tomyUser);
  }

  //sign in anon
  Future<MyUser> signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _tomyUser(user);
    } catch (e) {
      return null;
    }
  }

  //register with email and passoword
  Future<MyUser> registerEmailAndPassword(String mail, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: mail, password: password);
      User user = result.user;
      return _tomyUser(user);
    } catch (e) {
      return null;
    }
  }

  //sign in with email and password
  Future<MyUser> signInEmailAndPassword(String mail, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: mail, password: password);
      User user = result.user;
      return _tomyUser(user);
    } catch (e) {
      return null;
    }
  }

  //sign out
  Future userSignOut() {
    return _auth.signOut();
  }
}
