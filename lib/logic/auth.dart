import 'package:firebase_auth/firebase_auth.dart';
import 'package:FleXcelerate/logic/database.dart';
import 'package:flutter/cupertino.dart';
import 'user.dart';

class AuthService {

  //creates easily accessible variable that connects to firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user obj based on FirebaseUser
  Users? _userFromFirebaseUser(User? user) {
    return user != null ? Users(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<Users?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      UserData userData = UserData(
          uid: user!.uid,
          firstName: 'Default',
          lastName: 'Default',
          age: '0',
          height: '0 0',
          weight: '0',
          gender: 'Default',
          profilePhoto: const AssetImage('lib/assets/logo.png'),
          weightGoal: '0'
      );

      UserDataSingleton().setUserData(userData);

      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  //register with email & password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      // Get the user from the result
      User? user = result.user;

      // Update the user data with default values
      await DatabaseService(uid: user?.uid ?? '').updateUserData(
          'Default',
          '',
          '0',
          '0 0',
          '0',
          'null',
          AssetImage('lib/assets/logo.png'),
          '0'
      );

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }


  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}