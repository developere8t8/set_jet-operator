import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/charter_create/charter_create_view.dart';
import 'package:set_jet/views/charter_details/charter_details_view.dart';
import 'package:set_jet/widgets/smart_widgets/custom_blurred_drawer/custom_blurred_drawer_widget.dart';
import 'package:snack/snack.dart';
import '../../models/charter.dart';
import '../../models/planes.dart';
import '../../models/usermodel.dart';
import '../../theme/common.dart';
import '../../theme/dark.dart';

class CharterView extends StatefulWidget {
  final UserData userData;

  const CharterView({Key? key, required this.userData}) : super(key: key);
  @override
  State<CharterView> createState() => _CharterViewState();
}

class _CharterViewState extends State<CharterView> {
  List<Charter> charters = [];
  List<Charter> dummy = [];
  void getCharters() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('charters')
        .where('opid', isEqualTo: widget.userData.userID)
        .get();

    setState(() {
      charters = snapshot.docs.map((d) => Charter.fromMap(d.data() as Map<String, dynamic>)).toList();
      dummy = snapshot.docs.map((d) => Charter.fromMap(d.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getCharters();
  }

  @override
  Widget build(BuildContext context) {
    //return ViewModelBuilder<CharterViewModel>.reactive(
    //builder: (BuildContext context, CharterViewModel viewModel, Widget? _) {
    var isLight = Theme.of(context).brightness == Brightness.light;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: MaterialButton(
            child: Image.asset('assets/drawer_${!isLight ? 'dark' : 'light'}.png'),
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomBlurredDrawerWidget(data: widget.userData)));
            },
          ),
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CharterCreateView(userdata: widget.userData)));
              }, //viewModel.goToAdd,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Charters',
                    style: GoogleFonts.rubik(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w600,
                        color: !isLight ? Colors.white : Colors.black),
                  ),
                  Text(
                    "You have ${charters.length} charters",
                    style: GoogleFonts.rubik(
                      color: isLight ? const Color(0xcc242424) : const Color(0xccffffff),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  TextField(
                    onChanged: (String? val) {
                      //searchin charters
                      if (val == '') {
                        setState(() {
                          charters = dummy.cast<Charter>();
                        });
                      } else {
                        setState(() {
                          charters = charters
                              .where((element) =>
                                  element.fromAirport!.toLowerCase().contains(val!.toLowerCase()))
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
                      label: Text("Search in charters (write fleet airport here)",
                          style: GoogleFonts.rubik(
                              color: isLight ? const Color(0x66242424) : const Color(0x66ffffff))),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                  itemCount: charters.length,
                  primary: false,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return AllCharters(
                      isLight: isLight,
                      charter: charters[index],
                      userdata: widget.userData,
                    );
                  })
            ],
          )),
        ),
      ),
    );
    //},
    //viewModelBuilder: () => CharterViewModel(),
    //);
  }

  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
  }

  void alert(String content, String title, context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: const [
                CloseButton(),
              ],
            ));
  }
}

class AllCharters extends StatefulWidget {
  final bool isLight;
  final Charter charter;
  final UserData userdata;
  const AllCharters({Key? key, required this.isLight, required this.charter, required this.userdata})
      : super(key: key);

  @override
  State<AllCharters> createState() => _AllChartersState();
}

class _AllChartersState extends State<AllCharters> {
  List<Planes> planes = [];
  void getPlane() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('planes')
        .where('id', isEqualTo: widget.charter.planeid)
        .get();
    setState(() {
      planes = snapshot.docs.map((d) => Planes.fromMap(d.data() as Map<String, dynamic>)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getPlane();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        loadingBar('loading locations... please wait', true, 4);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CharterDetailsView(
                      charter: widget.charter,
                      userdata: widget.userdata,
                      plane: planes.first,
                    )));
      },
      child: planes.isEmpty
          ? Center(
              child: Container(),
            )
          : Container(
              margin: const EdgeInsets.only(top: 5.0),
              height: 320.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: widget.isLight ? lightSecondary : darkSecondary,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 70.h,
                    color: accentColor,
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.h),
                          child: Row(
                            children: [
                              planes[0].pics![0] == ''
                                  ? CircleAvatar(
                                      radius: 20.0.h,
                                      backgroundImage: const AssetImage("assets/plane_square.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 20.0.h,
                                      backgroundImage: NetworkImage(planes[0].pics![0]),
                                    ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      planes[0].brand.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      planes[0].planeName.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  const Icon(
                                    Icons.airline_seat_recline_extra_rounded,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '${planes[0].seats} Seats',
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                ],
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  // Row with check icon and text
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          planes[0].type.toString(),
                          style: GoogleFonts.rubik(
                            fontSize: 16.sp,
                            color: accentColor,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Expanded(child: Text('From: ${widget.charter.fromAirport}')),
                          ],
                        ),
                        Row(
                          children: [Expanded(child: Text('To: ${widget.charter.toAirport}'))],
                        ),
                        //Text(' - ${}'),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              planes[0].wyvern == true ? Icons.check : Icons.close,
                              color: planes[0].wyvern == true ? accentColor : Colors.red,
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
                              planes[0].wifi == true ? Icons.check : Icons.close,
                              color: planes[0].wifi == true ? accentColor : Colors.red,
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
                              planes[0].placeholder == true ? Icons.check : Icons.close,
                              color: planes[0].placeholder == true ? accentColor : Colors.red,
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
                      ],
                    ),
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
    );
  }

  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(content),
          (load) ? const CircularProgressIndicator(color: Colors.red) : const Text(''),
        ],
      ),
      duration: Duration(seconds: duration),
    );
    bar.show(context);
  }
}
