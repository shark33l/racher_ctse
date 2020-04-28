import 'package:firebase_auth/firebase_auth.dart';
import 'package:racher/models/user.dart';
import 'package:racher/services/database.dart';

class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User Object based on Firebase user
  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  // Check for Auth Change | User Stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map((FirebaseUser user) => _userFromFirebaseUser(user));
  }

  // Sign in Anonymously
  Future signInAnonymously() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Email/Password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Register with Email/Password
  Future registerWithEmailAndPassword(String email, String password, String firstName, String lastName) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user= result.user;

      // Create user profile
      await DatabaseService(uid: user.uid).updateUserData(firstName, lastName, 'empty', true);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign Out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}