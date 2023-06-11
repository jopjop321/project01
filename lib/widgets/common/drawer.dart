import 'package:jstock/constants/imports.dart';
import 'package:jstock/view/posScreen.dart';

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
                  'เมนู',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'ยินดีต้อนรับ,',
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
            title: const Text('หน้าแรก', style: TextStyle(fontSize: 18)),
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
            title: const Text('ขายสินค้า', style: TextStyle(fontSize: 18)),
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
            leading: const Icon(Icons.trolley),
            title: const Text('สินค้า', style: TextStyle(fontSize: 18)),
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
            title: const Text('เพิ่มสินค้า', style: TextStyle(fontSize: 18)),
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
            leading: const Icon(Icons.logout),
            title: const Text('ออกจากระบบ', style: TextStyle(fontSize: 18)),
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
