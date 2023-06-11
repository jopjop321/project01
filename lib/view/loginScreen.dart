import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';


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
                            'เข้าสู่ระบบ',
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
                                'อีเมล',
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
                              RequiredValidator(errorText: "กรุณาใส่อีเมล")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: "อีเมล",
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
                                'รหัสผ่าน',
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
                              RequiredValidator(errorText: "กรุณาใส่รหัสผ่าน"),
                            ]),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: "รหัสผ่าน",
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
                                "เข้าสู่ระบบ",
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(360, 60)),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try {
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                            email: profile.email!,
                                            password: profile.password!);

                                    print(
                                        "email:${profile.email} password:${profile.password}");
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool('isLoggedIn', true);
                                    formKey.currentState!.reset();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DashboardScreen(),
                                      ),
                                    );
                                  } on FirebaseAuthException catch (e) {
                                    // print(e.message);
                                    Fluttertoast.showToast(
                                        msg: e.message!,
                                        gravity: ToastGravity.CENTER);
                                  }
                                }
                              },
                            ),
                          ),
                          SizedBox(height: 30),
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
