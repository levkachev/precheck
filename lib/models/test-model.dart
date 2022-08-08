import 'dart:convert';
import 'dart:io';

import 'package:tests/models/stage_model.dart';

class TestModel extends Stage {
  final int testStartedTimestamp;
  final int stepsCount;
  final int currentStep;
  final QuestionModel question;

  TestModel.fromJson(Map<String, dynamic> json)
      : this.testStartedTimestamp = json['startAtTimestamp'],
        this.stepsCount = json['stepsCount'],
        this.currentStep = json['currentStep'],
        this.question = QuestionModel.fromJson(json["currentQuestion"]);
}

class QuestionModel {
  final int id;
  final TestKind kind;
  final String title;
  final String description;
  final String? codeSnippet;
  final InputModel inputModel;

  QuestionModel.fromJson(Map<String, dynamic> json)
      : this.kind = TestKind.values.byName(json['kind']),
        this.id = json['id'],
        this.title = json['title'],
        this.description = json['description'],
        this.codeSnippet = json['codeSnippet'],
        this.inputModel = InputModel.fromMap(
            json['inputModel'], TestKind.values.byName(json['kind']));
}

abstract class InputModel {
  const InputModel();

  factory InputModel.fromMap(Map<String, dynamic> map, TestKind kind) {
    switch (kind) {
      case TestKind.multiChoice:
        return ChoicesOutput.fromMap(map);
      case TestKind.singleChoice:
        return ChoicesOutput.fromMap(map);
      case TestKind.codeInput:
        return CodeOutput.fromMap(map);
      case TestKind.textInput:
        return TextOutput.fromMap(map);
    }
  }
}

class ChoicesOutput extends InputModel {
  final Map<String, String> choises;

  ChoicesOutput(this.choises);

  factory ChoicesOutput.fromMap(Map<String, dynamic> map) {
    Map<String, String> stringList =
        (map['variants'] as Map<dynamic, dynamic>).cast<String, String>();
    return ChoicesOutput(stringList);
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

  final int id;

  SingleChoiceAnswer(this.answer, this.id);

  Map<String, dynamic> toJson() =>
      { 'questionId': id, 'kind': 'singleChoice', 'outputModel': { 'variant': answer } };
}

class MultiChoiceAnswer {
  final List<String> answers;

  final int id;

  MultiChoiceAnswer(this.answers, this.id);

  Map<String, dynamic> toJson() =>
      { 'questionId': id, 'kind': 'multiChoice', 'outputModel': { 'variants': answers } };
}

class TextInputAnswer {
  final String answer;

  final int id;

  TextInputAnswer(this.answer, this.id);

  Map<String, dynamic> toJson() =>
      { 'questionId': id, 'kind': 'textInput', 'outputModel': { 'text': answer } };
}

class CodeInputAnswer {
  final String answer;

  final int id;

  CodeInputAnswer(this.answer, this.id);

  Map<String, dynamic> toJson() =>
      { 'questionId': id, 'kind': 'codeInput', 'outputModel': { 'code': answer } };
}
