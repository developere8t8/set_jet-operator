import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/constants/drawer_enum.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../models/usermodel.dart';
import '../../widgets/dumb_widgets/search_param_selector.dart';
import 'search_results_view_model.dart';

class SearchResultsView extends StatelessWidget {
  UserData data = UserData(
      // this is demo class obj has to be removed
      contact: 'contact',
      endDate: Timestamp.fromDate(DateTime.now()),
      lastName: 'lastName',
      pic: 'pic',
      role: 'role',
      subDate: Timestamp.fromDate(DateTime.now()),
      subscrp: true,
      timeZone: 'timeZone',
      userID: 'userID',
      userName: 'userName',
      amount: 0,
      subscrpType: 'userName');
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchResultsViewModel>.reactive(
      builder: (BuildContext context, SearchResultsViewModel viewModel, Widget? _) {
        var isLight = Theme.of(context).brightness == Brightness.light;
        return Scaffold(
          backgroundColor: isLight ? Theme.of(context).scaffoldBackgroundColor : Colors.black,
          key: scaffoldKey,
          drawer: CustomBlurredDrawerWidget(
            drawerOption: DrawerOptions.SearchFlights,
            //imgUrl: '',
            unRead: 2,
            data: data,
          ),
          appBar: AppBar(
            elevation: 0,
            backgroundColor: accentColor,
            leading: MaterialButton(
              child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
              onPressed: () {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
            centerTitle: true,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    locator<NavigationService>().back();
                  },
                ),
                Text(
                  "KHPN",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Image.asset(
                  "assets/plane_dark.png",
                  height: 20.h,
                ),
                Text(
                  "KLAS",
                  style: GoogleFonts.rubik(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              )
            ],
          ),
          body: Column(
            children: [
              Container(
                height: 110.h,
                color: accentColor,
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  // padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: const Color(0xff126ABD), borderRadius: BorderRadius.circular(10.w)),
                  child: Row(
                    children: const [
                      SearchParamWidget(
                        icon: Icons.calendar_view_month,
                        text: "October 8 Friday",
                      ),
                      SearchParamWidget(
                        icon: Icons.timer,
                        text: "05:00 PM EST",
                      ),
                      SearchParamWidget(
                        icon: Icons.people_outline,
                        text: "3",
                      ),
                      SearchParamWidget(
                        icon: Icons.airplanemode_on,
                        text: "One way",
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    const Text("Search Results"),
                    SizedBox(
                      width: 10.w,
                    ),
                    Text(
                      "12",
                      style: GoogleFonts.rubik(color: accentColor),
                    )
                  ],
                ),
                trailing: const Icon(Icons.filter_list),
              ),
              Expanded(
                child: Container(
                  color: isLight ? lightSecondary : const Color(0xff202020),
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: viewModel.goToDetails,
                        child: Container(
                          // height: 247.h,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isLight ? lightSecondary : darkSecondary),
                          child: Column(
                            children: [
                              Image.asset("assets/bd100.png"),
                              Column(
                                children: [
                                  SizedBox(height: 8.h),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Bombadier",
                                        style: GoogleFonts.rubik(
                                          color: isLight
                                              ? const Color(0xcc242424)
                                              : const Color(0xccffffff),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.airline_seat_recline_extra,
                                            color: accentColor,
                                          ),
                                          SizedBox(
                                            width: 8.w,
                                          ),
                                          Text("8 seats")
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "BD-100-1A10 (CHALLENGER 300)",
                                              style: GoogleFonts.rubik(
                                                  fontWeight: FontWeight.bold, fontSize: 21.sp),
                                            ),
                                            Text(
                                              "Super Mid Het",
                                              style: GoogleFonts.rubik(color: accentColor),
                                            ),
                                            const Text("KBED - BEDFORD, MA United States"),
                                          ],
                                        ),
                                      ),
                                      Expanded(child: Container())
                                    ],
                                  ),
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: Image.asset(
                                      "assets/profile.png",
                                      height: 30.h,
                                    ),
                                    title: Row(
                                      children: [
                                        const Text("Adam Smith"),
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.email,
                                            color: accentColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    trailing: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                        color: accentColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        "\$4,950/hour",
                                        style: GoogleFonts.rubik(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => SearchResultsViewModel(),
    );
  }
}
