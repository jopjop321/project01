import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final String title;
  final String titleunit;
  final double unit;

  const CustomContainer(
      {required this.color, required this.title, required this.titleunit, required this.unit});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colorconstants.white,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "(${titleunit})",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colorconstants.white,
                    ),
                  )
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${unit}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colorconstants.white,
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
