import 'dart:convert';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerTotelItemListModel.dart';
import 'package:eurovision/Screens/Customer/CustomeItems/AddItem.dart';
import 'package:eurovision/Screens/Customer/CustomeItems/CustomerItelListPdfView.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CustomerItems extends StatelessWidget {
  const CustomerItems({Key? key}) : super(key: key);

  static String? pdflink, amc_no, TotalPmCall, TotalIncompleteCall;

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
      home: CustomerItemsScreen(),
    );
  }
}

class CustomerItemsScreen extends StatefulWidget {
  CustomerItemsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerItemsScreen> createState() => _CustomerItemsScreenState();
}

class _CustomerItemsScreenState extends State<CustomerItemsScreen> {
// Declaring Variable
// CustomerTotelItemListModel? customeTotalItemList;
  bool information = true;
  bool isLoading = true;
  bool isVisible = false;
  double? cardItemHeight;

  List customeTotalItemList = [];

  Future<CustomerTotelItemListModel> customerTotalItemProcess() async {
    String customerTotelItemListApiUrl = customerTotelItemListApi;
    final http.Response response = await http.post(
      Uri.parse(customerTotelItemListApiUrl),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        'customerid': CustomerHome.customerId.toString(),
        'token': CustomerHome.customerToken.toString(),
      },
    );

    if (response.statusCode == 200) {
      var status = json.decode(response.body)['status'];
      print("status " + status.toString());

      print("res" + response.body);
      var totalItemList = json.decode(response.body)['data'] ?? [];

      setState(() {
        information = false;
        customeTotalItemList = totalItemList;
        //  refreshlist();
// print(customeTotalItemList.length);
      });

      return CustomerTotelItemListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerTotalItemProcess();
    // getTotalItemList();
    // refreshlist();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    // customerTotalItemProcess();

    return Scaffold(
      appBar: AppBar(
         
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: themBlueColor,
        toolbarHeight: height * 0.1,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => CustomerHome()));
          },
        ),
        title: Text(
          "My Items",
          style: TextStyle(
              fontFamily: 'TimesNEwRoman',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: themWhiteColor),
        ),
        centerTitle: true,
      ),
      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: CustomerDrawer()),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: width,
              height: height * 0.05,
              alignment: Alignment.topRight,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Text("Create Item",
                    style: TextStyle(
                        fontFamily: 'Righteous',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.red)),
                RawMaterialButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(builder: (context) => AddItem()));
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
            Container(
                width: width,
                height: height * 0.80,
                // child: Text("abc"),

                child: information
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          "Please Wait....",
                          style: TextStyle(
                              fontFamily: 'AkayaKanadaka',
                              fontSize: 25,
                              fontWeight: FontWeight.w700,
                              color: Colors.black54),
                        ),
                      ))
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 5, top: 10),
                        child: ListView.builder(
                            itemCount: customeTotalItemList.length,
                            itemBuilder: (context, index) {
                              CustomerItems.pdflink =
                                  customeTotalItemList[index]["pdflink"]
                                      .toString();
                              print(CustomerItems.pdflink);
                              CustomerItems.amc_no = customeTotalItemList[index]
                                      ["amcnumber"]
                                  .toString();

                              return ListTile(
                                title: Container(
                                  height: height * 0.30,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    color: themWhiteColor,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          ListTile(
                                            // leading:

                                            // showTotalComplainList[index]['complaintstatus'].toString()=="Pending" ?

                                            // Image.asset("assets/images/complain_icon.png",height: 80,width:60,color: Colors.red,) :
                                            // Image.asset("assets/images/complain_icon.png",height: 80,width:60,color: Colors.green,)
                                            // ,
                                            title: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "Item",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                              index]["itemname"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    )
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
                                                      "Model No",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                              index]["modelno"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    )
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
                                                      "Bill No",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                              index]["billno"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                //  visible:
                                                // customeTotalItemList[
                                                //                     index]
                                                //                 ["amcnumber"]
                                                //              == null ? false : true,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "AMC No",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                                          index]
                                                                      [
                                                                      "amcnumber"]
                                                                  .toString() ==
                                                              "null"
                                                          ? "-"
                                                          : customeTotalItemList[
                                                                      index]
                                                                  ["amcnumber"]
                                                              .toString(), //amcnumber
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    )
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
                                                      "Quantity",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                              index]["quantity"]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
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
                                                      "TotalPMCall",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                                          index]
                                                                      [
                                                                      "totalpendingpmcall"]
                                                                  .toString() ==
                                                              "null"
                                                          ? "-"
                                                          : customeTotalItemList[
                                                                      index][
                                                                  "totalpendingpmcall"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
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
                                                      "TotalIncompletePMCall",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                    Text(
                                                      customeTotalItemList[
                                                                          index]
                                                                      [
                                                                      "totalpendingpmcall"]
                                                                  .toString() ==
                                                              "null"
                                                          ? "-"
                                                          : customeTotalItemList[
                                                                      index][
                                                                  "totalpendingpmcall"]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Righteous',
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Colors.black45),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 8,
                                                ),
                                                Visibility(
                                                  visible: customeTotalItemList[
                                                                  index]
                                                              ["pdflink"] ==
                                                          null
                                                      ? false
                                                      : true,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Container(
                                                        height: 30,
                                                        width: 40,
                                                        child:
                                                            RawMaterialButton(
                                                          onPressed: () {
                                                            print(customeTotalItemList[
                                                                        index]
                                                                    ["pdflink"]
                                                                .toString());

                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .push(
                                                                    MaterialPageRoute(
                                                                        builder: (context) =>
                                                                            CustomerItelListPdfView(
                                                                              pdfUrl: customeTotalItemList[index]["pdflink"].toString(),
                                                                            )));
                                                          },
                                                          child: Center(
                                                            child: new Icon(
                                                              Icons.book,
                                                              color:
                                                                  themWhiteColor,
                                                              size: 13.0,
                                                            ),
                                                          ),
                                                          // shape: new CircleBorder(),
                                                          shape:
                                                              new CircleBorder(),
                                                          elevation: 10.0,
                                                          fillColor:
                                                              themBlueColor,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                              //child: Text('Heart Shaker', style: TextStyle(color: Colors.white))
                                            ),
                                            //subtitle: Text('TWICE', style: TextStyle(color: Colors.white)),
                                          ),
                                          // ButtonTheme.bar(
                                          //   child: ButtonBar(
                                          //     children: <Widget>[
                                          //       FlatButton(
                                          //         child: const Text('Edit', style: TextStyle(color: Colors.white)),
                                          //         onPressed: () {},
                                          //       ),
                                          //       FlatButton(
                                          //         child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                          //         onPressed: () {},
                                          //       ),
                                          //     ],
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // Card(
                                //   elevation: 10,
                                //   child: Container(
                                //     color: Colors.white,
                                //     width: width,
                                //     height: height*0.3,
                                //   ),
                                // )

                                // Container(
                                //   width: width,
                                //   height: height*0.8,
                                //   child:  Padding(
                                //     padding: EdgeInsets.only(top: 20),
                                //     child:  ListView.builder(
                                //       itemCount: showPendingComplainList.length,
                                //       itemBuilder: (context,index){
                                //         return ListTile(
                                //           title:

                                //           Container(
                                //             color: Colors.white,
                                //             height: 230,
                                //             child: Stack(
                                //               children: [
                                //                 Positioned(
                                //                   top: 35,
                                //                   left: 20,
                                //                   child: Container(
                                //                     height: 480,
                                //                     width: width*0.9,

                                //                     decoration: BoxDecoration(
                                //                       color: Colors.red,
                                //                       borderRadius: BorderRadius.circular(0.0),
                                //                       boxShadow: [
                                //                         new BoxShadow(
                                //                           color: Colors.grey.withOpacity(0.3),
                                //                           offset: new Offset(-10.0, 10.0),
                                //                           blurRadius: 5.0,
                                //                           spreadRadius: 4.0
                                //                         ),
                                //                       ]

                                //                     ),
                                //                   )
                                //                 )
                                //               ],
                                //             ),
                                //           )
                                //         );
                                //       }
                                //     )
                                //   )
                                // )
                              );
                            }),
                      ))
          ],
        ),
      ),
    );
  }
}
