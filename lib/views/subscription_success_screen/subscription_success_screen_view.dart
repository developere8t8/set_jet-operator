import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/payment_widgets/monthly.dart';
import 'package:set_jet/widgets/payment_widgets/yearly.dart';
import 'package:snack/snack.dart';
import 'package:stacked/stacked.dart';
import '../../models/usermodel.dart';
import '../home/home_view.dart';
import 'subscription_success_screen_view_model.dart';

class SubscriptionSuccessScreenView extends StatefulWidget {
  final String plan;
  const SubscriptionSuccessScreenView({Key? key, required this.plan}) : super(key: key);

  @override
  State<SubscriptionSuccessScreenView> createState() => _SubscriptionSuccessScreenViewState();
}

class _SubscriptionSuccessScreenViewState extends State<SubscriptionSuccessScreenView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SubscriptionSuccessScreenViewModel>.reactive(
      builder: (BuildContext context, SubscriptionSuccessScreenViewModel viewModel, Widget? _) {
        return Builder(builder: (context) {
          var theme = Theme.of(context);
          var isLight = theme.brightness == Brightness.light;
          return Scaffold(
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                title: SizedBox(
                  height: 50.h,
                  width: 50.w,
                  child: Image.asset(
                    'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                  ),
                ),
                centerTitle: true,
              ),
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/subscription_bg.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: Center(
                          child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 56.h,
                                    width: 56.h,
                                    decoration:
                                        BoxDecoration(color: accentColor, shape: BoxShape.circle),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text('You have\nsubscribed',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.rubik(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w400,
                                        color: !isLight ? Colors.white : Colors.black)),
                              ],
                            ),
                          ),
                        ],
                      )),
                    ),
                    Visibility(
                        visible: (widget.plan == 'monthly') ? true : false,
                        child: Container(
                          height: 400.h,
                          width: 287.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: !isLight ? Colors.white : Colors.black,
                              width: 1,
                            ),
                            color: !isLight ? Color(0xFF3A3A3A) : Color(0xFFE9E9E9),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('MONTHLY PLAN',
                                  style: GoogleFonts.rubik(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w500,
                                      color: !isLight ? Colors.white : Colors.black)),
                              SizedBox(
                                height: 20.h,
                              ),
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 30.0),
                                child: Container(
                                  height: 260.h,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: !isLight ? Colors.white : Colors.black,
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
                                            border: Border(
                                                bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                          ),
                                          child: Center(
                                            child: Text('Advertisement Included',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.rubik(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
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
                                          child: Text('1 Months Free',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.rubik(
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
                                        ),
                                      )),
                                      Expanded(
                                          child: SizedBox(
                                        height: 20.h,
                                      )),
                                      Expanded(
                                          child: MaterialButton(
                                              height: 55.h,
                                              minWidth: 250.w,
                                              color: accentColor,
                                              textColor: Colors.white,
                                              onPressed: () {},
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Text('\$375/Month',
                                                      style: GoogleFonts.rubik(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.w400,
                                                          color: Colors.white)),
                                                ],
                                              ))),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text('\$4500/Year',
                                                style: GoogleFonts.rubik(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xFFA7A7A7))),
                                          ],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              )),
                            ],
                          ),
                        )),
                    Visibility(
                        visible: (widget.plan == 'yearly') ? true : false,
                        child: Container(
                          height: 400.h,
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
                                  style: GoogleFonts.rubik(
                                      fontSize: 24.sp, fontWeight: FontWeight.w500, color: accentColor)),
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
                                            border: Border(
                                                bottom: BorderSide(color: Colors.grey, width: 0.5)),
                                          ),
                                          child: Center(
                                            child: Text('Add Fee Usage',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.rubik(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black)),
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
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black)),
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
                                          onPressed: () {},
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('\$3800/Year',
                                                  style: GoogleFonts.rubik(
                                                      fontSize: 18.sp,
                                                      fontWeight: FontWeight.w400,
                                                      color: Colors.white)),
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
                        )),
                    Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Row(
                            children: [
                              Expanded(flex: 2, child: Container()),
                              Expanded(
                                child: Container(),
                                flex: 2,
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 50.h,
                                  width: 20.w,
                                  child: MaterialButton(
                                    color: accentColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    onPressed: () {
                                      getUserData();
                                    },
                                    child: Text(
                                      "Done",
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white, //change your color here
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
              ));
        });
      },
      viewModelBuilder: () => SubscriptionSuccessScreenViewModel(),
    );
  }

  void getUserData() async {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

  //loading indicator bar
  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
  }
}
