import 'package:flutter_test/flutter_test.dart';

class UserModel {
  UserModel(
      {required this.name,
      required this.location,
      required this.testName,
      required this.testingDate});

  final String name;
  final String location;
  final String testName;
  final String testingDate;
}

class SkillsModel {
  SkillsModel({required this.skills, required this.totalScore});

  final int totalScore;
  final List<SkillModel> skills;
}

class SkillModel {
  SkillModel(
      {required this.title,
      required this.score,
      required this.companyAverage,
      required this.industryAverage});

  final String title;
  final int score;
  final int companyAverage;
  final int industryAverage;
}

class TestSummaryScreenArguments {
  final UserModel userModel;
  final SkillsModel skillsModel;

  TestSummaryScreenArguments(this.userModel, this.skillsModel);
}
