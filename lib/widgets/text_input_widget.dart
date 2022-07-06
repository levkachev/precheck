

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/test_screen_widget.dart';

class TextInputWidget extends StatelessWidget {
  final String placeholder;

  final Callback callback;

  final controller = TextEditingController();

  TextInputWidget(this.placeholder, this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black38),
        borderRadius: const BorderRadius.all(Radius.circular(2))
      ),
      child: TextField(
        controller: controller,
        onChanged: (text) => callback(TextInputAnswer(text)),
        decoration: InputDecoration(
          hintText: placeholder,
          disabledBorder: null,
          enabledBorder: null,
          border: InputBorder.none
        ),
      ),
    );
  }
}