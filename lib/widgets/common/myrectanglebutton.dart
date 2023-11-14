import 'package:flutter/material.dart';
import 'package:jstock/constants/imports.dart';

class MyRectangleButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final IconData? icon;
  const MyRectangleButton({this.text, this.onPressed, this.icon});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colorconstants.transparent,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              text!,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
