import 'dart:io';

class TestModel {
  final TestKind kind;
  final int testStartedTimestamp;
  final int stepsCount;
  final int currentStep;
  final String title;
  final String description;
  final String? codeSnippet;
  final InputModel inputModel;

  TestKind parseTestKind(final String kind) {
    switch (kind) {
      case 'multiChoice':
        return TestKind.multiChoice;
      case 'textInput':
        return TestKind.textInput;
      case 'codeInput':
        return TestKind.codeInput;
      case 'singleChoice':
        return TestKind.singleChoice;
      default:
        throw Exception('$kind is not valid kind');
    }
  }

  TestModel.rawInit(
      this.kind,
      this.testStartedTimestamp,
      this.stepsCount,
      this.currentStep,
      this.title,
      this.description,
      this.inputModel,
      [this.codeSnippet]
      );

  TestModel.fromJson(Map<String, dynamic> json)
      : this.kind = TestKind.values.byName(json['kind']),
        this.testStartedTimestamp = json['testStartAt'],
        this.stepsCount = json['stepsCount'],
        this.currentStep = json['currentStep'],
        this.title = json['title'],
        this.description = json['description'],
        this.codeSnippet = json['codeSnippet'],
        this.inputModel =
            InputModel.fromMap(json['inputModel'], TestKind.values.byName(json['kind']));
}

abstract class InputModel {
  const InputModel();

  factory InputModel.fromMap(Map<String, dynamic> map, TestKind kind) {
    switch (kind) {
      case TestKind.multiChoice:
        return ChoisesOutput.fromMap(map);
      case TestKind.singleChoice:
        return ChoisesOutput.fromMap(map);
      case TestKind.codeInput:
        return CodeOutput.fromMap(map);
      case TestKind.textInput:
        return TextOutput.fromMap(map);
    }
  }
}

class ChoisesOutput extends InputModel {
  final List<String> choises;

  ChoisesOutput(this.choises);

  factory ChoisesOutput.fromMap(Map<String, dynamic> map) {
    List<String> stringList = (map['variants'] as List<dynamic>).cast<String>();
    return ChoisesOutput(stringList);
  }
}

class CodeOutput extends InputModel {
  final String template;

  CodeOutput(this.template);

  factory CodeOutput.fromMap(Map<String, dynamic> map) {
    return CodeOutput(map['template']);
  }
}

class TextOutput extends InputModel {
  final String placeholder;

  TextOutput(this.placeholder);

  factory TextOutput.fromMap(Map<String, dynamic> map) {
    return TextOutput(map['placeholder']);
  }
}

enum TestKind { multiChoice, textInput, codeInput, singleChoice }

class SingleChoiceAnswer {
  final String answer;

  SingleChoiceAnswer(this.answer);
}

class MultiChoiceAnswer {
  final List<String> answers;

  MultiChoiceAnswer(this.answers);
}

class TextInputAnswer {
  final String answer;

  TextInputAnswer(this.answer);
}

class CodeInputAnswer {
  final String answer;

  CodeInputAnswer(this.answer);
}
