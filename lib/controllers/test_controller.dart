import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/models/stage_model.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/repositories/repository.dart';

class TestController extends ControllerMVC {
  final Repository repo = Repository();

  var currentStep = 1;

  ScreenState stateNew;

  Object? currentAnswer;

  QuestionModel? currentTest;

  StageModel initialModel;

  String testId;

  void nextButtonTap() {
    if (currentAnswer is CodeInputAnswer) {
      postAnswer((currentAnswer as CodeInputAnswer).toJson());
    } else if (currentAnswer is TextInputAnswer) {
      postAnswer((currentAnswer as TextInputAnswer).toJson());
    } else if (currentAnswer is SingleChoiceAnswer) {
      postAnswer((currentAnswer as SingleChoiceAnswer).toJson());
    } else if (currentAnswer is MultiChoiceAnswer) {
      postAnswer((currentAnswer as MultiChoiceAnswer).toJson());
    }
      setState(() { stateNew = LoadingState(); });
  }

  void setVariantForItem(Object? variant) {
    currentAnswer = variant;
  }

  void postAnswer(Map<String, dynamic> answer) async {
    try {
      StageModel model = await repo.postAnswer(answer, testId);
      setState(() { stateNew = DataLoadedState(model); });
    } catch (error) {
      setState(() { stateNew = ErrorState(error.toString()); });
    }
  }

  // сам по себе factory конструктор не создает
  // экземляра класса HomeController
  // и используется для различных кастомных вещей
  // в данном случае мы реализуем паттерн Singleton
  // то есть будет существовать единственный экземпляр
  // класса HomeController
  factory TestController(StageModel initialModel, String testId) => _this ??= TestController._(initialModel, DataLoadedState(initialModel), testId);

  TestController._(this.initialModel, this.stateNew, this.testId);

  static TestController? _this;
}

abstract class ScreenState {}

class LoadingState extends ScreenState {}

class DataLoadedState extends ScreenState {
  final StageModel model;
  DataLoadedState(this.model);
}

class ErrorState extends ScreenState {
  final String error;
  ErrorState(this.error);
}