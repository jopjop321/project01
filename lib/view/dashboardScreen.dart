import 'package:jstock/constants/imports.dart';
import 'package:jstock/widgets/common/cardcontainerdashboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:qrscan/qrscan.dart' as scanner ;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NavigationDrawerState state = NavigationDrawerState();
  bool isDrawerOpen = false;
  String? scanresult;

  List<Map<String, dynamic>>? listdata = [];
  Map<String, dynamic>? dataip;
  String? storedData;
  @override
  void initState() {
    setState(() {
      SharedPreferences.getInstance().then((prefs) {
        storedData = prefs.getString('position') ?? 'NoStatus';
      });
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
  }

  Future<Map<String, dynamic>> _fetchData1() async {
    // final db = FirebaseFirestore.instance;
    // final products = await db.collection('products').get();
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/products'));
    if (listdata!.isEmpty) {
      for (var product in json.decode(response.body)) {
        Map<String, dynamic> _datalist = {
          'name': product['name'],
          'sell': product['sell'],
          'image': product['image']
        };
        // print(_datalist['name']);
        listdata!.add(_datalist);
        // print(listdata);
      }
    }

    // print(listdata);
    listdata!.sort(((a, b) => b['sell'].compareTo(a['sell'])));
    // print(listdata);

    return {'data1': listdata![0], 'data2': listdata![1]};
  }

  Future<Map<String, dynamic>> _fetchData() async {
    final db = FirebaseFirestore.instance;
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/profit/ip'));
    final sells = json.decode(response.body) as Map<String, dynamic>;
    dataip = sells;
    return dataip!;
  }

  Future<List<dynamic>> _fetchLatestSells() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/histony'));
    final sells = json.decode(response.body) as List<dynamic>;

    return sells;
  }

  Future<List<dynamic>> _fetchLatestprofit() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.77:8080/profit'));
    final profit = json.decode(response.body) as List<dynamic>;

    return profit;
  }

  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final totalProvider = Provider.of<TotlaProvider>(context);
    return Scaffold(
      backgroundColor: Colorconstants.transparent,
      extendBody: true,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          children: [
            Row(
              children: [
                const Text(
                  'JStock',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colorconstants.texttitledashboard,
                  ),
                ),
                Spacer(),
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
                      // pos.resetQuantity();
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
                                "dashboardscreen.open",
                              ).tr(),
                            ))
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Visibility(
                visible: storedData ==
                    'Owner', // เงื่อนไขที่กำหนดว่าต้องการให้แสดงหรือไม่
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    FutureBuilder<Map<String, dynamic>>(
                        future: _fetchData(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            // print(snapshot.data!['income_month']);
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 153 / 126,
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              CustomContainer(
                                color: Colorconstants.green009F3A,
                                title: "dashboardscreen.monthly_income",
                                // titleunit: "dashboardscreen.baht".tr(),
                                unit: (snapshot.data!['income_month'] as int)
                                    .toDouble(),
                              ),
                              CustomContainer(
                                color: Colorconstants.blue195DD1,
                                title: "dashboardscreen.yearly_income",
                                // titleunit: ,
                                unit: (snapshot.data!['income_year'] as int)
                                    .toDouble(),
                              ),
                              CustomContainer(
                                color: Colorconstants.orangeFA7A1E,
                                title: "dashboardscreen.monthly_profit",
                                // titleunit: "dashboardscreen.baht".tr(),
                                unit: (snapshot.data!['profit_month'] as int)
                                    .toDouble(),
                              ),
                              CustomContainer(
                                color: Colorconstants.redE73134,
                                title: "dashboardscreen.yearly_profit",
                                // titleunit: "dashboardscreen.baht".tr(),
                                unit: (snapshot.data!['profit_year'] as int)
                                    .toDouble(),
                                // intUnit: true,
                              ),
                            ],
                          );
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                )),

            // const Text(
            //   'dashboardscreen.best_seller',
            //   style: TextStyle(
            //     fontSize: 20,
            //     fontWeight: FontWeight.bold,
            //     color: Colorconstants.texttitledashboard,
            //   ),
            // ).tr(),
            // const SizedBox(
            //   height: 20,
            // ),
            // FutureBuilder<Map<String, dynamic>>(
            //     future: _fetchData1(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: CircularProgressIndicator(),
            //         );
            //       }
            //       return GridView(
            //         padding: EdgeInsets.zero,
            //         gridDelegate:
            //             const SliverGridDelegateWithFixedCrossAxisCount(
            //           crossAxisCount: 2,
            //           crossAxisSpacing: 10,
            //           mainAxisSpacing: 10,
            //           childAspectRatio: 153 / 185,
            //         ),
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         children: [
            //           CardContainerdashboard(data: snapshot.data!['data1']),
            //           CardContainerdashboard(data: snapshot.data!['data2']),
            //         ],
            //       );
            //     }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'dashboardscreen.latest_history',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colorconstants.texttitledashboard,
              ),
            ).tr(),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<List<dynamic>>(
                future: _fetchLatestSells(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        height: 50,
                        decoration: const BoxDecoration(
                          color: Colorconstants.blue195DD1,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: TextTable(
                          text1: "dashboardscreen.word_history.name".tr(),
                          text2: "dashboardscreen.word_history.unit".tr(),
                          text3: "dashboardscreen.word_history.amount".tr(),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          border: Border.all(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              for (var sell in snapshot.data!)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 4,
                                        child: Text(
                                          sell['name'],
                                          style: TextStyle(
                                              color: Colorconstants.black),
                                        )),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                          '${sell['amount']}',
                                          style: TextStyle(
                                              color: Colorconstants.black),
                                        )),
                                    Expanded(
                                        flex: 2,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${sell['price_total']}฿',
                                              style: TextStyle(
                                                  color: Colorconstants.black),
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                              // Container(
                              //   height: 30,
                              //   alignment: Alignment.center,
                              //   child: TextTable(
                              //     text1: sell['name'],
                              //     text2: '${sell['amount']}',
                              //     text3: '${sell['price_total']}',
                              //     color: Colorconstants.black,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
            Visibility(
                visible: storedData == 'Owner',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'dashboardscreen.profit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.texttitledashboard,
                      ),
                    ).tr(),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<dynamic>>(
                        future: _fetchLatestprofit(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                height: 50,
                                decoration: const BoxDecoration(
                                  color: Colorconstants.blue195DD1,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          "dashboardscreen.date".tr(),
                                          style: TextStyle(
                                              color: Colorconstants.white),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "dashboardscreen.profit".tr(),
                                            style: TextStyle(
                                                color: Colorconstants.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(20),
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (var sell in snapshot.data!)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Expanded(
                                                flex: 3,
                                                child: Text(
                                                  '${sell['date']}',
                                                  style: TextStyle(
                                                      color:
                                                          Colorconstants.black),
                                                )),
                                            Expanded(
                                                flex: 1,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${sell['profit']}฿',
                                                      style: TextStyle(
                                                          color: Colorconstants
                                                              .black),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                )),

            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
      drawer: DrawerWidget(),
    );
  }
}
