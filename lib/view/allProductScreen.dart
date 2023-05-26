import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

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
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final totalProvider = Provider.of<TotlaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          children: [
            Row(
              children: [
                Text(
                  'Product',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colorconstants.texttitledashboard,
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Add Product",
                      ),
                    ],
                  ),
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
                        return AlertDialog(
                          // title: Text("D"),
                          content: Padding(
                            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)),
                              height: screenHeight - 300,
                              width: screenWidth,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Add Product',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colorconstants.blue195DD1,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 80,
                                          height: 30,
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  side: BorderSide(
                                                      color: Colors.black,
                                                      width: 1.0),
                                                ),
                                                backgroundColor:
                                                    Colorconstants.white
                                                // primary: Colors.blue, // เปลี่ยนสีพื้นหลังของปุ่ม
                                                // onPrimary: Colors.white, // เปลี่ยนสีข้อความภายในปุ่ม
                                                ),
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text(
                                              "cancel",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colorconstants.gray),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    FormProduct(
                                      text: "Product Name",
                                      onSaved: (String? email) {
                                        profile.email = email;
                                      },
                                    ),
                                    FormProduct(
                                      text: "Product Code",
                                      onSaved: (String? email) {
                                        profile.email = email;
                                      },
                                    ),
                                    FormProduct(
                                      text: "Description",
                                      onSaved: (String? email) {
                                        profile.email = email;
                                      },
                                      height: 200,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            GridView(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 153 / 230,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                CardContainer(
                  title: "Speaker",
                  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus. Sed dignissim, metus nec fringilla accumsan, risus sem sollicitudin lacus, ut interdum tellus elit sed risus. Maecenas eget condimentum velit, sit amet feugiat lectus. Class aptent ",
                  remaining: 10,
                  price: 25000,
                  pricecost: 12000,
                  pricemember: 21000,
                ),
                CardContainer(
                  title: "Monthly",
                  remaining: 10,
                ),
                CardContainer(
                  title: "Total profit",
                  remaining: 10,
                ),
                CardContainer(
                  title: "TotalSelling",
                  remaining: 10,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
