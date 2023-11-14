import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jstock/widgets/dialogs/addProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PosnewScreen extends StatefulWidget {
  final bool addProduct;

  const PosnewScreen({
    super.key,
    this.addProduct = false,
  });

  @override
  State<PosnewScreen> createState() => _PosnewScreenState();
}

class _PosnewScreenState extends State<PosnewScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final NavigationDrawerState state = NavigationDrawerState();
  bool isDrawerOpen = false;
  String? scanresult;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> _searchResults = [];
  List<Product> _products = [];
  String? positionme;
  String? storedData;
  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
  }

  @override
  void initState() {
    setState(() {
      
    });
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      storedData = prefs.getString('position') ?? 'NoStatus';});
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.addProduct) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AddProductDialog();
          },
        );
      }
    });
  }

  Future<List<dynamic>> _listProducts() async {
    final pos = Provider.of<PosProvider>(context, listen: false);
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      if (_products.isEmpty) {
        for (var product in data) {
          Product datalist = Product(
              id: product['id'],
              code: product['code'],
              costPrice: product['cost_price'],
              name: product['name'],
              price: product['price'],
              image: product['image'],
              amount: product['amount'],
              quantity: 0
              // sell: product['sell'],
              );
          _products.add(datalist);
        }
      }
      
      // final data1 = response.body;
      // print("\n : ${data[1]['code']}");
      return data;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  // Future<List<dynamic>> _getProducts() async {
  //   final response =
  //       await http.get(Uri.parse('http://192.168.1.77:8080/products'));
  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body) as List<dynamic>;
  //     return data;
  //   } else {
  //     throw Exception('Failed to fetch products');
  //   }
  // }

  // List<Widget> _buildProducts(
  //     List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
  //   List<Widget> list = [];

  //   for (var product in data) {
  //     list.add(
  //       CardContainer(
  //         data: product.data(),
  //         positionme: ,
  //       ),
  //     );
  //   }

  //   return list;
  // }

  void _performSearch(String value) async {
    List<dynamic> products = await _listProducts();
    setState(() {
      _searchResults = products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(value.toLowerCase());
      }).toList();
    });
  }

  Future<void> _submit(List<Product> _data) async {
    final pos = Provider.of<PosProvider>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? employeeid = prefs.getInt('employeeid');
    int index = 1;
    // print(employeeid);
    try {
      // print(employeeid);
      final db = FirebaseFirestore.instance;
      var url =
          Uri.parse('http://192.168.1.77:8080/product/sell/${employeeid}');

      List<SellProduct> _data2 = [];
      for (var product in _data) {
        if (product.quantity > 0) {
          _data2.add(SellProduct(
              idproduct: product.id,
              amount: product.quantity,
              price_cost: product.costPrice,
              price: product.price));
        }
      }
      if (_data2 != null) {
        print(_data2.length);
      } else {
        print(null);
      }

      final List<Map<String, dynamic>> jsonList =
          _data2.map((product) => product.toJson()).toList();
      print(jsonList);
      var response = await http.post(url, body: json.encode(jsonList));

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

      pos.Setamount();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home(page_receive: "pos"),
        ),
      );
    } on Error catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? data;
    //  String searchtext = 'product.search_for_products'.tr();
    final pos = Provider.of<PosProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colorconstants.transparent,
      // appBar: AppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'pos.pos',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.texttitledashboard,
                      ),
                    ).tr(),
                    const Spacer(),
                    Container(
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colorconstants.blue195DD1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          pos.resetQuantity();
                          setState(() {});
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(
                                    "pos.reset",
                                  ).tr(),
                                ))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colorconstants.blue195DD1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          if (storedData == 'staff' ||storedData == 'Owner') {
                          calculateTotalAmount(pos.getalldata());
                          _showReceiptDialog(pos.getalldata());}
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(
                                    "view.sell",
                                  ).tr(),
                                ))
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: "Search for product",
                  ),
                  onChanged: _performSearch,
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<dynamic>>(
                  future: _listProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic> products = snapshot.data!;
                      List<dynamic> displayedProducts =
                          _searchResults.isNotEmpty ? _searchResults : products;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 153 / 225,
                        ),
                        itemCount: displayedProducts.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          // print(_products[index].quantity);
                          if (pos.check(_products[index])) {
                            pos.setData(_products[index]);
                          }
                          return CardContainerPos(
                            data: displayedProducts[index],
                            data3: pos.getData(index),
                            index: index,
                          );
                        },
                      );
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerWidget(),
    );
  }

  double totalAmount = 0.0;
  void calculateTotalAmount(List<Product> _data) {
    totalAmount = 0.0;
    double amount = 0.0;
    for (var product in _data) {
      amount += product.price * product.quantity;
    }
    setState(() {
      totalAmount = amount;
    });
  }

  void _showReceiptDialog(List<Product> _data) async {
    final pos = Provider.of<PosProvider>(context, listen: false);
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
                for (var product in _data)
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
                // pos.resetQuantity();
                Navigator.pop(context);
              },
              child: const Text('cancel').tr(),
            ),
            TextButton(
              onPressed: () {
                _submit(_data);
              },
              child: const Text('confirm').tr(),
            ),
          ],
        );
      },
    );
  }
}



// class NotesNotifier with ChangeNotifier {
//   Iterable<NoteModel> result = [];

//   void search(String value) {
//     Box<NoteModel> eventsBox = Hive.box<NoteModel>('notes');
//     result = eventsBox.values.where(
//       (e) => e.text.toLowerCase().contains(value.toLowerCase()),
//     );
//     notifyListeners();
//   }
// }
