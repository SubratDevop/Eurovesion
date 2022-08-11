import 'dart:convert';
import 'package:ev_testing_app/AES256encryption/Encrypted.dart';
import 'package:ev_testing_app/Api/Api.dart';
import 'package:ev_testing_app/Model/EngineerModel/EngineerAssignmentModel.dart';
import 'package:ev_testing_app/Screens/Engineer/CustomerServiceReport/CustomerServiceReport.dart';
import 'package:ev_testing_app/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EngineerHome extends StatelessWidget {
  static String? engId,
      engineertourId,
      engDecryptId,
      engToken,
      engName,
      engEmail,
      engBranchaddress,
      engContact,
      engTypeId,
      engEmployeeType,
      engBranchid,
      engBranchname,
      engEngineerimage,
      asign_list_id,
      csrStatus,
      complain_id;
  // static late String  totalComplain,pendingComplain,completedComplain;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EngineerHomeScreen(),
    );
  }
}

class EngineerHomeScreen extends StatefulWidget {
  @override
  _EngineerHomeScreenState createState() => _EngineerHomeScreenState();
}

class _EngineerHomeScreenState extends State<EngineerHomeScreen> {
  /// Greeting Message started
  var timeNow;
  String? greetingMessageStatus;
  // bool? responseSts;

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

  ///////////////// Greeting Message

  String? date,
      sendingDateToServer,
      complaintnumber,
      complainttext,
      complaindate,
      assignedfordate,
      total_assign_count;

  DateTime currentDate_start = DateTime.now();

  ///////////// Start Date///////////////
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
        context: context,
        initialDate: currentDate_start,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050)))!;
    if (pickedDate != null && pickedDate != currentDate_start)
      setState(() {
        currentDate_start =
            pickedDate; // change current state value to picked value
        print("start date" + currentDate_start.toString());

        var dateTime = DateTime.parse("${currentDate_start}");
        print("start date 2" + dateTime.toString());

        var formate1 =
            "${dateTime.day}/${dateTime.month}/${dateTime.year}"; //change format to dd-mm-yyyyy

        var formate2 =
            "${dateTime.month}/${dateTime.day}/${dateTime.year}"; //change format t0 yyy-mm-dd

        date = formate1.toString();
        sendingDateToServer = formate2.toString();

        showingAssignmentProcess();

        print("start date  " + date.toString());
        print("Sending date " + sendingDateToServer.toString());
      });
  }

  /////////// Pending complain List/////////////////
  List showAssignmentList = [];
  List tempAssignmentList = [];

  bool isLoading = true;
  bool? status;
  bool? csrStatus;
  String? chooseDateStatus;
  String? chooseDate;
  String? gotValue;
  int? noOfAssign;

  Future<EngineerAssignmentModel> showingAssignmentProcess12() async {
    SharedPreferences engPrefs = await SharedPreferences.getInstance();

    print("engineerid " + EngineerHome.engId.toString());
    print("engineerDecryptid " + EngineerHome.engDecryptId.toString());
    print("token " + EngineerHome.engToken.toString());

    String assignment_url = engineerAssignmentApi;

    final http.Response response = await http.post(
      Uri.parse(assignment_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "engineerid": EngineerHome.engId.toString(),
        "token": engPrefs.getString("token"),
        // "date": sendingDateToServer.toString()
        // "data":null
      },
    );

    if (response.statusCode == 200) {
      print("res" + response.body);
      // choseDate = sendingDateToServer.toString();

      setState(() {
        status = json.decode(response.body)['status'];
      });

      print("main status " + status.toString());

      if (status == true) {
        var itemList = json.decode(response.body)['data'] ?? [];

        print("item list " + itemList.toString());
        setState(() {
          gotValue = "done";
          showAssignmentList = itemList;
          noOfAssign = showAssignmentList.length;
        });
      } else {
        setState(() {
          gotValue = "not done";
          noOfAssign = 0;
        });
      }

      // if (status == false) {
      //   setState(() {
      //     gotValue = "not done";
      //   });
      // } else {
      //   // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoCompletedComplain()));

      // }
      return EngineerAssignmentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  Future<EngineerAssignmentModel> showingAssignmentProcess() async {
    print("showingAssignmentProcess called");

    print("engineerid " + EngineerHome.engId.toString());
    print("token " + EngineerHome.engToken.toString());
    print("date " + sendingDateToServer.toString());
    // print("date " + dateToServer.toString());

    String assignment_url = engineerAssignmentApi;

    final http.Response response = await http.post(
      Uri.parse(assignment_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "engineerid": EngineerHome.engId.toString(),
        "token": EngineerHome.engToken.toString(),
        "date": sendingDateToServer.toString()
        // "date": dateToServer
        // "data":null
      },
    );

    if (response.statusCode == 200) {
      print("res" + response.body);
      // choseDate = sendingDateToServer.toString();

      setState(() {
        status = json.decode(response.body)['status'];
      });

      print("main status " + status.toString());

      if (status == true) {
        var itemList = json.decode(response.body)['data'] ?? [];

        print("item list " + itemList.toString());
        setState(() {
          gotValue = "done";
          showAssignmentList = itemList;
        });
      }

      if (status == false) {
        setState(() {
          gotValue = "not done";
        });
      } else {
        // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoCompletedComplain()));

      }
      return EngineerAssignmentModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  showCSsrReportedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            content: Text(
              'CSR Already Given By Engineer',
              style: TextStyle(
                  fontFamily: 'Righteous',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45),
            ),
            actions: <Widget>[
              FlatButton(
                color: themBlueColor,
                child: const Text(
                  'OK',
                  style: TextStyle(
                      fontFamily: 'Righteous',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: themWhiteColor),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

//////////////////////////////////////////////////////////////////
  ///

  // Future<bool> showingCustomerDetailsProcess() async {
  Future<bool> showingCustomerDetailsProcess() async {
    print("showingCustomerDetailsProcess called");
    String customerDetails_url = engineerInitiatecsrApi;
    // bool responseSts;
    var assign_list_id = AesEncryption.encryptAES(1.toString());
    var complain_id =
        AesEncryption.encryptAES(EngineerHome.complain_id.toString());

    final http.Response response = await http.post(
      Uri.parse(customerDetails_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "assign_list_id": assign_list_id,
        // "assign_list_id": EngineerHome.asign_list_id.toString(),
        "engineer_id": EngineerHome.engId.toString(),
        "complain_id": complain_id,
        "token": EngineerHome.engToken.toString(),
      },
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)["status"] == true) {
      return true;
    } else {
      return false;
    }
    // if (response.statusCode == 200) {
    //   setState(() {
    //     print("res" + response.body);
    //     // CustomerServiceReport.customeServiceStatus =
    //     //     json.decode(response.body)["status"];
    //   });
    //   return true;
    // } else {
    //   return false;
    // }
  }

// Future<bool> showingCustomerDetailsResponse() async {
//     String customerDetails_url = engineerInitiatecsrApi;
//     final http.Response response = await http.post(
//       Uri.parse(customerDetails_url),
//       headers: <String, String>{
//         // 'Accept': 'application/json',
//         // 'Content-type': 'application/json',
//         'Accept': 'application/json'
//       },
//       body: {
//         "assign_list_id": EngineerHome.asign_list_id.toString(),
//         "engineer_id": EngineerHome.engId.toString(),
//         "complain_id": EngineerHome.complain_id.toString(),
//         "token": EngineerHome.engToken.toString(),
//       },
//     );
//     bool statusResponse  = json.decode(response.body)["status"];
// return statusResponse;
// }

  Future<String> getToken() async {
    print("???????????????????????????????????????????");

    SharedPreferences engPrefs = await SharedPreferences.getInstance();
    print("updated token init State");
    String token = engPrefs.getString("token")!;
    print(token);
    print("updated token init Stae");

    print("???????????????????????????????????????????");

    return token;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var now = DateTime.now();
    // final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // String createDate = formatter.format(DateTime.now());
    String createDate = "${now.day}/${now.month}/${now.year}";
    // DateFormat.yMd('es').format(now);
    // _selectStartDate(context);
    date = createDate;
    chooseDate = "";
    // showingAssignmentProcess12();

//     print("???????????????????????????????????????????");

//  SharedPreferences engPrefs = await SharedPreferences.getInstance();
//  print("updated token init State");
//  String token =  engPrefs.getString("token")!;
//  print(token);
//  print("updated token init Stae");

// print("???????????????????????????????????????????");

// var dateString = DateFormat('dd-MM-yyyy').format(now);

    getLoginCredentials();
    showingAssignmentProcess12();
    greetingMessage();
    upDateGreetingMessageAccordingToTime();
    // showingAssignmentProcess(createDate);

    // choseDate = sendingDateToServer.toString();
    // tempAssignmentList = showAssignmentList;
    print("eng token init >>>>>>>>" +
        EngineerHome.engToken.toString()); // previos token hitted at first
    print("Assignment list screen called");
// chooseDateStatus = status;
  }

  @override
  Widget build(BuildContext context) {
    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // _selectStartDate(context);
    /// screen Orientation end///////////

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
                child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                        "Hi , " +
                            EngineerHome.engName.toString() +
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

      // appBar: AppBar(

      //   backwardsCompatibility: false,
      //   systemOverlayStyle: SystemUiOverlayStyle(
      //   statusBarColor: themBlueColor,
      //   statusBarBrightness: Brightness.light,
      //   statusBarIconBrightness: Brightness.light
      //   ),

      //   backgroundColor: themBlueColor,
      //   elevation: 0.0,
      //   title: Center(child: Text('Home',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
      //   // leading: IconButton(
      //   //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
      //   //   onPressed: (){
      //   //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //   //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));
      //   //   },
      //   // ),
      // ),

      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: EngineerDrawer()),

      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 0, left: 5, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: InkWell(
                    onTap: () {
                      _selectStartDate(context);
                    },
                    child: Container(
                      width: width * 0.3,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: themWhiteColor,
                          boxShadow: [
                            BoxShadow(color: Colors.orange, spreadRadius: 4)
                          ]),
                      child: Center(
                          child: Text("Choose Date",
                              style: TextStyle(
                                  fontFamily: 'Righteous',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: themBlueColor))),
                    ),
                  ),
                ),
                Text(
                  date.toString(),
                  style: TextStyle(
                      fontFamily: 'Righteous',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black54),
                )
              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              width: width,
              height: height * 0.75,
              child: gotValue == "done"
                  ? ListView.builder(
                      itemCount: showAssignmentList.length,
                      itemBuilder: (context, index) {
                        csrStatus = showAssignmentList[index]["csr_status"];
                        return ListTile(
                          onTap: () {
                            print("Card tapped");
                            // EngineerHome.asign_list_id = AesEncryption.encryptAES(showAssignmentList[index]['id'].toString());
                            EngineerHome.complain_id = AesEncryption.encryptAES(showAssignmentList[index]['complainid'].toString());
                            // // EngineerHome.complain_id = int.parse(showAssignmentList[index]['complainid']);
                            // print(EngineerHome.engDecryptId);
                            // csrStatus =
                            //     showAssignmentList[index]["csr_status"];
                            //! Navigate to CSR report Screen
                            Navigator.of(context, rootNavigator: true).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CustomerServiceReport()));

                            //!  Navigate to  CSR Web Screen
                            // setState(() {
                            // if (csrStatus == true) {
                            //   // print("Csr Already Assigned");
                            //   showCSsrReportedDialog(context);
                            // } else {
                            //   Navigator.of(context, rootNavigator: true)
                            //       .push(MaterialPageRoute(
                            //           builder: (context) =>
                            //               CsrWebScreen()));

                            //   print("Csr web Screen naviagtion Stared");
                            // }
                            // });

                            // if (status == true) {
                            //   setState(() {});
                            //   EngineerHome.asign_list_id =
                            //       AesEncryption.encryptAES(
                            //           showAssignmentList[index]['id']
                            //               .toString());
                            //   EngineerHome.complain_id =
                            //       showAssignmentList[index]['complainid']
                            //           .toString();
                            //   // EngineerHome.complain_id = int.parse(showAssignmentList[index]['complainid']);
                            //   print(EngineerHome.engDecryptId);
                            //   csrStatus =
                            //       showAssignmentList[index]["csr_status"];
                            //   Navigator.of(context, rootNavigator: true).push(
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               CustomerServiceReport()));
                            // } else {
                            //   print("not navigated");
                            // }
                          },
                          title: Container(
                            height: height * 0.15,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              color: csrStatus == true
                                  ? themBlueColor.withOpacity(0.8)
                                  : themWhiteColor,
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ListTile(
                                      leading: Image.asset(
                                        "assets/images/complain_icon.png",
                                        height: 80,
                                        width: 60,
                                        color: csrStatus == true
                                            ? themWhiteColor
                                            : Colors.black45,
                                      ),
                                      title: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today,
                                                      color: csrStatus == true
                                                          ? themWhiteColor
                                                          : Colors.black45),
                                                  Text(
                                                    showAssignmentList[index]
                                                            ['complaindate']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Righteous',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: csrStatus == true
                                                            ? themWhiteColor
                                                            : Colors.black45),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: csrStatus == true
                                                        ? themWhiteColor
                                                        : Colors.black45,
                                                  ),
                                                  Text(
                                                    showAssignmentList[index]
                                                            ['assignedfordate']
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontFamily: 'Righteous',
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: csrStatus == true
                                                            ? themWhiteColor
                                                            : Colors.black45),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              FittedBox(
                                                  child: Text(
                                                showAssignmentList[index]
                                                        ['complaintnumber']
                                                    .toString(),
                                                style: TextStyle(
                                                    fontFamily: 'Righteous',
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                    color: csrStatus == true
                                                        ? themWhiteColor
                                                        : Colors.black54),
                                              ))
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  showAssignmentList[index]
                                                          ['complainttext']
                                                      .toString(),
                                                  // maxLines: 2,//3
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                      fontFamily: 'Righteous',
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: csrStatus == true
                                                          ? themWhiteColor
                                                          : Colors.black87),
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // ),
                        );
                      })
                  : Center(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "No Assignments...",
                            style: TextStyle(
                                fontFamily: 'AkayaKanadaka',
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }

  void getLoginCredentials() async {
    SharedPreferences engPrefs = await SharedPreferences.getInstance();

    print("id .............." + engPrefs.getString("engineerId").toString());

    setState(() {
      EngineerHome.engEmail = engPrefs.getString("email");
      EngineerHome.engContact = engPrefs.getString("contact");
      EngineerHome.engName = engPrefs.getString("name");
      EngineerHome.engToken = engPrefs.getString("token");
      EngineerHome.engId = engPrefs.getString("engineerId");
      EngineerHome.engDecryptId = engPrefs.getString("engineerDecryptId");
      EngineerHome.engineertourId = engPrefs.getString("engineerTourId");
      EngineerHome.engTypeId = engPrefs.getString("typeId");
      EngineerHome.engEmployeeType = engPrefs.getString("employeeType");
      EngineerHome.engBranchid = engPrefs.getString("branchid");
      EngineerHome.engBranchname = engPrefs.getString("branchname");
      EngineerHome.engBranchaddress = engPrefs.getString("branchaddress");
      EngineerHome.engEngineerimage = engPrefs.getString("engineerimage");
    });

    // showingAssignmentProcess();
    print("Eng token " + EngineerHome.engToken.toString());

    // if(CustomerHome.customerId!=null && CustomerHome.customerToken!=null){
    //   customerComplainCountProcess();
    // }
  }
}
