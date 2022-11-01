import 'dart:convert';
import 'dart:io';
import 'dart:ui' show Brightness, FontWeight, ImageFilter, TextAlign;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:set_jet/models/planes.dart';
import 'package:set_jet/models/usermodel.dart';
import 'package:set_jet/theme/common.dart';
import 'package:set_jet/theme/light.dart';
import 'package:set_jet/views/plane/plane_view.dart';
import 'package:set_jet/widgets/dumb_widgets/app_textfield.dart';
import 'package:snack/snack.dart';
import 'package:http/http.dart' as http;
import '../../theme/dark.dart';

class AddPlaneView extends StatefulWidget {
  final UserData userdata;
  const AddPlaneView({Key? key, required this.userdata}) : super(key: key);

  @override
  State<AddPlaneView> createState() => _AddPlaneViewState();
}

class _AddPlaneViewState extends State<AddPlaneView> {
  final _selecttestkey = GlobalKey<FormState>();
  TextEditingController airport = TextEditingController();
  TextEditingController brand = TextEditingController();
  TextEditingController planeName = TextEditingController();
  TextEditingController seats = TextEditingController();

  List<String> pics = []; //to store image paths for showing
  List<File> imgs = []; // to store files for uploads
  List<String> urls = []; // to store urls of uploaded files
  List<String> airPorts = []; //to suggest airports
  //List<String> airports = ["KHPN", "OPKC", "KLAS"];
  //String? selectedairport;
  double milePrice = 150.0;
  bool? placeholder = true;
  bool? wifi = true;
  bool? wyvern = true;
  String? type;
  List<String> items = ["Cargo", "Passenger"];

  void getAiports(String? val) async {
    String apiKey = 'AIzaSyCEmHBhem_KFl1_prIbKS2wIA1pTDGRB74';
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

  Future<void> savePlane() async {
    //saving new plane
    try {
      final newPlane = FirebaseFirestore.instance.collection('planes').doc();
      Planes planes = Planes(
          id: newPlane.id,
          airport: airport.text,
          brand: brand.text,
          operator: widget.userdata.userID,
          pics: pics,
          placeholder: placeholder,
          planeName: planeName.text,
          price: double.parse(milePrice.toString()),
          seats: int.parse(seats.text),
          type: type,
          wifi: wifi,
          wyvern: wyvern);

      newPlane.set(planes.toMap()); //saving new plane

      //uploading images
      var imgname = 1;
      if (imgs.isNotEmpty) {
        for (var image in imgs) {
          final firebaseStorage = FirebaseStorage.instance;
          var snapshot = await firebaseStorage
              .ref()
              .child('planeimages/${newPlane.id + imgname.toString()}')
              .putFile(image);
          var imgUrl = await snapshot.ref.getDownloadURL();
          setState(() {
            urls.add(imgUrl);
            imgname += 1;
          });
        }
        final docplane = FirebaseFirestore.instance.collection('planes').doc(newPlane.id);
        docplane.update({'pics': urls});
      }
    } catch (e) {
      alert(e.toString(), 'Error', context);
    }
  }

  @override
  void initState() {
    super.initState();
    type = items[0];
    if (imgs.isNotEmpty) {
      imgs.clear();
    }
    if (pics.isNotEmpty) {
      pics.clear();
    }
    if (urls.isNotEmpty) {
      urls.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScrollController scontroller = ScrollController();
    var theme = Theme.of(context);
    var isLight = theme.brightness == Brightness.light;
    //return ViewModelBuilder<AddPlaneViewModel>.reactive(
    //builder: (BuildContext context, AddPlaneViewModel viewModel, Widget? _) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.all(20.h),
          child: Scaffold(
            // backgroundColor: Colors.transparent,
            // appBar: AppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    //margin: EdgeInsets.all(5.h),
                    padding: EdgeInsets.all(2.h),
                    decoration: BoxDecoration(
                        color: theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(
                          10.w,
                        )),
                    height: 125.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: scontroller,
                            shrinkWrap: true,
                            primary: false,
                            itemCount: pics.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, int index) {
                              return picWidget(pics[index], index);
                            },
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                          width: 100.w,
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            textColor: accentColor,
                            color: isLight ? lightSecondary : darkSecondary,
                            onPressed: () async {
                              await Permission.photos.request();

                              var permissionStatus = await Permission.photos.status;
                              if (permissionStatus.isGranted) {
                                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                                if (image == null) {
                                  return;
                                }
                                setState(() {
                                  pics.add(image.path);
                                  imgs.add(File(image.path));
                                  scontroller.animateTo(scontroller.position.maxScrollExtent,
                                      duration: const Duration(milliseconds: 100),
                                      curve: Curves.easeOut);
                                });
                              } else {
                                loadingBar('cant access your gallery', false, 2);
                              }
                            },
                            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                              Icon(
                                Icons.add,
                                size: 38.h,
                              ),
                              const Text(
                                "Add New Photo",
                                textAlign: TextAlign.center,
                              )
                            ]),
                          ),
                        )
                      ],
                    )),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 10.h),
                    padding: EdgeInsets.only(
                      top: 10.h,
                      left: 10.h,
                      right: 10,
                    ),
                    color: theme.scaffoldBackgroundColor,
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              createAirportSearch(),
                              // AppTextField(
                              //   label: "Airport",
                              //   controller: airport,
                              //   prefix: const Icon(Icons.place),
                              // ),
                              SizedBox(
                                height: 30.h,
                              ),
                              AppTextField(
                                label: "Manufacturer",
                                controller: brand,
                              ),
                              // const FormDropDown(
                              //   items: ["Bombadier"],
                              //   label: "Manufacturer",
                              // ),
                              SizedBox(
                                height: 30.h,
                              ),
                              AppTextField(
                                label: "Plane Name",
                                controller: planeName,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              AppTextField(
                                label: "Seats",
                                keyboardType: TextInputType.number,
                                controller: seats,
                              ),
                              SizedBox(
                                height: 30.h,
                              ),
                              DropdownButtonFormField(
                                  // hint: Text(label),
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    labelText: "Type",
                                    hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
                                  ),
                                  // borderRadius: BorderRadius.circular(10),
                                  isExpanded: true,
                                  items: items
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e),
                                          ))
                                      .toList(),
                                  onChanged: (String? val) {
                                    setState(() {
                                      setState(() {
                                        type = val;
                                      });
                                    });
                                  }),
                              // const FormDropDown(
                              //   label: "Type",
                              //   items: ["Cargo", "Passenger"],
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        Text("Price per mile (current price : \$ $milePrice)",
                            style: GoogleFonts.rubik(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6),
                            )),
                        Row(
                          children: [
                            Text("\$ 100",
                                style: TextStyle(
                                    color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                            Expanded(
                              child: Slider(
                                value: milePrice,
                                onChanged: (val) {
                                  setState(() {
                                    milePrice = val;
                                  });
                                },
                                divisions: 100,
                                label: "\$ $milePrice",
                                min: 100,
                                max: 200,
                              ),
                            ),
                            Text("\$ 200",
                                style: TextStyle(
                                    color: (isLight ? bgColorDark : Colors.white).withOpacity(0.4))),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price Range",
                              style: GoogleFonts.rubik(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: (isLight ? bgColorDark : Colors.white).withOpacity(0.6),
                              ),
                            ),
                            Text(
                              "\$1600 - \$2300",
                              style: TextStyle(
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Container(
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                                color: isLight ? lightSecondary : Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Wifi',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: wifi!,
                                  onChanged: (val) {
                                    setState(() {
                                      wifi = val;
                                    });
                                  },
                                  activeColor: accentColor,
                                )
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                                color: isLight ? lightSecondary : Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'WYVERN',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: wyvern!,
                                  onChanged: (val) {
                                    setState(() {
                                      wyvern = val;
                                    });
                                  },
                                  activeColor: accentColor,
                                )
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.all(8.w),
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                                color: isLight ? lightSecondary : Colors.black,
                                borderRadius: BorderRadius.circular(10)),
                            height: 50.h,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Placeholder',
                                  style: GoogleFonts.rubik(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                CupertinoSwitch(
                                  value: placeholder!,
                                  onChanged: (val) {
                                    setState(() {
                                      placeholder = val;
                                    });
                                  },
                                  activeColor: accentColor,
                                )
                              ],
                            )),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: MaterialButton(
                                color: accentColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                onPressed: () {
                                  if (pics.isNotEmpty &&
                                      airport.text.isNotEmpty &&
                                      brand.text.isNotEmpty &&
                                      planeName.text.isNotEmpty &&
                                      seats.text.isNotEmpty &&
                                      type.toString().isNotEmpty) {
                                    loadingBar('saving data...please wait', true, 4);
                                    savePlane();
                                    Future.delayed(const Duration(seconds: 3), () {
                                      alert('New plane added successfully', 'SUCCESS', context);
                                    });
                                  } else {
                                    loadingBar(
                                        'please provide all detail & select pics for plane', false, 1);
                                  }
                                },
                                elevation: 0,
                                child: Text(
                                  "Save",
                                  style: GoogleFonts.rubik(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: MaterialButton(
                                color: bgColorDark.withOpacity(0.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaneView(userData: widget.userdata))),
                                child: Text(
                                  "Close",
                                  style: GoogleFonts.rubik(),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    //},
    // viewModelBuilder: () => AddPlaneViewModel(),
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
              ),
            ),
            getImmediateSuggestions: true,
            hideSuggestionsOnKeyboardHide: true,
            hideOnEmpty: false,
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

  Widget picWidget(String link, int index) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 90.h,
          backgroundImage: FileImage(File(link)),
          // child: CircleAvatar(radius: 90,
          // backgroundImage: FileImage(img),),
        ),
        Positioned(
            bottom: 0,
            right: 10,
            child: RawMaterialButton(
              onPressed: () {
                setState(() {
                  pics.removeAt(index);
                  imgs.removeAt(index);
                });
              },
              elevation: 2.0,
              fillColor: const Color(0xFFF5F6F9),
              padding: const EdgeInsets.all(10.0),
              shape: const CircleBorder(),
              child: const Icon(
                Icons.delete,
                color: Colors.blue,
              ),
            )),
      ],
    );
  }

  void loadingBar(String content, bool load, int duration) {
    final bar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(content),
          ),
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
                      MaterialPageRoute(builder: (context) => PlaneView(userData: widget.userdata)));
                }),
              ],
            ));
  }
}

// class FormDropDown extends StatelessWidget {
//   const FormDropDown({
//     Key? key,
//     this.items,
//     this.label,
//   }) : super(key: key);

//   final List? items;
//   final String? label;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 331.w,
//       height: 56.h,
//       child: DropdownButtonFormField(
//           // hint: Text(label),
//           decoration: InputDecoration(
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             labelText: label,
//             hintStyle: GoogleFonts.rubik(color: Colors.grey[800]),
//           ),
//           // borderRadius: BorderRadius.circular(10),
//           isExpanded: true,
//           items: items!
//               .map((e) => DropdownMenuItem(
//                     child: Text(e),
//                     value: e,
//                   ))
//               .toList(),
//           onChanged: (dynamic val) {}),
//     );
//   }
// }
