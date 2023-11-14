import 'package:jstock/constants/imports.dart';
import 'package:jstock/widgets/common/cardcontainerdashboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:qrscan/qrscan.dart' as scanner ;

class Home extends StatefulWidget {
  final String? page_receive;
  const Home({super.key, this.page_receive});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final NavigationDrawerState state = NavigationDrawerState();
  bool isDrawerOpen = false;
  String? scanresult;
  String? storedData;
  List<Map<String, dynamic>>? listdata = [];
  int _pageindex = 2;
  Widget? _page;
  List<Widget>? screens;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      storedData = prefs.getString('position') ?? 'NoStatus';
    });
    super.initState();
    switch (widget.page_receive) {
      case 'product':
        _pageindex = 0;
        break;
      case 'nos':
        _pageindex = 3;
        break;
      case 'pos':
        _pageindex = 1;
        break;
    }

    screens = [
      ProductScreen(),
      PosnewScreen(),
      DashboardScreen(),
      NearyofstockScreen(),
      InfoScreen()
    ];
  }

  void toggleDrawer() {
    setState(
      () {
        isDrawerOpen = !isDrawerOpen;
      },
    );
  }

  List<Widget> myIcons = [
    Icon(Icons.trolley, size: 30, color: Colorconstants.white),
    Icon(Icons.add_shopping_cart, size: 30, color: Colorconstants.white),
    Icon(Icons.home, size: 30, color: Colorconstants.white),
    Icon(Icons.add_business_outlined, size: 30, color: Colorconstants.white),
    Icon(Icons.account_circle_rounded, size: 30, color: Colorconstants.white),
  ];

  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 229, 240, 250),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colorconstants.blue195DD1,
        color: Colorconstants.blue195DD1,
        animationDuration: Duration(milliseconds: 300),
        key: _bottomNavigationKey,
        items: myIcons,
        index: _pageindex,
        onTap: (index) {
          setState(() {
            _pageindex = index;
          });
        },
      ),
      appBar: AppBarWidget(),
      body: screens![_pageindex],
      drawer: DrawerWidget(),
    );
  }
}
