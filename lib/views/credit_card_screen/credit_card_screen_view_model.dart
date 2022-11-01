import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/views/subscription_success_screen/subscription_success_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class CreditCardScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  navigateToViewSubscriptionSuccessScreen(String plan) {
    _navService!.navigateToView(SubscriptionSuccessScreenView(
      plan: plan,
    ));
  }

  CreditCardScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
