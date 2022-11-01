import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class HomeViewModel extends BaseViewModel {
  Logger? log;

  HomeViewModel() {
    log = getLogger(runtimeType.toString());
  }
}
