import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:tests/models/test-model.dart';

class TestController extends ControllerMVC {
  var text = "main screen MVC";

  var currentStep = 1;

  Object? currentAnswer = null;

  List<String> answers = [];

  List<TestModel> testItems = [
    TestModel.rawInit(
        TestKind.singleChoice,
        "123123",
        4,
        1,
        "Что будет выведено в консоль при выполнении следующего блока кода?",
        "Выберите один ответ из перечисленных",
        ChoisesOutput(["4", "2", "3", "1", "no one from variants are true"]),
      "if a == 4 \n"
          "print('a = 4') \n"
          "else print('a != 4') \n"
    ),
    TestModel.rawInit(
        TestKind.multiChoice,
        "123123",
        4,
        2,
        "Какие варианты из нижеперечисленных соответствуют действительности?",
        "Выберите несколько вариантов ответа",
        ChoisesOutput(["1", "2", "3"]),
      "if a == 4 print('a = 4') else print('a!=4')"
    ),
    TestModel.rawInit(
        TestKind.textInput,
        "123123",
        4,
        3,
        "Что будет выведено в консоль при выполнении следующего блока кода?",
        "Введите ответ в текстовое поле",
        TextOutput("Введите ответ.."),
      "if a == 4 print('a = 4') else print('a!=4')"
    ),
    TestModel.rawInit(
        TestKind.codeInput,
        "123123",
        4,
        4,
        "Каким образом данный блок кода можно отрефакторить, чтобы значения вывелись в обратном порядке?",
        "Исправьте заготовленный код",
        CodeOutput("if a == 5 { \n    print('a = 5') \n}")
    )
  ];

  void nextButtonTap() {
    if (currentAnswer is CodeInputAnswer) {
      print((currentAnswer as CodeInputAnswer).answer);
      answers.add((currentAnswer as CodeInputAnswer).answer);
    } else if (currentAnswer is TextInputAnswer) {
      print((currentAnswer as TextInputAnswer).answer);
      answers.add((currentAnswer as TextInputAnswer).answer);
    } else if (currentAnswer is SingleChoiceAnswer) {
      print((currentAnswer as SingleChoiceAnswer).answer);
      answers.add((currentAnswer as SingleChoiceAnswer).answer);
    } else if (currentAnswer is MultiChoiceAnswer) {
      print((currentAnswer as MultiChoiceAnswer).answers);
      answers.add((currentAnswer as MultiChoiceAnswer).answers.toString());
    }
    if (currentStep < testItems.length) {
      setState(() { currentStep++; });
    }
  }

  void setVariantForItem(Object? variant) {
    currentAnswer = variant;
  }

  TestModel getCurrentModel() {
    return testItems[currentStep - 1];
  }

  // сам по себе factory конструктор не создает
  // экземляра класса HomeController
  // и используется для различных кастомных вещей
  // в данном случае мы реализуем паттерн Singleton
  // то есть будет существовать единственный экземпляр
  // класса HomeController
  factory TestController() => _this ??= TestController._();

  TestController._();

  static TestController? _this;
}
