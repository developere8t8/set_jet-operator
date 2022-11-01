import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_jet/models/charter.dart';
import 'package:set_jet/models/planes.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/charter/charter_view.dart';
import 'package:http/http.dart' as http;
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import '../../constants/strings.dart';
import '../../models/usermodel.dart';

class CharterDetailsView extends StatefulWidget {
  final UserData userdata;
  final Charter charter;
  final Planes plane;
  const CharterDetailsView(
      {Key? key, required this.userdata, required this.charter, required this.plane})
      : super(key: key);

  @override
  State<CharterDetailsView> createState() => _CharterDetailsViewState();
}

class _CharterDetailsViewState extends State<CharterDetailsView> {
  List<LatLng> latLong = [];
  List<Polyline> polyline = [];
  CameraPosition? position; //CameraPosition(target: LatLng(33.63779875, -84.42927118585675), zoom: 8);
  GoogleMapController? controller;
  List<Marker> markers = [];
  String apiKey = googleMapApiKey; //'AIzaSyCEmHBhem_KFl1_prIbKS2wIA1pTDGRB74'; // google map api key
//setting markers of flight range
  void addMarkerDestination() async {
    //getting from location coordinates
    Uri fromUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${widget.charter.fromAirport}&key=$apiKey');
    //getting destination location coordinates
    Uri toUri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${widget.charter.toAirport}&key=$apiKey');
    final toResponse = await http.get(toUri);
    final fromResponse = await http.get(fromUri);

    if (fromResponse.statusCode == 200) {
      var temp = jsonDecode(fromResponse.body)['results'];
      for (var element in temp) {
        Map obj = element;
        Map geo = obj['geometry'];
        Map loc = geo['location'];
        setState(() {
          latLong.add(LatLng(loc['lat'], loc['lng']));
          markers.add(Marker(
              markerId: MarkerId(widget.charter.fromAirport.toString()),
              position: LatLng(latLong[0].latitude, latLong[0].longitude),
              infoWindow: InfoWindow(title: widget.charter.fromAirport.toString())));
        });
      }
    }
    if (toResponse.statusCode == 200) {
      var toTemp = jsonDecode(toResponse.body)['results'];
      for (var toelement in toTemp) {
        Map toobj = toelement;
        Map togeo = toobj['geometry'];
        Map toloc = togeo['location'];
        setState(() {
          latLong.add(LatLng(toloc['lat'], toloc['lng']));
          markers.add(Marker(
              markerId: MarkerId(widget.charter.toAirport.toString()),
              position: LatLng(latLong[1].latitude, latLong[1].longitude),
              infoWindow: InfoWindow(title: widget.charter.toAirport.toString())));
          position = CameraPosition(target: LatLng(latLong[1].latitude, latLong[1].longitude), zoom: 5);
          polyline.add(Polyline(polylineId: const PolylineId('1'), points: latLong, color: Colors.red));
        });
        controller?.animateCamera(CameraUpdate.newCameraPosition(position!));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    addMarkerDestination();
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    // return ViewModelBuilder<CharterDetailsViewModel>.reactive(
    // builder: (BuildContext context, CharterDetailsViewModel viewModel, Widget? _) {
    return Scaffold(
      appBar: AppBar(
        leading: MaterialButton(
          child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBlurredDrawerWidget(data: widget.userdata)));
          },
        ),
        backgroundColor: isLight ? Colors.white : Colors.black,
        title: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              }, //viewModel.back,
              icon: Icon(
                Icons.arrow_back_ios,
                color: accentColor,
              ),
            ),
            Text(
              "Charter Details",
              style: isLight ? darkText : lightText,
            ),
          ],
        ),
        // actions: [
        //   IconButton(
        //       onPressed: () {},
        //       icon: Icon(
        //         Icons.more_vert,
        //       ))
        // ],
      ),
      body: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          SizedBox(
            height: 150.h,
            child: widget.plane.pics!.first == ''
                ? Image.asset("assets/plane_full.png")
                : Image.network(
                    widget.plane.pics!.first,
                    fit: BoxFit.cover,
                  ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            child: Column(
              children: [
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.plane.brand.toString(),
                      style: GoogleFonts.rubik(
                        color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.airline_seat_recline_extra,
                          color: accentColor,
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Text(
                          "${widget.plane.seats} seats",
                          style: GoogleFonts.rubik(),
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.plane.planeName.toString(),
                            style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 21.sp),
                          ),
                          Text(
                            widget.plane.type.toString(),
                            style: GoogleFonts.rubik(color: accentColor),
                          ),
                          Row(
                            children: [
                              Expanded(child: Text('From: ${widget.charter.fromAirport}')),
                            ],
                          ),
                          Row(
                            children: [Expanded(child: Text('To: ${widget.charter.toAirport}'))],
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container())
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      widget.plane.wyvern == true ? Icons.check : Icons.close,
                      color: widget.plane.wyvern == true ? accentColor : Colors.red,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Text(
                        'WYVERN',
                        style: GoogleFonts.rubik(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      widget.plane.wifi == true ? Icons.check : Icons.close,
                      color: widget.plane.wifi == true ? accentColor : Colors.red,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Text(
                        'Wifi',
                        style: GoogleFonts.rubik(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Icon(
                      widget.plane.placeholder == true ? Icons.check : Icons.close,
                      color: widget.plane.placeholder == true ? accentColor : Colors.red,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Expanded(
                      child: Text(
                        'Placeholder',
                        style: GoogleFonts.rubik(
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: 200.w,
                  margin: const EdgeInsets.all(8.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '\$ ${widget.charter.price}',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      color: accentColor,
                    ),
                  ),
                )
              ],
            ),
          ),
          //const AdSection(),
          SizedBox(
            height: 10.h,
          ),
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 600.h,
            child: position == null
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  )
                : GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: position!,
                    markers: Set<Marker>.of(markers),
                    polylines: Set<Polyline>.of(polyline),
                    onMapCreated: (GoogleMapController contrl) {
                      setState(() {
                        controller = contrl;
                      });
                    },
                  ),
          ),
          SizedBox(
            height: 10.h,
          ),
          // ROw with two text
          Container(
            margin: EdgeInsets.all(8.w),
            padding: EdgeInsets.all(8.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Flight Range",
                  style:
                      GoogleFonts.rubik(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6)),
                ),
                Text(
                  '${roundDouble(double.parse(widget.charter.range.toString()), 1)} km',
                  style: GoogleFonts.rubik(
                    color: accentColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //},
    //viewModelBuilder: () => CharterDetailsViewModel(),
    //);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void alert(String _content, String _title, _context) {
    showDialog(
        context: _context,
        builder: (context) => AlertDialog(
              title: Text(_title),
              content: Text(_content),
              actions: [
                CloseButton(onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CharterView(userData: widget.userdata)));
                }),
              ],
            ));
  }
}
