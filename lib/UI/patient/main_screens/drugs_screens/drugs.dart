import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewAllDrugs extends StatefulWidget {
  const ViewAllDrugs({Key? key}) : super(key: key);

  @override
  State<ViewAllDrugs> createState() => _ViewAllDrugsState();
}

class _ViewAllDrugsState extends State<ViewAllDrugs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TyperAnimatedTextKit(
          text: const ["Drugs Screen Soon ..."],
          textStyle: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.w600,
            color: const Color(0xff0B3C42),
          ),
          textAlign: TextAlign.center,
          // alignment: AlignmentDirectional.centerStart,
          isRepeatingAnimation: false, // Set this to false to show the text only once
          speed: const Duration(milliseconds: 50), // Adjust the speed as needed
        ),
      ),
    );
  }
}
