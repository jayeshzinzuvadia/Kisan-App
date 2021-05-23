import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.greenAccent[100],
      child: Center(
        child: SpinKitFadingCircle(
          color: Colors.lightGreen[800],
          size: 100.0,
        ),
      ),
    );
  }
}
