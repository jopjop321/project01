import 'package:jstock/constants/imports.dart';
import 'package:jstock/view/posScreen.dart';
import 'package:easy_localization/easy_localization.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

List languageCode = ["en", "th"];
List countryCode = ["US", "TH"];

class _DrawerWidgetState extends State<DrawerWidget> {
  Widget _buildLanguageOption(
      String languageName, String langCode, String countryCode) {
    return InkWell(
      onTap: () {
        EasyLocalization.of(context)!.setLocale(Locale(langCode, countryCode));
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          languageName,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
  
  Future<String> readData(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(key)!;
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colorconstants.blue195DD1,
              image: DecorationImage(
                image: AssetImage('assets/images/drawer_header_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'darwer.menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ).tr(),
                SizedBox(height: 8),
                Text(
                  'darwer.welcome',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ).tr(),
                SizedBox(height: 8),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text('darwer.home', style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_shopping_cart),
            title: const Text('darwer.pos', style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PosScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_business_outlined),
            title: const Text('darwer.nos', style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushNamed(context, '/nos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.trolley),
            title: const Text('darwer.product', style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_sharp),
            title: const Text('darwer.add_product',
                style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(
                    addProduct: true,
                  ),
                ),
              );
              // Navigator.pop(context);
              // นำทางไปยังหน้า Settings
            },
          ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.account_circle_outlined),
            title: const Text('darwer.profile', style: TextStyle(fontSize: 18)).tr(),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductScreen(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('darwer.logout', style: TextStyle(fontSize: 18)).tr(),
            onTap: () async {
              try {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                FirebaseAuth.instance.signOut().then(
                  (value) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoScreen(),
                      ),
                    );
                  },
                );
              } on FirebaseAuthException catch (e) {
                // print(e.message);
                Fluttertoast.showToast(
                  msg: e.message!,
                  gravity: ToastGravity.CENTER,
                );
              }
            },
          ),
          // Spacer(),
          ListTile(
            // leading: const Icon(Icons.add_sharp),
            title: const Text('TH/EN', style: TextStyle(fontSize: 18)),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('darwer.select_lnguage').tr(),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLanguageOption('English', 'en', 'US'),
                        _buildLanguageOption('ภาษาไทย', 'th', 'TH'),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
