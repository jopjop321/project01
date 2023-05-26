import 'package:flutter/material.dart';
import 'package:jstock/widgets/common/customAlertDialog.dart';
import 'package:jstock/constants/colors.dart';

class CardContainer extends StatelessWidget {
  final String title;
  final int remaining;
  final double? price;
  final double? pricemember;
  final double? pricecost;
  final String? description;

  const CardContainer({
    required this.title,
    required this.remaining,
    this.description,
    this.price = 0,
    this.pricemember =0,
    this.pricecost = 0,
  });
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              title: title,
              code: "SK14785743",
              price: price,
              pricecost: pricecost,
              pricemember: pricemember,
              remaining: remaining,
              description: description,
            );
          },
        );
      },
      child: Container(
        height: 230,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colorconstants.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey, // สีของเงา
              offset: Offset(2, 2), // ตำแหน่งเงา (x, y)
              blurRadius: 5, // รัศมีของเงา
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Container(
                width: 110, // กำหนดความกว้างของ Container
                height: 110, // กำหนดความสูงของ Container
                child: Image.asset(
                  'assets/images/logoblue.png', // ตำแหน่งไฟล์รูปภาพ
                  fit: BoxFit
                      .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blacktext37465A,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Icon(Icons.edit,
                          color: Colorconstants.blacktext37465A)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colorconstants.green009F3A,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Row(
                    children: [
                      Text(
                        "Remaining",
                        style: TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${remaining}",
                        style: TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                children: [Text("Price"), Spacer(), Text("${price}฿")],
              ),
              Row(
                children: [Text("Member"), Spacer(), Text("${pricemember}฿")],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
