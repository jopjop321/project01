import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';

class TextTable extends StatelessWidget {
  final String? text1;
  final String? text2;
  final String? text3;
  final Color color;

  const TextTable({this.text1, this.text2, this.text3,this.color = Colorconstants.white});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("    ${text1}", style: TextStyle(color: color)),
      Spacer(),
      Spacer(),
      Text("${text2}", style: TextStyle(color: color)),
      Spacer(),
      Text("${text3}    ", style: TextStyle(color: color))
    ]);
    ;
  }
}
