import 'package:easy_localization/easy_localization.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  Signup signupdata = Signup();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
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
                    // Image.asset(
                    //   'assets/images/login.png',
                    //   fit: BoxFit.contain,
                    // ),
                    SizedBox(height: 16),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'signup.signup'.tr(),
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
                                'signup.name'.tr(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colorconstants.graytext75,
                                ),
                              ),
                            ],
                          ),
                          TextFormField(
                            validator: MultiValidator(
                                [RequiredValidator(errorText: "ใส่nameด้วย")]),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: 'signup.name'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            controller: _nameController,
                            onSaved: (String? name) {
                              signupdata.name = name;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                'signup.lastname'.tr(),
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
                              RequiredValidator(errorText: "ใส่lastnameด้วย")
                            ]),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: 'signup.lastname'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            controller: _lastnameController,
                            onSaved: (String? lastname) {
                              signupdata.lastname = lastname;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                'signup.nickname'.tr(),
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
                              RequiredValidator(errorText: "ใส่nicknameด้วย")
                            ]),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              labelText: '',
                              hintText: 'signup.nickname'.tr(),
                              border: OutlineInputBorder(),
                            ),
                            controller: _nicknameController,
                            onSaved: (String? nickname) {
                              signupdata.nickname = nickname;
                            },
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
                            controller: _usernameController,
                            onSaved: (String? email) {
                              signupdata.username = email;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                'signup.password'.tr(),
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
                              hintText: 'signup.password'.tr(),
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
                            controller: _passwordController,
                            onSaved: (String? password) {
                              signupdata.password = password;
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                'signup.password'.tr(),
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
                              hintText: 'signup.confirmpassword'.tr(),
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
                            controller: _cpasswordController,
                            onSaved: (String? confirmpassword) {
                              signupdata.confirmpassword = confirmpassword;
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
                                'signup.signup'.tr(),
                              ),
                              style: ElevatedButton.styleFrom(
                                  minimumSize: Size(360, 60)),
                              onPressed: () async {
                                try {
                                  if (_passwordController.text ==
                                      _cpasswordController.text && _passwordController.text != null) {
                                    var url = Uri.parse(
                                        'http://192.168.1.77:8080/register');
                                    Map<String, dynamic> data = {
                                      'name': _nameController.text,
                                      'last_name': _lastnameController.text,
                                      'nickname': _nicknameController.text,
                                      'id': _usernameController.text,
                                      'password': _passwordController.text,
                                    };
                                    print(data);
                                    var response = await http.post(url,
                                        body: json.encode(data));
                                    if (response.statusCode == 200) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: const Text(
                                          'Signup Successfully',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        backgroundColor: Colors.green[400],
                                      ));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        ),
                                      );
                                    } else {
                                      print(
                                          'POST request failed with status: ${response.statusCode}');
                                    } 
                                    }else{
                                      print(signupdata.username);
                                    
                                  }
                                } on Error catch (e) {
                                  // print(e.message);
                                  Fluttertoast.showToast(
                                      msg: "สมัครสมาชิกไม่สำเร็จ",
                                      gravity: ToastGravity.CENTER);
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
}
