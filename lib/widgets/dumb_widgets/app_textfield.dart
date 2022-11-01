import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField(
      {Key? key,
      this.controller,
      this.Onchange,
      this.label,
      this.obscureText,
      this.keyboardType,
      this.prefix})
      : super(key: key);
  final Onchange;
  final label;
  final obscureText;
  final controller;
  final prefix;
  final keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 331.w,
      height: 56.h,
      child: TextField(
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            prefixIcon: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
            labelText: label,
            fillColor: Colors.transparent),
        onChanged: Onchange,
        controller: controller,
      ),
    );
  }
}
