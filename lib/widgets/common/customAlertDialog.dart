import 'package:jstock/constants/imports.dart';

class CustomAlertDialog extends StatefulWidget {
  final String title;
  final String code;
  final double? price;
  final double? pricemember;
  final double? pricecost;
  final int remaining;
  final String? description;

  CustomAlertDialog({
    required this.title,
    required this.code,
    required this.remaining,
    this.description,
    this.price = 0,
    this.pricemember = 0,
    this.pricecost = 0,
  });

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    String selectedOption = 'Option 1';
    List<String> options = ['Option 1', 'Option 2', 'Option 3'];
    return AlertDialog(
      content: Padding(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          height: screenHeight - 300,
          width: screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colorconstants.blue195DD1,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          height: 30,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButton<String>(
                            borderRadius: BorderRadius.circular(8.0),
                            value: selectedOption,
                            items: options.map((String option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {

                              setState(() {
                                selectedOption = newValue!;
                              });
                            },
                          ),
                          // ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(8.0),
                          //         side: BorderSide(
                          //             color: Colors.black, width: 1.0),
                          //       ),
                          //       backgroundColor: Colorconstants.white
                          //       // primary: Colors.blue, // เปลี่ยนสีพื้นหลังของปุ่ม
                          //       // onPrimary: Colors.white, // เปลี่ยนสีข้อความภายในปุ่ม
                          //       ),
                          //   onPressed: () => Navigator.pop(context),
                          //   child: Text(
                          //     "cancel",
                          //     style: TextStyle(
                          //         fontSize: 12, color: Colorconstants.gray),
                          //   ),
                          // ),
                        )
                      ],
                    ),
                    Text(widget.code, style: TextStyle(fontSize: 18)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${widget.description}",
                  style: TextStyle(
                    color: Colorconstants.graytext75,
                  ),
                  maxLines: 8,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colorconstants.grayD9,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        "${widget.remaining}",
                        style: TextStyle(color: Colorconstants.blacktext37465A),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text("Cost"),
                        Spacer(),
                        Text("${widget.pricecost}฿")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Price"),
                        Spacer(),
                        Text("${widget.price}฿")
                      ],
                    ),
                    Row(
                      children: [
                        Text("Member"),
                        Spacer(),
                        Text("${widget.pricemember}฿")
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
