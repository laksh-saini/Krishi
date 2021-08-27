import 'package:ai_app/models/user.dart';
import 'package:ai_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //create user object based on firebase user
  IDUser _fromFirebaseUser(User user) {
    return user != null ? IDUser(uid: user.uid) : null;
  }

  // auth chnage user stream
  Stream<IDUser> get user {
    return _auth.authStateChanges().map(_fromFirebaseUser);
  }

  Future<String> getCurrentUID() async {
    return (_auth.currentUser).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return _auth.currentUser.uid;
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;

      return _fromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _fromFirebaseUser(user);
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  // register with emial & password
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await DatabaseService(uid: user.uid).updateUserData(name);
      return _fromFirebaseUser(user);
    } catch (e) {
      print(e.toString());

      return null;
    }
  }

  getName() async {
    try {
      return (_auth.currentUser).displayName;
    } catch (e) {
      print(e.toString());
      return 'Guest';
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a new credential
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future signOutGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
}
