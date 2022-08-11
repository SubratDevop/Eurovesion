import 'dart:convert';
import 'package:ev_testing_app/AES256encryption/Encrypted.dart';
import 'package:ev_testing_app/Api/Api.dart';
import 'package:ev_testing_app/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:ev_testing_app/Screens/Engineer/CustomerServiceReport/CustomerServiceReportPdfView.dart';
import 'package:ev_testing_app/Screens/Engineer/CustomerServiceReport/EditCustomerServiceReport.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerTour/EngineerTour.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerTour/EngineerTourEdit.dart';
import 'package:ev_testing_app/Screens/Engineer/Home/EngineerHome.dart';
import 'package:ev_testing_app/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:url_launcher/url_launcher.dart';

import 'EngineerTourLIstPdfView.dart';

class EngineerTourList extends StatelessWidget {
  static String? depDate, deptime, grandTotal, teritory, pdflink,tourid;

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
      home: EngineerTourListScreen(),
    );
  }
}

class EngineerTourListScreen extends StatefulWidget {
  const EngineerTourListScreen({Key? key}) : super(key: key);

  @override
  _CustomerServiceReportListScreenState createState() =>
      _CustomerServiceReportListScreenState();
}

class _CustomerServiceReportListScreenState
    extends State<EngineerTourListScreen> {

  List showTourCsrList = [];
  fetchTourCSRList() async {
    var TourList_url = engineerTourListApi;

    var response = await http.post(
      Uri.parse(TourList_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        // "engineer_id": EngineerHome.engId.toString()
        "engineerid": EngineerHome.engId.toString(),
        "token": EngineerHome.engToken.toString(),
      },
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('all Tour list body');
      print(items);

      setState(() {
        showTourCsrList = items;
      });

      print("CSR List " + showTourCsrList.toString());

      if (showTourCsrList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showTourCsrList = [];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTourCSRList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: themWhiteColor,
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
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => EngineerHome()));
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
                      "Tour List",
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
        endDrawer: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: EngineerDrawer()),
        body: showTourCsrList.length == 0
            ? Center(
                child: Text(
                  "No Tour Available... ",
                  style: TextStyle(
                      fontFamily: 'AkayaKanadaka',
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45),
                ),
              )
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowGlow();
                  return false;
                },
                child: Column(mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                 Container(
              width: width,
              height: height * 0.05,
              alignment: Alignment.topRight,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Create a new tour",
                    style: TextStyle(
                        fontFamily: 'Righteous',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.red)),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => EngineerTour()));
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
              ]),
            ),
                        Expanded(
                      child: ListView.builder(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: showTourCsrList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: InkWell(
                                onTap: () {
                                  setState(() {
                                    EngineerTourList.depDate =
                                        showTourCsrList[index]['depdate'].toString();
                                    EngineerTourList.deptime =
                                        showTourCsrList[index]['deptime'].toString();
                                    EngineerTourList.grandTotal =
                                        showTourCsrList[index]['grandtotal']
                                            .toString();
                                    EngineerTourList.teritory =
                                        showTourCsrList[index]['teritory'].toString();
                                  });
                    
                                  print("Service +++++++++++++++++++++++++" +
                                      showTourCsrList[index]['servicetypename']
                                          .toString());
                    
                                  // Navigator.of(context, rootNavigator: true).push(
                                  //     MaterialPageRoute(
                                  //         builder: (context) =>
                                  //             EditCustomerServiceReport()));
                                },
                                child: IntrinsicHeight(
                                  child: Container(
                                    width: width,
                                    height: height * 0.315, //0.24
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      color: themWhiteColor,
                                      elevation: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            ListTile(
                                              // leading: Image.asset("assets/images/csr_list.png",height: 100,width:100,color: Colors.black45,),
                                              //leading: ,
                                              title: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Image.asset(
                                                        "assets/images/csr_list.png",
                                                        height: 50,
                                                        width: 50,
                                                        color: Colors.black45,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Departure date",
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // Icon(Icons.lock_clock),
                                                      Text(
                                                        showTourCsrList[index]
                                                                ['depdate']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Departure Time",
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // Icon(Icons.lock_clock),
                                                      Text(
                                                        showTourCsrList[index]
                                                                ['deptime']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Grand Total",
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // Icon(Icons.lock_clock),
                                                      Text(
                                                        "₹ ${showTourCsrList[index]['grandtotal'].toString()}",
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 3, //2
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "Teritory",
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      ),
                                                      // SizedBox(
                                                      //   width: 10,
                                                      // ),
                                                      // Icon(Icons.lock_clock),
                                                      Text(
                                                        showTourCsrList[index]
                                                                ['teritory']
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontFamily: 'WorkSans',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: Colors.black54,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      IconButton(
                                                          tooltip: "PDF",
                                                          onPressed: () {
                                                            EngineerTourList.pdflink =
                                                                showTourCsrList[index]
                                                                        ['pdf_link']
                                                                    .toString();
                                                            Navigator.of(context,
                                                                    rootNavigator:
                                                                        true)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        EngineerTourLIstPdfView()));
                                                           },
                                                           icon: Icon(
                                                            Icons.book,
                                                            color: themBlueColor,
                                                           )
                                                          ),
                                                      IconButton(
                                                          tooltip: 'Download',
                                                          onPressed: () {
                                                            _launchURL();
                                                          },
                                                          icon: Icon(
                                                            Icons.download,
                                                            color: themBlueColor,
                                                          )),
                                                      IconButton(
                                                          tooltip: 'Edit CSR',
                                                          onPressed: () {
                                                            setState(() {
                                                              //  EngineerTourList.tourid= AesEncryption.encryptAES(showTourCsrList[index]['tourid'].toString());
                                                              //  showTourCsrList[index]['tourid'].toString();
                                                               EngineerTourList.tourid= showTourCsrList[index]['tourid'].toString();
                                                
                                                              //  EngineerTourList.endtime=showTourCsrList[index]['endtime'].toString();
                                                              //  EngineerTourList.date=showTourCsrList[index]['csrdate'].toString();
                                                              //  EngineerTourList.csrno=showTourCsrList[index]['csrno'].toString();
                                                              //  EngineerTourList.csrid= AesEncryption.encryptAES(showTourCsrList[index]['csrid'].toString());
                                                              //  EngineerTourList.action_taken=showTourCsrList[index]['actiontaken'].toString();
                                                              //  EngineerTourList.spare_name=showTourCsrList[index]['partsname'].toString();
                                                              //  EngineerTourList.eng_sign=showTourCsrList[index]['engsign'].toString();
                                                              //  EngineerTourList.cust_sign=showTourCsrList[index]['custsign'].toString();
                                                              //  EngineerTourList.complaintext=showTourCsrList[index]['complainttext'].toString();
                                                              //  EngineerTourList.complainid=showTourCsrList[index]['complainid'].toString();
                                                              //  EngineerTourList.customerName=showTourCsrList[index]['customername'].toString();
                                                              //  EngineerTourList.customerType=showTourCsrList[index]['customertypename'].toString();
                                                              //  EngineerTourList.customerMobile=showTourCsrList[index]['mobile'].toString();
                                                              //  EngineerTourList.customerEmailId=showTourCsrList[index]['emailid'].toString();
                                                              //  EngineerTourList.customerAddress=showTourCsrList[index]['customeraddress'].toString();
                                                              //  EngineerTourList.servicetypename=showTourCsrList[index]['servicetypename'].toString();
                                                              //  EngineerTourList.complainnaturename=showTourCsrList[index]['complainnaturename'].toString();
                                                              //  EngineerTourList.complaintnumber=showTourCsrList[index]['complaintnumber'].toString();
                                                              //  EngineerTourList.producttypename=showTourCsrList[index]['producttype'].toString();
                                                            });
                                                            Navigator.of(context,
                                                                    rootNavigator: true)
                                                                .push(MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        EngineerTourEdit()));
                                                          },
                                                          icon: Icon(
                                                            Icons.edit,
                                                            color: themBlueColor,
                                                          ))
                                                    ],
                    
                                                    // child:   Text("Edit",style: TextStyle(fontFamily: 'WorkSans',fontWeight: FontWeight.w900,color: Colors.red,fontSize: 16),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ));
  }

  void _launchURL() async {
    if (!await launch(EngineerTourList.pdflink.toString()))
      throw 'Could not launch $EngineerTourListScreen.pdflink.toString()';
  }
}
