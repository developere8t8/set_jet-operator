import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/views/login_screen/login_screen_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class EditSubscriptionScreenViewModel extends BaseViewModel {
  Logger? log;
  final NavigationService? _navService = locator<NavigationService>();

  
  navigateToViewLoginScreen() {
    _navService!.navigateToView(LoginScreenView());
  }

  EditSubscriptionScreenViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
