import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';

class MyText extends StatelessWidget {
  final String text;
  final String language;
  final bool enDefault;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final double? lineHeight;
  final TextDecoration? decoration;
  final TextAlign textAlign;
  final bool isInputLabel;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool static;
  final String? fontFamily;

  MyText(this.text,
      {this.language = 'th',
      this.enDefault = true,
      this.fontSize = 16,
      this.color = Colorconstants.black29,
      this.fontWeight = FontWeight.normal,
      this.lineHeight,
      this.decoration,
      this.textAlign = TextAlign.left,
      this.isInputLabel = false,
      this.overflow,
      this.maxLines,
      this.static = false,
      this.fontFamily});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        // fontFamily: fontFamily != null
        //     ? fontFamily
        //     : AppLanguage.getFont(
        //         enDefault: enDefault,
        //         static: static,
        //         language: language,
        //       ),
        fontSize: isInputLabel ? 14 : fontSize,
        color: isInputLabel ? Colorconstants.inputLabel : color,
        fontWeight: fontWeight,
        height: lineHeight,
        decoration: decoration,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textHeightBehavior: TextHeightBehavior(
        applyHeightToFirstAscent: false,
        applyHeightToLastDescent: false,
      ),
    );
  }
}