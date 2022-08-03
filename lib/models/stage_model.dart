import 'dart:io';

import 'package:tests/models/test-model.dart';

enum StageKind { start, test, finish }

class StageModel {
  final StageKind kind;
  final Stage stage;

  StageModel.fromJson(Map<String, dynamic> json)
      : kind = StageKind.values.byName(json['kind']),
        stage =
            Stage.fromMap(json["model"], StageKind.values.byName(json['kind']));
}

abstract class Stage {
  const Stage();

  factory Stage.fromMap(Map<String, dynamic> map, StageKind kind) {
    switch (kind) {
      case StageKind.start:
        return StartFinishStage.fromMap(map);
      case StageKind.finish:
        return StartFinishStage.fromMap(map);
      case StageKind.test:
        return TestModel.fromJson(map);
    }
  }
}

class StartFinishStage extends Stage {
  final String title;
  final String description;

  StartFinishStage.fromMap(Map<String, dynamic> map)
      : title = map["title"],
        description = map["description"];
}
