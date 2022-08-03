import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/controllers/test_controller.dart';
import 'package:tests/models/stage_model.dart';

import '../repositories/repository.dart';

class StartController extends ControllerMVC {
  final Repository repo = Repository();

  ScreenState stateNew;

  factory StartController(StageModel initialModel) => _this ??= StartController._(DataLoadedState(initialModel));

  StartController._(this.stateNew);

  static StartController? _this;

  void acceptButtonTap() {
    setState(() { stateNew = LoadingState(); });
    getStage();
  }

  void getStage() async {
    try {
      StageModel model = await repo.postAnswer(EulaAcceptance().toJson());

     setState(() { stateNew = DataLoadedState(model); });

    } catch (error) {
      print(error);
      setState(() { ErrorState(error.toString()); });
    }
  }
}