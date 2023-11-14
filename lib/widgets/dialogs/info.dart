// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jstock/constants/imports.dart';
import 'package:jstock/utils/parser.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoDialog extends StatefulWidget {
  final Map<String, dynamic> data;
  InfoDialog({super.key, required this.data});

  @override
  State<InfoDialog> createState() => _InfoDialogState();
}

class _InfoDialogState extends State<InfoDialog> {
  final _formKey = GlobalKey<FormState>();

  String? selectedValue;
  String? positionme;
  @override
  void initState() {
    selectedValue = widget.data['position'];
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  Future<void> _check() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    positionme = prefs.getString('position');
  }

  Future<void> _saveStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print(selectedValue);
    try {
      print("object");
      var url = Uri.parse('http://192.168.1.77:8080/profile/updatestatus');
      var urlo = Uri.parse(
          'http://192.168.1.77:8080/profile/ownerupdate/${widget.data['employee_id']}');
      final db = FirebaseFirestore.instance;
      var response;
      if (selectedValue == 'Owner') {
        response = await http.put(urlo);
        if (response.statusCode == 200) {
          prefs.setString('position', "Staff");
        }
      } else {
        Map<String, dynamic> data = {
          'employeeid': widget.data['employee_id'],
          'position': selectedValue,
        };
        response = await http.put(url, body: json.encode(data));
        if (response.statusCode == 200) {
          prefs.setString('position', selectedValue!);
        }
      }
      print(response.statusCode);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Update Status Successfully',
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
            builder: (context) => const Home(),
          ),
        );
        print('update status successful');
        print('Response body: ${response.body}');
      } else {
        print('POST request failed with status: ${response.statusCode}');
      }
    } on Error catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      // title: Text("D"),
      content: Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          height: screenHeight - 650,
          width: screenWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'info.update',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.black,
                      ),
                    ).tr(),
                    Text(
                      ' ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.black,
                      ),
                    ),
                    const Text(
                      'info.status',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colorconstants.blue195DD1,
                      ),
                    ).tr(),
                    const Spacer(),
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          backgroundColor: Colorconstants.white,
                          // primary: Colors.blue, // เปลี่ยนสีพื้นหลังของปุ่ม
                          // onPrimary: Colors.white, // เปลี่ยนสีข้อความภายในปุ่ม
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "cancel",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colorconstants.gray,
                          ),
                        ).tr(),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          'info.id',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colorconstants.black,
                          ),
                        ).tr(),
                        Text(
                          'info.name',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colorconstants.black,
                          ),
                        ).tr(),
                        Visibility(
                          visible: widget.data['position'] ==
                              'Owner', // เงื่อนไขที่กำหนดว่าต้องการให้แสดงหรือไม่
                          child: Text(
                            'info.position',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colorconstants.black,
                            ),
                          ).tr(), // วัตถุที่คุณต้องการแสดงหรือซ่อน
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(
                          "${widget.data['employee_id']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colorconstants.black,
                          ),
                        ),
                        Text(
                          "${widget.data['name']} ${widget.data['last_name']}",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: Colorconstants.black,
                          ),
                        ),
                        Visibility(
                          visible: widget.data['position'] ==
                              'Owner', // เงื่อนไขที่กำหนดว่าต้องการให้แสดงหรือไม่
                          child: Text(
                            'Owner',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colorconstants.black,
                            ),
                          ), // วัตถุที่คุณต้องการแสดงหรือซ่อน
                        ),
                      ],
                    ),
                  ),
                ]),
                Visibility(
                  visible: widget.data['position'] != 'Owner',
                  child: DropdownButton<String>(
                    value: selectedValue,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue!;
                      });
                    },
                    isExpanded: true,
                    items: <String>[
                      'NoStatus',
                      'Staff',
                      'backendstaff',
                      'Owner'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: widget.data['position'] != 'Owner',
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.greenAccent[700],
                      ),
                      onPressed: () {
                        _saveStatus();
                      },
                      child: const Text(
                        "edit_product.seve",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ).tr(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
