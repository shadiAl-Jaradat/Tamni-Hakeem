import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Center(
        child:SpinKitChasingDots(
          color: Color(0xff0B3C42),
          size: 50.0,
          duration : Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
