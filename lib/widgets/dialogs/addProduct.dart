// ignore_for_file: file_names

import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jstock/constants/firebase.dart';
import 'package:jstock/constants/imports.dart';

class AddProductDialog extends StatefulWidget {
  const AddProductDialog({super.key});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _normalPriceController = TextEditingController();
  final TextEditingController _memberPriceController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  File? _imageFile;
  String? _imageName;

  final _formKey = GlobalKey<FormState>();

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      try {
        final db = FirebaseFirestore.instance;

        Map<String, dynamic> data = {
          'name': _nameController.text,
          'code': _codeController.text,
          'desc': _descController.text,
          'cost_price': double.parse(_costPriceController.text),
          'normal_price': double.parse(_normalPriceController.text),
          'member_price': double.parse(_memberPriceController.text),
          'amount': int.parse(_amountController.text),
        };

        if (_imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref();

          final uploadFile = await storageRef
              .child(
                  '${FirebaseConfig.storageImagePath}/${_codeController.text}')
              .putFile(_imageFile!);

          final downloadUrl = await uploadFile.ref.getDownloadURL();
          data['image'] = downloadUrl;
        }

        await db.collection('products').doc(_codeController.text).set(data);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            'Created Product Successfully',
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
            builder: (context) => const ProductScreen(),
          ),
        );
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
                      'add_product.add_product',
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
                        text: "add_product.product_name".tr(),
                        controller: _nameController,
                      ),
                      FormProduct(
                        text: "add_product.product_code".tr(),
                        controller: _codeController,
                      ),
                      FormProduct(
                        text: "add_product.product_code".tr(),
                        maxLines: 5,
                        controller: _descController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Text(
                    'add_product.image',
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
                          Text('Upload', style: TextStyle(color: Colors.white) ,overflow: TextOverflow.ellipsis),
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
                  text: "add_product.cost_price".tr(),
                  inputType: TextInputType.number,
                  controller: _costPriceController,
                ),
                FormProduct(
                  text: "add_product.normal_price".tr(),
                  inputType: TextInputType.number,
                  controller: _normalPriceController,
                ),
                FormProduct(
                  text: "add_product.member_price".tr(),
                  inputType: TextInputType.number,
                  controller: _memberPriceController,
                ),
                FormProduct(
                  text: "add_product.amount".tr(),
                  inputType: TextInputType.number,
                  controller: _amountController,
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
                      "Save",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
