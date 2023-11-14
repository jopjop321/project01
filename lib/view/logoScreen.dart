import 'package:jstock/constants/imports.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LogoScreen extends StatelessWidget {
  // ProfileData? data2;
  @override
  Widget build(BuildContext context) {
    //  final provider_profile =
    //     Provider.of<ProfileProvider>(context, listen: false);
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      checkSavedLoginStatus().then((isLoggedIn) {
        // นำทางไปยังหน้าที่เหมาะสมตามสถานะการเข้าสู่ระบบ
        if (isLoggedIn) {
          // provider_profile.setData(data2!);         
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
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
  Future<bool> checkSavedLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  return isLoggedIn;
}

// Future<void> checkid() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   int id = prefs.getInt('id') ?? 0;
//   var response = await http.get(Uri.parse('http://192.168.1.77:8080/profile/${id}'));
//   if (response.statusCode == 200) {
//       final data = json.decode(response.body) as dynamic;
//       data2 = ProfileData(employee_id: data['employee_id'],name: data['name'],lastname: data['last_name'],nickname: data['nickname'],position: data['position']);
//       // return data2;
//     } else {
//       throw Exception('Failed to fetch products');
//     }
// }
}


