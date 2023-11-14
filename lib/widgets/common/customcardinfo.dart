import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:jstock/widgets/dialogs/viewProduct.dart';
import 'package:jstock/constants/imports.dart';

class CardContainerInfo extends StatelessWidget {
  final Map<String, dynamic> data;

  const CardContainerInfo({
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
     
    return InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.getString('position') == 'Owner'){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return InfoDialog(
              data: data,
            );
          },
        );
        }
      },
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colorconstants.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey, // สีของเงา
              offset: Offset(2, 2), // ตำแหน่งเงา (x, y)
              blurRadius: 5, // รัศมีของเงา
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                     '${data['name']} ${data['last_name']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blacktext37465A,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: Text(
                     '${data['position']}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blacktext37465A,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

