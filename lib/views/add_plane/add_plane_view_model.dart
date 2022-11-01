import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../core/locator.dart';

class AddPlaneViewModel extends BaseViewModel {
  Logger? log;

  final NavigationService? _navigationService = locator<NavigationService>();

  AddPlaneViewModel() {
    log = getLogger(runtimeType.toString());
  }

  void back() {
    _navigationService!.back();
  }
}
