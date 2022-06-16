import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tests/models/models.dart';

class TestScreenWidget extends StatefulWidget {
  const TestScreenWidget({Key? key, required this.skillsModel, required this.userModel}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final SkillsModel skillsModel;
  final UserModel userModel;

  @override
  State<TestScreenWidget> createState() => _TestScreenWidgetState();
}

class _TestScreenWidgetState extends State<TestScreenWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TestSummaryWidget(userModel: widget.userModel, skillsModel: widget.skillsModel)
        ],
      ),
    );
  }
}

class TestSummaryWidget extends StatelessWidget {
  const TestSummaryWidget({
    Key? key,
    required this.userModel,
    required this.skillsModel
  }) : super(key: key);

  final UserModel userModel;
  final SkillsModel skillsModel ;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 50, right: 50),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(userModel.name),
                   Text(userModel.location)
                 ],
               ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(userModel.testName),
                  Text(userModel.testingDate)
                ],
              )
            ],
          ),
          Divider(
            height: 30,
            thickness: 3,
            color: Colors.black12,
          ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 450,
                    child: Column(
                      children:
                        skillsModel.skills.map((skill) {
                          return SkillScore(name: skill.title, score: skill.score);
                        }).toList()
                    ),
                  ),
                  Container(
                    width: 400,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue,
                        width: 5
                      )
                    ),
                    child: Center(
                      child: Text("${skillsModel.totalScore} %"),
                    ),
                  )
                ],
              ),
        ],
      ),
    );
  }
}

class SkillScore extends StatelessWidget {
const SkillScore({
  Key? key,
  required this.name,
  required this.score
}) : super(key: key);

  final String name;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text("${score.toString()}/100%"),
                  )
                ],
              ),
            )
          ],
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 20,
            child: LinearProgressIndicator(
              value: score/100,
              color: this.makeColor(this.score),
              backgroundColor: Colors.grey,
            ),
          ),
        )
      ],
    );
  }

  Color makeColor(int score) {
  if (score < 20) {
    return Colors.red;
  } else if (score < 50) {
    return Colors.orange;
  } else if (score < 80) {
    return Colors.lightGreen;
  } else {
    return Colors.green;
  }
  }
}