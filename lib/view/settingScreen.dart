import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/scheduler.dart';
import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:jstock/widgets/dialogs/addProduct.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  ProfileData? employee;
  @override
  void initState() {
    super.initState();
  }

  Future<ProfileData?> _listProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    employee = ProfileData(
      employee_id: prefs.getInt('employeeid'),
      name: prefs.getString('name'),
      lastname: prefs.getString('lastname'),
      nickname: prefs.getString('nickname'),
      position: prefs.getString('position'),
    );
    final response = await http
        .get(Uri.parse('http://192.168.1.77:8080/profile/${employee!.employee_id}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as dynamic;
      // data['']
      // final data1 = response.body;
      // print("\n : ${data[1]['code']}");
      return data;
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  @override
  Widget build(BuildContext context) {
    //  employee = _listProfile();
    //  String searchtext = 'product.search_for_products'.tr();
    final provider_profile =
        Provider.of<ProfileProvider>(context, listen: false);
    ProfileData? _profile = provider_profile.getData();
    return Scaffold(
      backgroundColor: Colorconstants.blue195DD1,
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Navigator.pushNamed(context, '/home'),
              icon: Icon(Icons.arrow_back, color: Colorconstants.white),
            );
          },
        ),
        title: Text(
          'setting.setting',
          style: TextStyle(
            color: Colorconstants.white,
            fontSize: 20,
          ),
        ).tr(),
        backgroundColor: Colorconstants.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
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
            child: Row(
              children: [
                Text(
                  'darwer.logout',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 104, 94),
                    fontSize: 15,
                  ),
                ).tr(),
                SizedBox(
                  width: 10,
                ),
                // Image.asset('assets/images/logoblue.png'),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          // Padding(
          //     padding: EdgeInsets.only(left: 20, right: 10),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         // Text(
          //         //   "${_profile!.name}  ${_profile.lastname}",
          //         //   style: TextStyle(
          //         //     fontSize: 30,
          //         //     color: Colorconstants.white,
          //         //   ),
          //         // ),
          //         Text(
          //           "${_profile!.nickname}",
          //           style: TextStyle(
          //             fontSize: 30,
          //             color: Colorconstants.white,
          //           ),
          //         ),
          //       ],
          //     )),
          // SizedBox(
          //   height: 50,
          // ),
          Container(
            height: MediaQuery.of(context).size.height - 145,
            decoration: BoxDecoration(
                color: Colorconstants.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0))),
            child: ListView(
              primary: false,
              padding: EdgeInsets.only(left: 25, right: 20),
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 45),
                  child: Container(
                    height: MediaQuery.of(context).size.height - 300,
                    child: ListView(
                      children: [
                        MyRectangleButton(
                          text: "ข้อมูลส่วนตัว",
                          icon: Icons.account_circle_rounded,
                          onPressed: () {
                            _listProfile();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                print(provider_profile.getDataid());
                                return EditProfileDialog(
                                    data: employee);
                              },
                            );
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // MyRectangleButton(
                        //   text: "ข้อมูลส่วนตัว",
                        //   icon: Icons.account_circle_rounded,
                        //   onPressed: () => EditProfileDialog,
                        // ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      // drawer: DrawerWidget(),
    );
  }
}
