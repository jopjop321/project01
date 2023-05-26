import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Cart cart = Cart(); // เก็บสถานะรถเข็น

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รถเข็น'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final product = cart.items[index];

                return ListTile(
                  title: Text(product.name),
                  // แสดงรายละเอียดอื่นๆของสินค้า
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // ลบสินค้าออกจากรถเข็น
                      setState(() {
                        cart.removeFromCart(product);
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ราคารวม:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '${cart.getTotalPrice()} บาท',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // ดำเนินการชำระเงินหรือการส่งสินค้า
              cart.checkout();
              setState(() {
                cart = Cart(); // รีเซ็ตรถเข็นเป็นสถานะเริ่มต้นหลังจากชำระเงิน
              });
            },
            child: Text('ชำระเงิน'),
          ),
        ],
      ),
    );
  }
}

class Cart {
  List<Product> items = [];

  void addToCart(Product product) {
    items.add(product);
  }

  void removeFromCart(Product product) {
    items.remove(product);
  }

  int getTotalPrice() {
    int totalPrice = 0;
    for (var product in items) {
      totalPrice += product.price;
    }
    return totalPrice;
  }

  void checkout() {
    // ดำเนินการชำระเงินหรือส่งสินค้า
  }
}

class Product {
  String name;
  int price;

  Product({required this.name, required this.price});
}
