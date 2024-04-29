import 'dart:convert';
import 'dart:typed_data';

import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class CsrWebScreen extends StatefulWidget {
  CsrWebScreen({Key? key}) : super(key: key);

  @override
  State<CsrWebScreen> createState() => _CsrWebScreenState();
}

class _CsrWebScreenState extends State<CsrWebScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
         
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
                    "CSR Web",
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
          url: Uri.parse(
              start_csr_web_api), // 111.93.167.34 , eurovision
          method: 'POST',
          body: Uint8List.fromList(utf8.encode(
              "engineerid=${int.parse(EngineerHome.engDecryptId!)}&complainid=${int.parse(EngineerHome.complain_id!)}")),
        ),
      ),
    );
  }
}
