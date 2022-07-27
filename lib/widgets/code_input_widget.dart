import 'package:flutter/cupertino.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:highlight/languages/swift.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/test_screen_widget.dart';

class CodeInputWidget extends StatelessWidget {
  late CodeController controller;

  CodeInputWidget(String text, Callback callback) {
    // codeController.text = text;
    this.controller = CodeController(
        language: swift,
        theme: monokaiSublimeTheme,
        webSpaceFix: false,
        onChange: (text) {
          callback(CodeInputAnswer(text));
          // print(text);
        },
      text: text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CodeField(
        controller: controller,
        enabled: true,
      ),
    );
  }
}