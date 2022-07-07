import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String title ;

  const SecondPage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SizedBox(
          child: Text(
            "Спасибо! В ближайшее время с вами свяжется наш hr-специалист и вы получите обратную связь по результатам теста",
            style: const TextStyle(
                fontSize: 18, fontFamily: 'Public Sans'),
          textAlign: TextAlign.center,
          ),
          width: 400,
        ),
      ),
    );
  }
}
