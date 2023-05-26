import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:jstock/constants/text.dart';

class MyButton extends StatelessWidget {
  final Color color;
  final Widget? child;
  final Function? onPressed;
  final double? width;
  final double? height;
  final Color shadowColor;
  final AlignmentGeometry alignment;
  final bool fullWidth;
  final EdgeInsetsGeometry padding;
  final BoxShadow? boxShadow;
  final double borderRadius;
  final bool disabled;

  const MyButton({
    this.color = Colorconstants.orange,
    this.child,
    this.onPressed,
    this.width,
    this.height,
    this.shadowColor = Colorconstants.buttonShadow,
    this.alignment = Alignment.center,
    this.fullWidth = true,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.boxShadow,
    this.borderRadius = 10,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      height: height ?? 47,
      decoration: BoxDecoration(boxShadow: [
        boxShadow! ??
            BoxShadow(
              offset: Offset(0, 3),
              color: shadowColor,
              blurRadius: 20,
            )
      ]),
      child: TextButton(
        onPressed: (!disabled ? onPressed : null) as void Function()?,
        child: Align(
          alignment: alignment,
          child: child,
        ),
        style: ButtonStyle(
          padding: MaterialStateProperty.all(padding),
          backgroundColor: !disabled
              ? MaterialStateProperty.all(color)
              : MaterialStateProperty.all(Colorconstants.gray),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      ),
    );
  }
}

class MyDefaultButton extends StatelessWidget {
  final Function? onPressed;
  final String text;
  final bool disabled;

  MyDefaultButton(
    this.text, {
    this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return MyButton(
      onPressed: !disabled ? onPressed : () {},
      child: MyText(
        text,
        fontWeight: FontWeight.w500,
        color: Colorconstants.white,
      ),
    );
  }
}