import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondPage extends StatelessWidget {
  final String title ;

  const SecondPage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          child: Text(
            title,
            style: GoogleFonts.raleway(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 18)),
          textAlign: TextAlign.center,
          ),
          width: 400,
        ),
      ),
    );
  }
}
