import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:set_jet/widgets/dumb_widgets/app_button.dart';
import 'package:set_jet/widgets/payment_widgets/monthly.dart';
import 'package:set_jet/widgets/payment_widgets/yearly.dart';
import 'package:snack/snack.dart';
import 'package:stacked/stacked.dart';
import 'subscription_screen_view_model.dart';

class SubscriptionScreenView extends StatefulWidget {
  @override
  State<SubscriptionScreenView> createState() => _SubscriptionScreenViewState();
}

class _SubscriptionScreenViewState extends State<SubscriptionScreenView> {
  @override
  Widget build(BuildContext context) {
    final CarouselController _controller = CarouselController();
    //final paymentController = Get.put(PaymentController());
    return ViewModelBuilder<SubscriptionScreenViewModel>.reactive(
      builder: (BuildContext context, SubscriptionScreenViewModel viewModel, Widget? _) {
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
              body: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
                      flex: 13,
                      child: Center(
                          child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AppButton(
                              text: 'SKIP',
                              textColor: !isLight ? Colors.white : const Color(0xFF0982F4),
                              color: !isLight ? const Color(0xFF7C7C7C) : const Color(0xFF9DCDFB),
                              onpressed: () {
                                getUserData();
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Expanded(
                          child: CarouselSlider(
                            items: const [
                              Yearly(buttonenable: true),
                              Monthly(
                                buttonenable: true,
                              ),
                            ],
                            carouselController: _controller,
                            options: CarouselOptions(
                                height: 430.h,
                                enableInfiniteScroll: false,
                                enlargeCenterPage: true,
                                reverse: false,
                                autoPlay: false,
                                aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  viewModel.pageChange(index);
                                }),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [1, 2].asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: accentColor.withOpacity(
                                        viewModel.currentPageNotifier.value == entry.key ? 0.9 : 0.4)),
                              ),
                            );
                          }).toList(),
                        ),
                      ])),
                    ),
                    Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: MaterialButton(
                                      elevation: 0,
                                      color: !isLight ? Color(0xFF242424) : Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios,
                                            color: !isLight ? Colors.white : Colors.black,
                                          ),
                                          Text(
                                            'Back',
                                            style: GoogleFonts.rubik(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isLight
                                                  ? Colors.white
                                                  : Colors.black, //change your color here
                                            ),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      })),
                              Expanded(
                                flex: 2,
                                child: Container(),
                              ),
                            ],
                          ),
                        ))
                  ],
                )),
              ));
        });
      },
      viewModelBuilder: () => SubscriptionScreenViewModel(),
    );
  }

  void getUserData() async {
    loadingBar('loading ... please wait', true, 3);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeView()));
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
