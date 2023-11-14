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

class EditProductDialog extends StatefulWidget {
  final Map<String, dynamic> data;

  EditProductDialog({super.key, required this.data});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  // final TextEditingController _memberPriceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _lowstockController = TextEditingController();

  File? _imageFile;
  String? _imageName;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = widget.data['name'];
      _codeController.text = widget.data['code'];
      _descController.text = widget.data['description'];
      _costPriceController.text = (widget.data['cost_price'] ?? 0).toString();
      _normalPriceController.text =
          (widget.data['price'] ?? 0).toString();
      // _memberPriceController.text =
      //     (widget.data['member_price'] ?? 0).toString();
      _amountController.text = (widget.data['amount'] ?? 0).toString();
      _lowstockController.text = (widget.data['low_stock'] ?? 0).toString();
    });
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        var url = Uri.parse('http://192.168.1.77:8080/product/edit');
        final db = FirebaseFirestore.instance;

        Map<String, dynamic> data = {
          'id' : widget.data['id'],
          'name': _nameController.text,
          'code': _codeController.text,
          'description': _descController.text,
          'cost_price': Parser.toInt(_costPriceController.text),
          'price': Parser.toInt(_normalPriceController.text),
          'image': widget.data['image'],
          'low_stock' : Parser.toInt(_lowstockController.text),
        };

        if (_imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref();

          final uploadFile = await storageRef
              .child('products/${_codeController.text}')
              .putFile(_imageFile!);

          final downloadUrl = await uploadFile.ref.getDownloadURL();
          data['image'] = downloadUrl;
        }

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

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _imageName = image.name;
          _imageFile = File(image.path);
        });
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
                        text: "edit_product.product_name".tr(),
                        controller: _nameController,
                      ),
                      FormProduct(
                        text: "edit_product.product_code".tr(),
                        disabled: true,
                        controller: _codeController,
                      ),
                      FormProduct(
                        text: "edit_product.description".tr(),
                        maxLines: 5,
                        controller: _descController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Text(
                    'edit_product.image',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ).tr(),
                  const SizedBox(width: 20),
                  SizedBox(
                    height: 30,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: _pickImage,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.attach_file,
                            color: Colors.white,
                            size: 15,
                          ),
                          SizedBox(width: 4),
                          Text('Upload', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ]),
                if (_imageName != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _imageName!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _imageName = null;
                              _imageFile = null;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FormProduct(
                  text: "edit_product.cost_price".tr(),
                  inputType: TextInputType.number,
                  controller: _costPriceController,
                ),
                FormProduct(
                  text: "edit_product.normal_price".tr(),
                  inputType: TextInputType.number,
                  controller: _normalPriceController,
                ),
                // FormProduct(
                //   text: "edit_product.member_price".tr(),
                //   inputType: TextInputType.number,
                //   controller: _memberPriceController,
                // ),
                // FormProduct(
                //   text: "edit_product.amount".tr(),
                //   inputType: TextInputType.number,
                //   controller: _amountController,
                // ),
                FormProduct(
                  text: "add_product.lowstock".tr(),
                  inputType: TextInputType.number,
                  controller: _lowstockController,
                ),
                const SizedBox(height: 10),
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
