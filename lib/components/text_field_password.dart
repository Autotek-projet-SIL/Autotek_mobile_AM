import 'package:flutter/material.dart';

class TextFieldPassword extends StatelessWidget {
  final String? hintText;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final AutovalidateMode? validationMode;
    bool visibleMdp;
   TextFieldPassword({
    Key? key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.validator,
    this.validationMode,
    required this.visibleMdp
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: validationMode,
      validator: validator,
      obscureText: visibleMdp,
      onChanged: (value) {},
      cursorColor:const Color.fromRGBO(27, 146, 164, 1),
      decoration: InputDecoration(
        hintText: hintText,
        suffixIcon: IconButton(
          icon: Icon(Icons.visibility),
          color: Colors.black,
          onPressed: () {
            visibleMdp=!visibleMdp;
          },
        ),
        contentPadding: const EdgeInsets.all(14.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              width: 3, color: Color.fromRGBO(27, 146, 164, 1)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
