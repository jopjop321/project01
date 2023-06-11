import 'package:jstock/constants/imports.dart';
import 'package:jstock/utils/parser.dart';

class ManageProductStockDialog extends StatefulWidget {
  Map<String, dynamic> data;

  ManageProductStockDialog({super.key, required this.data});

  @override
  State<ManageProductStockDialog> createState() =>
      _ManageProductStockDialogState();
}

class _ManageProductStockDialogState extends State<ManageProductStockDialog> {
  TextEditingController _stockController = TextEditingController();
  int _currentStock = 0;
  int _addcurrentStock = 0 ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _stockController.text = (0).toString();
      _currentStock = widget.data['amount'] ?? 0;
    });
  }

  void _increaseStock() {
    FocusScope.of(context).unfocus();
    _addcurrentStock++;
    _stockController.text = _addcurrentStock.toString();
  }

  void _decreaseStock() {
    FocusScope.of(context).unfocus();
    if (_addcurrentStock > 0) {
      _addcurrentStock--;
      _stockController.text = _addcurrentStock.toString();
    }
  }

  Future<void> _saveProduct() async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection('products').doc(widget.data['code']).update({
        'amount': _currentStock+_addcurrentStock,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Updated Stock Successfully',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        backgroundColor: Colors.green[400],
      ));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ProductScreen(),
        ),
      );
    } on Error catch (e) {
      print(e);
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
        width: screenWidth,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  'เพิ่มจำนวนสินค้า',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colorconstants.blue195DD1,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 80,
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          8.0,
                        ),
                        side: const BorderSide(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      backgroundColor: Colorconstants.white,
                      // primary: Colors.blue, // เปลี่ยนสีพื้นหลังของปุ่ม
                      // onPrimary: Colors.white, // เปลี่ยนสีข้อความภายในปุ่ม
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "ยกเลิก",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colorconstants.gray,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SizedBox(
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
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.data['name'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colorconstants.blue195DD1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: Text(
                widget.data['code'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'จำนวน',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _decreaseStock,
                        child: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: '',
                          ),
                          textAlign: TextAlign.center,
                          controller: _stockController,
                          onChanged: (String value) {
                            _addcurrentStock = Parser.toInt(value);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _increaseStock,
                        child: const Icon(
                          Icons.add_circle_outline,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.greenAccent[700],
                ),
                onPressed: _saveProduct,
                child: const Text(
                  "ยืนยัน",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
