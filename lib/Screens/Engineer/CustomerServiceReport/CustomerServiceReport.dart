// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/EngineerModel/CsrEntryModel.dart';
import 'package:eurovision/Model/EngineerModel/CustomerDetailsInCSRModel.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class CustomerServiceReport extends StatelessWidget {
  // const CustomerServiceReport({ Key? key }) : super(key: key);

  static String customerid = "",
      customertype = "",
      complainid = "",
      complaintnumber = "",
      customername = "",
      customercode = "",
      customermobile = "",
      customermail = "",
      customeraddress = "",
      branchcode = "",
      csrno = "";

  static var csrMsg;
  static var csrResponseStatus;
  static var customeServiceStatus;
  static String satusIfCSRsubmitted = "";

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
      home: CustomerServiceReportScreen(),
    );
  }
}

class CustomerServiceReportScreen extends StatefulWidget {
  //const CustomerServiceReportScreen({ Key? key }) : super(key: key);

  @override
  _CustomerServiceReportScreenState createState() =>
      _CustomerServiceReportScreenState();
}

class _CustomerServiceReportScreenState
    extends State<CustomerServiceReportScreen> {
  Uint8List? capturedBytes;
  bool loading = false;
  // var engineerSignatureBytes, customerSignatureBytes;
  var customerSignatureBytes;

  TextEditingController _customerActionController = TextEditingController();
  TextEditingController _spartsController = TextEditingController();

  String? partsValue, msg;
  String csrMsg1 = "";
  String? currentDate,
      serndingDateToServer,
      showingOnServiceeDate = "Choose Date"; // sate

  String _selectedStartTime = "Click here", _selectedEndTime = "Click here";

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<SfSignaturePadState> customerSignatureGlobalKey = GlobalKey();

  final GlobalKey<SfSignaturePadState> engineerSignatureGlobalKey = GlobalKey();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;
  Map<String, dynamic> csrBodyResponse = Map<String, dynamic>();
  var csrresponseStatus;
  var csrresponseMsg;
  var selectedValue = -1;
  var selectedSignMethod = -1;
  bool isSigned = true;
  Uint8List? imagebytes;
  File? imageFile;

  List showCustomerDetailsList = [];
  var statusFalseresBody;

  Future<CustomerDetailsInCsrModel> showingCustomerDetailsProcess() async {
    String customerDetails_url = engineerInitiatecsrApi;
    var assign_list_id = AesEncryption.encryptAES(1.toString());

    final http.Response response = await http.post(
      Uri.parse(customerDetails_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        // "assign_list_id": EngineerHome.asign_list_id.toString(),
        "assign_list_id": assign_list_id,
        "engineer_id": EngineerHome.engId.toString(),
        "complain_id": EngineerHome.complain_id.toString(),
        "token": EngineerHome.engToken.toString(),
      },
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)["status"] == true) {
      showCustomerDetailsList = json.decode(response.body)["data"];
      // bool resStatus = json.decode(response.body)["status"];

      setState(() {
        print(showCustomerDetailsList);
        print("res" + response.body);
        CustomerServiceReport.customeServiceStatus =
            json.decode(response.body)["status"];

        //  json.decode(response.body)["status"];
        print(showComplainNatureList.runtimeType);
      });

      setState(() {
        // csrresponseMsg= json.decode(response.body)['message']
        CustomerServiceReport.customerid =
            showCustomerDetailsList[0]['customerid'].toString();
        CustomerServiceReport.customertype =
            showCustomerDetailsList[0]['customertype'].toString() != null
                ? showCustomerDetailsList[0]['customertype'].toString()
                : "not available!";
        CustomerServiceReport.complainid =
            showCustomerDetailsList[0]['complainid'].toString();
        CustomerServiceReport.complaintnumber =
            showCustomerDetailsList[0]['complaintnumber'].toString();
        CustomerServiceReport.customername =
            showCustomerDetailsList[0]['customername'].toString();
        CustomerServiceReport.customercode =
            showCustomerDetailsList[0]['customercode'].toString();
        CustomerServiceReport.customermobile =
            showCustomerDetailsList[0]['customermobile'].toString();
        CustomerServiceReport.customermail =
            showCustomerDetailsList[0]['customermail'].toString();
        CustomerServiceReport.customeraddress =
            showCustomerDetailsList[0]['customeraddress'].toString();
        CustomerServiceReport.branchcode =
            showCustomerDetailsList[0]['branchcode'].toString();
        CustomerServiceReport.csrno =
            showCustomerDetailsList[0]['csrno'].toString();
      });

      print("Address >>>>>>>>>> " +
          CustomerServiceReport.customeraddress.toString());

      return CustomerDetailsInCsrModel.fromJson(json.decode(response.body));
    } else {
      setState(() {
        // resStatus = json.decode(response.body)["status"];
        CustomerServiceReport.customeServiceStatus =
            json.decode(response.body)["status"];
        CustomerServiceReport.satusIfCSRsubmitted =
            json.decode(response.body)["message"];
      });
      print("status false123");
      throw Exception('Failed to create album.');
    }
  }

  ///////// CsrService Api Start///////////
  List showCsrServiceList = [];
  String? csrServiceDropDown_id;

  fetchCsrServiceList() async {
    var engineerCsrService_url = engineerCsrServiceApi;
    var response = await http.get(
      Uri.parse(engineerCsrService_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('State body');
      print(items);

      setState(() {
        showCsrServiceList = items;
      });

      print("Service List " + showCsrServiceList.toString());

      if (showCsrServiceList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showCsrServiceList = [];
    }
  }
  ///////// CsrService Api End///////////

  ///////// CsrProduct Api Start///////////
  List showCsrProductList = [];
  String? csrProductDropDown_id;
  fetchCsrProductList() async {
    var csrProductList_url = engineerCsrProductApi;

    var response = await http.get(
      Uri.parse(csrProductList_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('State body');
      print(items);

      setState(() {
        showCsrProductList = items;
      });

      print("Service List " + showCsrProductList.toString());

      if (showCsrProductList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showCsrProductList = [];
    }
  }
  ///////// CsrProduct Api End///////////

  ///////// CsrComplainNature Api Start///////////
  List showComplainNatureList = [];
  String? csrComplainNatureDropDown_id;
  fetchComplainNatureList() async {
    var csrComplainNatureList_url = engineerCsrComplainNatureApi;
    var response = await http.get(
      Uri.parse(csrComplainNatureList_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('State body');
      print(items);

      setState(() {
        showComplainNatureList = items;
      });

      print("Service List " + showComplainNatureList.toString());

      if (showComplainNatureList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showComplainNatureList = [];
    }
  }
  ///////// CsrComplainNature Api End///////////

  ///////// CsrParts Api Start///////////
  List showCsrPartsRelacedList = [];
  String? csrPartsReplacedDropDown_id;
  fetchCsrPartsLReplacedist() async {
    var showCsrPartsReplacedList_url = engineerCsrPartsReplacedsApi;
    var response = await http.get(
      Uri.parse(showCsrPartsReplacedList_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('parts body');
      print(items);

      setState(() {
        showCsrPartsRelacedList = items;
      });

      print("Parts List " + showCsrPartsRelacedList.toString());
      if (showCsrPartsRelacedList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showCsrPartsRelacedList = [];
    }
  }
  ///////// CsrParts Api End///////////

  Future<CsrEntryModel> enginnerCsrEntryProcess() async {
    print("date >>>>" + serndingDateToServer.toString());
    print("Customer Signature >>>>" +
        base64Encode(customerSignatureBytes).toString());
    // print(
    //     "Eng Signature >>>>" + base64Encode(engineerSignatureBytes).toString());

    String engineerCsrEntry_url = engineerCsrEntryApi;
    final http.Response response = await http.post(
      Uri.parse(engineerCsrEntry_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "csrno": CustomerServiceReport.csrno.toString(),
        "csrdate": serndingDateToServer.toString(),
        "complainid": CustomerServiceReport.complainid.toString(),
        "producttypeid": csrProductDropDown_id.toString(),
        "servicetypeid": csrServiceDropDown_id.toString(),
        "starttime": _selectedStartTime.toString() + ":00",
        "endtime": _selectedEndTime.toString() + ":00",
        "natureid": csrComplainNatureDropDown_id.toString(),
        "action_taken": _customerActionController.text.toString(),
        "item_type": csrPartsReplacedDropDown_id.toString(),
        "spare_name": _spartsController.text.toString(),
        "cust_sign": base64Encode(customerSignatureBytes),
        // "eng_sign": base64Encode(engineerSignatureBytes),
        // "eng_sign": "null",
        "engineerid": EngineerHome.engId.toString(),
        "complain_status": selectedValue.toString()
      },
    );

    if (response.statusCode == 200) {
      print("Engineer Body " + response.body);
      var mess = json.decode(response.body)['message'];
      print("message Body " + mess.toString());

      return CsrEntryModel.fromJson(json.decode(response.body));
    } else {
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      throw Exception('Failed to create album.');
    }
  }
  ////////////Engineer csr End///////////

  // void _handleClearEngineerSignatureButtonPressed() {
  //   engineerSignatureGlobalKey.currentState!.clear();
  // }
  void _handleCustomerSignatureClearButtonPressed() {
    customerSignatureGlobalKey.currentState!.clear();
  }

  // void _handleEngineerSignatureSaveButtonPressed() async {
  // RenderSignaturePad boundary = engineerSignatureGlobalKey.currentContext!
  //     .findRenderObject() as RenderSignaturePad;
  // ui.Image image = await boundary.toImage();
  // ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
  //     as FutureOr<ByteData>);
  // //engineerSignatureBytes = image.readAsBytesSync();

  // //byteData.buffer.asUint8List(),quality:100,name:name;
  // setState(() {
  //   engineerSignatureBytes = byteData.buffer.asUint8List();
  // });

  // if (engineerSignatureBytes.toString() != null) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Engineer Signature Save Successfully")));
  // }

  // print("eng signature" + base64Encode(engineerSignatureBytes));

  // if (byteData != null) {
  //   final time = DateTime.now().millisecond;
  //   final name = "eurovision_$time.png";
  //   final result =
  //   await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),quality:100,name:name);
  //   print(result);
  //   _toastInfo(result.toString());

  //   final isSuccess = result['isSuccess'];
  //   engineerSignatureGlobalKey.currentState!.clear();
  //   if (isSuccess) {
  //     await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (BuildContext context) {
  //           return Scaffold(
  //             appBar: AppBar(),
  //             body: Center(
  //               child: Container(
  //                 color: Colors.grey[300],
  //                 child: Image.memory(byteData.buffer.asUint8List()),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     );
  //   }
  // }
  // }
//!    //! handle Customer's mannual sign
  void _handleCustomerSignatureSaveButtonPressed() async {
    RenderSignaturePad boundary = customerSignatureGlobalKey.currentContext!
        .findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
        await (image.toByteData(format: ui.ImageByteFormat.png));

    // ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png)
    //     as FutureOr<ByteData>);
    // customerSignatureBytes = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);

    setState(() {
      customerSignatureBytes = byteData!.buffer.asUint8List();
    });

    if (customerSignatureBytes.toString() != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer Signature Save Successfully")));
    }

    print("Customer signature ======= " + base64Encode(customerSignatureBytes));

    // if (byteData != null) {
    //   final time = DateTime.now().millisecond;
    //   final name = "signature_$time.png";
    //   final result =
    //   await ImageGallerySaver.saveImage(byteData.buffer.asUint8List(),quality:100,name:name);
    //   print(result);
    //   _toastInfo(result.toString());

    //   final isSuccess = result['isSuccess'];
    //   customerSignatureGlobalKey.currentState!.clear();
    //   if (isSuccess) {
    //     await Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (BuildContext context) {
    //           return Scaffold(
    //             appBar: AppBar(),
    //             body: Center(
    //               child: Container(
    //                 color: Colors.grey[300],
    //                 child: Image.memory(byteData.buffer.asUint8List()),
    //               ),
    //             ),
    //           );
    //         },
    //       ),
    //     );
    //   }
    // }
  }

  _toastInfo(String info) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(info),
    ));
  }

  //! open Camera for Capture Customer Sign

  void _openCamera() async {
    final pickedFileCamera =
        await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFileCamera != null) {
      setState(
        () {
          imageFile = File(pickedFileCamera.path);
          print(imageFile.toString());
        },
      );

      imagebytes = imageFile!.readAsBytesSync();
      _handleCustomerSignatureBycamera(imagebytes);
    }
  }

  //! handle customer Sign captured by Camera

  void _handleCustomerSignatureBycamera(Uint8List? byte) async {
    // RenderSignaturePad boundary = customerSignatureGlobalKey.currentContext!
    //     .findRenderObject() as RenderSignaturePad;
    // ui.Image image = await boundary.toImage();
    // ByteData? byteData =
    //     await (image.toByteData(format: ui.ImageByteFormat.png));

    setState(() {
      customerSignatureBytes = byte!.buffer.asUint8List();
    });

    if (customerSignatureBytes.toString() != null) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Customer Signature Save Successfully")));
    }

    print("Customer signature ======= " + base64Encode(customerSignatureBytes));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = new DateTime.now();

    var formatter = new DateFormat('dd-MM-yyyy');
    var sendingServerDateFormatter = new DateFormat('yyy-mm-dd');
    var timeformatter = new DateFormat('hh:mm:ss').format(DateTime.now());
    currentDate = formatter.format(now);
    serndingDateToServer = sendingServerDateFormatter.format(now);
    print("serndingDateToServer Date  >>>>>>>>>> " +
        serndingDateToServer.toString());
    showingCustomerDetailsProcess();

    fetchCsrServiceList();
    fetchCsrProductList();
    fetchComplainNatureList();
    fetchCsrPartsLReplacedist();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _customerActionController.dispose();
  }

  //! Show alert  SignPad
  showAlertSignPad(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 330,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 450,
                  child: SfSignaturePad(
                      key: customerSignatureGlobalKey,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                      minimumStrokeWidth: 3.0,
                      maximumStrokeWidth: 6.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  width: 450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                         
                          side: BorderSide(
                              color: Colors.green, width: 1), 
                        ),
                        child: Text(
                          'Save',
                          style: TextStyle(
                              color: Colors.green,
                              fontFamily: 'TimesNewRoman',
                              fontWeight: FontWeight.w800,
                              fontSize: 20),
                        ),
                        onPressed: () {
                          _handleCustomerSignatureSaveButtonPressed();

                          // showDialog(
                          //   context: context,
                          //   barrierDismissible: false,
                          //   builder: (BuildContext context) {
                          //     return CupertinoAlertDialog(
                          //       title: Text("Warning",
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: TextStyle(
                          //               fontFamily: 'RobotoMono',
                          //               fontSize: 20,
                          //               color: Colors.red)),
                          //       actions: [
                          //         CupertinoDialogAction(
                          //           onPressed: () {
                          //             _handleCustomerSignatureSaveButtonPressed();

                          //             // Navigator.pop(context); //! worked
                          //             // Navigator.of(context).pop(true);
                          //             Navigator.of(context, rootNavigator: true)
                          //                 .pop();
                          //           },
                          //           child: Text("Save"),
                          //         ),
                          //         CupertinoDialogAction(
                          //             onPressed: () {
                          //               Navigator.pop(context);
                          //             },
                          //             child: Text("Modify")),
                          //       ],
                          //       content: Text(
                          //           "Signature cann't Modify After Save",
                          //           maxLines: 2,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: TextStyle(
                          //               fontFamily: 'RobotoMono',
                          //               fontSize: 20,
                          //               color: Colors.black87)),
                          //     );
                          //   },
                          // );

                          Navigator.of(context, rootNavigator: true).pop();
                        },
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                       
                          side: BorderSide(color: Colors.red, width: 1),
                        ),
                        child: Text('Clear',
                            style: TextStyle(
                                color: Colors.red,
                                fontFamily: 'TimesNewRoman',
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                        onPressed: _handleCustomerSignatureClearButtonPressed,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: BorderSide(
                              color: themBlueColor, width: 1), //<-- SEE HERE
                        ),
                        child: Text('Cancel',
                            style: TextStyle(
                                color: themBlueColor,
                                fontFamily: 'TimesNewRoman',
                                fontWeight: FontWeight.w800,
                                fontSize: 20)),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _openStartTimePicker(BuildContext context) async {
      final TimeOfDay? startTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (startTime != null) {
        setState(() {
          _selectedStartTime = startTime.format(context);
        });
      }
    }

    Future<void> _openEndTimePicker(BuildContext context) async {
      final TimeOfDay? endTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      if (endTime != null) {
        setState(() {
          _selectedEndTime = endTime.format(context);
        });
      }
    }

    //! Select Date
    DateTime currentDateOfChooseDate = DateTime.now();
    Future<void> _selectServiceDate(BuildContext context) async {
      final DateTime pickedDate = (await showDatePicker(
          context: context,
          initialDate: currentDateOfChooseDate,
          firstDate: DateTime(2015),
          lastDate: DateTime(2050)))!;
      if (pickedDate != null && pickedDate != currentDateOfChooseDate) {
        setState(() {
          currentDateOfChooseDate =
              pickedDate; // change current state value to picked value
          print("start date" + currentDateOfChooseDate.toString());

          var dateTime = DateTime.parse("${currentDateOfChooseDate}");
          print("start date 2" + dateTime.toString());

          var formate1 =
              "${dateTime.day}-${dateTime.month}-${dateTime.year}"; //change format to dd-mm-yyyyy

          // var formate2 = "${dateTime.month}/${dateTime.day}/${dateTime.year}";
          var formate2 =
              "${dateTime.year}-${dateTime.month}-${dateTime.day}"; //change format t0 yyy-mm-dd

          showingOnServiceeDate = formate1.toString();
          serndingDateToServer = formate2.toString();
        });
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        key: scaffoldKey,
        backgroundColor: themWhiteColor,
        appBar: AppBar(
           
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: themBlueColor,
              statusBarBrightness: Brightness.light,
              statusBarIconBrightness: Brightness.light),
          backgroundColor: themBlueColor,
          toolbarHeight: height * 0.1,
          elevation: 0.0,
          title: Center(
            child: FittedBox(
              child: Text(
                'Customer Service Report',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'TimesNewRoman',
                    fontWeight: FontWeight.w800,
                    fontSize: 30),
              ),
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
        body:
            // CustomerServiceReport.customeServiceStatus == true
            //     ?
            //SingleChildScrollView(

            // child: Container(
            //    width: width,
            //     height: height*0.8,
            // child: Container(

            Form(
          key: _formkey,
          // autovalidate: _autovalidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Container(
            width: width,
            height: height * 0.8,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.65,
                            child: Text(
                              "Mr. " + EngineerHome.engName.toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'AkayaKanadaka',
                                  fontSize: 30,
                                  color: themBlueColor),
                            )),
                        Container(
                            width: width * 0.3,
                            child: Text(currentDate.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'AkayaKanadaka',
                                    fontSize: 25,
                                    color: Colors.black54)))
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Customer Type: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                                width: width * 0.55,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      CustomerServiceReport.customertype
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 15,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold)),
                                ))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Customer Code: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                                width: width * 0.55,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        CustomerServiceReport.customercode
                                                    .toString() ==
                                                null
                                            ? "Not Available!"
                                            : CustomerServiceReport.customercode
                                                .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'RobotoMono',
                                            fontSize: 15,
                                            color: Colors.black87))))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Customer Name: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                                width: width * 0.55,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        CustomerServiceReport.customername
                                                    .toString() !=
                                                null
                                            ? CustomerServiceReport.customername
                                                .toString()
                                            : "Not Available!",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'RobotoMono',
                                            fontSize: 15,
                                            color: Colors.black87,
                                            fontWeight: FontWeight.bold))))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.4,
                              child: Text(
                                "Br.Name/Code: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          Container(
                              width: width * 0.55,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      CustomerServiceReport.branchcode
                                                  .toString() !=
                                              "null"
                                          ? CustomerServiceReport.branchcode
                                              .toString()
                                          : "Not Available!",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 15,
                                          color: Colors.black87))))
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Email id: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                                width: width * 0.55,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        CustomerServiceReport.customermail
                                                    .toString() ==
                                                null
                                            ? "Not Available!"
                                            : CustomerServiceReport.customermail
                                                .toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'RobotoMono',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87))))
                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.4,
                              child: Text(
                                "Mobile No: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          Container(
                              width: width * 0.55,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      CustomerServiceReport.customermobile
                                                  .toString() ==
                                              "null"
                                          ? "Not Available!"
                                          : CustomerServiceReport.customermobile
                                              .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 15,
                                          color: Colors.black87))))
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: width * 0.4,
                            // height: 30,

                            child: Text(
                              "Customer Address: ",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.55,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                    CustomerServiceReport.customeraddress
                                                .toString() ==
                                            "null"
                                        ? "Not Available!"
                                        : CustomerServiceReport.customeraddress
                                            .toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontFamily: 'RobotoMono',
                                        fontSize: 15,
                                        color: Colors.black87))))
                      ],
                    ),

                    // SizedBox(height: 5,),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     TextButton(
                    //       child: Text('Save',style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: themBlueColor,fontWeight: FontWeight.w800),),
                    //       onPressed: _handleSaveButtonPressed,
                    //     ),
                    //     TextButton(
                    //       child: Text('Clear',style:TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: Colors.red,fontWeight: FontWeight.w800)),
                    //       onPressed: _handleClearButtonPressed,
                    //     )
                    //   ],
                    // ),

                    SizedBox(
                      height: 5,
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Service Type: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),
                                value: csrServiceDropDown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text('Please Choose Service',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                onChanged: (itemid) => setState(
                                    () => csrServiceDropDown_id = itemid),
                                validator: (value) => value == null
                                    ? 'Service is required'
                                    : null,
                                items: showCsrServiceList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['servicename'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.4,
                              child: Text(
                                "CSR: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          Container(
                              width: width * 0.55,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      CustomerServiceReport.csrno.toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 15,
                                          color: Colors.black87))))
                        ],
                      ),
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Products Type: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),
                                value: csrProductDropDown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text('Please Choose Product',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                onChanged: (itemid) => setState(
                                    () => csrProductDropDown_id = itemid),
                                validator: (value) => value == null
                                    ? 'Product is required'
                                    : null,
                                items: showCsrProductList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['categoryname'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.4,
                              child: Text(
                                "Complaint No: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          Container(
                              width: width * 0.55,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                      CustomerServiceReport.complaintnumber
                                          .toString(),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 15,
                                          color: Colors.black87))))
                        ],
                      ),
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.5,
                                child: Text(
                                  "Service Start Time: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            SizedBox(
                              width: width * 0.4,
                              child: RawMaterialButton(
                                fillColor: themBlueColor,
                                child: Text(
                                  _selectedStartTime,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                onPressed: () {
                                  _openStartTimePicker(context);
                                },
                              ),
                            )
                            // Container(
                            //   width: width*0.4,
                            //   child: Align(
                            //     alignment: Alignment.centerRight,
                            //     child: Text(currentDate.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.bold))
                            //   )
                            // )
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.5,
                              child: Text(
                                "Service Finish Time: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          SizedBox(
                            width: width * 0.4,
                            child: RawMaterialButton(
                              fillColor: Colors.red,
                              child: Text(
                                _selectedEndTime,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              onPressed: () {
                                _openEndTimePicker(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              width: width * 0.5,
                              child: Text(
                                "Service Date: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          SizedBox(
                            width: width * 0.4,
                            child: RawMaterialButton(
                              fillColor: themBlueColor,
                              child: Text(
                                showingOnServiceeDate.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              onPressed: () {
                                _selectServiceDate(context);
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                                width: width * 0.5,
                                child: Text(
                                  "Nature Of Complaint: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),
                                value: csrComplainNatureDropDown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text(
                                      'Please Choose Nature Of Complaint',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                onChanged: (itemid) => setState(() =>
                                    csrComplainNatureDropDown_id = itemid),
                                validator: (value) => value == null
                                    ? 'Nature Of Complaint is required'
                                    : null,
                                items: showComplainNatureList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['partsname'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                              width: width * 0.4,
                              child: Text(
                                "Sparts Replaced Type: ",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )),
                          Container(
                            height: 70.0,
                            width: MediaQuery.of(context).size.width - 10,
                            child: DropdownButtonFormField<String>(
                              isExpanded: true,
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.black54,
                                size: 30,
                              ),
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black54))),
                              value: csrPartsReplacedDropDown_id,
                              hint: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Text('Please Choose Replaced Sparts',
                                    style: TextStyle(
                                        fontFamily: 'RaleWay',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black38)),
                              ),
                              onChanged: (itemid) => setState(
                                  () => csrPartsReplacedDropDown_id = itemid),
                              validator: (value) => value == null
                                  ? 'Replaced Sparts is required'
                                  : null,
                              items: showCsrPartsRelacedList.map((list) {
                                return DropdownMenuItem(
                                  value: list['id'].toString(),
                                  child: FittedBox(
                                      child: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text(
                                      list['partsname'].toString(),
                                      style: TextStyle(
                                          color: Color(0xff454f63),
                                          fontWeight: FontWeight.w800,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 16),
                                    ),
                                  )),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: width * 0.4,
                                child: Text(
                                  "Name Of Spare: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                            Container(
                                width: width * 0.55,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextFormField(
                                      maxLengthEnforcement:
                                          MaxLengthEnforcement.enforced,
                                      controller: _spartsController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 0),
                                        hintText: "Enter Spares",
                                        hintStyle: TextStyle(fontSize: 12),
                                        // labelText: "Pincode",

                                        // border: InputBorder.none
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(0)
                                        // )
                                      ),
                                      validator: (String? value) {
                                        if (value!.isEmpty) {
                                          return 'Spares is required!';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        partsValue = value!;
                                      },
                                    )))
                          ],
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: width,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Action Taken: ",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontFamily: 'RobotoMono',
                                      fontSize: 20,
                                      color: Colors.black87),
                                )),
                          ),
                        ),
                        Container(
                          width: width,
                          height: height * 0.2,
                          child: Padding(
                            padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                            child: Container(
                              height: height * 0.2,
                              //color: Color(0xffeeeeee),
                              color: themWhiteColor,
                              padding: EdgeInsets.all(5.0),
                              child: new ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 180.0,
                                ),
                                child: new Scrollbar(
                                  child: new SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    reverse: true,
                                    child: SizedBox(
                                      height: 160.0,
                                      child: new TextFormField(
                                        autofocus: false,
                                        maxLength: 500,
                                        maxLengthEnforcement:
                                            MaxLengthEnforcement.enforced,
                                        maxLines: 100,
                                        controller: _customerActionController,
                                        decoration: new InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: "Fill Action",
                                          hintStyle: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontWeight: FontWeight.w300),
                                          labelText: "Action",
                                        ),
                                        validator: (String? value) {
                                          if (value!.isEmpty) {
                                            return 'Please fill up!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
//! Engineer Sign mannually
                    // engineerSignatureBytes.toString() != "null"
                    //     ? Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Image.asset(
                    //             "assets/images/signature.png",
                    //             width: 50,
                    //             height: 50,
                    //           ),
                    //           Text(
                    //             "Engineer signature saved",
                    //             maxLines: 1,
                    //             overflow: TextOverflow.ellipsis,
                    //             style: TextStyle(
                    //                 fontFamily: 'RobotoMono',
                    //                 fontSize: 20,
                    //                 color: Colors.black87),
                    //           )
                    //         ],
                    //       )
                    //     : Column(
                    //         children: [
                    //           Padding(
                    //             padding: const EdgeInsets.all(5.0),
                    //             child: Container(
                    //                 width: width,
                    //                 // height: 30,
                    //                 child: Text(
                    //                   "Engineer Signature: ",
                    //                   maxLines: 1,
                    //                   overflow: TextOverflow.ellipsis,
                    //                   style: TextStyle(
                    //                       fontFamily: 'RobotoMono',
                    //                       fontSize: 20,
                    //                       color: Colors.black87),
                    //                 )),
                    //           ),
                    //           Padding(
                    //               padding: EdgeInsets.all(5),
                    //               child: Container(
                    //                   child: SfSignaturePad(
                    //                       key: engineerSignatureGlobalKey,
                    //                       backgroundColor: Colors.white,
                    //                       strokeColor: Colors.black,
                    //                       minimumStrokeWidth: 3.0,
                    //                       maximumStrokeWidth: 6.0),
                    //                   decoration: BoxDecoration(
                    //                       border: Border.all(
                    //                           color: Colors.grey)))),
                    //           SizedBox(
                    //             height: 5,
                    //           ),
                    //           Row(
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceEvenly,
                    //             children: [
                    //               TextButton(
                    //                   child: Text(
                    //                     'Save',
                    //                     style: TextStyle(
                    //                         fontFamily: 'AkayaKanadaka',
                    //                         fontSize: 20,
                    //                         color: themBlueColor,
                    //                         fontWeight: FontWeight.w800),
                    //                   ),
                    //                   onPressed: () {
                    //                     showDialog(
                    //                         context: context,
                    //                         barrierDismissible: false,
                    //                         builder:
                    //                             (BuildContext context) {
                    //                           return CupertinoAlertDialog(
                    //                             title: Text("Warning",
                    //                                 maxLines: 1,
                    //                                 overflow: TextOverflow
                    //                                     .ellipsis,
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         'RobotoMono',
                    //                                     fontSize: 20,
                    //                                     color:
                    //                                         Colors.red)),
                    //                             actions: [
                    //                               CupertinoDialogAction(
                    //                                   onPressed: () {
                    //                                     _handleEngineerSignatureSaveButtonPressed();
                    //                                     Navigator.pop(
                    //                                         context);
                    //                                   },
                    //                                   child:
                    //                                       Text("Save")),
                    //                               CupertinoDialogAction(
                    //                                   onPressed: () {
                    //                                     Navigator.pop(
                    //                                         context);
                    //                                   },
                    //                                   child:
                    //                                       Text("Modify")),
                    //                             ],
                    //                             content: Text(
                    //                                 "Signature cann't Modify After Save",
                    //                                 maxLines: 2,
                    //                                 overflow: TextOverflow
                    //                                     .ellipsis,
                    //                                 style: TextStyle(
                    //                                     fontFamily:
                    //                                         'RobotoMono',
                    //                                     fontSize: 20,
                    //                                     color: Colors
                    //                                         .black87)),
                    //                           );
                    //                         });
                    //                   }),
                    //               TextButton(
                    //                 child: Text('Clear',
                    //                     style: TextStyle(
                    //                         fontFamily: 'AkayaKanadaka',
                    //                         fontSize: 20,
                    //                         color: Colors.red,
                    //                         fontWeight: FontWeight.w800)),
                    //                 onPressed:
                    //                     _handleClearEngineerSignatureButtonPressed,
                    //               )
                    //             ],
                    //           ),
                    //         ],
                    //       ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                          width: width,
                          // height: 30,
                          child: Text(
                            "Customer Signature: ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontSize: 20,
                                color: Colors.black87),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: themBlueColor, width: 1)),
                              fillColor: selectedSignMethod == 1
                                  ? themBlueColor
                                  : themWhiteColor,
                              child: Text(
                                "Capture",
                                style: TextStyle(
                                    color: selectedSignMethod == 1
                                        ? themWhiteColor
                                        : themBlueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedSignMethod = 1;
                                });
                                //! open Cameara fujctionlaity
                                _openCamera();
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: RawMaterialButton(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: themBlueColor, width: 1)),
                              fillColor: selectedSignMethod == 0
                                  ? themBlueColor
                                  : themWhiteColor,
                              child: Text(
                                "Sign",
                                style: TextStyle(
                                    color: selectedSignMethod == 0
                                        ? themWhiteColor
                                        : themBlueColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedSignMethod = 0;

                                  showAlertSignPad(context);
                                });
                                // showAlertSignPad(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),
//! mannual Customer Sign

                    customerSignatureBytes.toString() != "null"
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/signature.png",
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                "Customer signature saved",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              )
                            ],
                          )
                        : Container(),
//! Complain Status
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: SizedBox(
                          width: width,
                          // height: 30,
                          child: Text(
                            "Complain Status: ",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: 'RobotoMono',
                                fontSize: 20,
                                color: Colors.black87),
                          )),
                    ),
                    SizedBox(
                      height: 5,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListTile(
                            title: const Text('Complain open'),
                            leading: Radio(
                              activeColor: themBlueColor,
                              value: 0,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                });
                                print("selectedValue = ${selectedValue}");
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                            title: const Text('Complain Closed'),
                            leading: Radio(
                              activeColor: themBlueColor,
                              value: 1,
                              groupValue: selectedValue,
                              onChanged: (int? value) {
                                setState(() {
                                  selectedValue = value!;
                                  print("selectedValue = ${selectedValue}");
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                        width: width,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  themBlueColor),
                            ),
                            child: Text("CSR Submit"),
                            onPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                if (_selectedStartTime == "Click here") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please Choose Start Time")));
                                } else if (_selectedEndTime == "Click here") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("Please Choose End Time")));
                                } else if (showingOnServiceeDate ==
                                    "Choose Date") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text("Please Choose Date")));
                                } else if (selectedValue == -1) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Please Provide Complain Status")));
                                } else if (selectedSignMethod == -1) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                      content: Text(
                                          "Customer signature is required ")));
                                } else if (customerSignatureBytes.toString() ==
                                    "null") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Please Put Customer Signature")));
                                } else {
                                  setState(() {
                                    showLoaderDialog(context);
                                  });
                                  var response =
                                      await enginnerCsrEntryProcess();
                                  bool res = response.status;

                                  setState(() {
                                    msg = response.message;
                                  });

                                  if (res == true) {
                                    Fluttertoast.showToast(
                                        msg: msg.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);

                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                EngineerHome()));
                                  } else {
                                    Future.delayed(const Duration(seconds: 3),
                                        () {
                                      setState(() {
                                        Fluttertoast.showToast(
                                            msg: msg.toString(),
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    EngineerHome()));
                                      });
                                    });
                                    Fluttertoast.showToast(
                                        msg: msg.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0);
                                    // Navigator.of(context, rootNavigator: true)
                                    //     .push(MaterialPageRoute(
                                    //         builder: (context) =>
                                    //             EngineerHome()));
                                  }

                                  // if (res == true)
                                  //   Fluttertoast.showToast(
                                  //       msg: msg.toString(),
                                  //       toastLength: Toast.LENGTH_SHORT,
                                  //       gravity: ToastGravity.CENTER,
                                  //       timeInSecForIosWeb: 1,
                                  //       backgroundColor: Colors.green,
                                  //       textColor: Colors.white,
                                  //       fontSize: 16.0);
                                }
                                // catch (e) {
                                //   ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //           content: Text(msg.toString())));
                                // }
                              }

                              _formkey.currentState!.save();
                            }
                            //  else {

                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //       SnackBar(
                            //           content: Text(
                            //               "Please Enter Essential Fields")));
                            // }
                            // },
                            )),
                  ],
                ),
              ),
            ),
          ),
        )
        // : Center(
        //     child: Text(CustomerServiceReport.satusIfCSRsubmitted,
        //         maxLines: 2,
        //         overflow: TextOverflow.ellipsis,
        //         style: TextStyle(
        //             fontFamily: 'RobotoMono',
        //             fontSize: 20,
        //             color: Colors.black87)),

        //     //   AlertDialog(
        //     //   content: Text(CustomerServiceReport.satusIfCSRsubmitted,
        //     //       // maxLines: 2,
        //     //       overflow: TextOverflow.ellipsis,
        //     //       style: TextStyle(
        //     //           fontFamily: 'RobotoMono',
        //     //           fontSize: 20,
        //     //           color: Colors.black87)),
        //     //   actions: [
        //     //     TextButton(
        //     //       child: Text("ok"),
        //     //       onPressed: () {
        //     //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => CustomerServiceReport())); // dismiss dialog
        //     //       },
        //     //     )
        //     //   ],
        //     // )
        //   )

        // ),
        // ),
        );
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
