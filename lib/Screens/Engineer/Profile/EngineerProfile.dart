import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/Model/EngineerModel/EngineerProfileEdit.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/Profile/EngineerProfileEdit.dart';
import 'package:eurovision/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class EngineerProfile extends StatelessWidget {
  static String? name,
      employeeType,
      contactNo,
      email,
      address,
      image,
      branchName,
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
      home: EngineerProfileScreen(),
    );
  }
}

class EngineerProfileScreen extends StatefulWidget {
  @override
  _EngineerProfileScreenState createState() => _EngineerProfileScreenState();
}

class _EngineerProfileScreenState extends State<EngineerProfileScreen> {
  Uint8List? bytes;
  String? profileImage;
  File? imageFile;

  Future<EngineerProfileEditModel> profileEditProcess() async {
    // var img = List.from(bytes).expand((i) => i).toList();
    print("eng id " + EngineerHome.engId.toString());
    print("token " + EngineerHome.engToken.toString());
    print("engineername sitanshu");
    print("engineeremail developersitu@gmail.com");
    print("engineermobile 7008323469");

    String engineerProfileEdit_url = engineerProfileEditApi;

    final http.Response response = await http.post(
      Uri.parse(engineerProfileEdit_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "engineerid": EngineerHome.engId.toString(),
        "token": EngineerHome.engToken.toString(),
        "engineername": "sitanshu",
        "engineeremail": "developersitu@gmail.com",
        "engineermobile": "7008323469",
        "engineerimage": base64Encode(bytes!),
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      var profileImage = responseBody['engineerimage'];

      print("profileImage  " + profileImage.toString());
      SharedPreferences engPrefs = await SharedPreferences.getInstance();

      setState(() {
        engPrefs.setString("profileImage", profileImage.toString());
        EngineerProfile.profileImage = engPrefs.getString("profileImage");
      });

      print('Profile update body');
      print(response.body);

      print('Profile update body');
      print(response.body);

      return EngineerProfileEditModel.fromJson(json.decode(response.body));
    } else {
      print('Profile update body');
      print(response.body);

      throw Exception('Failed to create album.');
    }
  }

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
      SharedPreferences engPrefs = await SharedPreferences.getInstance();

      setState(() {
        profileImage = response.engineerimage;
        engPrefs.setString("profileImage", profileImage.toString());
        EngineerProfile.profileImage = engPrefs.getString("profileImage");
      });
      print("Profile image " + profileImage.toString());
    }
  }

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
      SharedPreferences engPrefs = await SharedPreferences.getInstance();

      setState(() {
        profileImage = response.engineerimage;
        engPrefs.setString("profileImage", profileImage.toString());
        EngineerProfile.profileImage = engPrefs.getString("profileImage");
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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  MaterialPageRoute(builder: (context) => EngineerHome()));
            },
          ),
        ),
        
        endDrawer: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: EngineerDrawer()),
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
                        child: EngineerProfile.profileImage == null
                            ? CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage:
                                      AssetImage("assets/images/profile1.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                              )
                            : CircleAvatar(
                                radius: 105,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 100.0,
                                  backgroundImage: NetworkImage(
                                      EngineerProfile.profileImage.toString()),
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
                                        onPressed: () async {
                                          // var response= await profileEditProcess();
                                          // bool res =response.status;

                                          // print("eng edit "+res.toString());

                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EngineerProfileEdit()));
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
                              child: Text(EngineerProfile.name.toString(),
                                  style: TextStyle(
                                      fontFamily: 'TimesNewRoman',
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      color: themWhiteColor))),
                          FittedBox(
                              child: Text(
                                  EngineerProfile.employeeType.toString(),
                                  style: TextStyle(
                                      fontFamily: 'TimesNEwRoman',
                                      fontSize: 30,
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
                          // Align(
                          //   alignment: Alignment.topRight,
                          // FittedBox(child: Text( CustomerProfileEdit.name.toString() == null ? CustomerHome.name.toString() : CustomerProfileEdit.name.toString(),style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))),
                          // ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Text( CustomerHome.customerTypeName.toString(),style: TextStyle(fontFamily: 'DancingScript',fontSize: 35,fontWeight: FontWeight.w700,color: themWhiteColor))
                          // ),

                          // SizedBox(
                          //   height: 50,
                          // ),

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
                                  child: Text("${EngineerProfile.contactNo}",
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
                                  child: Text("${EngineerProfile.email}",
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
                                  child: Text("${EngineerProfile.address}",
                                      style: TextStyle(
                                          fontFamily: 'Righteous',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black45)))

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
    SharedPreferences engPrefs = await SharedPreferences.getInstance();

    setState(() {
      EngineerProfile.email = engPrefs.getString("email");
      EngineerProfile.contactNo = engPrefs.getString("contact");
      EngineerProfile.name = engPrefs.getString("name");
      EngineerHome.engToken = engPrefs.getString("token");
      EngineerHome.engId = engPrefs.getString("engineerId");
      EngineerProfile.branchName = engPrefs.getString("branchname");
      EngineerProfile.employeeType = engPrefs.getString("employeeType");
      EngineerProfile.address = engPrefs.getString("branchaddress");
      EngineerProfile.profileImage = engPrefs.getString("profileImage");
    });

    print("update profile  " + EngineerProfile.name.toString());
  }
}
