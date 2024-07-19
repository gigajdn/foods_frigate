import 'package:flutter/material.dart';
import 'package:foods_frigate/themes.dart';

class TextInput extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;

  final String? Function(String?) onValidation;
  final void Function(String?) onSaved;
  FocusNode? focusNode;

  TextInputType keyboardType;

  TextInput({
    Key? key,
    required this.label,
    required this.ctrl,
    required this.onValidation,
    required this.onSaved,
    this.focusNode,
    required this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.GRAY_n236,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.BLACK.withOpacity(.05),
                offset: Offset(0.0, 5.0),
                blurRadius: 20.0,
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
          child: TextFormField(
            controller: ctrl,
            validator: onValidation,
            onSaved: onSaved,
            focusNode: focusNode,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 18,
              color: AppColors.GRAY_n135,
            ),
            decoration: InputDecoration(
              hintText: label,
              // helperText: 'sdajksdhjkasd',
              hintStyle: TextStyle(
                fontSize: 18,
                color: AppColors.GRAY_n135,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
