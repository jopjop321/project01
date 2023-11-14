import 'package:easy_localization/easy_localization.dart';
import 'package:jstock/constants/imports.dart';
import 'package:jstock/main.dart';
import 'package:jstock/utils/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SellProductDialog extends StatefulWidget {
  Map<String, dynamic> data;
  

  SellProductDialog({
    super.key,
    required this.data,
    });

  @override
  State<SellProductDialog> createState() => _SellProductDialogState();
}

class _SellProductDialogState extends State<SellProductDialog> {
//   TextEditingController _amountController = TextEditingController(text: '1');
//   int _currentAmount = 1;
//   bool _isMember = false;
  

//   void _increaseStock() {
//     FocusScope.of(context).unfocus();
//     if (_currentAmount < widget.data!['amount']) {
//       _currentAmount++;
//       _amountController.text = _currentAmount.toString();
//     }
//   }

//   void _decreaseStock() {
//     FocusScope.of(context).unfocus();
//     if (_currentAmount > 1) {
//       _currentAmount--;
//       _amountController.text = _currentAmount.toString();
//     }
//   }
//   Future<void> _showNotifincation(String title,String body) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails('nextflow_noti_001', "แจ้งเตือนทั่วไป",
//         channelDescription: "ก็แจ้งเตือน",
//             importance: Importance.max,
//             priority: Priority.high,
//             ticker: 'ticker');
//     const NotificationDetails platfromChannelDetails = NotificationDetails(
//       android: androidNotificationDetails,
//     );

//     await flutterLocalNotificationsPlugin.show(0,title,body,platfromChannelDetails);
//   }

//   Future<void> _sellProduct() async {
//     if (_currentAmount >= 1 && _currentAmount <= widget.data!['amount']) {
//       try {
//         final db = FirebaseFirestore.instance;
//         var url = Uri.parse('http://192.168.1.77:8080/products/sell');

//         int price = _isMember
//             ? widget.data!['member_price']
//             : widget.data!['normal_price'];

//         Map<String, dynamic> data = {
//           'code': widget.data!['code'],
//           'name': widget.data!['name'],
//           'cost_price': widget.data!['cost_price'],
//           'buy_price': price,
//           'sell': _currentAmount,
//           'amount': widget.data!['amount'],
//           'ismember': _isMember,
//         };

//         var response = await http.put(url, body: json.encode(data));
//         if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: const Text(
//             'Sell Product Successfully',
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//           backgroundColor: Colors.green[400],
//         ));
        
//         String nameProduct = widget.data!['name'];
//         int amountProduct = widget.data!['amount']-_currentAmount;
//         if (amountProduct<=10) {
//           _showNotifincation("สินค้ากำลังจะหมด"," $nameProduct เหลือแค่ $amountProduct ชิ้น");
//         }
//         else if(amountProduct == 0) {
//           _showNotifincation("สินค้าหมดแล้ว"," $nameProduct อย่าลืมสั่งสินค้าเพิ่มด้วย");
//         }



//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const ProductScreen(),
//           ),
//         );
//         }
//         else {
//           print('POST request failed with status: ${response.statusCode}');
//         }
//       } on Error catch (e) {
//         print(e);
//       }
//     }
//   }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    
    return AlertDialog(
      content: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.data['id']),
//             Row(
//               children: [
//                 const Text(
//                   'sell.sell_product',
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colorconstants.blue195DD1,
//                   ),
//                 ).tr(),
//                 const Spacer(),
//                 SizedBox(
//                   width: 80,
//                   height: 30,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(
//                           8.0,
//                         ),
//                         side: const BorderSide(
//                           color: Colors.black,
//                           width: 1.0,
//                         ),
//                       ),
//                       backgroundColor: Colorconstants.white,
//                       // primary: Colors.blue, // เปลี่ยนสีพื้นหลังของปุ่ม
//                       // onPrimary: Colors.white, // เปลี่ยนสีข้อความภายในปุ่ม
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text(
//                       "cancel",
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colorconstants.gray,
//                       ),
//                     ).tr(),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(height: 10),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               child: SizedBox(
//                 width: 110, // กำหนดความกว้างของ Container
//                 height: 110, // กำหนดความสูงของ Container
//                 child: widget.data!['image'] != null
//                     ? Image.network(
//                         widget.data!['image'], // ตำแหน่งไฟล์รูปภาพ
//                         fit: BoxFit
//                             .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
//                       )
//                     : Image.asset(
//                         'assets/images/logoblue.png', // ตำแหน่งไฟล์รูปภาพ
//                         fit: BoxFit
//                             .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
//                       ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 widget.data!['name'],
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colorconstants.blue195DD1,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 widget.data!['code'],
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.grey,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 30),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'amount',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ).tr(),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 200,
//                   height: 40,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(
//                       color: Colors.grey,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: _decreaseStock,
//                         child: const Icon(
//                           Icons.remove_circle_outline,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: TextField(
//                           keyboardType: TextInputType.number,
//                           decoration: const InputDecoration(
//                             isDense: true,
//                             border: InputBorder.none,
//                             hintText: '',
//                           ),
//                           textAlign: TextAlign.center,
//                           controller: _amountController,
//                           onChanged: (String value) {
//                             _currentAmount = Parser.toInt(value);
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       GestureDetector(
//                         onTap: _increaseStock,
//                         child: const Icon(
//                           Icons.add_circle_outline,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//              SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'sell.membership',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ).tr(),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 150,
//                   height: 30,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   clipBehavior: Clip.hardEdge,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isMember = true;
//                             });
//                           },
//                           child: Container(
//                             alignment: Alignment.center,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             decoration: BoxDecoration(
//                               color: _isMember
//                                   ? const Color(0xFF009F3A)
//                                   : Colors.grey[300],
//                             ),
//                             child: Text(
//                               'sell.yes',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: _isMember ? Colors.white : Colors.grey,
//                               ),
//                             ).tr(),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               _isMember = false;
//                             });
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 8,
//                               vertical: 4,
//                             ),
//                             alignment: Alignment.center,
//                             decoration: BoxDecoration(
//                               color: !_isMember
//                                   ? const Color(0xFF009F3A)
//                                   : Colors.grey[300],
//                             ),
//                             child: Text(
//                               'sell.no',
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 color: !_isMember ? Colors.white : Colors.grey,
//                               ),
//                             ).tr(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 'sell.total',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.grey,
//                 ),
//               ).tr(),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: Text(
//                 '${_isMember ? widget.data!['member_price']*_currentAmount : widget.data!['normal_price']*_currentAmount}฿',
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF37465A),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             SizedBox(
//               width: double.infinity,
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.greenAccent[700],
//                 ),
//                 onPressed: _sellProduct,
//                 child: const Text(
//                   "confirm",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ).tr(),
//               ),
//             ),
          ],
        ),
      ),
    );
  }
}
