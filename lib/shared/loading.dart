import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

//shows a loading icon that can be easily called for any use case
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SpinKitCircle(
          color: Colors.greenAccent,
          size: 75.0,
        ),
      ),
    );
  }
}