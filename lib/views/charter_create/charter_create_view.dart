import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:set_jet/constants/strings.dart';
import 'package:set_jet/models/charter.dart';
import 'package:set_jet/models/planes.dart';
//import 'package:geocoding/geocoding.dart';
import 'package:set_jet/theme/dark.dart';
import 'package:set_jet/views/charter/charter_view.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:snack/snack.dart';
import '../../models/usermodel.dart';
import '../../theme/common.dart';

class CharterCreateView extends StatefulWidget {
  final UserData userdata;
  const CharterCreateView({Key? key, required this.userdata}) : super(key: key);
  @override
  State<CharterCreateView> createState() => _CharterCreateViewState();
}

class _CharterCreateViewState extends State<CharterCreateView> {
  String apiKey = googleMapApiKey; //'AIzaSyCEmHBhem_KFl1_prIbKS2wIA1pTDGRB74'; // google map api key
  final _selecttestkey = GlobalKey<FormState>();
  List<LatLng> latLong = [];
  List<Polyline> polyline = [];
  CameraPosition? position; //CameraPosition(target: LatLng(33.63779875, -84.42927118585675), zoom: 8);
  GoogleMapController? controller;
  List<Planes> planes = []; //all planes to show in list
  int index = 0;
  List<String> airPorts = []; //to suggest airports
  List<Marker> markers = [];
  double distance = 150;
  double price = 150;
  TextEditingController airport = TextEditingController();

  //get airport list to search
  void getAiports(String? val) async {
    if (val!.isNotEmpty) {
      Uri requestUri = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$val&key=$apiKey');
      final response = await http.get(requestUri);
      if (response.statusCode == 200) {
        setState(() {
          var temp = jsonDecode(response.body)['predictions'];
          //airPorts.clear();
          for (var element in temp) {
            airPorts.add(element['description']);
          }
        });
      }
    } else {
      setState(() {
        airPorts.clear();
      });
    }
  }

//getting all plane data
  void getPlane() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('planes')
        .where('operator', isEqualTo: widget.userdata.userID)
        .get();

    setState(() {
      planes = snapshot.docs.map((d) => Planes.fromMap(d.data() as Map<String, dynamic>)).toList();
      index = 0;
    });
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${planes[index].airport.toString()}&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body)['results'];
      for (var element in temp) {
        Map obj = element;
        Map geo = obj['geometry'];
        Map loc = geo['location'];
        setState(() {
          latLong.add(LatLng(loc['lat'], loc['lng']));
          //latitude = loc['lat'];
          //logitude = loc['lng'];
          markers.add(Marker(
              markerId: MarkerId(planes[index].airport.toString()),
              position: LatLng(latLong.first.latitude, latLong.first.longitude),
              infoWindow: InfoWindow(title: planes[index].airport)));
          position =
              CameraPosition(target: LatLng(latLong.first.latitude, latLong.first.longitude), zoom: 12);
        });
      }
    }
  }

  //adding destination markers on map
  void addMarkerDestination() async {
    loadingBar('calculating distance... please wait', true, 3);
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${airport.text}&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body)['results'];
      for (var element in temp) {
        Map obj = element;
        Map geo = obj['geometry'];
        Map loc = geo['location'];
        setState(() {
          latLong.add(LatLng(loc['lat'], loc['lng']));
          // latitude2 = loc['lat'];
          // logitude2 = loc['lng'];
          markers.add(Marker(
              markerId: MarkerId(airport.text),
              position: LatLng(latLong[1].latitude, latLong[1].longitude),
              infoWindow: InfoWindow(title: airport.text)));
          position = CameraPosition(target: LatLng(latLong[1].latitude, latLong[1].longitude), zoom: 5);
          polyline.add(Polyline(polylineId: const PolylineId('1'), points: latLong, color: Colors.red));
          distance = calculateDistane(latLong);
        });
        controller?.animateCamera(CameraUpdate.newCameraPosition(position!));
      }
    }
  }

  //adding markers of next plane airport
  void addMarkerNextPlane(int index) async {
    loadingBar('calculating distance... please wait', true, 3);
    Uri uri = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${planes[index].airport}&key=$apiKey');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body)['results'];
      for (var element in temp) {
        Map obj = element;
        Map geo = obj['geometry'];
        Map loc = geo['location'];
        setState(() {
          latLong.add(LatLng(loc['lat'], loc['lng']));
          markers.add(Marker(
              markerId: MarkerId(planes[index].airport.toString()),
              position: LatLng(latLong.first.latitude, latLong.first.longitude),
              infoWindow: InfoWindow(title: planes[index].airport)));
          position =
              CameraPosition(target: LatLng(latLong.first.latitude, latLong.first.longitude), zoom: 12);
        });
        controller?.animateCamera(CameraUpdate.newCameraPosition(position!));
      }
    }
  }

  void saveCharter() {
    loadingBar('saving charter... please wait', true, 3);
    final docuser = FirebaseFirestore.instance.collection('charters').doc();
    Charter charter = Charter(
        id: docuser.id,
        fromAirport: planes[index].airport,
        toAirport: airport.text,
        operator: widget.userdata.userID,
        active: true,
        createdon: Timestamp.fromDate(DateTime.now()),
        price: roundDouble(price * distance, 1),
        planeid: planes[index].id,
        range: distance.toString());
    docuser.set(charter.toMap()); //saving new charter
    alert('New charter saved ', 'Success', context);
  }

  @override
  void initState() {
    super.initState();
    getPlane(); //getting planes
  }

  @override
  Widget build(BuildContext context) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    //return ViewModelBuilder<CharterCreateViewModel>.reactive(
    //builder: (BuildContext context, CharterCreateViewModel viewModel, Widget? _) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: accentColor,
        leading: MaterialButton(
          child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomBlurredDrawerWidget(data: widget.userdata)));
          },
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/logo_black.png',
          height: 41.h,
          width: 50.w,
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        primary: false,
        children: [
          Container(
            // height: 60.h,
            color: accentColor,
            padding: EdgeInsets.all(4.h),
            // padding: EdgeInsets.all(8.h),
            child: planes.isEmpty
                ? const Center(
                    // child: CircularProgressIndicator(
                    //   color: Colors.red,
                    // ),
                    )
                : Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff126ABD),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                                child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios),
                              onPressed: () async {
                                //onpress previous next plane data
                                setState(() {
                                  if (index > 0) {
                                    index--;
                                  } else if (index == 0) {
                                    index = planes.length - 1;
                                  } else {
                                    index = 0;
                                  }
                                  latLong.clear();
                                  markers.clear();
                                  polyline.clear();
                                  distance = 150;
                                  price = 150;
                                });
                                addMarkerNextPlane(index);
                              },
                            )),
                            planes[index].pics!.isEmpty
                                ? const CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: AssetImage("assets/plane_square.png"),
                                  )
                                : CircleAvatar(
                                    radius: 20.0,
                                    backgroundImage: NetworkImage(planes[index].pics!.first),
                                  ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              flex: 9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    planes[index].brand.toString(),
                                    style: GoogleFonts.rubik(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    planes[index].planeName.toString(),
                                    style: GoogleFonts.rubik(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: IconButton(
                              icon: const Icon(Icons.arrow_forward_ios),
                              onPressed: () {
                                //onpress get next plane data
                                setState(() {
                                  if (index < planes.length - 1) {
                                    index++;
                                  } else if (index == planes.length) {
                                    index = 0;
                                  } else {
                                    index = 0;
                                  }
                                  latLong.clear();
                                  markers.clear();
                                  polyline.clear();
                                  distance = 150;
                                  price = 150;
                                });
                                addMarkerNextPlane(index);
                              },
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(planes[index].type.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(planes[index].airport.toString()),
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.airline_seat_recline_extra_rounded,
                                    ),
                                    Text(
                                      '${planes[index].seats} seats',
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(
                                    planes[index].wyvern == true ? Icons.check : Icons.close,
                                    color: planes[index].wyvern == true ? accentColor : Colors.red,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "WVYERN",
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    planes[index].wifi == true ? Icons.check : Icons.close,
                                    color: planes[index].wifi == true ? accentColor : Colors.red,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "wifi",
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    planes[index].placeholder == true ? Icons.check : Icons.close,
                                    color: planes[index].placeholder == true ? accentColor : Colors.red,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Placeholder",
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
          ),
          SizedBox(
            height: 10.h,
          ),
          createAirportSearch(),
          Container(
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            height: 600.h,
            child: position == null
                ? const Center(
                    //child: CircularProgressIndicator(color: Colors.red),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Flight Range => ${roundDouble(distance, 1)} km",
                  style:
                      GoogleFonts.rubik(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6)),
                ),
                Row(
                  children: [
                    Text("0 km",
                        style:
                            TextStyle(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                    Expanded(
                      child: RangeSlider(
                          values: RangeValues(0, roundDouble(distance, 1)),
                          onChanged: (val) {},
                          divisions: 100,
                          min: 0,
                          max: 5000),
                    ),
                    Text('5000',
                        style:
                            TextStyle(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: isLight ? const Color(0xfff1f1f1) : Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Price per mile => \$ $price",
                    style: GoogleFonts.rubik(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                      color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6),
                    )),
                Row(
                  children: [
                    Text("\$ 100",
                        style:
                            TextStyle(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                    Expanded(
                      child: Slider(
                        value: price,
                        onChanged: (val) {
                          setState(() {
                            price = val;
                          });
                        },
                        divisions: 100,
                        label: "\$ $price",
                        min: 100,
                        max: 200,
                      ),
                    ),
                    Text("\$ 200",
                        style:
                            TextStyle(color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price Range",
                      style: GoogleFonts.rubik(
                          color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6)),
                    ),
                    Text(
                      "\$ ${roundDouble(price * distance, 1)}",
                      style: GoogleFonts.rubik(
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                // Create a material button with acccnt color
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: MaterialButton(
              padding: const EdgeInsets.all(16.0),
              color: accentColor,
              onPressed: () {
                if (airport.text.isNotEmpty && planes.isNotEmpty) {
                  saveCharter();
                } else {
                  loadingBar('Provide airport for this charter', false, 1);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Create Charter",
                style: GoogleFonts.rubik(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
    //},
    //viewModelBuilder: () => CharterCreateViewModel(),
    //);
  }

  //ariport search widget
  Widget createAirportSearch() {
    return Form(
        key: _selecttestkey,
        child: SizedBox(
          height: 70.h,
          width: 331.w,
          child: TypeAheadFormField(
            suggestionsCallback: (patteren) =>
                airPorts.where((element) => element.toLowerCase().contains(patteren.toLowerCase())),
            onSuggestionSelected: (String value) {
              airport.text = value;
            },
            itemBuilder: (_, String item) => Card(
              color: Colors.purple[100],
              child: ListTile(
                title: Text(item),
                leading: const Icon(Icons.place_outlined),
                onTap: () {
                  airport.text = item;
                  setState(() {
                    if (markers.length > 1) {
                      markers.removeAt(markers.length - 1);
                    }
                    if (latLong.length > 1) {
                      latLong.removeAt(latLong.length - 1);
                    }
                    if (polyline.length > 1) {
                      polyline.removeAt(polyline.length - 1);
                    }
                  });
                  addMarkerDestination();
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            ),
            getImmediateSuggestions: true,
            hideSuggestionsOnKeyboardHide: true,
            hideOnEmpty: true,
            noItemsFoundBuilder: (_) => const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text('No airport found'),
            ),
            textFieldConfiguration: TextFieldConfiguration(
                decoration: InputDecoration(
                    labelText: 'Airport',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15.0))),
                controller: airport,
                onChanged: (String? val) {
                  getAiports(val);
                }),
          ),
        ));
  }

  double calculateDistane(List<LatLng> polyline) {
    double totalDistance = 0;
    for (int i = 0; i < polyline.length; i++) {
      if (i < polyline.length - 1) {
        // skip the last index
        totalDistance += getStraightLineDistance(polyline[i + 1].latitude, polyline[i + 1].longitude,
            polyline[i].latitude, polyline[i].longitude);
      }
    }
    if (totalDistance > 5000000) {
      totalDistance = 4999999;
    }
    return totalDistance / 1000;
  }

  double getStraightLineDistance(lat1, lon1, lat2, lon2) {
    var R = 6371; // Radius of the earth in km
    var dLat = deg2rad(lat2 - lat1);
    var dLon = deg2rad(lon2 - lon1);
    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(deg2rad(lat1)) * math.cos(deg2rad(lat2)) * math.sin(dLon / 2) * math.sin(dLon / 2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    var d = R * c; // Distance in km
    return d * 1000; //in m
  }

  dynamic deg2rad(deg) {
    return deg * (math.pi / 180);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(content)),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
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
