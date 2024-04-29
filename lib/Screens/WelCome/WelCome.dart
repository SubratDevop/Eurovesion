import 'dart:io';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/Login/EngineerLogin.dart';
import 'package:eurovision/Screens/WelCome/Webview.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Welcome extends StatelessWidget {
  static String? iniTialVideoId;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelComeScreen(),
    );
  }
}

class WelComeScreen extends StatefulWidget {
  @override
  _WelComeScreenState createState() => _WelComeScreenState();
}

class _WelComeScreenState extends State<WelComeScreen> {
  Map<String, dynamic> appImageVideo = {};
  String? iniTialVideoId;
  YoutubePlayerController? mYoutubePlayerController;
  YoutubeMetaData? _videoMetadata;
  bool _isPlayerReady = false;
  PlayerState? _playerState;

  Future fethAppImageVideos() async {
    final String appImageVideoUrl = appImageVideoApi;

    var response = await http.get(Uri.parse(appImageVideoUrl));

    if (response.statusCode == 200) {
      var items = convert.json.decode(response.body)['data'] ?? [];
      setState(() {
        appImageVideo = items;

        // get video id

        String videoURL = appImageVideo["video"].toString();

        String? videoID = YoutubePlayer.convertUrlToId(videoURL);
        Welcome.iniTialVideoId = videoID;
        print(iniTialVideoId);
      });
    } else {
      print(response.body);
      throw Exception('Failed to fetch images and videos.');
    }

    // return AppImageVideoMOdel.fromJson(json.decode(response.body));
  }

  void navigateCustomer() async {
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    var user = userPrefs.getString("user");

    if (user == null) {
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => CustomerLogin()));
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => CustomerLogin(),
      //   ),
      // );
    }
    if (user == "customer") {
      // navigateCustomer();
      // Navigator.of(context, rootNavigator: true)
      //     .push(MaterialPageRoute(builder: (context) => CustomerHome()));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerHome(),
        ),
      );
    }

    if (user == "eng") {
      navigateEngineer();
      // Navigator.of(context, rootNavigator: false)
      //     .push(MaterialPageRoute(builder: (context) => CustomerLogin()));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CustomerLogin(),
        ),
      );
    }
  }

  void navigateEngineer() async {
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    var user = userPrefs.getString("user");

    if (user == null) {
      // Navigator.of(context, rootNavigator: true)
      // .push(MaterialPageRoute(builder: (context) => EngineerLogin(),),);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EngineerLogin(),
        ),
      );
    }
    if (user == "customer") {
      navigateCustomer();
      // Navigator.of(context, rootNavigator: true)
      //     .push(MaterialPageRoute(builder: (context) => EngineerLogin()));
    }

    if (user == "eng") {
      // navigateEngineer();
      Navigator.of(context, rootNavigator: true)
          .push(MaterialPageRoute(builder: (context) => EngineerHome()));
    }
  }

  // ! BackButtonInterceptor
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    exit(0);

    // return true;
  }

  @override
  void initState() {
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);

    fethAppImageVideos();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);

//! Set landscape orientation
// SystemChrome.setPreferredOrientations([
//   DeviceOrientation.landscapeLeft,
//   DeviceOrientation.landscapeRight,
// ]);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    void listener() {
      if (_isPlayerReady &&
          mounted &&
          mYoutubePlayerController!.value.isFullScreen) {
        setState(() {
          _playerState = mYoutubePlayerController!.value.playerState;
          _videoMetadata = mYoutubePlayerController!.metadata;
        });
      }
    }

    return Scaffold(
      backgroundColor: themWhiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
         
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        toolbarHeight: height * 0.1,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Center(
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 30),
              child: Text(
                "Banking Automation",
                style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
            ),
          ),
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
                    "Welcome To Eurovesion Systems",
                    style: TextStyle(
                        fontFamily: 'TimesNewRoman',
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Container(
              width: width,
              height: height,
              child: Column(
                children: [
                  Container(
                    width: width,
                    height: height * 0.8,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(top: 0, right: 2, left: 2),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                color: themWhiteColor,
                                width: width,
                                height: height * 0.25,
                                child: Column(
                                  children: [
                                    Container(
                                        width: width,
                                        height: height * 0.22,
                                        child:
                                            appImageVideo["firstimage"] != null
                                                ? Image.network(
                                                    "${appImageVideo["firstimage"]}",
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: themBlueColor,
                                                    ),
                                                  )

                                        // Image.asset("assets/images/welcome1.png",
                                        // fit: BoxFit.cover,
                                        ),
                                    Container(
                                      width: width,
                                      height: height * 0.03,
                                      color: Colors.black54,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: FittedBox(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: appImageVideo['firsttext'] ==
                                                    null
                                                ? Text("")
                                                : Text(
                                                    appImageVideo['firsttext'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'AkayaKanadaka',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themWhiteColor),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Container(
                                color: themWhiteColor,
                                width: width,
                                height: height * 0.25,
                                child: Column(
                                  children: [
                                    Container(
                                        width: width,
                                        height: height * 0.22,
                                        child:
                                            appImageVideo["secondimage"] != null
                                                ? Image.network(
                                                    "${appImageVideo["secondimage"]}",
                                                    fit: BoxFit.cover,
                                                  )
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: themBlueColor,
                                                    ),
                                                  )

                                        // Image.asset("assets/images/welcome1.png",
                                        // fit: BoxFit.cover,
                                        ),
                                    Container(
                                      width: width,
                                      height: height * 0.03,
                                      color: Colors.black54,
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: FittedBox(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: appImageVideo[
                                                        'secondtext'] ==
                                                    null
                                                ? Text("")
                                                : Text(
                                                    appImageVideo['secondtext'],
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'AkayaKanadaka',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themWhiteColor),
                                                  ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 15,
                              ),

                              Welcome.iniTialVideoId != null
                                  ? Container(
                                      child: YoutubePlayerBuilder(
                                      builder: (context, player) {
                                        return player;
                                      },
                                      player: YoutubePlayer(
                                        showVideoProgressIndicator: true,
                                        progressIndicatorColor: themWhiteColor,
                                        controller: YoutubePlayerController(
                                          initialVideoId:
                                              Welcome.iniTialVideoId!,
                                          flags: const YoutubePlayerFlags(
                                              autoPlay: false,
                                              mute: false,
                                              isLive: false,
                                              forceHD: false),
                                        ),
                                        onReady: () {
                                          // mYoutubePlayerController!.addListener(listener);
                                        },
                                      ),
                                    ))
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: themBlueColor,
                                      ),
                                    )

                              // InkWell(
                              //   onTap: (){
                              //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>YouTube()));
                              //   },
                              //   child: Container(
                              //     color: themWhiteColor,
                              //     width: width,
                              //     height: height*0.19,
                              //     child: Column(
                              //       children: [
                              //         Container(
                              //           width: width,
                              //           height: height*0.15,
                              //           child: Image.asset("assets/images/youtube.png",
                              //           fit: BoxFit.cover,
                              //           ),
                              //         ),

                              //         Container(
                              //           width: width,
                              //           height: height*0.04,
                              //           color: Colors.black54,
                              //           child: Align(
                              //             alignment: Alignment.bottomLeft,
                              //             child: FittedBox(
                              //               child: Padding(
                              //                 padding: const EdgeInsets.only(left: 10),
                              //                 child: Text("Service Video",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
                              //               ),
                              //             ),
                              //           ),
                              //         )

                              //       ],

                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    height: height * 0.05,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        color: themWhiteColor,
                        width: width,
                        height: height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: SizedBox(
                                width: width * 0.49,
                                height: 50,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: themBlueColor,
                                        // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      navigateCustomer();
                                    },
                                    child: Text("Customer")),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: SizedBox(
                                // height: 50,
                                width: width * 0.49,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: themBlueColor,
                                        // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                                        textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    onPressed: () {
                                      navigateEngineer();
                                    },
                                    child: Text("Engineer")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40, right: 5),
        child: FloatingActionButton(
          backgroundColor: themBlueColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebviewPage(),
                ));
          },
          child: Container(
              padding: EdgeInsets.only(left: 1, bottom: 2),
              child: Text(
                "Buy\nNow",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
                color: Colors.white),
              )),
        ),
      ),
    );
  }
}
