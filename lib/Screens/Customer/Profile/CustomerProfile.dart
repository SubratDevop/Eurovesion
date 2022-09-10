import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/Model/CustomerModel/CustomerProfileEditModel.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/Profile/CustomerProfileEdit.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfile extends StatelessWidget {
  static String? name,
      customerType,
      contactNo,
      email,
      address,
      gst,
      image,
      profileImage;

  @override
  Widget build(BuildContext context) {
    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// screen Orientation end///////////

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: customerProfileScreen(),
    );
  }
}

class customerProfileScreen extends StatefulWidget {
  @override
  _customerProfileScreenState createState() => _customerProfileScreenState();
}

class _customerProfileScreenState extends State<customerProfileScreen> {
  Uint8List? bytes;
  String? profileImage;
  File? imageFile;
//! profileEditProcess
  Future<CustomerProfileEditModel> profileEditProcess() async {
    String customerEditPrifile_url = customerProfileEditApi;

    final http.Response response = await http.post(
      Uri.parse(customerEditPrifile_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        'customerid': CustomerHome.customerId.toString(),
        'token': CustomerHome.customerToken.toString(),
        'customer_name': CustomerProfile.name.toString(),
        'customer_address': CustomerProfile.address.toString(),
        'customer_email': CustomerProfile.email.toString(),
        'customer_phone': CustomerProfile.contactNo.toString(),
        'customer_image': base64Encode(bytes!)
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      var profileImage = responseBody['customerimage'];

      print("profileImage  " + profileImage.toString());
      SharedPreferences customerPrefs = await SharedPreferences.getInstance();

      setState(() {
        customerPrefs.setString("profileImage", profileImage.toString());
        CustomerProfile.profileImage = customerPrefs.getString("profileImage");
      });

      print('Profile update body');
      print(response.body);

      return CustomerProfileEditModel.fromJson(json.decode(response.body));
    } else {
      print('Profile update body');
      print(response.body);
      throw Exception('Failed to create album.');
    }
  }

//! Open Gallery
  void _openGallery() async {
    final pickedFileGalery =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFileGalery != null) {
      setState(
        () {
          imageFile = File(pickedFileGalery.path);
        },
      );

      bytes = imageFile!.readAsBytesSync();

      var response = await profileEditProcess();
      SharedPreferences customerPrefs = await SharedPreferences.getInstance();

      setState(() {
        profileImage = response.customerimage;
        customerPrefs.setString("profileImage", profileImage.toString());
        CustomerProfile.profileImage = customerPrefs.getString("profileImage");
      });
      print("Profile image " + profileImage.toString());
    }
  }

//! Open Camera
  void _openCamera() async {
    final pickedFileCamera =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFileCamera != null) {
      setState(
        () {
          imageFile = File(pickedFileCamera.path);
        },
      );

      bytes = imageFile!.readAsBytesSync();

      var response = await profileEditProcess();
      SharedPreferences customerPrefs = await SharedPreferences.getInstance();

      setState(() {
        profileImage = response.customerimage;
        customerPrefs.setString("profileImage", profileImage.toString());
        CustomerProfile.profileImage = customerPrefs.getString("profileImage");
      });
      print("Profile image " + profileImage.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UpdateProfile();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: themBlueColor,
        appBar: AppBar(
          backwardsCompatibility: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: themBlueColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: themBlueColor,
          elevation: 0.0,
          title: Center(
            child: Text(
              'Profile',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'TimesNewRoman',
                  fontWeight: FontWeight.w800,
                  fontSize: 30),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.keyboard_arrow_left,
              color: Colors.white,
              size: 40,
            ),
            onPressed: () {
              //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => CustomerHome()));
            },
          ),
        ),
        endDrawer: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: CustomerDrawer()),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: width,
                  height: height * 0.5,
                  color: themBlueColor,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, left: 10),
                        child: CustomerProfile.profileImage == null
                            ? CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage: AssetImage(
                                      "assets/images/profile1.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage: NetworkImage(
                                      CustomerProfile.profileImage
                                          .toString()),
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          width: width * 0.3,
                          height: height * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          _openCamera();
                                        },
                                        icon: Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                        )),
                                    Text("Camera",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: themWhiteColor))
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          // chooseImage(ImageSource.gallery);
                                          _openGallery();
                                        },
                                        icon: Icon(
                                          Icons.image,
                                          color: Colors.white,
                                        )),
                                    Text("Gallery",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: themWhiteColor))
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerProfileEdit()));
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )),
                                    Text("Edit",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: themWhiteColor))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.1,
                  color: themBlueColor,
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 10),
                    child: FittedBox(
                      child: Column(
                        children: [
                          FittedBox(
                              child: Text(CustomerProfile.name.toString(),
                                  style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: themWhiteColor))),
                          FittedBox(
                              child: Text(
                                  CustomerProfile.customerType.toString(),
                                  style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: themWhiteColor))),
                          // Text( CustomerProfileEdit.customerType.toString() == null ? CustomerHome.customerTypeName.toString() : CustomerProfileEdit.customerType.toString(),style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: width,
                  height: height * 0.4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: themWhiteColor,
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Container(
                      width: width,
                      height: height * 0.3,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.phone,
                                      color: themWhiteColor,
                                    ),
                                    Text("Contact No:",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87))
                                  ],
                                ),
                              ),

                              FittedBox(
                                  child: Text("${CustomerProfile.contactNo}",
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45)))
                              //FittedBox(child: Text(CustomerProfile.contactNo== null ? CustomerHome.contact.toString() : CustomerProfile.contactNo.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      color: themWhiteColor,
                                    ),
                                    Text("Email:",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87))
                                  ],
                                ),
                              ),

                              FittedBox(
                                  child: Text("${CustomerProfile.email}",
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45)))

                              //FittedBox(child: Text( CustomerProfile.email== null ? CustomerHome.email.toString() : CustomerProfile.email.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      color: themWhiteColor,
                                    ),
                                    Text("Address:",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87))
                                  ],
                                ),
                              ),

                              FittedBox(
                                  child: Text("${CustomerProfile.address}",
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45)))

                              // FittedBox(child: Text( CustomerProfile.address== null ? CustomerHome.customerAddress.toString() : CustomerProfileEdit.address.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45)))
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.location_city,
                                      color: themWhiteColor,
                                    ),
                                    Text("Gst no:",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.black87))
                                  ],
                                ),
                              ),

                              FittedBox(
                                child: CustomerProfile.gst == ""
                                    ? Text(
                                        "-",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black45),
                                      )
                                    : Text(
                                        "${CustomerProfile.gst}",
                                        style: TextStyle(
                                            fontFamily: 'Righteous',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black45),
                                      ),
                              )

                              // FittedBox(child: Text( CustomerProfile.address== null ? CustomerHome.customerAddress.toString() : CustomerProfileEdit.address.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45)))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  void UpdateProfile() async {
    SharedPreferences customerPrefs = await SharedPreferences.getInstance();

    setState(() {
      CustomerProfile.email = customerPrefs.getString("email");
      CustomerProfile.contactNo = customerPrefs.getString("contact");
      CustomerProfile.name = customerPrefs.getString("name");
      CustomerHome.customerToken = customerPrefs.getString("token");
      CustomerHome.customerId = customerPrefs.getString("customerId");
      CustomerHome.customerCode = customerPrefs.getString("customerCode");
      CustomerProfile.customerType =
          customerPrefs.getString("customerTypeName");
      CustomerProfile.address = customerPrefs.getString("customerAddress");
      CustomerProfile.gst = customerPrefs.getString("gst");
      CustomerProfile.profileImage = customerPrefs.getString("profileImage");
    });
  }
}
