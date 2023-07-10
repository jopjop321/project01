import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jstock/widgets/dialogs/addProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductScreen extends StatefulWidget {
  final bool addProduct;

  const ProductScreen({
    super.key,
    this.addProduct = false,
  });

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final NavigationDrawerState state = NavigationDrawerState();
  bool isDrawerOpen = false;
  String? scanresult;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<dynamic> _searchResults = [];

  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
  }

  @override
  void initState() {
    super.initState();
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

  Future<List<dynamic>>
      _listProducts() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      // final data1 = response.body;
      // print("\n : ${data[1]['code']}");
      return data;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Future<List<dynamic>> _getProducts() async {
    final response =
        await http.get(Uri.parse('http://localhost:8080/products'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

//   Future<void> fetchData() async {
//   final response = await http.get(Uri.parse('http://localhost:8080/products'));
//   if (response.statusCode == 200) {
//     final data = response.body;
//   } else {
//     print('Failed to fetch data');
//   }
//   return data;
// }

  List<Widget> _buildProducts(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    List<Widget> list = [];

    for (var product in data) {
      list.add(
        CardContainer(
          data: product.data(),
        ),
      );
    }

    return list;
  }

  void _performSearch(String value) async {
    List<dynamic> products =
        await _listProducts();
    setState(() {
      _searchResults = products.where((product) {
        final productName = product['name'].toString().toLowerCase();
        return productName.contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    //  String searchtext = 'product.search_for_products'.tr();
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'product.product',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.texttitledashboard,
                      ),
                    ).tr(),
                    const Spacer(),
                    Container(
                      width: 160,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colorconstants.blue195DD1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const AddProductDialog();
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1, child: Icon(Icons.add_circle_outline)),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                                flex: 5,
                                child: Center(
                                  child: Text(
                                    "add_product.add_product",
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
                FutureBuilder<
                    List<dynamic>>(
                  future: _listProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<dynamic>
                          products = snapshot.data!;
                      List<dynamic>
                          displayedProducts =
                          _searchResults.isNotEmpty ? _searchResults : products;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 153 / 235,
                        ),
                        itemCount: displayedProducts.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return CardContainer(
                            data: displayedProducts[index],
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
