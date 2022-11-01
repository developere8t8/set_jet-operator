import 'dart:convert';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:set_jet/provider/loginprovider.dart';
//import 'package:set_jet/core/services/theme_service.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'core/locator.dart';
import 'core/router_constants.dart';
import 'core/router.dart' as router;
import 'theme/light.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_live_51LW36iJdYdkNxCcJBWrK0AfqQs4OufD0GEih4gowf4r0gSnpmOLlC3jhZzgtnDw9T8olG3LhqnnYgOTIXNXySe9H009LCpbFop';
  await Firebase.initializeApp();
  await LocatorInjector.setUpLocator();

  await GetStorage.init();
  GetStorage().writeIfNull("user-theme", "dark");
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ignore: prefer_typing_uninitialized_variables
  bool isDark = false;
  Future getTheme() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      String dark = localStorage.getString('theme').toString();
      if (dark == 'dark') {
        isDark = true;
      } else {
        isDark = false;
      }
    });
  }

  @override
  void initState() {
    getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var isDark = GetStorage().read<String>("user-theme") == "dark";
    //var isDark = GetStorage().read<String>("user-theme") == "dark";
    //initialize screenutil
    return ThemeProvider(
      initTheme: isDark ? darkTheme : lightTheme,
      builder: (_, theme) {
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          splitScreenMode: true,
          builder: (BuildContext context, child) {
            return ChangeNotifierProvider(
              create: (context) => LoginMethods(),
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: theme,
                // ignore: deprecated_member_use
                navigatorKey: locator<NavigationService>().navigatorKey,
                onGenerateRoute: router.Router.generateRoute,
                initialRoute: welcomeViewRoute,
              ),
            );

            // return
          },
        );
      },
    );
  }
}
