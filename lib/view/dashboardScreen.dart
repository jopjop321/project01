import 'package:jstock/constants/imports.dart';
import 'package:jstock/widgets/common/cardcontainerdashboard.dart';
import 'package:easy_localization/easy_localization.dart';


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

  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
  }

  Future<Map<String, dynamic>> _fetchData1() async {
    final db = FirebaseFirestore.instance;
    final products = await db.collection('products').get();

    if (listdata!.isEmpty) {
      for (var product in products.docs) {
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

  Future<Map<String, double>> _fetchData() async {
    final db = FirebaseFirestore.instance;
    final sells = await db.collection('sells').get();

    DateTime now = DateTime.now();
    DateTime currentMonth = DateTime(now.year, now.month, 1);
    DateTime endOfCurrentMonth = DateTime(now.year, now.month + 1, 0);

    final monthlySells = await db
        .collection('sells')
        .where(
          'date',
          isGreaterThanOrEqualTo: currentMonth,
          isLessThanOrEqualTo: endOfCurrentMonth,
        )
        .get();

    double totalIncome = 0;
    double totalProfit = 0;
    double totalSelling = 0;
    double monthlyIncome = 0;

    for (var sell in sells.docs) {
      double costPrice = sell['cost_price'];
      double buyPrice = sell['buy_price'];
      int amount = sell['amount'];

      totalIncome += buyPrice * amount;
      totalProfit += (buyPrice - costPrice) * amount;
      totalSelling += amount;
    }

    for (var sell in monthlySells.docs) {
      double buyPrice = sell['buy_price'];
      int amount = sell['amount'];

      monthlyIncome += buyPrice * amount;
    }

    return {
      'totalIncome': totalIncome,
      'monthlyIncome': monthlyIncome,
      'totalProfit': totalProfit,
      'totalSelling': totalSelling,
    };
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      _fetchLatestSells() async {
    final db = FirebaseFirestore.instance;
    final sells = await db
        .collection('sells')
        .orderBy(
          'date',
          descending: true,
        )
        .get();

    return sells.docs;
  }

  @override
  Widget build(BuildContext context) {
    final totalProvider = Provider.of<TotlaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          children: [
            const Text(
              'JStock',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colorconstants.texttitledashboard,
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
                future: _fetchData(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
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
                        title: "dashboardscreen.total_income",
                        titleunit: "dashboardscreen.baht".tr(),
                        unit: snapshot.data!['totalIncome'],
                      ),
                      CustomContainer(
                        color: Colorconstants.blue195DD1,
                        title: "dashboardscreen.monthly_income",
                        titleunit: "dashboardscreen.baht".tr(),
                        unit: snapshot.data!['monthlyIncome'],
                      ),
                      CustomContainer(
                        color: Colorconstants.orangeFA7A1E,
                        title: "dashboardscreen.total_profit",
                        titleunit: "dashboardscreen.baht".tr(),
                        unit: snapshot.data!['totalProfit'],
                      ),
                      CustomContainer(
                        color: Colorconstants.redE73134,
                        title: "dashboardscreen.total_selling",
                        titleunit: "dashboardscreen.item".tr(),
                        unit: snapshot.data!['totalSelling'],
                        intUnit: true,
                      ),
                    ],
                  );
                }),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'dashboardscreen.best_seller',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colorconstants.texttitledashboard,
              ),
            ).tr(),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder<Map<String, dynamic>>(
                future: _fetchData1(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
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
                      childAspectRatio: 153 / 185,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CardContainerdashboard(data: snapshot.data!['data1']),
                      CardContainerdashboard(data: snapshot.data!['data2']),
                    ],
                  );
                }),
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
            FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
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
                                Container(
                                  height: 30,
                                  alignment: Alignment.center,
                                  child: TextTable(
                                    text1: sell['name'],
                                    text2: '${sell['amount']}',
                                    text3: '${sell['total_price']}',
                                    color: Colorconstants.black,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }),
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
