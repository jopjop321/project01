import 'package:flutter/scheduler.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jstock/widgets/dialogs/addProduct.dart';

class NearyofstockScreen extends StatefulWidget {
  final bool addProduct;

  const NearyofstockScreen({
    super.key,
    this.addProduct = false,
  });

  @override
  State<NearyofstockScreen> createState() => _NearyofstockScreenState();
}

class _NearyofstockScreenState extends State<NearyofstockScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final NavigationDrawerState state = NavigationDrawerState();
  bool isDrawerOpen = false;
  String? scanresult;
  TextEditingController _searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];
  List<Map<String, dynamic>>? listdata = [];

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

  Future<Map<String, dynamic>> _fetchData1() async {
    final db = FirebaseFirestore.instance;
    final products = await db.collection('products').get();

    if (listdata!.isEmpty) {
      for (var product in products.docs) {
        Map<String, dynamic> _datalist = {
          'name': product['name'],
          'sell': product['sell'],
          'image': product['image'],
          'amount': product['amount'],
        };
        // print(_datalist['name']);
        listdata!.add(_datalist);
        // print(listdata);
      }
    }

    // print(listdata);
    listdata!.sort(((a, b) => a['amount'].compareTo(b['amount'])));
    // print(listdata);

    return {'data1': listdata![0], 'data2': listdata![1]};
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _listProducts() async {
    final db = FirebaseFirestore.instance;
    final snapshot =
        await db.collection('products').where('amount', isLessThan: 10).get();
    return snapshot.docs;
  }

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
    List<QueryDocumentSnapshot<Map<String, dynamic>>> products =
        await _listProducts();
    setState(() {
      _searchResults = products.where((product) {
        final productName = product.data()['amount'];
        return productName.contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      'Neary Of Stock',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.texttitledashboard,
                      ),
                    ),
                    const Spacer(),
                    // ElevatedButton(
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colorconstants.blue195DD1,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(8),
                    //     ),
                    //   ),
                    //   onPressed: () {
                    //     showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) {
                    //         return const AddProductDialog();
                    //       },
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       Icon(Icons.add_circle_outline),
                    //       SizedBox(
                    //         width: 5,
                    //       ),
                    //       Text(
                    //         "   เพิ่มสินค้า     ",
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
                // const SizedBox(
                //   height: 20,
                // ),
                // TextField(
                //   controller: _searchController,
                //   decoration: const InputDecoration(
                //     hintText: 'ค้นหาสินค้า',
                //   ),
                //   onChanged: _performSearch,
                // ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                  future: _listProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          products = snapshot.data!;
                      List<QueryDocumentSnapshot<Map<String, dynamic>>>
                          displayedProducts = products;
                      return GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 153 / 185,
                        ),
                        itemCount: displayedProducts.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          // print(index);
                          // if (displayedProducts[index].data()['amount'] <10 ) {
                          return CardContainerdashboard(
                            typesell: false,
                            word: "amount :",
                            data: displayedProducts[index].data(),
                          );
                          // }
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