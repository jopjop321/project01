import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormProduct extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final int maxLines;

  const FormProduct({
    this.maxLines = 1,
    required this.text,
    required this.controller,
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
            maxLines: maxLines,
            validator: MultiValidator(
              [RequiredValidator(errorText: "ใส่ ${text} ด้วย")],
            ),
            // keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              isDense: true,
              labelText: '',
              hintText: text,
              border: const OutlineInputBorder(),
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
