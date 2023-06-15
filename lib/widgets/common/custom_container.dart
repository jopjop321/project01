import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:intl/intl.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final String title;
  final String titleunit;
  final double unit;
  final bool intUnit;

  const CustomContainer({
    super.key,
    required this.color,
    required this.title,
    required this.titleunit,
    required this.unit,
    this.intUnit = false,
  });

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
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colorconstants.white,
                ),
              ).tr(),
              const SizedBox(height: 5),
              Text(
                "($titleunit)",
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colorconstants.white,
                ),
              ).tr(),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${unit == 0 ? 0 : !intUnit ? NumberFormat('#,###.0#').format(unit) : unit.toInt()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colorconstants.white,
                    ),
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
