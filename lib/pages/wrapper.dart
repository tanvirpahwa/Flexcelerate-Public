import 'package:FleXcelerate/logic/authenticate.dart';
import 'package:FleXcelerate/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/user.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<Users?>(context);
    print(user);

    // return home or auth
    if(user == null) {
      return Authenticate();
    } else {
      return HomePage();
    }
  }
}
