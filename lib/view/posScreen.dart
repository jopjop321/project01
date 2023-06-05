import 'package:flutter/material.dart';
import 'package:jstock/constants/imports.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final List<Product> _products = [];

  Future<List<Product>> _listProducts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('products').get();

    if (_products.isEmpty) {
      for (var product in snapshot.docs) {
        Map<String, dynamic> data = product.data();
        _products.add(
          Product(
            code: data['code'],
            costPrice: data['cost_price'],
            name: data['name'],
            price: data['normal_price'],
            amount: data['amount'],
          ),
        );
      }
    }

    return _products;
  }

  Future<void> _submit() async {
    try {
      final db = FirebaseFirestore.instance;
      

      List<Map<String, dynamic>> data =
          _products.where((e) => e.quantity > 0).map((product) {
        return {
          'amount': product.quantity,
          'buy_price': product.price,
          'code': product.code,
          'cost_price': product.costPrice,
          'date': Timestamp.now(),
          'isMember': false,
          'name': product.name,
          'total_price': product.quantity * product.price,
        };
      }).toList();

      

      for (var item in data) {
        await db.collection('sells').add(item);
      }
      for (var i = 0; i < _products.length; i++) {
        await db.collection('products').doc(_products[i].code).update({
          'amount':_products[i].amount - _products[i].quantity,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          'Sell Product Successfully',
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
          builder: (context) => const DashboardScreen(),
        ),
      );
    } on Error catch (e) {
      print(e);
    }
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
                      Text('฿${_products[index].price.toStringAsFixed(2)}\nจำนวน ${_products[index].amount} ชิ้น'),
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
        child: const Icon(Icons.check),
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
          title: const Text('รายการ'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Text('Items:'),
                for (var product in _products)
                  if (product.quantity > 0)
                    Row(
                      children: [
                        Text(
                          '${product.name}',
                          overflow: TextOverflow.clip,
                        ),
                        Spacer(),
                        Text(
                          '${(product.price * product.quantity).toStringAsFixed(2)}฿',
                        ),
                      ],
                    ),

                const SizedBox(height: 16),
                Text('รวม: ${totalAmount.toStringAsFixed(2)}฿'),
                Image.asset(
                      'assets/images/qrcode.png',
                      fit: BoxFit.contain,
                    ),
                
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // ดำเนินการที่ต้องการเมื่อกดปุ่มปิดใบเสร็จ
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: _submit,
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}

class Product {
  final String code;
  final double costPrice;
  final String name;
  final double price;
  final int amount;
  int quantity;

  Product({
    this.quantity = 0,
    required this.name,
    required this.price,
    required this.code,
    required this.costPrice,
    required this.amount,
  });
}

class QuantitySelector extends StatefulWidget {
  final ValueChanged<int> onChanged;

  const QuantitySelector({super.key, required this.onChanged});

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
          icon: const Icon(Icons.remove),
        ),
        Text(quantity.toString()),
        IconButton(
          onPressed: () {
            setState(() {
              quantity++;
              widget.onChanged(quantity);
            });
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
