import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';

class CharterCreateViewModel extends BaseViewModel {
  Logger? log;

  CharterCreateViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }
}
