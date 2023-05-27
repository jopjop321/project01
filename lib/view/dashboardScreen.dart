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

  @override
  Widget build(BuildContext context) {
    final totalProvider = Provider.of<TotlaProvider>(context);
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          scrollDirection: Axis.vertical,
          children: [
            Text(
              'JStock',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colorconstants.texttitledashboard,
              ),
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
                childAspectRatio: 153 / 126,
              ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              children: [
                CustomContainer(
                  color: Colorconstants.green009F3A,
                  title: "Total Income",
                  titleunit: "Baht",
                  unit: totalProvider.total.totalIncome!,
                ),
                CustomContainer(
                  color: Colorconstants.blue195DD1,
                  title: "Monthly Income",
                  titleunit: "Baht",
                  unit: totalProvider.total.monthlyIncome!,
                ),
                CustomContainer(
                  color: Colorconstants.orangeFA7A1E,
                  title: "Total profit",
                  titleunit: "Baht",
                  unit: totalProvider.total.totalprofit!,
                ),
                CustomContainer(
                  color: Colorconstants.redE73134,
                  title: "Total Selling",
                  titleunit: "item",
                  unit: totalProvider.total.totalSelling!.toDouble(),
                ),
              ],
            ),
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
            Column(
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
                    // border: Border.all(
                    //   color: Colors.black,
                    //   width: 1.0,
                    // ),
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
                        for (int i = 0; i < 100; i++)
                          Container(
                            height: 30,
                            alignment: Alignment.center,
                            child: TextTable(
                              text1: "Name $i",
                              text2: "Unit $i",
                              text3: "Amount $i",
                              color: Colorconstants.black,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
