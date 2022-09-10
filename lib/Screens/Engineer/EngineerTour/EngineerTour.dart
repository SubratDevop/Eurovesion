import 'dart:convert';
import 'dart:typed_data';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../Login/EngineerLogin.dart';

class EngineerTour extends StatelessWidget {
  const EngineerTour({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EngineerTourScreen(),
    );
  }
}

class EngineerTourScreen extends StatefulWidget {
  const EngineerTourScreen({Key? key}) : super(key: key);

  @override
  State<EngineerTourScreen> createState() => _EngineerTourScreenState();
}

class _EngineerTourScreenState extends State<EngineerTourScreen> {
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  var webUrlBody;
  // String returnUrl =
  //     "https://apanabazar.com/Payment_Success/call_back"; // for web view go back to app

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("engTour id " + EngineerHome.engId.toString());
    print("engTour id " + EngineerHome.engineertourId.toString());
    print("engTour id " + EngineerLogin.engineertourId.toString());
    print("TourToken " + EngineerHome.engToken.toString());
    // enginerTourProcess();
  }

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // String callBackUrl =
    //     "http://203.112.143.203/eurovesion/Toursuccess/index"; // 111.93.167.34 , eurovision
    // String callBackUrl = "http://111.93.167.34/eurovision/Toursuccess/index";

    String title, url;
    bool isLoading = true;
    final _key = UniqueKey();

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
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => EngineerHome()));
          },
        ),
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
                    "Tour",
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: themBlueColor,
        child: Icon(
          Icons.arrow_left,
          size: 40,
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .push(MaterialPageRoute(builder: (context) => EngineerHome()));
        },
      ),
      // appBar: AppBar(
      //   backwardsCompatibility: true,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //       statusBarColor: themBlueColor,
      //       statusBarBrightness: Brightness.light,
      //       statusBarIconBrightness: Brightness.light),

      //   backgroundColor: Colors.transparent,
      //   toolbarHeight: height * 0.1,
      //   elevation: 0.0,
      //   title: Align(
      //     alignment: Alignment.topLeft,
      //     child: FittedBox(
      //       child: Padding(
      //         padding: const EdgeInsets.only(left: 10,top: 0),
      //         child: Text("Tour",style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
      //       ),
      //     ),
      //   ),
      //   leading: IconButton(
      //     icon: Icon(
      //       Icons.keyboard_arrow_left,
      //       color: Colors.white,
      //       size: 40,
      //     ),
      //     onPressed: () {
      //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //       Navigator.of(context, rootNavigator: true)
      //           .push(MaterialPageRoute(builder: (context) => EngineerHome()));
      //     },
      //   ),
      // ),
      body: InAppWebView(
        initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(useHybridComposition: true),
            crossPlatform: InAppWebViewOptions(
                // useOnLoadResource: true,
                // allowFileAccessFromFileURLs: true,
                // useShouldInterceptAjaxRequest: true,
                // allowUniversalAccessFromFileURLs: true,
                // clearCache: true,
                javaScriptCanOpenWindowsAutomatically:
                    true, //engineerStratTourApi
                javaScriptEnabled: true)),
        initialUrlRequest: URLRequest(
          // url: Uri.parse(
          //     "http://111.93.167.34/eurovision/Api/start_tour_api"), //111.93.167.34  eurovision

          url: Uri.parse(engineerStratTourApi), //111.93.167.34  eurovision
          method: 'POST',
          body: Uint8List.fromList(utf8.encode(
              "token=${EngineerHome.engToken.toString()}&engineerid=${EngineerHome.engineertourId.toString()}")),
          //8  ${EngineerLogin.engineertourId.toString()}
          // "token=${EngineerHome.engToken.toString()}&engineerid=${EngineerHome.engId.toString()}")),
        ),
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          setState(() {
            if (url.toString() == tourSuccessApi) {//! callback Url
              print("mmmmmmmmmmmmmmmmmmmmmmmmm " + "Url matched");

              //close the webview
              //webView.goBack();

              //navigate to the desired screen with arguments
              Timer(
                  Duration(seconds: 1),
                  () => Navigator.of(context, rootNavigator: true).push(
                      MaterialPageRoute(builder: (context) => EngineerHome())));
            }
          });
        },
      ),
   
    );
  }
}
