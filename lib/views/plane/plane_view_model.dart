import 'package:logger/logger.dart';
import 'package:set_jet/core/locator.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/views/add_plane/add_plane_view.dart';
import 'package:stacked/stacked.dart';
import 'package:set_jet/core/logger.dart';
import 'package:stacked_services/stacked_services.dart';

class PlaneViewModel extends BaseViewModel {
  Logger? log;

  //Get navigation service
  final NavigationService? _navigationService = locator<NavigationService>();

  PlaneViewModel() {
    this.log = getLogger(this.runtimeType.toString());
  }

  void add() {
    _navigationService!.navigateTo(addPlaneViewRoute);
  }

  // getAddDialog() {
  //   return AddPlaneView(userdata: ,);
  // }
}
