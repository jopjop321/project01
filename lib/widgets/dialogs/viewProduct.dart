import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jstock/constants/firebase.dart';
import 'package:jstock/constants/imports.dart';
import 'package:jstock/widgets/dialogs/confirm.dart';
import 'package:jstock/widgets/dialogs/editProduct.dart';
import 'package:jstock/widgets/dialogs/manageProductStock.dart';
import 'package:jstock/widgets/dialogs/sellProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewProductDialog extends StatefulWidget {
  Map<String, dynamic> data;

  ViewProductDialog({super.key, required this.data});

  @override
  State<ViewProductDialog> createState() => _ViewProductDialogState();
}

class _ViewProductDialogState extends State<ViewProductDialog> {
  List<String> options = [
    'view.sell'.tr(),
    'view.add'.tr(),
    'view.edit'.tr(),
    'view.delete'.tr()
  ];
  Future<void> _deleteProduct() async {
    try {
      // final db = FirebaseFirestore.instance;
      // await db.collection('products').doc(widget.data['code']).delete();

      final response =
          await http.delete(Uri.parse('http://192.168.1.77:8080/products/${widget.data['code']}'));
      if (response.statusCode == 200) {
        if (widget.data['image'] != null) {
        final storage = FirebaseStorage.instance.ref();
        final image = storage
            .child('${FirebaseConfig.storageImagePath}/${widget.data['code']}');
        await image.delete();
      }
        print('ลบข้อมูลสำเร็จ');
      } else {
        print('เกิดข้อผิดพลาดในการลบข้อมูล: ${response.statusCode}');
      }
      
    } on Error catch (e) {
      print(e);
    }
  }

  void _onAction(String? action) {
    BuildContext widgetContext = context;
    switch (action) {
      case 'Edit':
        showDialog(
          context: context,
          builder: (context) {
            return EditProductDialog(data: widget.data);
          },
        );
        break;
      case 'Delete':
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              title: 'Confirm Delete Product',
              description:
                  'Are you sure you want to delete product "${widget.data['code']}"?',
              onConfirm: () async {
                await _deleteProduct();

                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  widgetContext,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              },
            );
          },
        );
        break;
      case 'Sell':
        showDialog(
          context: context,
          builder: (context) {
            return SellProductDialog(data: widget.data);
          },
        );
        break;
      case 'Add':
        showDialog(
          context: context,
          builder: (context) {
            return ManageProductStockDialog(data: widget.data);
          },
        );
        break;
      case 'แก้ไข':
        showDialog(
          context: context,
          builder: (context) {
            return EditProductDialog(data: widget.data);
          },
        );
        break;
      case 'ลบ':
        showDialog(
          context: context,
          builder: (context) {
            return ConfirmDialog(
              title: 'ยืนยันจะลบสินค้า',
              description:
                  'คุณแน่ใจหรือไม่ว่าต้องการลบสินค้า "${widget.data['code']}"?',
              onConfirm: () async {
                await _deleteProduct();

                // ignore: use_build_context_synchronously
                Navigator.pushReplacement(
                  widgetContext,
                  MaterialPageRoute(
                    builder: (context) => const ProductScreen(),
                  ),
                );
              },
            );
          },
        );
        break;
      case 'ขาย':
        showDialog(
          context: context,
          builder: (context) {
            return SellProductDialog(data: widget.data);
          },
        );
        break;
      case 'เพิ่ม':
        showDialog(
          context: context,
          builder: (context) {
            return ManageProductStockDialog(data: widget.data);
          },
        );
        break;
    }
  }

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
        height: screenHeight - 300,
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  child: FittedBox(
                    child: Text(
                      widget.data['name'],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blue195DD1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(8.0),
                      hint: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'view.action',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ).tr(),
                      ),
                      items: options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: TextStyle(
                              color: option == 'view.delete'.tr()
                                  ? Colors.red
                                  : Colors.black,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: _onAction,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Text(
              widget.data['code'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 110, // กำหนดความกว้างของ Container
              height: 110, // กำหนดความสูงของ Container
              child: widget.data['image'] != null
                  ? Image.network(
                      widget.data['image'], // ตำแหน่งไฟล์รูปภาพ
                      fit: BoxFit
                          .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                    )
                  : Image.asset(
                      'assets/images/logoblue.png', // ตำแหน่งไฟล์รูปภาพ
                      fit: BoxFit
                          .cover, // การปรับขนาดรูปภาพให้พอดีกับขนาดของ Container
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.data['description'] ?? '',
              style: const TextStyle(
                color: Colorconstants.graytext75,
              ),
              maxLines: 8,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            const SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              height: 50,
              width: 150,
              decoration: BoxDecoration(
                  color: Colorconstants.grayD9,
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                "${widget.data['amount'] ?? 0}",
                style: const TextStyle(
                  color: Colorconstants.blacktext37465A,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("add_product.cost_price").tr(),
                const Spacer(),
                Text("${widget.data['cost_price'] ?? 0}฿")
              ],
            ),
            Row(
              children: [
                const Text("add_product.price").tr(),
                const Spacer(),
                Text("${widget.data['normal_price'] ?? 0}฿")
              ],
            ),
            Row(
              children: [
                const Text("add_product.member_price").tr(),
                const Spacer(),
                Text("${widget.data['member_price'] ?? 0}฿")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
