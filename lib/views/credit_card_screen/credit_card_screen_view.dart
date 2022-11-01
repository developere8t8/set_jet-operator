import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/dumb_widgets/app_textfield.dart';
import 'package:set_jet/widgets/dumb_widgets/credit_card_field.dart';
import 'package:stacked/stacked.dart';
import 'credit_card_screen_view_model.dart';

class CreditCardScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreditCardScreenViewModel>.reactive(
      builder: (BuildContext context, CreditCardScreenViewModel viewModel, Widget? _) {
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
              body: Center(
                  child: Column(
                children: [
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    flex: 12,
                    child: Center(
                        child: Column(children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: accentColor, width: 1.0),
                              bottom: BorderSide(color: accentColor, width: 1.0),
                            ),
                            color: !isLight ? Color(0xFF212D39) : Color(0xFFE6F3FE),
                          ),
                          child: Center(
                            child: Text(
                              'PREPAID PLAN',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: CreditCardField(
                                        label: 'Card Number',
                                        icon: 'assets/masterlogo.png',
                                        mask: 'xxxx-xxxx-xxxx-xxxx',
                                        separator: '-',
                                        Onchange: (email) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Expanded(
                                      child: CreditCardField(
                                        label: 'Exp. Date',
                                        mask: 'xx/xx',
                                        separator: '/',
                                        Onchange: (email) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Expanded(
                                      child: CreditCardField(
                                        label: 'CVV',
                                        mask: 'xxx',
                                        separator: '',
                                        Onchange: (email) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Expanded(
                                      child: CreditCardField(
                                        label: 'Name on Card',
                                        mask: 'xxxxxxxxxxxxxxxxxxxxxxxxxxxx',
                                        separator: '',
                                        Onchange: (email) {},
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Expanded(
                                      child: CreditCardField(
                                        label: 'ZIP Code',
                                        mask: 'xxxxxx',
                                        separator: '',
                                        Onchange: (email) {},
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 331.w,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Subscription',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: !isLight ? Colors.white : Colors.black,
                                                )),
                                            Text('\$ 3800',
                                                style: GoogleFonts.rubik(
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color: accentColor,
                                                ))
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ])),
                  ),
                  Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 2,
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
                              child: Container(),
                              flex: 2,
                            ),
                            Expanded(
                              flex: 2,
                              child: SizedBox(
                                height: 50.h,
                                width: 25.w,
                                child: MaterialButton(
                                  color: accentColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  onPressed: () {
                                    viewModel.navigateToViewSubscriptionSuccessScreen('monthly');
                                  },
                                  child: Text(
                                    "Pay",
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
              )));
        });
      },
      viewModelBuilder: () => CreditCardScreenViewModel(),
    );
  }
}
