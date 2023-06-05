import 'package:flutter/material.dart';
import 'package:jstock/constants/imports.dart';

class PosScreen extends StatefulWidget {
  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final List<Product> _products = [];

  Future<List<Product>> _listProducts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('products').get();

    for (var product in snapshot.docs) {
      _products.add(
        Product(
            name: product.data()['name'],
            price: product.data()['normal_price']),
      );
    }

    return _products;
  }

  double totalAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      drawer: DrawerWidget(),
      body: FutureBuilder<List<Product>>(
        future: _listProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_products[index].name),
                  subtitle:
                      Text('\$${_products[index].price.toStringAsFixed(2)}'),
                  trailing: QuantitySelector(
                    // quantity: _products[index].quantity,
                    onChanged: (value) {
                      setState(() {
                        _products[index].quantity = value;
                        calculateTotalAmount();
                      });
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
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
    for (var product in _products) {
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
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Items:'),
                for (var product in _products)
                  if (product.quantity > 0)
                    Text(
                      '${product.name}: ${product.quantity} x \$${product.price.toStringAsFixed(2)} = \$${(product.price * product.quantity).toStringAsFixed(2)}',
                    ),
                SizedBox(height: 16),
                Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
              ],
            ),
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
