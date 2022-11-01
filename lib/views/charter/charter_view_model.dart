import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/locator.dart';
import '../../core/router_constants.dart';

class CharterViewModel extends BaseViewModel {
  Logger? log;

  //create nav service
  final NavigationService? _navService = locator<NavigationService>();

  CharterViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  void goToDetails() {
    _navService!.navigateTo(charterDetailsViewRoute);
  }

  void goToAdd() {
    _navService!.navigateTo(charterCreateViewRoute);
  }
}
