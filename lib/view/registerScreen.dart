import 'package:flutter/material.dart';
import 'package:jstock/constants/colors.dart';
import 'package:jstock/widgets/common/button.dart';
import 'package:jstock/view/loginScreen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 150, 0, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(
              'assets/images/login.png',
              fit: BoxFit.contain,
            ),
            SizedBox(height: 16),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colorconstants.blue195DD1,
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colorconstants.graytext75,
                        ),
                      ),
                    ],
                  ),     
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  Row(
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colorconstants.graytext75,
                        ),
                      ),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 30),
                  // MyDefaultButton(
                  //   "login",
                  //   // onPressed: ,
                  // ),
                  Container(
                    alignment: Alignment.center,
                    // padding: EdgeInsets.all(32),
                    child: ElevatedButton(
                      child: Text(
                        "Login",
                      ),
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(360, 60)),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}