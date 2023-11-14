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

class EditProfileDialog extends StatefulWidget {
  ProfileData? data;
  EditProfileDialog({
    super.key,
    required this.data
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final TextEditingController _employeeidController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _employeeidController.text = widget.data!.employee_id.toString();
      _nameController.text = widget.data!.name.toString();
      _lastnameController.text = widget.data!.lastname.toString();
      _nicknameController.text = widget.data!.nickname.toString();
      _positionController.text = widget.data!.position.toString();
    });
  }
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        var url = Uri.parse('http://192.168.1.77:8080/profile/updateprofile');
        final db = FirebaseFirestore.instance;

        Map<String, dynamic> data = {
          'employee_id' : widget.data!.employee_id,
          'name': _nameController.text,
          'last_name': _lastnameController.text,
          'nickname': _nicknameController.text,
        };


        var response = await http.put(url, body: json.encode(data));

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              'Updated Product Successfully',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            backgroundColor: Colors.green[400],
          ));

          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const Home(page_receive: "product",),
            ),
          );
          print('put request successful');
          print('Response body: ${response.body}');
        } else {
          print('put request failed with status: ${response.statusCode}');
        }
      } on Error catch (e) {
        print(e);
      }
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
          height: screenHeight - 300,
          width: screenWidth,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'edit_product.edit_product',
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      FormProduct(
                        text: "setting.id".tr(),
                        disabled: true,
                        controller: _employeeidController,
                      ),
                      FormProduct(
                        text: "setting.name".tr(),
                        controller: _nameController,
                      ),
                      FormProduct(
                        text: "setting.lastname".tr(),
                        // maxLines: 5,
                        controller: _lastnameController,
                      ),
                      FormProduct(
                        text: "setting.nickname".tr(),
                        // maxLines: 5,
                        controller: _nicknameController,
                      ),
                      FormProduct(
                        text: "setting.position".tr(),
                        disabled: true,
                        // maxLines: 5,
                        controller: _positionController,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.greenAccent[700],
                    ),
                    onPressed: _saveProduct,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
