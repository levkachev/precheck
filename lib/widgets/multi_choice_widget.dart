import 'package:flutter/cupertino.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/single_choice_widget.dart';
import 'package:tests/widgets/test_screen_widget.dart';

class MultiChoiceWidget extends StatefulWidget {
  late List<ChoiceModel> model;
  late String id;
  late Callback callback;

  MultiChoiceWidget(Map<String, String> items, Callback callback, String id) {
    this.callback = callback;
    List<ChoiceModel> list = [];
    items.forEach((id, title) {
      list.add(ChoiceModel(title, id, false));
    });
    this.model = list;
    this.id = id;
  }

  @override
  State<StatefulWidget> createState() => _MultiChoiceWidgetState();

  void choiceSelected(int index) {
    var newModel = model.map((element) {
      final currentIndex = model.indexOf(element);
      if (currentIndex == index) {
        return ChoiceModel(element.title, element.id, !element.isSelected);
      } else {
        return element;
      }
    });
    callback(MultiChoiceAnswer(newModel.where((element) => element.isSelected).map((e) => e.id).toList(), id));
    model = newModel.toList();
  }
}

class _MultiChoiceWidgetState extends State<MultiChoiceWidget> {
  void choiceSelected(int index) {
    widget.choiceSelected(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            padding: EdgeInsets.only(top: 2),
            child: GestureDetector(
              onTap: () {
                choiceSelected(index);
              },
              child: ChoiceWidget(
                  widget.model[index].title, widget.model[index].isSelected),
            ),
          );
        },
        shrinkWrap: true,
        itemCount: widget.model.length,
      ),
    );
  }
}
