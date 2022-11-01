import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/models/routedata.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/views/booked_charters/booked_charters_view.dart';

import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../constants/drawer_enum.dart';
import '../../../core/locator.dart';

class CustomBlurredDrawerViewModel extends BaseViewModel {
  Logger? log;

  final drawerOption;
  final UserData? data;

  final NavigationService? _navService = locator<NavigationService>();

  CustomBlurredDrawerViewModel(this.drawerOption, this.data) {
    // drawerOption = ModalRoute.of(context).settings.arguments;

    log = getLogger(runtimeType.toString());
  }

  navigateSettings() {
    if (drawerOption != DrawerOptions.Settings) {
      _navService!.navigateTo(userSettingScreenViewRoute);
    }
  }

  navigateBookCharters() {
    if (drawerOption != DrawerOptions.BookedCharters) {
      _navService!.navigateTo(bookedChartersViewRoute);
    }
  }

  navigateSentRequests() {
    if (drawerOption != DrawerOptions.SentRequests) {
      _navService!.navigateTo(sentRequestViewRoute);
    }
  }

  navigateSearchFlights() {
    if (drawerOption != DrawerOptions.SearchFlights) {
      _navService!.navigateTo(searchViewRoute);
    }
  }

  navigateHome(UserData data) {
    if (drawerOption != DrawerOptions.Home) {
      _navService!.navigateTo(homeViewRoute, arguments: data);
    }
  }

  navigateToPlanes() {
    if (drawerOption != DrawerOptions.Planes) {
      _navService!.navigateTo(planeViewRoute);
    }
  }

  navigateToCharter() {
    if (drawerOption != DrawerOptions.Charters) {
      _navService!.navigateTo(charterViewRoute);
    }
  }

  navigateToMessages(UserData data) {
    if (drawerOption != DrawerOptions.Message) {
      _navService!.navigateTo(messagesScreenViewRoute, arguments: data);
    }
  }
}
