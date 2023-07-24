import 'package:flutter/material.dart';

class SingleSelectionWidget extends StatefulWidget {
  List<String> s = [];

  SingleSelectionWidget(this.s, Function onPressed);
  Function onPressed=(String){};
  @override
  State<SingleSelectionWidget> createState() => _SingleSelectionWidgetState();
}

class _SingleSelectionWidgetState extends State<SingleSelectionWidget> {
  //const SingleSelectionWidget({ Key? key }) : super(key: key);
  var _selectIndex;
  

  Iterable<Widget> get iWidgets sync* {
    for (String i in widget.s) {
      yield Padding(
        padding: const EdgeInsets.all(4.0),
        child: FilterChip(
          showCheckmark: true,
          label: Text(i),
          selected: _selectIndex == i,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                _selectIndex = i;
                widget.onPressed(i);
              } else {
              }
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Container(
          child: Column(
            children: <Widget>[
              Wrap(
                children: iWidgets.toList(),
              )
            ],
          ),
        );
      }
    );
  }
}
