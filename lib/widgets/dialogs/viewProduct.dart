import 'package:jstock/constants/imports.dart';
import 'package:jstock/widgets/dialogs/editProduct.dart';

class ViewProductDialog extends StatefulWidget {
  Map<String, dynamic> data;

  ViewProductDialog({super.key, required this.data});

  @override
  State<ViewProductDialog> createState() => _ViewProductDialogState();
}

class _ViewProductDialogState extends State<ViewProductDialog> {
  List<String> options = ['Sell', 'Add', 'Edit', 'Delete'];

  void _onAction(String? action) {
    switch (action) {
      case 'Edit':
        showDialog(
          context: context,
          builder: (context) {
            return EditProductDialog(data: widget.data);
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
                      hint: const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          'Action',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      items: options.map((String option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(
                            option,
                            style: TextStyle(
                              color: option == 'Delete'
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
              widget.data['desc'] ?? '',
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
                const Text("Cost"),
                const Spacer(),
                Text("${widget.data['cost_price'] ?? 0}฿")
              ],
            ),
            Row(
              children: [
                const Text("Price"),
                const Spacer(),
                Text("${widget.data['normal_price'] ?? 0}฿")
              ],
            ),
            Row(
              children: [
                const Text("Member"),
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
