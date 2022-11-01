import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/constants/drawer_enum.dart';
import 'package:set_jet/models/planes.dart';
import 'package:set_jet/views/add_plane/edit_plane_view.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:stacked/stacked.dart';
import '../../models/usermodel.dart';
import '../../theme/dark.dart';
import '../../theme/light.dart';
import 'plane_view_model.dart';
import 'package:set_jet/views/add_plane/add_plane_view.dart';

class PlaneView extends StatefulWidget {
  final UserData userData;
  const PlaneView({Key? key, required this.userData}) : super(key: key);

  @override
  State<PlaneView> createState() => _PlaneViewState();
}

class _PlaneViewState extends State<PlaneView> {
  int totalPlanes = 0;
  List<Planes> planes = [];
  List<Planes> dummyPlane = [];

  //getting total planes

  void getPlanes() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('planes')
        .where('operator', isEqualTo: widget.userData.userID)
        .get();
    setState(() {
      planes = snapshot.docs.map((d) => Planes.fromMap(d.data() as Map<String, dynamic>)).toList();
      dummyPlane = snapshot.docs.map((d) => Planes.fromMap(d.data() as Map<String, dynamic>)).toList();
      totalPlanes = snapshot.docs.length;
    });
  }

  @override
  void initState() {
    super.initState();
    getPlanes();
  }

  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<PlaneViewModel>.reactive(
    //builder: (BuildContext context, PlaneViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBlurredDrawerWidget(data: widget.userData)));
            },
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Image.asset(
            'assets/logo_${!isLight ? 'dark' : 'light'}.png',
            height: 41.h,
            width: 50.w,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPlaneView(
                              userdata: widget.userData,
                            )));
              },
              icon: const Icon(
                Icons.add,
              ),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Planes',
                    style: GoogleFonts.rubik(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: !isLight ? Colors.white : Colors.black),
                  ),
                  Text(
                    "You have $totalPlanes planes",
                    style: GoogleFonts.rubik(
                      color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextField(
                    onChanged: (String? val) {
                      if (val == '') {
                        setState(() {
                          planes = dummyPlane.cast<Planes>();
                        });
                      } else {
                        setState(() {
                          planes = planes
                              .where(
                                  (plane) => plane.planeName!.toLowerCase().contains(val!.toLowerCase()))
                              .toList();
                        });
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: isLight ? lightSecondary : darkSecondary,
                      prefixIcon: Icon(
                        Icons.search_sharp,
                        color: isLight ? const Color(0x66242424) : const Color(0x66ffffff),
                      ),
                      label: Text("Search in Planes",
                          style: GoogleFonts.rubik(
                              color: isLight ? const Color(0x66242424) : const Color(0x66ffffff))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  ListView.builder(
                      itemCount: planes.length,
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, index) {
                        return PlaneWidget(
                          isLight: isLight,
                          plane: planes[index],
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditPlaneView(
                                          userdata: widget.userData,
                                          planes: planes[index],
                                        )));
                          },
                        );
                      })
                ],
              ),
            )),
      ),
    );
    // },
    //viewModelBuilder: () => PlaneViewModel(),
    //);
  }
}

class PlaneWidget extends StatefulWidget {
  const PlaneWidget({Key? key, required this.isLight, required this.onPressed, required this.plane})
      : super(key: key);

  final bool isLight;
  final Planes plane;

  final Function()? onPressed;

  @override
  State<PlaneWidget> createState() => _PlaneWidgetState();
}

class _PlaneWidgetState extends State<PlaneWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.h),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: widget.isLight ? lightSecondary : darkSecondary,
        borderRadius: BorderRadius.circular(10),
      ),
      height: 180.h,
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Expanded(
          child: widget.plane.pics!.isEmpty
              ? Image.asset(
                  "assets/plane_full.png",
                  fit: BoxFit.cover,
                )
              : Image.network(
                  widget.plane.pics![0],
                  fit: BoxFit.cover,
                ),
        ),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.plane.brand.toString(),
                      style: GoogleFonts.rubik(
                          color: widget.isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                          fontSize: 16.sp),
                    ),
                    Expanded(
                      child: Text(
                        widget.plane.planeName.toString(),
                        style: GoogleFonts.rubik(fontWeight: FontWeight.bold, fontSize: 21.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: IconButton(
                      alignment: Alignment.centerRight,
                      onPressed: widget.onPressed,
                      icon: const Icon(Icons.edit)))
            ],
          ),
        ))
      ]),
    );
  }
}
