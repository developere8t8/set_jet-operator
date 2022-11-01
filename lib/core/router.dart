// [ This is an auto generated file ]

import 'package:flutter/material.dart';
import 'package:set_jet/core/router_constants.dart';
import 'package:set_jet/models/charter.dart';
import 'package:set_jet/models/chatroom.dart';
import 'package:set_jet/models/planes.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/views/pre_login/auth.dart';

import 'package:set_jet/views/welcome/welcome_view.dart' as view0;
import 'package:set_jet/views/pre_login/pre_login_view.dart' as view1;
import 'package:set_jet/views/login_screen/login_screen_view.dart' as view2;
import 'package:set_jet/views/post_login_screen/post_login_screen_view.dart' as view3;
import 'package:set_jet/views/time_zone_setting/time_zone_setting_view.dart' as view4;
import 'package:set_jet/views/home/home_view.dart' as view5;
import 'package:set_jet/views/messages_screen/messages_screen_view.dart' as view6;
import 'package:set_jet/views/chatbox_screen/chatbox_screen_view.dart' as view7;
import 'package:set_jet/views/search/search_view.dart' as view8;
import 'package:set_jet/views/user_setting_screen/user_setting_screen_view.dart' as view9;
import 'package:set_jet/views/search_results/search_results_view.dart' as view10;
import 'package:set_jet/views/charter_details/charter_details_view.dart' as view11;
import 'package:set_jet/views/booked_charters/booked_charters_view.dart' as view12;
import 'package:set_jet/views/booked_charter_detail/booked_charter_detail_view.dart' as view13;
import 'package:set_jet/views/sent_request/sent_request_view.dart' as view14;
import 'package:set_jet/views/subscription_screen/subscription_screen_view.dart' as view15;
import 'package:set_jet/views/credit_card_screen/credit_card_screen_view.dart' as view16;
import 'package:set_jet/views/subscription_success_screen/subscription_success_screen_view.dart'
    as view17;
import 'package:set_jet/views/feedback_screen/feedback_screen_view.dart' as view18;
import 'package:set_jet/views/edit_subscription_screen/edit_subscription_screen_view.dart' as view19;
import 'package:set_jet/views/plane/plane_view.dart' as view20;
import 'package:set_jet/views/add_plane/add_plane_view.dart' as view21;
import 'package:set_jet/views/charter/charter_view.dart' as view22;
import 'package:set_jet/views/charter_create/charter_create_view.dart' as view23;

import '../models/flights.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case welcomeViewRoute:
        return MaterialPageRoute(builder: (_) => const view0.WelcomeView());
      case authViewRoute:
        return MaterialPageRoute(builder: (_) => const AuthLogin());
      case preLoginViewRoute:
        return MaterialPageRoute(builder: (_) => view1.PreLoginView());
      case loginScreenViewRoute:
        return MaterialPageRoute(builder: (_) => const view2.LoginScreenView());
      case postLoginScreenViewRoute:
        return MaterialPageRoute(builder: (_) => view3.PostLoginScreenView());
      case timeZoneSettingViewRoute:
        return MaterialPageRoute(builder: (_) => view4.TimeZoneSettingView());
      case homeViewRoute:
        return MaterialPageRoute(builder: (_) => const view5.HomeView());
      case messagesScreenViewRoute:
        return MaterialPageRoute(
            builder: (_) => view6.MessagesScreenView(
                  userdata: args as UserData,
                ));
      case chatboxScreenViewRoute:
        return MaterialPageRoute(
            builder: (_) => view7.ChatboxScreenView(
                  userdata: args as UserData,
                  targetuser: args,
                  model: args as ChatRoomModel,
                ));
      case searchViewRoute:
        return MaterialPageRoute(builder: (_) => view8.SearchView());
      case userSettingScreenViewRoute:
        return MaterialPageRoute(
            builder: (_) => view9.UserSettingScreenView(
                  data: args as UserData,
                ));
      case searchResultsViewRoute:
        return MaterialPageRoute(builder: (_) => view10.SearchResultsView());
      case charterDetailsViewRoute:
        return MaterialPageRoute(
            builder: (_) => view11.CharterDetailsView(
                  charter: args as Charter,
                  plane: args as Planes,
                  userdata: args as UserData,
                ));
      // case bookedCharterView:
      //   return MaterialPageRoute(
      //       builder: (_) => view12.BookedCharterView(
      //             data: args as UserData,
      //           ));
      case bookedCharterDetailViewRoute:
        return MaterialPageRoute(
            builder: (_) => view13.BookedCharterDetailView(
                  charter: args as Charter,
                  plane: args as Planes,
                  user: args as UserData,
                  pasenger: args as UserData,
                  flight: args as Flights,
                ));
      case sentRequestViewRoute:
        return MaterialPageRoute(
            builder: (_) => view14.SentRequestView(
                  userdata: args as UserData,
                ));
      case subscriptionScreenViewRoute:
        return MaterialPageRoute(builder: (_) => view15.SubscriptionScreenView());
      case creditCardScreenViewRoute:
        return MaterialPageRoute(builder: (_) => view16.CreditCardScreenView());
      case subscriptionSuccessScreenViewRoute:
        return MaterialPageRoute(
            builder: (_) => const view17.SubscriptionSuccessScreenView(
                  plan: 'monthly',
                ));
      case feedbackScreenViewRoute:
        return MaterialPageRoute(
            builder: (_) => view18.FeedbackScreenView(
                  data: args as UserData,
                ));
      case editSubscriptionScreenViewRoute:
        return MaterialPageRoute(builder: (_) => view19.EditSubscriptionScreenView());
      case planeViewRoute:
        return MaterialPageRoute(
            builder: (_) => view20.PlaneView(
                  userData: args as UserData,
                ));
      case addPlaneViewRoute:
        return MaterialPageRoute(
            builder: (_) => view21.AddPlaneView(
                  userdata: args as UserData,
                ));
      case charterViewRoute:
        return MaterialPageRoute(
            builder: (_) => view22.CharterView(
                  userData: args as UserData,
                ));
      case charterCreateViewRoute:
        return MaterialPageRoute(
            builder: (_) => view23.CharterCreateView(
                  userdata: args as UserData,
                ));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
