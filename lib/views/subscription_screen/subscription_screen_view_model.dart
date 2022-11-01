import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/views/credit_card_screen/credit_card_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../home/home_view.dart';

class SubscriptionScreenViewModel extends BaseViewModel {
  Logger? log;
  final currentPageNotifier = ValueNotifier<int>(0);
  final NavigationService? _navService = locator<NavigationService>();

  navigateToViewCreditCardScreen() {
    _navService!.navigateToView(CreditCardScreenView());
  }

  navigateToViewHomeScreen(UserData data) {
    _navService!.navigateToView(const HomeView());
  }

  void pageChange(index) {
    currentPageNotifier.value = index;
    notifyListeners();
  }

  SubscriptionScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
