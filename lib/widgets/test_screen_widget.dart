import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/controllers/test_controller.dart';
import 'package:tests/models/test-model.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/swift.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight_core.dart';
import 'package:tests/widgets/code_input_widget.dart';
import 'package:tests/widgets/multi_choice_widget.dart';
import 'package:tests/widgets/second_screen.dart';
import 'package:tests/widgets/text_input_widget.dart';

import 'single_choice_widget.dart';

typedef void Callback(Object answer);

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends StateMVC {
  late TestController _con;

  _TestScreenState() : super(TestController()) {
    // получаем ссылку на наш контроллер
    _con = TestController();
  }

  void callback(Object answer) {
  _con.setVariantForItem(answer);
  }

  void openSecondScreen() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                const SecondPage(title: "the end")),
        (route) => false);
  }

  Widget currentQuestionWidget() {
    TestModel currentModel = _con.getCurrentModel();

    Widget currentWidget;

    switch (currentModel.kind) {
      case TestKind.singleChoice:
        currentWidget = SingleChoiceQuestionWidget((currentModel.inputModel as ChoisesOutput).choises, callback);
        break;
      case TestKind.codeInput:
        currentWidget = CodeInputWidget((currentModel.inputModel as CodeOutput).template, callback);
        break;
      case TestKind.textInput:
        currentWidget = TextInputWidget((currentModel.inputModel as TextOutput).placeholder, callback);
        break;
      case TestKind.multiChoice:
        currentWidget = MultiChoiceWidget((currentModel.inputModel as ChoisesOutput).choises, callback);
        break;
    }

    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        currentWidget
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TestModel currentModel = _con.getCurrentModel();
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                flex: 2,
                child: ProgressIndicatorWidget(
                    currentModel.currentStep, currentModel.stepsCount),
              ),
              Expanded(child: Container())
            ]),
            SizedBox(
              height: 50,
            ),
            Text(currentModel.title),
            SizedBox(
              height: 10,
            ),
            if (currentModel.codeSnippet != null) ...{
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: CodeFieldWidget(currentModel.codeSnippet ?? "")),
                  Expanded(child: Container())
                ],
              ),
            },
            SizedBox(
              height: 20,
            ),
            Text(
                currentModel.description,
                style: const TextStyle(
                  fontSize: 20,
                  // fontFamily: 'Public Sans'

            )
            ),
            currentQuestionWidget(),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                  onPressed: () {
                    if (currentModel.stepsCount == currentModel.currentStep) {
                      _con.nextButtonTap();
                      openSecondScreen();
                    } else {
                      _con.nextButtonTap();
                    }
                  },
                  child: Center(child: Text("Далее"))
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CodeFieldWidget extends StatelessWidget {
  late String codeSource;

  final codeController = CodeController(
    language: swift,
    theme: monokaiSublimeTheme,
  );

  CodeFieldWidget(String text) {
    this.codeSource = text;
    codeController.text = codeSource;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CodeField(
        controller: codeController,
        enabled: false,
      ),
    );
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final int stepsCount;

  ProgressIndicatorWidget(this.currentStep, this.stepsCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text("Шаг $currentStep из $stepsCount"),
          Container(width: 40),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                child: LinearProgressIndicator(
                  minHeight: 20,
                  backgroundColor: Colors.black12,
                  color: Colors.blueGrey,
                  value: currentStep / stepsCount,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*
return Scaffold(
body: Center(
child: Row(
children: [
Expanded(
child: Center(child: Text(currentModel.title)),
),
if (currentModel.currentStep != currentModel.stepsCount)...[
Expanded(
child: Center(
child: SizedBox(
width: 100,
child: ElevatedButton(
onPressed: () { _con.nextButtonTap(); },
child: Text('Next question'),
),
),
),
),
]
],
),
),
);
 */
