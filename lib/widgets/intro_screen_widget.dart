
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tests/widgets/test_screen_widget.dart';

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
    Navigator.of(context).pushAndRemoveUntil(
        _createRoute(),
            (route) => false);
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
              child: Text("Подтвердите согласие на запись экрана и предоставление данных компании Люкс-тестс",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16, fontFamily: 'Public Sans')),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Подтверждаю",
                    style: const TextStyle(
                        fontSize: 13, fontFamily: 'Public Sans')),
                Checkbox(value: isButtonEnabled, onChanged: (value) {
                  isCheckboxValueChanged(value ?? false);
                })
              ],
            ),
            SizedBox(
              width: 170,
              height: 30,
              child: ElevatedButton(
                  onPressed: (){
                    if (isButtonEnabled) {
                      openTestScreen();
                    }
                  },
                  child: Text(isButtonEnabled ? "Далее" : "Примите правила",
                      style: const TextStyle(
                          fontSize: 16, fontFamily: 'Public Sans')),
                style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(isButtonEnabled ? Colors.indigoAccent : Colors.black26),
                  overlayColor:
                  MaterialStateProperty.resolveWith((states) {
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