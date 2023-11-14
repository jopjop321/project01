import 'package:easy_localization/easy_localization.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final provider_profile =
        Provider.of<ProfileProvider>(context, listen: false);
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 150,
                    ),
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
                            'login.loginb'.tr(),
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
                                'login.username'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colorconstants.graytext75,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "ใส่Usernameด้วย")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: "Username",
                              border: OutlineInputBorder(),
                            ),
                            onSaved: (String? email) {
                              profile.email = email;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                'login.password'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colorconstants.graytext75,
                                ),
                              )
                            ],
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "ใส่Passwordด้วย"),
                            ]),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: "Password",
                              border: OutlineInputBorder(),
                              // suffixIcon: IconButton(
                              //   icon: Icon(
                              //     _obscureText
                              //         ? Icons.visibility
                              //         : Icons.visibility_off,
                              //   ),
                              //   onPressed: () {
                              //     setState(() {
                              //       _obscureText = !_obscureText;
                              //     });
                              //   },
                              // ),
                            ),
                            onSaved: (String? password) {
                              profile.password = password;
                            },
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
                                'login.login'.tr(),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(360, 60)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    // await FirebaseAuth.instance
                                    //     .signInWithEmailAndPassword(
                                    //         email: profile.email!,
                                    //         password: profile.password!);
                                    var url = Uri.parse(
                                        'http://192.168.1.77:8080/login');
                                    Map<String, dynamic> data = {
                                      'id': profile.email,
                                      'password': profile.password,
                                    };
                                    var response = await http.post(url,
                                        body: json.encode(data));
                                    // print(
                                    //     "email:${profile.email} password:${profile.password}");
                                    // print(response.body);
                                    
                                    if (response.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                          'login Successfully',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor: Colors.green[400],
                                      ));
                                      final data2 = jsonDecode(response.body);
                                      // print(data2);
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setBool('isLoggedIn', true);
                                      await prefs.setInt('id', data2['employee_id']);
                                      await prefs.setString('position', data2['position']);
                                      await prefs.setString('name', data2['name']);
                                      await prefs.setString('lastname', data2['last_name']);
                                      await prefs.setString('nickname', data2['nickname']);
                                      print("${prefs.getInt('id')} ${prefs.getString('position')}");
                                      provider_profile.setData(
                                        ProfileData(
                                          employee_id: data2['employee_id'],
                                          name: data2['name'],
                                          lastname: data2['last_name'],
                                          nickname: data2['nickname'],
                                          position: data2['position'],
                                        ),
                                      );
                                      print(provider_profile.getDataid());
                                      formKey.currentState!.reset();
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ),
                                      );
                                      print('POST request successful');
                                      print('Response body: ${response.body}');
                                    } else {
                                      print(
                                          'POST request failed with status: ${response.statusCode}');
                                    }
                                  } on Error catch (e) {
                                    // print(e);
                                    Fluttertoast.showToast(
                                        msg: "เข้าสู่ระบบไม่สำเร็จ",
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUpScreen(),
                                ),
                              );
                            },
                            child: RichText(
                                text: TextSpan(
                                    text: 'login.not_amember'.tr(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colorconstants.graytext75,
                                    ),
                                    children: <TextSpan>[
                                  TextSpan(
                                    text: 'login.signup'.tr(),
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colorconstants.blue195DD1,
                                    ),
                                  )
                                ])),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
