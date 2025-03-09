import 'package:FleXcelerate/pages/signInPage.dart';
import 'package:FleXcelerate/pages/signUpPage.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

//either shows sign in or sign up page
class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn){
      return SignInPage(toggleView: toggleView);
    } else {
      return SignUpPage(toggleView: toggleView);
    }
  }
}
