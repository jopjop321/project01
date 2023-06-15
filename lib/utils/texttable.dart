import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';

class TextTable extends StatefulWidget {
  final String? text1;
  final String? text2;
  final String? text3;
  final Color color;
  const TextTable({
    super.key,
    this.text1,
    this.text2,
    this.text3,
    this.color = Colorconstants.white,
  });

  @override
  State<TextTable> createState() => _TextTableState();
}

class _TextTableState extends State<TextTable> {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text("${widget.text1}", style: TextStyle(color: widget.color)),
      const Spacer(),
      const Spacer(),
      Text("${widget.text2}", style: TextStyle(color: widget.color)),
      const Spacer(),
      Text("${widget.text3}", style: TextStyle(color: widget.color))
    ]);
    ;
  }
}
