import 'package:jstock/constants/imports.dart';

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

  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
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
                        title: "Total Income",
                        titleunit: "Baht",
                        unit: snapshot.data!['totalIncome'],
                      ),
                      CustomContainer(
                        color: Colorconstants.blue195DD1,
                        title: "Monthly Income",
                        titleunit: "Baht",
                        unit: snapshot.data!['monthlyIncome'],
                      ),
                      CustomContainer(
                        color: Colorconstants.orangeFA7A1E,
                        title: "Total profit",
                        titleunit: "Baht",
                        unit: snapshot.data!['totalProfit'],
                      ),
                      CustomContainer(
                        color: Colorconstants.redE73134,
                        title: "Total Selling",
                        titleunit: "Item",
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
              'Latest History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colorconstants.texttitledashboard,
              ),
            ),
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
                        child: const TextTable(
                          text1: "Name",
                          text2: "Unit",
                          text3: "Amount",
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
