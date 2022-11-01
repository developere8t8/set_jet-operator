import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/common.dart';
import '../../../theme/dark.dart';
import '../../../theme/light.dart';

class TripTypeSelector extends StatelessWidget {
  const TripTypeSelector({
    Key? key,
    required this.isLight,
  }) : super(key: key);

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100.h,
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: isLight ? lightSecondary : darkSecondary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
                height: 100.h,
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/icons/oneway_selected.png",
                      ),
                    ),
                    const Text("One Way")
                  ],
                )),
          ),
          Expanded(
            child: Container(
                height: 100.h,
                margin: const EdgeInsets.all(2.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    // color: accentColor,
                    ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/icons/roundtrip${isLight ? "_light" : ""}.png",
                      ),
                    ),
                    Text(
                      "Round Trip",
                      style: GoogleFonts.rubik(
                        color: Color(0xFF707070),
                      ),
                    )
                  ],
                )),
          ),
          Expanded(
            child: Container(
                height: 100.h,
                margin: const EdgeInsets.all(2.0),
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    // color: accentColor,
                    ),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        "assets/icons/multileg.png",
                      ),
                    ),
                    Text(
                      "One Way",
                      style: GoogleFonts.rubik(
                        color: const Color(0xFF707070),
                      ),
                    )
                  ],
                )),
          )
        ],
      ),
    );
  }
}
