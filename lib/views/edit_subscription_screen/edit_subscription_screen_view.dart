import 'package:flutter/material.dart';
import 'package:flutter_screenutil/src/size_extension.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/widgets/dumb_widgets/app_button.dart';
import 'package:set_jet/widgets/smart_widgets/custom_theme_switch.dart';
import 'package:stacked/stacked.dart';
import 'edit_subscription_screen_view_model.dart';

class EditSubscriptionScreenView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditSubscriptionScreenViewModel>.reactive(
      builder: (BuildContext context, EditSubscriptionScreenViewModel viewModel,
          Widget? _) {
        var scaffoldKey = GlobalKey<ScaffoldState>();
        return Builder(builder: (context) {
          var theme = Theme.of(context);
          var isLight = theme.brightness == Brightness.light;
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: MaterialButton(
                child: Image.asset(
                    'assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
              ),
              automaticallyImplyLeading: false,
              title: SizedBox(
                height: 50.h,
                width: 150.w,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back_ios,
                            color: accentColor, size: 20),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Image.asset(
                      'assets/logo_${!isLight ? 'dark' : 'light'}.png',
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.125,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 70.h,
                                width: 70.w,
                                child: Image.asset(
                                  'assets/profile.png',
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'John Doe',
                                    style: GoogleFonts.rubik(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: !isLight
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5.h,
                                  ),
                                  GestureDetector(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.logout_outlined,
                                            size: 20,
                                            color: !isLight
                                                ? Color(0xFF7C7C7C)
                                                : Color(0xFFA7A7A7),
                                          ),
                                          Text(
                                            'Logout',
                                            style: GoogleFonts.rubik(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: !isLight
                                                  ? Color(0xFF7C7C7C)
                                                  : Color(0xFFA7A7A7),
                                            ),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        viewModel.navigateToViewLoginScreen();
                                      })
                                ],
                              ),
                            ],
                          ),
                          const CustomThemeSwitch(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 320.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: accentColor,
                          width: 1,
                        ),
                        color: !isLight ? Color(0xFF212D39) : Color(0xFFE6F3FE),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('PREPAID PLAN',
                              style: GoogleFonts.rubik(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor)),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              height: 240.h,
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
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 9.0, right: 9.0),
                                    child: Container(
                                      height: 70.h,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey,
                                                width: 0.5)),
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
                                  ),
                                  Container(
                                    height: 70.h,
                                    width: double.infinity,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey, width: 0.5),
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
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  MaterialButton(
                                    child: Text('\$3800/Year',
                                        style: GoogleFonts.rubik(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white)),
                                    height: 55.h,
                                    minWidth: 250.w,
                                    color: accentColor,
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Container(
                        width: 331.w,
                        height: 56.h,
                        child: AppButton(
                          color: accentColor,
                          textColor: Colors.white,
                          text: 'Change Plan',
                          onpressed: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: Container(
                        width: 331.w,
                        height: 56.h,
                        child: AppButton(
                          color:!isLight? Color(0xFF505050):Color(0xFFD3D3D3),
                          textColor: !isLight?Colors.white:Colors.black,
                          text: 'Cancel Plan',
                          onpressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
      viewModelBuilder: () => EditSubscriptionScreenViewModel(),
    );
  }
}
