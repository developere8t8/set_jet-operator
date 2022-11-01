import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/payment_widgets/payment.dart';
import 'package:get/get.dart';

import '../../views/subscription_success_screen/subscription_success_screen_view.dart';

class Yearly extends StatefulWidget {
  final bool buttonenable;
  const Yearly({Key? key, required this.buttonenable}) : super(key: key);

  @override
  State<Yearly> createState() => _YearlyState();
}

class _YearlyState extends State<Yearly> {
  bool enable = true;

  @override
  void initState() {
    super.initState();
    enable = widget.buttonenable;
  }

  @override
  Widget build(BuildContext context) {
    final paymentController = Get.put(PaymentController());
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    return Container(
      height: 800.h,
      width: 287.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: accentColor,
          width: 1,
        ),
        color: !isLight ? const Color(0xFF212D39) : const Color(0xFFE6F3FE),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('PREPAID PLAN',
              style:
                  GoogleFonts.rubik(fontSize: 24.sp, fontWeight: FontWeight.w500, color: accentColor)),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
            child: Container(
              height: 270.h,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: accentColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 9.0, right: 9.0),
                    child: Container(
                      height: 70.h,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
                      ),
                      child: Center(
                        child: Text('Add Fee Usage',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.rubik(
                                fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black)),
                      ),
                    ),
                  )),
                  Expanded(
                      child: Container(
                    height: 70.h,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                    ),
                    child: Center(
                      child: Text('4 Months Free',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                              fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black)),
                    ),
                  )),
                  Expanded(
                    child: SizedBox(
                      height: 20.h,
                    ),
                  ),
                  Expanded(
                    child: MaterialButton(
                      height: 55.h,
                      minWidth: 250.w,
                      color: accentColor,
                      textColor: Colors.white,
                      onPressed: enable
                          ? () async {
                              setState(() {
                                enable = false;
                              });
                              bool success =
                                  await paymentController.makePayment(amount: '3800', currency: 'USD');
                              if (success) {
                                User? user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  QuerySnapshot snapshot = await FirebaseFirestore.instance
                                      .collection('users')
                                      .where('id', isEqualTo: user.uid)
                                      .get();
                                  if (snapshot.docs.isNotEmpty) {
                                    UserData data = UserData.fromMap(
                                        snapshot.docs.first.data() as Map<String, dynamic>);

                                    final userdoc =
                                        FirebaseFirestore.instance.collection('users').doc(user.uid);
                                    final json = {
                                      'subscrp': true,
                                      'subscrp_date': DateTime.now(),
                                      'end_Date': DateTime.now().add(const Duration(days: 366)),
                                      'amount': 3800,
                                      'subscrp_type': 'yearly',
                                    };

                                    //update serives
                                    await FirebaseFirestore.instance
                                        .collection('charters')
                                        .where('opid', isEqualTo: user.uid)
                                        .get()
                                        .then((value) async {
                                      for (var result in value.docs) {
                                        final updateCharter = FirebaseFirestore.instance
                                            .collection('charters')
                                            .doc(result.id);
                                        updateCharter.update({'active': true});
                                      }
                                    });
                                    await userdoc.update(json);
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SubscriptionSuccessScreenView(plan: 'yearly')));
                                  } else {
                                    //
                                  }
                                }
                              } else {
                                setState(() {
                                  enable = true;
                                });
                              }
                            }
                          : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('\$3800/Year',
                              style: GoogleFonts.rubik(
                                  fontSize: 18.sp, fontWeight: FontWeight.w400, color: Colors.white)),
                          const SizedBox(
                            width: 20,
                          ),
                          Icon(
                            Icons.send,
                            color: !isLight ? Colors.black : Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text('\$250/Month',
                            style: GoogleFonts.rubik(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFFA7A7A7))),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
