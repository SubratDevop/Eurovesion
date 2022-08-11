import 'dart:convert';
import 'dart:typed_data';
import 'package:ev_testing_app/Api/Api.dart';
import 'package:ev_testing_app/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerTour/EngineerTourList.dart';
import 'package:ev_testing_app/Screens/Engineer/Home/EngineerHome.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class EngineerTourEdit extends StatelessWidget {
  const EngineerTourEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EngineerTourEditScreen();
  }
}

class EngineerTourEditScreen extends StatefulWidget {
  EngineerTourEditScreen({Key? key}) : super(key: key);

  @override
  State<EngineerTourEditScreen> createState() => _EngineerTourEditScreenState();
}

class _EngineerTourEditScreenState extends State<EngineerTourEditScreen> {
  String? url;

  // Future enginnerTourEditProcess() async {

  //   String engineerStartTourEditUrl = engineerStartTourEditApi;
  //   final http.Response response = await http.post(
  //     Uri.parse(engineerStartTourEditUrl),
  //     headers: <String, String>{
  //       // 'Accept': 'application/json',
  //       // 'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     },

  //     body: {
  //       "engineerid": AesEncryption.encryptAES(EngineerHome.engId.toString()),
  //       "tourid": AesEncryption.encryptAES(EngineerTourList.tourid.toString()),
  //       "token": EngineerHome.engToken
  //     },
  //     // body: {
  //     //   'email': email,
  //     //   'password': password,
  //     // }
  //   );

  //   if (response.statusCode == 200) {
  //    print(response.body);
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "${response.reasonPhrase}",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.green,
  //         textColor: Colors.white,
  //         fontSize: 16.0);

  //     throw Exception('Failed to edit tour.');
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(EngineerTourList.tourid);
    print("tourid+ ${EngineerTourList.tourid}");
    print("tourid+ ${EngineerHome.engineertourId}");
    print("engineerid+ ${EngineerHome.engId}");
    print("token+ ${EngineerHome.engToken}");
// enginnerTourEditProcess();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    String engineerStartTourEditUrl = engineerStartTourEditApi;

    return Scaffold(
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),

        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.1,
        elevation: 0.0,
        // title: Align(
        //   alignment: Alignment.topLeft,
        //   child: FittedBox(
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 10,top: 0),
        //       child: Text("CSR List",style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
        //     ),
        //   ),
        // ),
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.keyboard_arrow_left,
        //     color: Colors.white,
        //     size: 40,
        //   ),
        //   onPressed: () {
        //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
        //     Navigator.of(context, rootNavigator: true).push(
        //         MaterialPageRoute(builder: (context) => EngineerHome()));
        //   },
        // ),
        flexibleSpace: ClipPath(
          clipper: Customshape(),
          child: Container(
            //height: height*0.2,
            width: MediaQuery.of(context).size.width,
            color: themBlueColor,
            child: Center(
              child: FittedBox(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    "Tour Edit",
                    style: TextStyle(
                        fontFamily: 'AkayaKanadaka',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: themWhiteColor),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
            crossPlatform: InAppWebViewOptions(
                javaScriptCanOpenWindowsAutomatically: true,
                javaScriptEnabled: true)),
        initialUrlRequest: URLRequest(
          url:
           Uri.parse("http://111.93.167.34/eurovision/Api/start_tour_edit_api/"),// 111.93.167.34 , eurovision
          method: 'POST',
          body: Uint8List.fromList(utf8.encode(
              "engineerid=${EngineerHome.engId.toString()}&tourid=${EngineerTourList.tourid.toString()}&token=${EngineerHome.engToken.toString()}")),
        ),
      ),
    );
  
  }
}
