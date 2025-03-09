import 'package:flutter/material.dart';
import 'package:FleXcelerate/logic/auth.dart';
import 'package:FleXcelerate/shared/loading.dart';

// creates the signup page required to register
// Has three fields: email, username and password
// Checks are performed on each field before being allowed to submit
class SignUpPage extends StatefulWidget {

  final Function toggleView;
  const SignUpPage({super.key, required this.toggleView});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}


class _SignUpPageState extends State<SignUpPage> {

  bool loading = false;
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String username = '';
  String password = '';
  String error = '';

  // These are used to go to the next field when the user hits enter
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the FocusNodes to prevent memory leaks
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // To hold and update the error text for each field
  String _emailErrorText = "";
  String _usernameErrorText = "";
  String _passwordErrorText = "";

  // updates error text if you do not meet email requirements
  void updateErrorTextEmail() {
    setState(() {
      _emailErrorText = _emailController.text.isEmpty ||
          !_emailController.text.contains('@')
          ? 'Please enter a valid email address'
          : '';
    });
  }

  // updates error text if you do not meet username requirements
  void updateErrorTextUsername() {
    setState(() {
      _usernameErrorText = _usernameController.text.isEmpty
          ? 'Username can not be empty'
          : '';
    });
  }

  // updates error text if you do not meet password requirements
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

      // Dismiss the keyboard when tapping outside of the form
        onTap: () {
      FocusScope.of(context).unfocus();
    },

    child: Scaffold(
      resizeToAvoidBottomInset : false,

      body: Center(
        child: Form(
          key: _formKey,
        child: Column(
          children: [

            // App name text
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

            // Information/instruction text
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0, top: 10, left: 50, right: 50),
              child: Text(
                'Sign up to create and save your custom fitness profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 18,
                ),
              ),
            ),

            // Sign in option text
            Padding(
                padding: const EdgeInsets.only(bottom: 20.0, top: 5, left: 85, right: 45),
                child: Row(
                  children: [
                    Text(
                      'Used FleXcelerate before?',
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
                        child: const Text('Sign in')
                    )
                  ],
                )
            ),

            // Email Form
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0, top: 16, left: 16, right: 16),
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
                  FocusScope.of(context).requestFocus(_usernameController as FocusNode?);
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

            // Username Form
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0, top: 16, left: 16, right: 16),
              child: TextFormField(
                //focusNode: _usernameFocus,
                controller: _usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return '';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  updateErrorTextUsername();
                  FocusScope.of(context).requestFocus(_passwordController as FocusNode?);
                },
                onChanged: (val) {
                  updateErrorTextUsername();
                  setState(() => username = val);
                },
              ),
            ),
            Text(
              _usernameErrorText,
              style: TextStyle(color: Colors.red),
            ),

            // Password Form
            Padding(
              padding: const EdgeInsets.only(bottom: 1.0, top: 16, left: 16, right: 16),
              child: TextFormField(
                obscureText: true,
                //focusNode: _passwordFocus,
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
                //textInputAction: TextInputAction.done,
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

            // Sign up button
            ElevatedButton(
              onPressed: () async {
                _emailErrorText = "";
                _usernameErrorText = "";
                _passwordErrorText = "";

                if (_formKey.currentState!.validate()) {
                  // Valid email and password, handle sign-up logic
                  // After successful sign-up, you can navigate to the home page.
                  setState(() => loading = true);
                  dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                  if(result == null) {
                    setState(() {
                      error = 'Please type a valid email';
                      loading = false;
                    });
                  }
                  else{
                    print(result);
                }

                } else {
                  updateErrorTextEmail();
                  updateErrorTextUsername();
                  updateErrorTextPassword();
                }
                // Handle sign-up logic
                // After successful sign-up, you can navigate to the home page.
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.only(left: 160, right: 160),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
      ),
    ),
    );
  }
}