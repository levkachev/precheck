import 'package:flutter/material.dart';
import 'package:tests/models/test-model.dart';
import 'package:tests/widgets/test_screen_widget.dart';

class SingleChoiceQuestionWidget extends StatefulWidget {
  List<ChoiceModel> model;

  final Callback callback;

  SingleChoiceQuestionWidget(List<String> items, Callback callback)
      : this.model = items.map((element) {
          return ChoiceModel(element, false);
        }).toList(),
        this.callback = callback;

  void choiceSelected(int index) {
    var newModel = model.map((element) {
      final currentIndex = model.indexOf(element);
      if (currentIndex == index) {
        callback(SingleChoiceAnswer(element.title));
        return ChoiceModel(element.title, true);
      } else {
        return ChoiceModel(element.title, false);
      }
    });
    model = newModel.toList();
  }

  @override
  _SingleChoiceQuestionWidgetState createState() =>
      _SingleChoiceQuestionWidgetState();
}

class _SingleChoiceQuestionWidgetState
    extends State<SingleChoiceQuestionWidget> {
  void selectVariant(int index) {
    widget.choiceSelected(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Container(
            height: 30,
            child: GestureDetector(
                onTap: () {
                  selectVariant(index);
                },
                child: ChoiceWidget(
                    widget.model[index].title, widget.model[index].isSelected)
            ),
          );
        },
        itemCount: widget.model.length,
      ),
    );
  }
}

class ChoiceWidget extends StatelessWidget {
  final String title;
  final bool isSelected;

  ChoiceWidget(this.title, this.isSelected);

  @override
  Widget build(BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          border: isSelected ? Border.all(color: Colors.black38, width: 1) : null,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: isSelected ? Colors.black12.withOpacity(0.05) : null,
        ),
        child: Row(
            children: [
              Icon(isSelected ? Icons.add_circle : Icons.add_circle_outline),
              SizedBox(width: 8),
              Expanded(child: Text(title))
            ],
          ),
      );
  }
}

class ChoiceModel {
  String title;
  bool isSelected;

  ChoiceModel(this.title, this.isSelected);
}
