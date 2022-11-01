import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

class CreditCardField extends StatelessWidget {
  const CreditCardField({
    Key? key,
    this.Onchange,
    this.label,
    this.icon,
    this.mask,
    this.separator,
  }) : super(key: key);
  final Onchange;
  final label;
  final icon;
  final mask;
  final separator;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 331.w,
      height: 56.h,
      child: TextFormField(
        inputFormatters: [
          MaskedTextInputFormatter(
            mask: mask,
            separator: separator,
          ),
        ],
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            filled: true,
            hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
            suffixIcon: icon == null ? null : Image.asset(icon),
            labelText: label,
            fillColor: Colors.transparent),
        onChanged: Onchange,
      ),
    );
  }
}
