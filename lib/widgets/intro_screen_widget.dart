import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tests/widgets/test_screen_widget.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroScreenWidget extends StatefulWidget {
  _IntroScreenWidgetState createState() => _IntroScreenWidgetState();
}

class _IntroScreenWidgetState extends State<IntroScreenWidget> {
  bool isButtonEnabled = false;

  void isCheckboxValueChanged(bool isEnabled) {
    isButtonEnabled = isEnabled;
    setState(() {});
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TestScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween);

        return FadeTransition(
          opacity: const AlwaysStoppedAnimation(1),
          child: child,
        );
      },
    );
  }

  void openTestScreen() {
    Navigator.of(context).pushAndRemoveUntil(_createRoute(), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 500,
              child: Text(
                  "Подтвердите согласие на запись экрана и предоставление данных компании Люкс-тестс",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.raleway(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 16))),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Подтверждаю",
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 13))),
                Checkbox(
                    value: isButtonEnabled,
                    onChanged: (value) {
                      isCheckboxValueChanged(value ?? false);
                    })
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 170,
              height: 30,
              child: ElevatedButton(
                onPressed: () {
                  if (isButtonEnabled) {
                    openTestScreen();
                  }
                },
                child: Text(isButtonEnabled ? "Далее" : "Примите правила",
                    style: GoogleFonts.raleway(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16))),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isButtonEnabled ? Colors.indigoAccent : Colors.black26),
                  overlayColor: MaterialStateProperty.resolveWith((states) {
                    return Colors.transparent;
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
