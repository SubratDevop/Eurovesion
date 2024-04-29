import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/EngineerModel/CsrEditModel.dart';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/CustomerServiceReportList.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;


class EditCustomerServiceReport extends StatelessWidget {
 // const CustomerServiceReport({ Key? key }) : super(key: key);

  static String  customerid="",customertype="",complainid="",complaintnumber="",customername="",
  customercode="",customermobile="",customermail="",customeraddress="",branchcode="",csrno="";

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
      home: EditCustomerServiceReportScreen(),
    );
  }
}

class EditCustomerServiceReportScreen extends StatefulWidget {
  //const CustomerServiceReportScreen({ Key? key }) : super(key: key);

  

  @override
  _EditCustomerServiceReportScreenState createState() => _EditCustomerServiceReportScreenState();
}

class _EditCustomerServiceReportScreenState extends State<EditCustomerServiceReportScreen> {

  Uint8List ? capturedBytes;

  var engineerSignatureBytes,customerSignatureBytes;

  late TextEditingController  _customerActionController; 
  late TextEditingController _spartsController; 

  String ? partsValue,msg;

  String ? currentDate, serndingDateToServer,showingOnServiceeDate="Choose Date"; // sate

  String _selectedStartTime="Click here",_selectedEndTime="Click here";

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<SfSignaturePadState> customerSignatureGlobalKey = GlobalKey();

  final GlobalKey<SfSignaturePadState> engineerSignatureGlobalKey = GlobalKey();

  GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
    // global key for form.
  bool _autovalidate = false;
  


  ///////// CsrService Api Start///////////
  List showCsrServiceList = [];
  String ? csrServiceDropDown_id;
  fetchCsrServiceList() async {
    
    var engineerCsrService_url= engineerCsrServiceApi;
    var response = await http.get(
      Uri.parse(engineerCsrService_url),
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? [];
     
      print('State body');
      print(items);
      
      setState(() {
        showCsrServiceList = items;
       
      });

      print("Service List "+ showCsrServiceList.toString());
      
      if(showCsrServiceList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showCsrServiceList = [];
     
    }
  }
  ///////// CsrService Api End///////////
  
  ///////// CsrProduct Api Start///////////
  List showCsrProductList = [];
  String ? csrProductDropDown_id;
  fetchCsrProductList() async {
    
    var csrProductList_url= engineerCsrProductApi;
    var response = await http.get(
      Uri.parse(csrProductList_url),
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? [];
     
      print('State body');
      print(items);
      
      setState(() {
        showCsrProductList = items;
       
      });

      print("Service List "+ showCsrProductList.toString());
      
      if(showCsrProductList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showCsrProductList = [];
     
    }
  }
  ///////// CsrProduct Api End///////////

  ///////// CsrComplainNature Api Start///////////
  List showComplainNatureList = [];
  String ? csrComplainNatureDropDown_id;
  fetchComplainNatureList() async {
    
    var csrComplainNatureList_url= engineerCsrComplainNatureApi;
    var response = await http.get(
      Uri.parse(csrComplainNatureList_url),
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? [];
     
      print('State body');
      print(items);
      
      setState(() {
        showComplainNatureList = items;
       
      });

      print("Service List "+ showComplainNatureList.toString());
      
      if(showComplainNatureList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showComplainNatureList = [];
     
    }
  }
  ///////// CsrComplainNature Api End///////////
  
  ///////// CsrParts Api Start///////////
  List showCsrPartsRelacedList = [];
  String ? csrPartsReplacedDropDown_id;
  fetchCsrPartsLReplacedist() async {
    
    var showCsrPartsReplacedList_url= engineerCsrPartsReplacedsApi;
    var response = await http.get(
      Uri.parse(showCsrPartsReplacedList_url),
    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? [];
     
      print('parts body');
      print(items);
      
      setState(() {
        showCsrPartsRelacedList = items;
       
      });
      
      print("Parts List "+ showCsrPartsRelacedList.toString());
      if(showCsrPartsRelacedList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showCsrPartsRelacedList = [];
     
    }
  }
  ///////// CsrParts Api End///////////
  

  
  ////////////Engineer csr Start///////////
  Future<CsrEditModel> csrEditProcess() async {
    
    print("date >>>>"+ serndingDateToServer.toString());
    print("Customer Signature >>>>"+base64Encode(customerSignatureBytes).toString());
    print("Eng Signature >>>>"+base64Encode(engineerSignatureBytes).toString());
   
    String engineerCsrEntry_url= engineerCsrEntryApi;
    final http.Response response = await http.post( Uri.parse(engineerCsrEntry_url),
       
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "csrno": CustomerServiceReportList.csrno.toString(),
        "csrdate": serndingDateToServer.toString(),
        "complainid": CustomerServiceReportList.complainid.toString(),
        "producttypeid": csrProductDropDown_id.toString(),
        "servicetypeid": csrServiceDropDown_id.toString(),
        "starttime": _selectedStartTime.toString()+":00",
        "endtime": _selectedEndTime.toString()+":00",
        "natureid": csrComplainNatureDropDown_id.toString(),
        "action_taken": _customerActionController.text.toString(),
        "item_type": csrPartsReplacedDropDown_id.toString(),
        "spare_name": _spartsController.text.toString(),
        "cust_sign": base64Encode(customerSignatureBytes),
        "eng_sign": base64Encode(engineerSignatureBytes),
        "engineerid": EngineerHome.engId.toString(),
        "csrid": CustomerServiceReportList.csrid.toString()
      },
       
    );
     
    if (response.statusCode == 200) {

      print("Engineer Body "+ response.body);
      var mess=json.decode(response.body)['message'];
      print("message Body "+ mess.toString());

      return CsrEditModel.fromJson(json.decode(response.body));
    } 
    else {
       
     
      Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
      );

      throw Exception('Failed to create album.');
    }
  }
  ////////////Engineer csr End///////////



  void _handleClearEngineerSignatureButtonPressed() {
    
    engineerSignatureGlobalKey.currentState!.clear();
  }

  void _handleCustomerSignatureClearButtonPressed() {
    customerSignatureGlobalKey.currentState!.clear();
  
  }


  void _handleEngineerSignatureSaveButtonPressed() async {
    
    RenderSignaturePad boundary =
    engineerSignatureGlobalKey.currentContext!.findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
    //engineerSignatureBytes = image.readAsBytesSync();
    

    //byteData.buffer.asUint8List(),quality:100,name:name;
    setState(() {
      engineerSignatureBytes=byteData.buffer.asUint8List();
    });
    

    if(engineerSignatureBytes.toString()!=null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Engineer Signature Save Successfully"))); 
    }
    
    print("eng signature"+base64Encode(engineerSignatureBytes));
    
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
  }

  void _handleCustomerSignatureSaveButtonPressed() async {
    RenderSignaturePad boundary =
    customerSignatureGlobalKey.currentContext!.findRenderObject() as RenderSignaturePad;
    ui.Image image = await boundary.toImage();
    ByteData byteData = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);
   // customerSignatureBytes = await (image.toByteData(format: ui.ImageByteFormat.png) as FutureOr<ByteData>);

    setState(() {
      customerSignatureBytes= byteData.buffer.asUint8List();
    });

   
    

    if(customerSignatureBytes.toString()!=null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Customer Signature Save Successfully"))); 
    }
    

    print("Customer signature "+base64Encode(customerSignatureBytes));
    
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(info),));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime now = new DateTime.now();
   
    var formatter = new DateFormat('dd-MM-yyyy');
    var sendingServerDateFormatter= new DateFormat('yyy-mm-dd');
    var timeformatter= new DateFormat('hh:mm:ss').format(DateTime.now());
    currentDate = formatter.format(now);
    serndingDateToServer= sendingServerDateFormatter.format(now);
    print("serndingDateToServer Date  >>>>>>>>>> "+serndingDateToServer.toString());
    //showingCustomerDetailsProcess();

    _customerActionController=TextEditingController(text: CustomerServiceReportList.action_taken.toString());
    _spartsController=TextEditingController(text: CustomerServiceReportList.spare_name.toString());
    
    fetchCsrServiceList();
    fetchCsrProductList();
    fetchComplainNatureList();
    fetchCsrPartsLReplacedist();
    
  }

  
  @override
  Widget build(BuildContext context) {

    Future<void> _openStartTimePicker(BuildContext context) async{
      final TimeOfDay ? startTime = await showTimePicker(context: context, initialTime: TimeOfDay.now()) ;   
      if(startTime!=null){
        setState(() {
         _selectedStartTime= startTime.format(context);
        });
      }
    }

    Future<void> _openEndTimePicker(BuildContext context) async{
      final TimeOfDay ? endTime = await showTimePicker(context: context, initialTime: TimeOfDay.now()) ;   
      if(endTime!=null){
        setState(() {
         _selectedEndTime= endTime.format(context);
        });
      }
    }
    
    ///////////// Start Date///////////////
    DateTime currentDateOfChooseDate = DateTime.now();
    Future<void> _selectServiceDate(BuildContext context) async {
      final DateTime pickedDate = (
        await showDatePicker(
          context: context,
          initialDate: currentDateOfChooseDate,
          firstDate: DateTime(2015),
          lastDate: DateTime(2050)
        )
      )!;
      if (pickedDate != null && pickedDate !=  currentDateOfChooseDate){
        setState(() {
          currentDateOfChooseDate = pickedDate; // change current state value to picked value
          print("start date"+currentDateOfChooseDate.toString());

          var dateTime = DateTime.parse("${currentDateOfChooseDate}");
          print("start date 2"+dateTime.toString());

          var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}"; //change format to dd-mm-yyyyy

         // var formate2 = "${dateTime.month}/${dateTime.day}/${dateTime.year}";
          var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";//change format t0 yyy-mm-dd

          showingOnServiceeDate=formate1.toString();
          serndingDateToServer=formate2.toString();
        });
      }  
    }

    double width= MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: themWhiteColor,

      
      appBar: AppBar(
        
         
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: themBlueColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),

        backgroundColor: Colors.transparent,
        toolbarHeight: height*0.1,
        elevation: 0.0,
        // title: Align(
        //   alignment: Alignment.topLeft,
        //   child: FittedBox(
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 10,top: 40),
        //       child: Text("Csr Edit",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 60,fontWeight: FontWeight.w700,color: themWhiteColor),),
        //     ),
        //   ),
        // ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerServiceReportList()));
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
                  child: Text("CSR Edit",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
       
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: EngineerDrawer()
      ),


      body: 
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
                height: height*0.8,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2,right: 2),
                    child: Column(
                      children: [
                            
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width*0.65,
                              child: Text("Mr. "+EngineerHome.engName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,color: themBlueColor),)
                            ),
                            Container(
                              width: width*0.3,
                              child: Text(currentDate.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 25,color: Colors.black54))
                            )
                          ],
                        ),
                            
                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width*0.4,
                                
                                child: Text("CSR: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)
                                
                              ),
                              Container(
                                width: width*0.55,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text( CustomerServiceReportList.csrno.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87))
                                )
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width*0.4,
                                child: Text("Complaint No: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)
                              ),
                              Container(
                                width: width*0.55,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(CustomerServiceReportList.complaintnumber.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87))
                                )
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: width*0.4,
                                child: Text("Customer Details: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'Righteous',fontSize: 20,color: Colors.black87),)
                              ),
                              
                            ],
                          ),
                        ),

                        Divider(
                          height: 2,
                          color: Colors.black45,
                        ),
                            
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            
                                Container(
                                  width: width*0.4,
                                  child: Text("Name: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text( CustomerServiceReportList.customerName.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.bold)),
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                            
                        SizedBox(height: 5,),
                            
                       
                          Container(
                            width: width,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5,right: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: width*0.4,
                                    
                                    child: Text("Customer Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                  
                                  ),
                                  Container(
                                    width: width*0.55,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(CustomerServiceReportList.customerType.toString() ==null ?   "Not Available!" : CustomerServiceReportList.customerType.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87))
                                    )
                                  )
                                ],
                              ),
                            ),
                          ),
                        
                            
                        SizedBox(height: 5,),
                            
                       
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  
                                  child: Text("Email: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                  
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.customerEmailId.toString() !=null ?  CustomerServiceReportList.customerEmailId.toString() :  "Not Available!",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.bold))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                            
                        SizedBox(height: 5,),
                            
                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width*0.4,
                                child: Text("Contact: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                              ),
                              Container(
                                width: width*0.55,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text( CustomerServiceReportList.customerMobile.toString() != "null" ?  CustomerServiceReportList.customerMobile.toString() : "Not Available!" ,maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87))
                                )
                              )
                            ],
                          ),
                        ),
                            
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Address: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.customerAddress.toString() ==null ?  "Not Available!" : CustomerServiceReportList.customerAddress.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                            
                        SizedBox(height: 20,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Current Service Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.servicetypename.toString() ==null ?  "Not Available!" : CustomerServiceReportList.servicetypename.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Change Service Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                  
                                Container(
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width-10,
                                  
                                  child: DropdownButtonFormField<String>(
                                    
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54)
                                      )
                                    ),
                                    
                                    value: csrServiceDropDown_id,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text('Please Choose Service',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                    ),
                                    onChanged: (itemid) =>
                                        setState(() => csrServiceDropDown_id = itemid),
                                        
                                    validator: (value) => value == null ? 'Service is required' : null,
                                    items: showCsrServiceList.map((list) {
                                      return DropdownMenuItem(
                                        value: list['id'].toString(),
                                        child: FittedBox(child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text(list['servicename'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                        )),
                                      );
                                    }).toList(),
                                   
                                  ),
                                ),  
                              ],
                            ),
                          ),
                        ),
                            
                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Current Product Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.producttypename.toString() ==null ?  "Not Available!" : CustomerServiceReportList.producttypename.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Change Products Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width-10,
                                  
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54)
                                      )
                                    ),
                                    
                                    value: csrProductDropDown_id,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text('Please Choose Product',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                    ),
                                    onChanged: (itemid) =>
                                        setState(() => csrProductDropDown_id = itemid),
                                        
                                    validator: (value) => value == null ? 'Product is required' : null,
                                    items: showCsrProductList.map((list) {
                                      return DropdownMenuItem(
                                        value: list['id'].toString(),
                                        child: FittedBox(child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text(list['categoryname'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                        )),
                                      );
                                    }).toList(),
                                  ),
                                ), 
                              ],
                            ),
                          ),
                        ),
                            
                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Previous Start Time: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.starttime.toString() ==null ?  "Not Available!" : CustomerServiceReportList.starttime.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.5,
                                  child: Text("Change Service Start Time: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                SizedBox(
                                  width: width*0.4,
                                  child: RawMaterialButton(
                                    fillColor: themBlueColor,
                                    child: Padding(
                                      padding: EdgeInsets.only(left:2,right: 2),
                                      child: Text(_selectedStartTime,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)
                                    ),
                                    onPressed: (){
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

                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Previous Finish Time: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.endtime.toString() ==null ?  "Not Available!" : CustomerServiceReportList.endtime.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Padding(
                          padding: const EdgeInsets.only(left:5,right:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width*0.5,
                                
                                child: Text("Change Service Finish Time: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                
                              ),
                              SizedBox(
                                width: width*0.4,
                                child: RawMaterialButton(
                                  fillColor: Colors.red,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2,right: 2),
                                    child: Text(_selectedEndTime,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                  ),
                                  onPressed: (){
                                    _openEndTimePicker(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Previous Date: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.date.toString() ==null ?  "Not Available!" : CustomerServiceReportList.date.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                
                        Padding(
                          padding: const EdgeInsets.only(left:5,right:5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: width*0.5,
                                
                                child: Text("Change Service Date: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                
                              ),
                              SizedBox(
                                width: width*0.4,
                                child: RawMaterialButton(
                                  fillColor: themBlueColor,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 2,right: 2),
                                    child: Text(showingOnServiceeDate.toString(),style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),
                                  ),
                                  onPressed: (){
                                    _selectServiceDate(context);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),

                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.5,
                                  child: Text("Current Nature Of Complaint:",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.4,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.complainnaturename.toString() ==null ?  "Not Available!" : CustomerServiceReportList.complainnaturename.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Container(
                                  width: width*0.5,
                                  child: Text("Change Nature Of Complaint: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width-10,
                                  
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Colors.black54)
                                      )
                                    ),
                                    
                                    value: csrComplainNatureDropDown_id,
                                    hint: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text('Please Choose Nature Of Complaint',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                    ),
                                    onChanged: (itemid) =>
                                      setState(() => csrComplainNatureDropDown_id = itemid),
                                        
                                    validator: (value) => value == null ? 'Nature Of Complaint is required' : null,
                                    items: showComplainNatureList.map((list) {
                                      return DropdownMenuItem(
                                        value: list['id'].toString(),
                                        child: FittedBox(child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text(list['partsname'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
                                        )),
                                      );
                                    }).toList(),
                                  ),
                                ), 
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 5,),

                        Container(
                          color: Colors.black12,
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Current Sparts Replaced: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(CustomerServiceReportList.spare_name.toString() ==null ?  "Not Available!" : CustomerServiceReportList.spare_name.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,fontWeight:FontWeight.bold,color: Colors.black87))
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                            
                        Padding(
                          padding: const EdgeInsets.only(left: 5,right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: width*0.4,
                                child: Text("Sparts Replaced Type: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                              ),
                              
                              Container(
                                height: 70.0,
                                width: MediaQuery.of(context).size.width-10,
                                
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down_circle,color: Colors.black54,size: 30,),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.black54)
                                    )
                                  ),
                                  
                                  value: csrPartsReplacedDropDown_id,
                                  hint: Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Text('Please Choose Replaced Sparts',style: TextStyle(fontFamily: 'RaleWay',fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black38)),
                                  ),
                                  onChanged: (itemid) =>
                                    setState(() => csrPartsReplacedDropDown_id = itemid),
                                      
                                  validator: (value) => value == null ? 'Replaced Sparts is required' : null,
                                  items: showCsrPartsRelacedList.map((list) {
                                    return DropdownMenuItem(
                                      value: list['id'].toString(),
                                      child: FittedBox(child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Text(list['partsname'].toString() ,style: TextStyle(color: Color(0xff454f63), fontWeight: FontWeight.w800, fontStyle: FontStyle.normal, fontSize: 16),),
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
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  
                                  child: Text("Name Of Spare: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87),)
                                  
                                ),
                                Container(
                                  width: width*0.55,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                            
                                    child: TextFormField(
                                      maxLengthEnforcement:MaxLengthEnforcement.enforced,
                                      controller: _spartsController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 0),
                                        hintText: "Enter Spares",
                                        hintStyle: TextStyle(fontSize: 12),
                                      // labelText: "Pincode",
                            
                                      // border: InputBorder.none
                                        // border: OutlineInputBorder(
                                        //   borderRadius: BorderRadius.circular(0)
                                        // )
                                          
                                      ),
                            
                                      validator: (String ? value){
                                        if(value!.isEmpty){
                                          return 'Spares is required!';
                                        }
                                        return null;
                                      },
                                      
                                      onSaved: (String ? value) {
                                        partsValue = value!;
                                      },
                                      
                                    )
                                  )
                                )
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
                                  
                                  child: Text("Action Taken: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w800),)
                                  
                                ),
                              ),
                            ),
                            
                            
                            Container(
                              width: width,
                              height: height*0.2,
                              child:  Padding(
                                padding: EdgeInsets.only(left: 0,right: 0,top: 0),
                                child: Container(
                                  height: height*0.2,
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
                                            maxLength: 500,
                                            maxLengthEnforcement:MaxLengthEnforcement.enforced,
                                            maxLines: 100,
                                            controller: _customerActionController,
                                            decoration: new InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText: "Fill Action",hintStyle: TextStyle(fontFamily: 'Raleway',fontWeight: FontWeight.w300),
                                              labelText: "Action",
                                              
                                            ),
                
                                            validator: (String ? value){
                                              if(value!.isEmpty){
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
                            
                        SizedBox(height: 5,),

                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width*0.4,
                                  child: Text("Previous Engineer Signature: ",maxLines: 2,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w700 ),)
                                ),
                                Container(
                                  width: width*0.55,
                                  height: 100,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.network(CustomerServiceReportList.eng_sign.toString())
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),

                        engineerSignatureBytes.toString()!= "null" ?

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/signature.png",width: 50,height: 50,),
                            Text("Engineer signature saved",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)

                          ],
                        ):
                        
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: width,
                                // height: 30,
                                child: Text("Change Engineer Signature: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                
                                child: SfSignaturePad(
                                  key: engineerSignatureGlobalKey,
                                  backgroundColor: Colors.white,
                                  strokeColor: Colors.black,
                                  minimumStrokeWidth: 3.0,
                                  maximumStrokeWidth: 6.0
                                ),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey))
                              )
                                  
                            ),
                            SizedBox(height: 5,),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                TextButton(
                                  child: Text('Save',style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: themBlueColor,fontWeight: FontWeight.w800),),
                                  onPressed:(){
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text("Warning",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.red)),
                                          actions: [
                                            CupertinoDialogAction(onPressed: (){
                                              _handleEngineerSignatureSaveButtonPressed();
                                              Navigator.pop(context);
                                            }, child: Text("Save")),
                                            CupertinoDialogAction(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text("Modify")),
                                          ],
                                          content: Text("Signature cann't Modify After Save",maxLines: 2,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87)),
                                        );                 
                                      }
                                    );
                                  }
                                 
                                ),
                                TextButton(
                                  child: Text('Clear',style:TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: Colors.red,fontWeight: FontWeight.w800)),
                                  onPressed: _handleClearEngineerSignatureButtonPressed,
                                )
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 5,),

                        Container(
                          width: width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5,right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                            
                                Container(
                                  width: width*0.4,
                                  child: Text("Previous Customer Signature: ",maxLines: 2,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 15,color: Colors.black87,fontWeight: FontWeight.w700 ),)
                                ),
                                
                                Container(
                                  width: width*0.55,
                                  height: 100,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Image.network(CustomerServiceReportList.cust_sign.toString())
                                  )
                                )
                              ],
                            ),
                          ),
                        ),
                        
                        SizedBox(height: 5,),
                        
                        customerSignatureBytes.toString()!="null" ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/images/signature.png",width: 50,height: 50,),
                            Text("Customer signature saved",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)

                          ],
                        ):
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: width,
                                // height: 30,
                                child: Text("Customer Signature: ",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87),)
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Container(
                                
                                child: SfSignaturePad(
                                  key: customerSignatureGlobalKey,
                                  backgroundColor: Colors.white,
                                  strokeColor: Colors.black,
                                  minimumStrokeWidth: 3.0,
                                  maximumStrokeWidth: 6.0
                                ),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey))
                              )
                            ),

                            SizedBox(height: 5,),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  child: Text('Save',style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: themBlueColor,fontWeight: FontWeight.w800),),
                                  
                                  onPressed:(){ 
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return CupertinoAlertDialog(
                                          title: Text("Warning",maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.red)),
                                          actions: [
                                            CupertinoDialogAction(onPressed: (){
                                             _handleCustomerSignatureSaveButtonPressed();
                                              Navigator.pop(context);
                                            }, child: Text("Save")),
                                            CupertinoDialogAction(onPressed: (){
                                              Navigator.pop(context);
                                            }, child: Text("Modify")),
                                          ],
                                          content: Text("Signature cann't Modify After Save",maxLines: 2,overflow: TextOverflow.ellipsis,style:TextStyle(fontFamily: 'RobotoMono',fontSize: 20,color: Colors.black87)),
                                        );                 
                                      }
                                    );
                                  }
                                ),
                                TextButton(
                                  child: Text('Clear',style:TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,color: Colors.red,fontWeight: FontWeight.w800)),
                                  onPressed: _handleCustomerSignatureClearButtonPressed,
                                )
                              ],
                            ),
                          ],
                        ),
                            
                        SizedBox(height: 5,),
                        
                        SizedBox(
                          width: width,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(themBlueColor),
                            ),
                            onPressed: () async{

                              _handleCustomerSignatureSaveButtonPressed();
                              // _handleEngineerSignatureSaveButtonPressed();

                              
                
                              if (_formkey.currentState!.validate()) {

                                if(_selectedStartTime=="Click here"){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Choose Start Time"))); 

                                }

                                else if(_selectedEndTime=="Click here"){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Choose Finish Time"))); 

                                }

                                else if(showingOnServiceeDate=="Choose Date"){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Choose Date"))); 
                                  
                                }

                                // else if(engineerSignatureBytes.toString()=="null"){

                                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Put Engineer Signature"))); 
                                  
                                // }

                                else if(customerSignatureBytes.toString()=="null"){

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Put Customer Signature"))); 
                                  
                                }

                                else{

                                  try {
                  
                                    var response=await csrEditProcess();
                                    bool res=response.status;

                                    setState(() {
                                      msg=response.message;
                                    });
                                    
                      
                                    if(res==true){
                                      Fluttertoast.showToast(
                                        msg: msg.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                    }

                                    if(res==false){
                                      Fluttertoast.showToast(
                                        msg: msg.toString(),
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.green,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                      );
                                    }
                                
                  
                                  }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please wait for image"))); 
                                  }

                                }
                    
                               _formkey.currentState!.save();
                              } 

                              else{
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Please Enter Essential Fields"))); 
                              }    
                              
                            }, 
                            child: Text("CSR ReSubmit")
                          ),
                        )
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          
       // ),
      // ),

      
    );
  }
}