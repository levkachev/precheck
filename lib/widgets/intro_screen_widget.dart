import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/controllers/start_controller.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/test_screen_widget.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/test_controller.dart';
import '../models/stage_model.dart';

class IntroScreenWidget extends StatefulWidget {
  final StageModel model;

  IntroScreenWidget(this.model);

  _IntroScreenWidgetState createState() => _IntroScreenWidgetState(model);
}

class _IntroScreenWidgetState extends StateMVC {
  bool isButtonEnabled = false;

  late StartController _con;

  void isCheckboxValueChanged(bool isEnabled) {
    isButtonEnabled = isEnabled;
    setState(() {});
  }

  _IntroScreenWidgetState(StageModel model) : super(StartController(model)) {
    _con = StartController(model);
  }

  Route _createRoute(StageModel model) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => TestScreen(model),
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

  void openTestScreen(StageModel model) {
    Navigator.of(context).pushAndRemoveUntil(_createRoute(model), (route) => false);
  }

  @override
  Widget build(BuildContext context) {

    ScreenState state = _con.stateNew;

    if (state is DataLoadedState) {
      // DataLoadedState currentState = state as DataLoadedState;

      if (state.model.stage is StartFinishStage) {
        StartFinishStage model = state.model.stage as StartFinishStage;

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 500,
                  child: Text(
                      model.title,
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
                    Text(model.description,
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
                        _con.acceptButtonTap();
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
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          openTestScreen(state.model);
        });
        return Scaffold();
      }
    } else if (state is LoadingState) {
      return Scaffold(
        body: Center(child:
        CircularProgressIndicator()
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: Text("UnexpectedState"),
        ),
      );
    }
  }
}
