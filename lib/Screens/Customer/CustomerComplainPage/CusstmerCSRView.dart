import 'dart:convert';

import 'package:ev_testing_app/AES256encryption/Encrypted.dart';
import 'package:ev_testing_app/Api/Api.dart';
import 'package:ev_testing_app/Model/CustomerModel/CustomeCSRViewModel.dart';
import 'package:ev_testing_app/Screens/Customer/CustomerComplainPage/CustomerCSRPdfScreen.dart';
import 'package:ev_testing_app/Screens/Customer/Home/CustomerHome.dart';
import 'package:ev_testing_app/Screens/Customer/NoComplains/NoCompletedComplain.dart';
import 'package:ev_testing_app/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'CustomerCompletedComplain.dart';

class CusstmerCSRView extends StatelessWidget {
  static String? csrPdfUrl;
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
      home: CusstmerCSRViewScreen(),
    );
  }
}

class CusstmerCSRViewScreen extends StatefulWidget {
  @override
  _CusstmerCSRViewScreenState createState() => _CusstmerCSRViewScreenState();
}

class _CusstmerCSRViewScreenState extends State<CusstmerCSRViewScreen> {
  bool information = false; //!true
  CustomeCsrViewModel? customeCsrData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    customerCSRVIewProcess();
    print(";;;;;;;;;;;;;;;;;;;;;;");
  }

  //! shimmerContainer
  Widget shimmerContainer(double height, double width, Widget widGet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: themBlueColor.withOpacity(0.5),
      loop: 50,
      enabled: true,
      direction: ShimmerDirection.ltr,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.25),
            borderRadius: BorderRadius.circular(10)),
        child: widget,
      ),
    );
  }

  //! shimmerContainer
  Widget shimmeWidget(Widget widGet) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.25),
      highlightColor: themBlueColor.withOpacity(0.5),
      loop: 50,
      enabled: true,
      direction: ShimmerDirection.ltr,
      child: Container(child: widGet),
    );
  }

  //! Customer CSR View Data

  Future<CustomeCsrViewModel> customerCSRVIewProcess() async {
    String customerCSRView_url = customerCSRVIewApi;
    final http.Response response = await http.post(
      Uri.parse(customerCSRView_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        'userid': CustomerHome.customerId.toString(),
        'complainid': AesEncryption.encryptAES(
            CustomerCompletedComplain.complainId.toString()),
        'complaintnumber': CustomerCompletedComplain.complaintnumber.toString(),
        'token': CustomerHome.customerToken.toString(),
      },
    );

    if (response.statusCode == 200) {
      print("res" + response.body);

      var status = json.decode(response.body)['status'];

      print("status " + status.toString());

      if (status == false) {
        Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(builder: (context) => NoCompletedComplain()));
      }

      var itemList = json.decode(response.body)['data'] ?? [];

      print("item list " + itemList.toString());
      setState(() {
        information = false;
        // showPendingComplainList = itemList;
      });

      customeCsrData = CustomeCsrViewModel.fromJson(json.decode(response.body));
      return customeCsrData!;
    } else {
      //  showPendingComplainList=[];
      // Fluttertoast.showToast(
      //   msg: "Please Check Login Credentials",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to create album.');
    }
  }

  Widget csrDetails(String tittle, String dec) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 3.0,
          child: Text(
            tittle,
            style: TextStyle(
                letterSpacing: 1,
                fontFamily: 'Righteous',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          dec,
          style: TextStyle(
              letterSpacing: 1,
              fontFamily: 'Righteous',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themWhiteColor,
      appBar: AppBar(
        // automaticallyImplyLeading: true,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),

        backgroundColor: themBlueColor,
        toolbarHeight: height * 0.1,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          "CSR View",
          style: TextStyle(
              fontFamily: 'AkayaKanadaka',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: themWhiteColor),
        ),
        // title: Align(
        //   alignment: Alignment.topLeft,
        //   child: FittedBox(
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 10,top: 40),
        //       child: Text("Login",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 60,fontWeight: FontWeight.w700,color: themWhiteColor),),
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
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => CustomerCompletedComplain()));
            // Navigator.pop(context);
          },
        ),

        // flexibleSpace: ClipPath(
        //   clipper: Customshape(),
        //   child: Container(
        //     //height: height*0.2,
        //     width: MediaQuery.of(context).size.width,
        //     color: themBlueColor,
        //     child: Center(
        //        child: FittedBox(
        //         child: Padding(
        //           padding: const EdgeInsets.only(left: 10),
        //           child: Text("CSR View",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
      ),
      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: CustomerDrawer()),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              height: height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: themBlueColor,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: themBlueColor)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        // width: 80,
                        child: Image.asset(
                          "assets/images/complain_icon.png",
                          height: 80,
                          width: 80,
                          color: Colors.white,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            csrDetails("Complain id : ",
                                CustomerCompletedComplain.complainId.toString()),
                            SizedBox(
                              height: 5,
                            ),
                            csrDetails(
                                "Complain No : ",
                                CustomerCompletedComplain.complaintnumber
                                    .toString()),
                            SizedBox(
                              height: 5,
                            ),
                            csrDetails(
                                "Complain Time : ",
                                CustomerCompletedComplain.complaintime
                                    .toString()),
                            SizedBox(
                              height: 5,
                            ),
                            csrDetails("Entry at : ",
                                CustomerCompletedComplain.entryAt.toString()),
                            SizedBox(
                              height: 5,
                            ),
                            csrDetails("Entry by : ",
                                CustomerCompletedComplain.entryBy.toString()),
                            SizedBox(
                              height: 5,
                            ),
                            
                            csrDetails("Is active : ",
                                CustomerCompletedComplain.isActive.toString()),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            customeCsrData == null //! ==
                ? CircularProgressIndicator(
                    color: themBlueColor,
                  )

                // Container(
                //     width: width,
                //     height: height * 0.7,
                //     // color: Colors.green,
                //     // child: Text("abc"),

                //     child: Padding(
                //       padding: const EdgeInsets.only(bottom: 2),
                //       child: Container(
                //                 height: height * 0.12,
                //                 child: Card(
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(15.0),
                //                   ),
                //                   color: themWhiteColor,
                //                   elevation: 10,
                //                   child: Padding(
                //                     padding: const EdgeInsets.only(top: 10),
                //                     child: Column(
                //                       // mainAxisSize: MainAxisSize.min,
                //                       children: <Widget>[
                //                         ListTile(
                //                           leading: shimmerContainer(
                //                               80,
                //                               60,
                //                               Container(
                //                                 height: 80,
                //                                 width: 60,
                //                               )),
                //                           // Image.asset(
                //                           //   "assets/images/csr_pdf.png",
                //                           //   height: 80,
                //                           //   width: 60,
                //                           //   color: themBlueColor,
                //                           // ),
                //                           title: Column(
                //                             crossAxisAlignment:
                //                                 CrossAxisAlignment.start,
                //                             mainAxisAlignment:
                //                                 MainAxisAlignment.center,
                //                             children: [
                //                               shimmeWidget(
                //                                Text(
                //                                   "Csr No",
                //                                   style: TextStyle(
                //                                       fontFamily: 'Righteous',
                //                                       fontSize: 18,
                //                                       fontWeight:
                //                                           FontWeight.w700,
                //                                       color: Colors.transparent),
                //                                 ),
                //                               ),
                //                               SizedBox(
                //                                 height: 5,
                //                               ),
                //                               shimmeWidget(
                //                                 Text(
                //                                   "data.csrno",
                //                                   style: TextStyle(
                //                                       fontFamily: 'Righteous',
                //                                       fontSize: 18,
                //                                       fontWeight:
                //                                           FontWeight.w700,
                //                                       color:
                //                                           Colors.transparent),
                //                                 ),
                //                               ),
                //                             ],
                //                             //child: Text('Heart Shaker', style: TextStyle(color: Colors.white))
                //                           ),
                //                           //subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ),

                //     ))

                : Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: ListView.builder(
                          itemCount: customeCsrData!.data.length,
                          itemBuilder: (context, index) {
                            var data = customeCsrData!.data[index];
                            return InkWell(
                              onTap: () {
                                CusstmerCSRView.csrPdfUrl = data.pdfLink;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CustomerCSRPdfScreen()));
                              },
                              child: ListTile(
                                title: Container(
                                  height: height * 0.12,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: themWhiteColor,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        // mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            leading: Image.asset(
                                              "assets/images/csr_pdf.png",
                                              height: 80,
                                              width: 60,
                                              color: themBlueColor,
                                            ),
                                            title: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Csr No",
                                                  style: TextStyle(
                                                      fontFamily: 'Righteous',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  data.csrno,
                                                  style: TextStyle(
                                                      fontFamily: 'Righteous',
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black45),
                                                ),
                                              ],
                                              //child: Text('Heart Shaker', style: TextStyle(color: Colors.white))
                                            ),
                                            //subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
