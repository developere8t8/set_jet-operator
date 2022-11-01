import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/views/home/home_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class SubscriptionSuccessScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  navigateToViewHomeScreen(UserData data) {
    _navService!.navigateToView(const HomeView());
  }

  SubscriptionSuccessScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
