import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/controllers/test_controller.dart';
import 'package:tests/models/stage_model.dart';
import 'package:tests/models/test-model.dart';
import 'package:code_text_field/code_text_field.dart';
import 'package:highlight/languages/swift.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/highlight_core.dart';
import 'package:tests/widgets/code_input_widget.dart';
import 'package:tests/widgets/multi_choice_widget.dart';
import 'package:tests/widgets/second_screen.dart';
import 'package:tests/widgets/text_input_widget.dart';
import 'package:tests/widgets/timer_widget.dart';
import 'single_choice_widget.dart';
import 'package:google_fonts/google_fonts.dart';

typedef void Callback(Object answer);

class TestScreen extends StatefulWidget {
  StageModel initialQuestion;

  TestScreen(this.initialQuestion);

  @override
  _TestScreenState createState() => _TestScreenState(initialQuestion);
}

class _TestScreenState extends StateMVC {
  late TestController _con;

  _TestScreenState(StageModel initialQuestion) : super(TestController(initialQuestion)) {
    // получаем ссылку на наш контроллер
    _con = TestController(initialQuestion);
  }

  void callback(Object answer) {
    _con.setVariantForItem(answer);
  }

  void openFinishScreen(String title) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
            builder: (BuildContext context) =>
                SecondPage(title: title)),
            (route) => false);
  }

  Widget currentQuestionWidget(QuestionModel currentModel) {
    Widget currentWidget;

    switch (currentModel.kind) {
      case TestKind.singleChoice:
        ChoicesOutput model = (currentModel.inputModel as ChoicesOutput);
        currentWidget = SingleChoiceQuestionWidget(
            model.choises,
            currentModel.id,
            callback
        );
        break;
      case TestKind.codeInput:
        currentWidget = CodeInputWidget(
            (currentModel.inputModel as CodeOutput).template, currentModel.id, callback);
        break;
      case TestKind.textInput:
        currentWidget = TextInputWidget(
            (currentModel.inputModel as TextOutput).placeholder, callback, currentModel.id);
        break;
      case TestKind.multiChoice:
        ChoicesOutput model = (currentModel.inputModel as ChoicesOutput);
        currentWidget = MultiChoiceWidget(
            model.choises,
            callback,
            currentModel.id
        );
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

  // @override
  // void initState() {
  //   _con.getCurrentModel();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    ScreenState state = _con.stateNew;

    if (state is LoadingState) {
       return Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is ErrorState) {
      var error = (state as ErrorState).error;
      return Center(
        child: Text(error),
      );
    } else {
      StageModel model = (state as DataLoadedState).model;

      if (model.stage is TestModel) {
        TestModel currentModel = model.stage as TestModel;

        return Scaffold(
          body: Container(
            color: Color(0xFF720D5D),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: ProgressIndicatorWidget(
                              currentModel.currentStep, currentModel.stepsCount),
                        ),
                        Expanded(
                            child: Container(
                              padding: EdgeInsets.only(left: 30),
                              child: TimerWidget(currentModel.testStartedTimestamp),
                            ))
                      ]),
                ),
                Container(
                  height: 30,
                ),
                Container(
                  height: 30,
                  child: Stack(
                    children: [
                      Container(
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16))
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(16),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Text(currentModel.question.title,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18
                                )
                            )
                        ),
                        // const TextStyle(fontSize: 18, fontFamily: 'Public Sans')),
                        SizedBox(
                          height: 10,
                        ),
                        if (currentModel.question.codeSnippet != null) ...{
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: CodeFieldWidget(
                                      currentModel.question.codeSnippet ?? "")),
                              Expanded(child: Container())
                            ],
                          ),
                        },
                        SizedBox(
                          height: 20,
                        ),
                        Text(currentModel.question.description,
                            style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18
                                )
                            )
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: currentQuestionWidget(currentModel.question),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: 200,
              height: 60,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.black),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF720D5D)),
                      overlayColor:
                      MaterialStateProperty.resolveWith((states) {
                        return Colors.transparent;
                      }),
                      enableFeedback: false,
                      animationDuration: Duration.zero,
                      shape
                          : MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32)
                          )
                      )
                  ),
                  onPressed: () {
                      _con.nextButtonTap();
                  },
                  child: Center(
                      child: Text("Далее",
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 18,
                                // color: Colors.black
                              )
                          )
                      )
                  )
              ),
            ),
          ),
        );
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openFinishScreen((model.stage as StartFinishStage).title);
        });
        return Scaffold();
      }
    }

  }
}

class CodeFieldWidget extends StatelessWidget {
  late String codeSource;

  final codeController = CodeController(
    language: swift,
    theme: monokaiSublimeTheme,
    webSpaceFix: false
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
      color: Color(0xFF720D5D),
      child: Row(
        children: [
          Text("Шаг $currentStep из $stepsCount",
              style: GoogleFonts.raleway(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.white70
                  )
              )
          ),
          Container(width: 40),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                child: LinearProgressIndicator(
                  minHeight: 20,
                  backgroundColor: Colors.black54,
                  color: Color(0xFF4E0D3A),
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
