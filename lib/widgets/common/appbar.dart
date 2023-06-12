import 'package:jstock/constants/imports.dart';
import 'package:jstock/main.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {

    

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(Icons.menu, color: Colorconstants.black),
          );
        },
      ),
      backgroundColor: Colorconstants.transparent,
      elevation: 0,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/nos');
          },
          child: Row(
            children: [
              Text(
                'JStock',
                style: TextStyle(
                  color: Colorconstants.blue195DD1,
                  fontSize: 15,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Image.asset('assets/images/logoblue.png'),
            ],
          ),

          // Icon(
          //   Icons.qr_code_scanner,
          //   color: Colors.black,
          // ),
        ),
      ],
    );
  }
}
