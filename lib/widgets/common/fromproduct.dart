import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormProduct extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType inputType;
  final int maxLines;
  final bool disabled;

  const FormProduct({
    this.maxLines = 1,
    required this.text,
    required this.controller,
    this.inputType = TextInputType.text,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colorconstants.graytext75,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            enabled: !disabled,
            keyboardType: inputType,
            maxLines: maxLines,
            validator: MultiValidator(
              [RequiredValidator(errorText: "ใส่ ${text} ด้วย")],
            ),
            // keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              isDense: true,
              hintText: text,
              hintStyle: const TextStyle(fontSize: 14),
              border: const OutlineInputBorder(),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0,
                ),
              ),
            ),
            // onSaved: onSaved,
            controller: controller,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
