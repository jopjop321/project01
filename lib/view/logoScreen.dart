import 'package:jstock/constants/imports.dart';

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      checkSavedLoginStatus().then((isLoggedIn) {
        // นำทางไปยังหน้าที่เหมาะสมตามสถานะการเข้าสู่ระบบ
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      });

      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(int.parse('0xFF195DD1')),
              Color(int.parse('0xFF0F387D')),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 50.0, right: 50.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: Image.asset('assets/images/logo.png'),
                ),
              ),
            ),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                'JSTOCK',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => LoginScreen()),
            //     );
            //   },
            //   child: Text('Get started'),
            // ),
          ],
        ),
      ),
    );
  }
}


Future<bool> checkSavedLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}
