import 'package:flutter/material.dart';
import 'package:jstock/constants/imports.dart';

class PosScreen extends StatefulWidget {
  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _listProducts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('products').get();
    return snapshot.docs;
  }
  List<Product> products = [
    Product(name: 'Product 1', price: 10.0),
    Product(name: 'Product 2', price: 15.0),
    Product(name: 'Product 3', price: 20.0),
    _buildProducts();
  ];

  List<Product> _buildProducts(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    List<Product> list = [];

    for (var product in data) {
      list.add(
        Product(name: product.data()['name'], price: product.data()['normal_price']),
      );
    }

    return list;
  }

  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidget(),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(products[index].name),
            subtitle: Text('\$${products[index].price.toStringAsFixed(2)}'),
            trailing: QuantitySelector(
              // quantity: products[index].quantity,
              onChanged: (value) {
                setState(() {
                  products[index].quantity = value;
                  calculateTotalAmount();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ดำเนินการที่ต้องการเมื่อกดปุ่มสรุปรายการสินค้า
          showReceiptDialog();
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void calculateTotalAmount() {
    double amount = 0.0;
    for (var product in products) {
      amount += product.price * product.quantity;
    }
    setState(() {
      totalAmount = amount;
    });
  }

  void showReceiptDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Receipt'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Items:'),
              for (var product in products)
                if (product.quantity > 0)
                  Text(
                    '${product.name}: ${product.quantity} x \$${product.price.toStringAsFixed(2)} = \$${(product.price * product.quantity).toStringAsFixed(2)}',
                  ),
              SizedBox(height: 16),
              Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // ดำเนินการที่ต้องการเมื่อกดปุ่มปิดใบเสร็จ
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class Product {
  final String name;
  final double price;
  int quantity;

  Product({required this.name, required this.price, this.quantity = 0});
}

class QuantitySelector extends StatefulWidget {
  final ValueChanged<int> onChanged;

  QuantitySelector({required this.onChanged});

  @override
  _QuantitySelectorState createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (quantity > 0) {
                quantity--;
                widget.onChanged(quantity);
              }
            });
          },
          icon: Icon(Icons.remove),
        ),
        Text(quantity.toString()),
        IconButton(
          onPressed: () {
            setState(() {
              quantity++;
              widget.onChanged(quantity);
            });
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
