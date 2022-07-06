import 'package:flutter/cupertino.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/single_choice_widget.dart';
import 'package:tests/widgets/test_screen_widget.dart';

class MultiChoiceWidget extends StatefulWidget {
  List<ChoiceModel> model;

  final Callback callback;

  MultiChoiceWidget(List<String> items, Callback callback)
      : this.model =
            items.map((element) => ChoiceModel(element, false)).toList(),
        this.callback = callback;

  @override
  State<StatefulWidget> createState() => _MultiChoiceWidgetState();

  void choiceSelected(int index) {
    var newModel = model.map((element) {
      final currentIndex = model.indexOf(element);
      if (currentIndex == index) {
        return ChoiceModel(element.title, !element.isSelected);
      } else {
        return element;
      }
    });
    callback(MultiChoiceAnswer(newModel.where((element) => element.isSelected).map((e) => e.title).toList()));
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
