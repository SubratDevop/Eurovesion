import 'dart:convert';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/Model/CustomerModel/CustomerComplainCountModel.dart';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CustomerCompletedComplain.dart';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CustomerPendingComplain.dart';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CustomerTotalComplain.dart';
import 'package:eurovision/Screens/Customer/CustomerCreateComplain/CustomerCreateComplain.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomerHome extends StatelessWidget {
  static String? customerId,
      customerToken,
      customerName,
      customerEmail,
      customerContact,
      customerCode,
      customerTypeName,
      customerAddress,
      customerGst;
  static late String totalComplain, pendingComplain, completedComplain;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //// Greeting Message started
  var timeNow;
  String? greetingMessageStatus;

  String greetingMessage() {
    var timeNow = DateTime.now().hour;

    if (timeNow <= 12) {
      return 'Good Morning';
    } else if ((timeNow > 12) && (timeNow <= 16)) {
      return 'Good Afternoon';
    } else if ((timeNow > 16) && (timeNow < 20)) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }

  void upDateGreetingMessageAccordingToTime() {
    setState(() {
      greetingMessageStatus = greetingMessage();
    });
  }
  ///////////////// Greeting Message ended

  bool isLoading = false;

  Future<CustomerComplainCountModel> customerComplainCountProcess() async {
    setState(() {
      isLoading = true;
    });

    print("customer id " + CustomerHome.customerId.toString());
    print("token " + CustomerHome.customerToken.toString());

    String customerComplainCount_url = customerComplainCountApi;
    final http.Response response = await http.post(
      Uri.parse(customerComplainCount_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "customerid": CustomerHome.customerId.toString(),
        "token": CustomerHome.customerToken.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("home ////////" + response.body);

      var totalComplain =
          json.decode(response.body)['data'][0]['total_complain'];
      var totalPendingComplain =
          json.decode(response.body)['data'][1]['total_pending_complain'];
      var totalCompletedComplain =
          json.decode(response.body)['data'][2]['total_completed_complain'];

      // int totalPendingComplain=json.decode(response.body)['data']['1']['total_pending_complain'] as int;
      // int totalCompletedComplain=json.decode(response.body)['data']['2']['total_completed_complain'] as int;

      print("totalComplain ////////" + totalComplain.toString());
      print("totalPendingComplain ////////" + totalPendingComplain.toString());
      print("totalCompletedComplain ////////" +
          totalCompletedComplain.toString());

      setState(() {
        CustomerHome.totalComplain = totalComplain.toString();
        CustomerHome.pendingComplain = totalPendingComplain.toString();
        CustomerHome.completedComplain = totalCompletedComplain.toString();

        isLoading = false;
      });

      return CustomerComplainCountModel.fromJson(json.decode(response.body));
    } else {
      isLoading = false;

      // Fluttertoast.showToast(
      //   msg: "Please Check Login Credentials",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to create album.');
    }
  }

  // ! BackButtonInterceptor
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Fluttertoast.showToast(
        msg: 'Back Button Clicked',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: themBlueColor);

    return false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    greetingMessage();
    upDateGreetingMessageAccordingToTime();
    // BackButtonInterceptor.add(myInterceptor);

    getLoginCredentials();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light); // 1

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// screen Orientation end///////////

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Theme(
      data: ThemeData(
          //primaryIconTheme: IconThemeData(color: Colors.white)
          ),
      child: Scaffold(
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: themBlueColor,
        //   child: Text("Items"),
        //   onPressed: (){
        //   Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerItems()));
        // },),

        backgroundColor: themWhiteColor,

        appBar: AppBar(
           
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: themBlueColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),

          backgroundColor: themBlueColor,
          toolbarHeight: height * 0.15,
          elevation: 0.0,
          title: Column(
            children: [
              Text(
                "WELCOME TO EUROVESION",
                style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 23,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                            "Hi , " +
                                CustomerHome.customerName.toString() +
                                " " +
                                "!!" +
                                "   " +
                                greetingMessageStatus!,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'RobotoMono',
                                fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ],
          ),

          // leading: IconButton(
          //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          //   onPressed: (){
          //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
          //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));
          //   },
          // ),

          bottom: PreferredSize(
              child: Container(
                color: Colors.orange,
                height: 4.0,
              ),
              preferredSize: Size.fromHeight(4.0)),
        ),

        endDrawer: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: CustomerDrawer()),

        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowIndicator();
            return false;
          },
          child: Container(
            child: Column(
              children: [
                Container(
                    width: width,
                    height: height * 0.05,
                    alignment: Alignment.topRight,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Create Complain",
                              style: TextStyle(
                                  fontFamily: 'Righteous',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.red)),
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CustomerCreateComplain()));
                            },
                            child: Center(
                              child: new Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20.0,
                              ),
                            ),
                            // shape: new CircleBorder(),
                            shape: new CircleBorder(),
                            elevation: 10.0,
                            fillColor: Colors.orange,
                            padding: const EdgeInsets.all(4.0),
                          ),
                        ])),

                isLoading
                    ? new Center(child: new CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 0),
                                child: Container(
                                  width: width * 0.9,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerTotalComplain()));
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          height: height * 0.2,
                                          color: Colors.blueAccent,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.blue
                                                        .withOpacity(0.2),
                                                    offset: Offset(0, 25),
                                                    blurRadius: 6,
                                                    spreadRadius: -5)
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      "Total Complains",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      CustomerHome.totalComplain
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerPendingComplain()));
                                        },
                                        child: Container(
                                          width: width * 0.4,
                                          height: height * 0.2,
                                          color: Colors.red,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(2),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors.red
                                                        .withOpacity(0.2),
                                                    offset: Offset(0, 25),
                                                    blurRadius: 6,
                                                    spreadRadius: -5)
                                              ],
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      "Pending Complains",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 25,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      CustomerHome.pendingComplain
                                                                  .toString() ==
                                                              null
                                                          ? ""
                                                          : CustomerHome
                                                              .pendingComplain
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 30,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                  SizedBox(height: 20),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 5, right: 5),
                                                    child: FittedBox(
                                                        child: Text(
                                                      "View",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              themWhiteColor),
                                                    )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerCompletedComplain()));
                                      },
                                      child: Container(
                                        width: width * 0.4,
                                        height: height * 0.2,
                                        color: Colors.green,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.green
                                                      .withOpacity(0.2),
                                                  offset: Offset(0, 25),
                                                  blurRadius: 6,
                                                  spreadRadius: -5)
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 20),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: FittedBox(
                                                      child: Text(
                                                    "Completed Complains",
                                                    style: TextStyle(
                                                        fontFamily: 'Righteous',
                                                        fontSize: 25,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themWhiteColor),
                                                  )),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: FittedBox(
                                                      child: Text(
                                                    CustomerHome
                                                        .completedComplain
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Righteous',
                                                        fontSize: 30,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themWhiteColor),
                                                  )),
                                                ),
                                                SizedBox(height: 20),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, right: 5),
                                                  child: FittedBox(
                                                      child: Text(
                                                    "View",
                                                    style: TextStyle(
                                                        fontFamily: 'Righteous',
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: themWhiteColor),
                                                  )),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )

                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                //       color: themWhiteColor
                //     ),

                //     child: Padding(
                //       padding: const EdgeInsets.only(bottom: 20),
                //       child: SingleChildScrollView(
                //         child: Container(
                //           width: width,

                //           child: Column(
                //             children: [

                //               Padding(
                //                 padding: const EdgeInsets.only(top: 30),
                //                 child: Container(
                //                   width: width*0.9,
                //                   child: Row(
                //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //                     children: [

                //                       Container(
                //                         width: width*0.4,
                //                         height: height*0.2,
                //                         color: Colors.blueAccent,
                //                       ),

                //                       Container(
                //                         width: width*0.4,
                //                         height: height*0.2,
                //                         color: Colors.red,
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ),

                //               Padding(
                //                 padding: EdgeInsets.only(top: 40),

                //                 child: Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   children: [

                //                     Container(
                //                       width: width*0.4,
                //                       height: height*0.2,
                //                       color: Colors.green,
                //                     ),

                //                   ],
                //                 ),
                //               ),

                //             ],
                //           ) ,
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getLoginCredentials() async {
    SharedPreferences customerPrefs = await SharedPreferences.getInstance();

    print(
        "id .............." + customerPrefs.getString("customerId").toString());

    setState(() {
      CustomerHome.customerName = customerPrefs.getString("name");
      CustomerHome.customerToken = customerPrefs.getString("token");
      CustomerHome.customerId = customerPrefs.getString("customerId");
      CustomerHome.customerEmail = customerPrefs.getString("email");
      CustomerHome.customerContact = customerPrefs.getString("contact");
      CustomerHome.customerCode = customerPrefs.getString("customerCode");
      CustomerHome.customerTypeName =
          customerPrefs.getString("customerTypeName");
      CustomerHome.customerAddress = customerPrefs.getString("customerAddress");
      CustomerHome.customerGst = customerPrefs.getString("gst");
    });
    print("customer id .............." + CustomerHome.customerId.toString());

    if (CustomerHome.customerId != null && CustomerHome.customerToken != null) {
      customerComplainCountProcess();
    }
  }
}
