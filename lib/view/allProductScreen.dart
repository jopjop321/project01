import 'package:flutter/scheduler.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jstock/widgets/dialogs/addProduct.dart';

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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _listProducts() async {
    final db = FirebaseFirestore.instance;
    final snapshot = await db.collection('products').get();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          children: [
            Row(
              children: [
                const Text(
                  'Product',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colorconstants.texttitledashboard,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
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
                    children: const [
                      Icon(Icons.add_circle_outline),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Add Product",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
              future: _listProducts(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 153 / 230,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    children: [
                      ..._buildProducts(snapshot.data!),
                    ],
                  );
                }

                return Container(
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
