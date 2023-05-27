import 'package:jstock/constants/imports.dart';

class DrawerWidget extends StatelessWidget {
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
              children: const [
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Welcome,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home', style: TextStyle(fontSize: 18)),
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
            leading: const Icon(Icons.trolley),
            title: const Text('Product', style: TextStyle(fontSize: 18)),
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
            title: const Text('Add Product', style: TextStyle(fontSize: 18)),
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
          // ListTile(
          //   leading: const Icon(Icons.edit),
          //   title: const Text('Edit', style: TextStyle(fontSize: 18)),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // นำทางไปยังหน้า Settings
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.add_shopping_cart),
          //   title: const Text('Add Stock', style: TextStyle(fontSize: 18)),
          //   onTap: () {
          //     Navigator.pop(context);
          //     // นำทางไปยังหน้า Settings
          //   },
          // ),
          const Divider(color: Colors.grey),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout', style: TextStyle(fontSize: 18)),
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
        ],
      ),
    );
  }
}
