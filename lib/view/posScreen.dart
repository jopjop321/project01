import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jstock/constants/imports.dart';
import 'package:jstock/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  _PosScreenState createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final List<Product> _products = [];

  Future<List<Product>> _listProducts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/products'));
    if (response.statusCode == 200) {
      final data2 = json.decode(response.body);
      if (_products.isEmpty) {
        for (var product in data2) {
          Product datalist = Product(
            id: product['id'],
            code: product['code'],
            costPrice: product['cost_price'],
            name: product['name'],
            price: product['price'],
            image : product['image'],
            amount: product['amount'],
            quantity:0
            // sell: product['sell'],
          );
          _products.add(datalist);
        }
      }
      // setState(() {
      // });
      // print(_products);
      return _products;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<void> _showNotifincation(int index, String title, String body) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('nextflow_noti_001', "แจ้งเตือนทั่วไป",
            channelDescription: "ก็แจ้งเตือน",
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platfromChannelDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        index, title, body, platfromChannelDetails);
  }
  
  Future<void> _submit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? employeeid = prefs.getInt('employeeid');
    int index = 1;
    try {
      final db = FirebaseFirestore.instance;
      var url = Uri.parse('http://192.168.1.77:8080//product/sell/${employeeid}');
      // List<Map<String, dynamic>> data =
      //     _products.where((e) => e.quantity > 0).map((product) {
      //   return {
      //     'amount': product.quantity,
      //     'buy_price': product.price,
      //     'code': product.code,
      //     'cost_price': product.costPrice,
      //     'date': Timestamp.now(),
      //     'isMember': false,
      //     'name': product.name,
      //     'total_price': product.quantity * product.price,
      //   };
      // }).toList();

      // for (var item in data) {
      //   await db.collection('sells').add(item);
      // }
      for (var i = 0; i < _products.length; i++) {
        Map<String, dynamic> data = {
          'code': _products[i].code,
          'name': _products[i].name,
          'cost_price': _products[i].costPrice,
          'buy_price': _products[i].price,
          'sell': _products[i].quantity,
          'amount': _products[i].amount,
          'ismember': false,
        };
        var response = await http.put(url, body: json.encode(data));
        if (_products[i].quantity >= 1) {
          String nameProduct = _products[i].name;
          int amountProduct = _products[i].amount - _products[i].quantity;
          if (amountProduct == 0) {
            _showNotifincation(index++, "สินค้าหมดแล้ว",
                " $nameProduct อย่าลืมสั่งสินค้าเพิ่มด้วย");
          } else if (amountProduct <= 10) {
            _showNotifincation(index++, "สินค้ากำลังจะหมด",
                " $nameProduct เหลือแค่ $amountProduct ชิ้น");
          }
        }
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
  List<dynamic> _searchResults = [];
  TextEditingController _searchController = TextEditingController();
  void _performSearch(String value) async {
    List<dynamic> products = await _listProducts();
    setState(() {
      _searchResults = products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    String searchKeyword = ''; // ตัวแปรสำหรับเก็บคำค้นหา
    return Scaffold(
      backgroundColor: Colorconstants.transparent,
      // appBar: AppBarWidget(),
      // drawer: DrawerWidget(),
      body: Column(
        children: [
          // TextField(
          //   controller: _searchController,
          //   decoration: const InputDecoration(
          //     hintText: "Search for product",
          //   ),
          //   onChanged: _performSearch,
          // ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _listProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // กรองรายการสินค้าตามคำค้นหา
                  List<dynamic> products = snapshot.data!;
                  List<dynamic> displayedProducts =
                      _searchResults.isNotEmpty ? _searchResults : products;
                  return ListView.builder(
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(displayedProducts[index].name),
                        subtitle: Text(
                            '฿${displayedProducts[index].price.toStringAsFixed(2)}\n${'amount'.tr()}: ${displayedProducts[index].amount} '),
                        trailing: QuantitySelector(
                          onChanged: (value) {
                            setState(() {
                              displayedProducts[index].quantity = value;
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
          ),
        ],
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
          title: Text('list').tr(),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                Text(
                    '${'total_price'.tr()}: ${totalAmount.toStringAsFixed(2)}฿'),
                Image.network(
                    'https://promptpay.io/0633134308/${totalAmount.toStringAsFixed(2)}'),
                // Image.asset(
                //   'assets/images/qrcode.png',
                //   fit: BoxFit.contain,
                // ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // ดำเนินการที่ต้องการเมื่อกดปุ่มปิดใบเสร็จ
                Navigator.pop(context);
              },
              child: const Text('cancel').tr(),
            ),
            TextButton(
              onPressed: _submit,
              child: const Text('confirm').tr(),
            ),
          ],
        );
      },
    );
  }
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
