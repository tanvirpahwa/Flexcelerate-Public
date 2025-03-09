import 'package:FleXcelerate/logic/auth.dart';
import 'package:flutter/material.dart';
import 'package:FleXcelerate/shared/loading.dart';

//creates the signin page required to login
class SignInPage extends StatefulWidget {

  final Function toggleView;
  const SignInPage({super.key, required this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool loading = false;
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';
  String error = '';


  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    // Dispose of the FocusNodes to prevent memory leaks
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  String _emailErrorText = "";
  String _passwordErrorText = "";

  //updates error text if you do not meet email requirements
  void updateErrorTextEmail() {
    setState(() {
      _emailErrorText = _emailController.text.isEmpty ||
          !_emailController.text.contains('@')
          ? 'Please enter a valid email address'
          : '';

    });
  }

  //updates error text if you do not meet password requirements
  void updateErrorTextPassword() {
    setState(() {
      _passwordErrorText = _passwordController.text.isEmpty ||
          _passwordController.text.length < 8
          ? 'Password must be at least 8 characters'
          : '';
    });
  }


  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside of the form
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset : false,

        body: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0, top: 75),
                  child: Text(
                    'FleXcelerate',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0, top: 10, left: 50, right: 50),
                  child: Text(
                    'Sign in to view and update your custom fitness profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 18,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, top: 5, left: 65, right: 45),
                  child: Row(
                    children: [
                      Text(
                        'New to FleXcelerate?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 15,
                        ),
                      ),
                      TextButton(
                          style:TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 15),
                      ),
                          onPressed: () {
                            widget.toggleView();
                          },
                          child: const Text('Create an account')
                      )
                    ],
                  )
                ),


                // Email Form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    //focusNode: _emailFocus,
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return '';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      updateErrorTextEmail();
                      FocusScope.of(context).requestFocus(_passwordController as FocusNode?); //was _usernameController
                    },
                    onChanged: (val) {
                      updateErrorTextEmail();
                      setState(() => email = val);
                    },
                  ),
                ),
                Text(
                  _emailErrorText,
                  style: TextStyle(color: Colors.red),
                ),

                // Password Form
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    obscureText: true,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 8) {
                        return '';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) {
                      updateErrorTextPassword();
                    },
                    onChanged: (val) {
                      updateErrorTextPassword();
                      setState(() => password = val);
                    },
                  ),
                ),
                Text(
                  _passwordErrorText,
                  style: TextStyle(color: Colors.red),
                ),



                // Sign in button
                ElevatedButton(
                  onPressed: () async {
                    _emailErrorText = "";
                    _passwordErrorText = "";


                    if (_formKey.currentState!.validate()) {
                      // Valid email and password, handle sign-up logic
                      // After successful sign-in, you can navigate to the home page.
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null) {
                        setState(() {
                          error = 'Could not sign in with those credentials';
                          loading = false;
                        });
                      }
                      else {
                        print(result);
                      }

                    } else {

                      updateErrorTextEmail();
                      updateErrorTextPassword();
                    }
                    // Handle sign-in logic
                    // After successful sign-in, you can navigate to the home page.
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.only(left: 160, right: 160),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
