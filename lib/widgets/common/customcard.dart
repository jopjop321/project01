import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:jstock/widgets/dialogs/viewProduct.dart';

class CardContainer extends StatelessWidget {
  final Map<String, dynamic> data;

  const CardContainer({
    required this.data,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return ViewProductDialog(
              data: data,
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
              SizedBox(
                width: 110, // กำหนดความกว้างของ Container
                height: 110, // กำหนดความสูงของ Container
                child: data['image'] != null
                    ? Image.network(
                        data['image'], // ตำแหน่งไฟล์รูปภาพ
                        fit: BoxFit
                            .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                      )
                    : Image.asset(
                        'assets/images/logoblue.png', // ตำแหน่งไฟล์รูปภาพ
                        fit: BoxFit
                            .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                      ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      data['name'],
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
                  const Icon(
                    Icons.edit,
                    color: Colorconstants.blacktext37465A,
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Container(
                height: 20,
                decoration: BoxDecoration(
                  color: Colorconstants.green009F3A,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Row(
                    children: [
                      const Text(
                        "Remaining",
                        style: TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "${data['amount'] ?? 0}",
                        style: const TextStyle(
                          color: Colorconstants.white,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  const Text("Price"),
                  const Spacer(),
                  Text("${data['normal_price'] ?? 0}฿")
                ],
              ),
              Row(
                children: [
                  const Text("Member"),
                  const Spacer(),
                  Text("${data['member_price'] ?? 0}฿")
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

