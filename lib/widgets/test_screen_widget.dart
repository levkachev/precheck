import 'dart:async';

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
import 'package:google_fonts/google_fonts.dart';

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
        currentWidget = SingleChoiceQuestionWidget(
            (currentModel.inputModel as ChoisesOutput).choises, callback);
        break;
      case TestKind.codeInput:
        currentWidget = CodeInputWidget(
            (currentModel.inputModel as CodeOutput).template, callback);
        break;
      case TestKind.textInput:
        currentWidget = TextInputWidget(
            (currentModel.inputModel as TextOutput).placeholder, callback);
        break;
      case TestKind.multiChoice:
        currentWidget = MultiChoiceWidget(
            (currentModel.inputModel as ChoisesOutput).choises, callback);
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
                            child: TimerWidget(),
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
                      Text(currentModel.title,
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
                      if (currentModel.codeSnippet != null) ...{
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: CodeFieldWidget(
                                    currentModel.codeSnippet ?? "")),
                            Expanded(child: Container())
                          ],
                        ),
                      },
                      SizedBox(
                        height: 20,
                      ),
                      Text(currentModel.description,
                          style: GoogleFonts.raleway(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18
                              )
                          )
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: currentQuestionWidget(),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      // Expanded(
                      //   child: Align(
                      //     alignment: Alignment.bottomCenter,
                      //     child: SizedBox(
                      //       width: 200,
                      //       height: 50,
                      //       child: ElevatedButton(
                      //           style: ButtonStyle(
                      //               backgroundColor:
                      //               MaterialStateProperty.all<Color>(Colors.brown),
                      //               overlayColor:
                      //               MaterialStateProperty.resolveWith((states) {
                      //                 return Colors.transparent;
                      //               }),
                      //               enableFeedback: false,
                      //               animationDuration: Duration.zero),
                      //           onPressed: () {
                      //             if (currentModel.stepsCount ==
                      //                 currentModel.currentStep) {
                      //               _con.nextButtonTap();
                      //               openSecondScreen();
                      //             } else {
                      //               _con.nextButtonTap();
                      //             }
                      //           },
                      //           child: Center(
                      //               child: Text("Далее",
                      //                   style: GoogleFonts.raleway(
                      //                       textStyle: TextStyle(
                      //                           fontWeight: FontWeight.w500,
                      //                           fontSize: 18
                      //                       )
                      //                   )
                      //               )
                      //           )
                      //       ),
                      //     ),
                      //   ),
                      // )
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
          if (currentModel.stepsCount ==
              currentModel.currentStep) {
            _con.nextButtonTap();
            openSecondScreen();
          } else {
            _con.nextButtonTap();
          }
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
    ),)
    ,
    )
    ,
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

class TimerWidget extends StatefulWidget {
  // int startTimestamp;
  // TimerWidget(this.startTimestamp);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer? timer;

  final stopwatch = Stopwatch();

  int minutes = 0;
  int seconds = 0;

  int milliseconds = 0;

  void callback(Timer timer) {
    if (milliseconds != stopwatch.elapsedMilliseconds) {
      milliseconds = stopwatch.elapsedMilliseconds;
      setState(() {
        final int hundreds = (milliseconds / 10).truncate();
        seconds = (hundreds / 100).truncate();
        minutes = (seconds / 60).truncate();
      });
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 30), callback);
    stopwatch.start();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    stopwatch.stop();
    stopwatch.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return Row(
      children: [
        Text("$minutesStr : $secondsStr",
            style: GoogleFonts.raleway(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white70
                )
            )
        )
      ],
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
