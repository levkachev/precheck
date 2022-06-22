import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String title ;

  const SecondPage({Key? key, required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      child: Text(title),
    );
  }
}
