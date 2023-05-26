import 'package:jstock/constants/imports.dart';
import 'package:form_field_validator/form_field_validator.dart';

class FormProduct extends StatelessWidget {
  final String text;
  final Function(String?)? onSaved ;
  final double height;

  const FormProduct({
    this.height = 50,
    required this.text,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
      Profile profile = Profile();
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                text,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colorconstants.graytext75,
                ),
              ),
            ],
          ),
          Container(
            height: height,
            child: TextFormField(
              validator: MultiValidator(
                  [RequiredValidator(errorText: "ใส่${text}ด้วย")]),
              // keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: '',
                hintText: text,
                border: OutlineInputBorder(),
              ),
              onSaved: onSaved,
            ),
          ),
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
