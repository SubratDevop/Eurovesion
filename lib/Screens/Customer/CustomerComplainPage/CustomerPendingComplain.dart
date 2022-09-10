import 'dart:convert';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerPendingComplainListModel.dart';
import 'package:eurovision/Screens/Customer/CustomerCreateComplain/CustomerCreateComplain.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/NoComplains/NoPendingComplain.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CustomerPendingComplain extends StatelessWidget {
  
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
      home: CustomerPendingComplainScreen(),
      
    );
  }
}

class CustomerPendingComplainScreen extends StatefulWidget {
 
  @override
  _CustomerPendingComplainScreenState createState() => _CustomerPendingComplainScreenState();
}

class _CustomerPendingComplainScreenState extends State<CustomerPendingComplainScreen> {

  bool information=true;

 String ? startDate,sendingToServer_startDate,endDate,sendingToServer_endDate;

  DateTime currentDate_start = DateTime.now();
  DateTime currentDate_end = DateTime.now();

 ///////////// Start Date///////////////
  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
      context: context,
      initialDate: currentDate_start,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050)))!;
    if (pickedDate != null && pickedDate != currentDate_start)
      setState(() {
        currentDate_start = pickedDate; // change current state value to picked value
        print("start date"+currentDate_start.toString());

        var dateTime = DateTime.parse("${currentDate_start}");
        print("start date 2"+dateTime.toString());

        var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}"; //change format to dd-mm-yyyyy

        var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";//change format t0 yyy-mm-dd

        startDate=formate1.toString();
        sendingToServer_startDate=formate2.toString();

        print("start date  "+startDate.toString());
        print("Sending date "+sendingToServer_startDate.toString());

      });
  }
 
  ///////////// End Date///////////////
  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
    context: context,
    initialDate: currentDate_end,
    firstDate: DateTime(2015),
    lastDate: DateTime(2050)))!;
    if (pickedDate != null && pickedDate != currentDate_end)
      setState(() {
        currentDate_end = pickedDate; // change current state value to picked value
        print("start date"+currentDate_start.toString());

        var dateTime = DateTime.parse("${currentDate_end}");
        print("start date 2"+dateTime.toString());

        var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}"; //change format to dd-mm-yyyyy

        var formate2 = "${dateTime.year}-${dateTime.month}-${dateTime.day}";//change format t0 yyy-mm-dd

        endDate=formate1.toString();
        sendingToServer_endDate=formate2.toString();

        customerPendingComplainProcess();

        print("end date  "+startDate.toString());
        print("Sending end date "+sendingToServer_startDate.toString());

      }
    );
  }


  /////////// Pending complain List/////////////////
 List showPendingComplainList=[]; 
  bool isLoading = true;


  Future<CustomerPendingComplainListModel> customerPendingComplainProcess() async {


    
    String customerPendingComplain_url= customerPendingComplainListApi;
    final http.Response response = await http.post(
        Uri.parse(customerPendingComplain_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
         // 'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          'customerid': CustomerHome.customerId.toString(),
          'token': CustomerHome.customerToken.toString(),
          'flagid': "1",
          'from_date': sendingToServer_startDate.toString(),
          'to_date' : sendingToServer_endDate.toString()
        },
       
    );
     
    if (response.statusCode == 200) {

      print("res" + response.body);

      var status=json.decode(response.body)['status'];
      print("status "+status.toString());

      if(status==false){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoPendingComplain()));

      }

      var itemList= json.decode(response.body)['data'] ?? [];

      print("item list "+itemList.toString());
      setState(() {

        information=false;
        showPendingComplainList=itemList;
      });
      

      

      return CustomerPendingComplainListModel.fromJson(json.decode(response.body));
    } else {
       
     //  showPendingComplainList=[];
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




  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      this.startDate="";
      this.endDate="";
     // showPendingComplainList=[];

      
    }

  @override
  Widget build(BuildContext context) {

    final width= MediaQuery.of(context).size.width;
    final height= MediaQuery.of(context).size.height;
    return Scaffold(

      backgroundColor: themWhiteColor,

      appBar: AppBar(
        
        backwardsCompatibility: false,
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
        //       child: Text("Login",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 60,fontWeight: FontWeight.w700,color: themWhiteColor),),
        //     ),
        //   ),
        // ),
       leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));
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
                  child: Text("Pending Complain",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
       
      ),

      // appBar: AppBar(
      //   backgroundColor: themBlueColor,
      //   elevation: 0.0,
      //   title: Center(child: Text('Pending Complain',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
      //   leading: IconButton(
      //     icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
      //     onPressed: (){
      //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));
      //     },
      //   ),
      // ),
      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: CustomerDrawer()
      ),

      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        }, 
        child: SingleChildScrollView(
          child: (
            Column(
              children: [

                Container(
                  width: width,
                  height: height*0.15,
                  color: themWhiteColor,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Container(
                            height: height*0.08,
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                  child: InkWell(
                                    onTap: (){
                                      _selectStartDate(context);
                                    },
                                    child: Container(
                                      width: width*0.35,
                                      height:30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: themWhiteColor,
                                        boxShadow: [BoxShadow(color: Colors.red, spreadRadius: 3)]
                                      ),
                                      child: Center(child: Text("Start Date",style: TextStyle(fontFamily: 'Righteous',fontSize: 14,fontWeight: FontWeight.w700,color: themBlueColor))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Text(startDate.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black54),)
                              ],
                            ),
                          ),

                          Container(
                            height: height*0.08,
                            child: Column(
                              children: [

                                Padding(
                                  padding: const EdgeInsets.only(left: 10,top: 10,right: 10),
                                  child: InkWell(
                                    onTap: startDate=="" ? null : () {
                                      _selectEndDate(context);
                                    },
                                    child: Container(
                                      width: width*0.35,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: themWhiteColor,
                                        boxShadow: [BoxShadow(color: Colors.red, spreadRadius: 3)]
                                      ),
                                      child: Center(child: Text("Final Date",style: TextStyle(fontFamily: 'Righteous',fontSize: 14,fontWeight: FontWeight.w700,color: themBlueColor))),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),

                                Text(endDate.toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black54),)
                              ],
                            ),
                          ),

                        ],
                      ),

                      Container(
                        width: width,
                        height: height*0.05,
                        alignment: Alignment.topRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("Create Complain",style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.red)),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerCreateComplain()));
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
                          ]  
                        )
                      ),


                      // Padding(
                      //   padding: const EdgeInsets.only(right: 10),
                      //   child: Align(
                      //     alignment: Alignment.topRight,
                      //     child: SizedBox(
                      //       width: width*0.6,
                      //       height: 50,
                      //       child: Padding(
                      //         padding: const EdgeInsets.only(bottom: 5,top: 5),
                      //         child: InkWell(
                      //           onTap: ()=> Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerCreateComplain())),
                      //           child: Container(
                      //             padding: EdgeInsets.all(5),      
                      //             decoration: new BoxDecoration(
                      //               //shape: BoxShape.circle,
                      //               shape: BoxShape.rectangle,
                      //               gradient: LinearGradient(
                      //                 begin: Alignment.bottomCenter,
                      //                 end: Alignment.topCenter,
                      //                 stops: [0.0, 0.5, 1.0],
                      //                 colors: [Colors.white, Colors.white,Colors.grey]
                      //               )  
                      //             ),
                      //             child: Row(
                      //               mainAxisAlignment: MainAxisAlignment.start,
                      //               children: [
                      //                 RawMaterialButton(
                      //                   onPressed: () {
                      //                     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerCreateComplain()));
                      //                   },
                      //                   child: Center(
                      //                     child: new Icon(
                      //                       Icons.add,
                      //                         color: Colors.white,
                      //                         size: 20.0,
                      //                     ),
                      //                   ),
                      //                   // shape: new CircleBorder(),
                      //                   shape: new CircleBorder(),
                      //                   elevation: 10.0,
                      //                   fillColor: Colors.red,
                      //                   padding: const EdgeInsets.all(4.0),
                      //                 ),

                      //                 Text("Create Complain",style: TextStyle(fontFamily: 'Righteous',fontSize: 15,fontWeight: FontWeight.w700,color: themBlueColor))
                      //               ]  
                      //             )
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                    
                      // Align(
                      //   alignment: Alignment.bottomRight,
                      //   child: Container(
                      //     child: Padding(
                      //       padding: EdgeInsets.only(top: 10,right: 10,left: 20,bottom: 10),
                      //       child: SizedBox(
                      //         width: width*0.4,
                      //         height: 30,
                      //         child: ElevatedButton.icon(
                      //           icon: Icon(Icons.add,color: themBlueColor,),
                      //           label: Text('Create Complain', style: TextStyle(color: themBlueColor),),
                      //           style: ElevatedButton.styleFrom(
                      //             primary: themWhiteColor,
                      //             onPrimary: Colors.white,
                      //             shadowColor: Colors.white,
                      //             shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                      //             elevation: 10,
                      //           ),
                      //           onPressed: () {

                      //             Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CustomerCreateComplain()));
                                
                      //           }
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // )
                    ]  
                  ),

                ),
 
                Container(
                  width: width,
                 height: height*0.7,
                  color: themWhiteColor,
                 // color: Colors.green,
                 // child: Text("abc"),

                 
                  child: 
                  //startDate== null  ? 

                  //Center(child: FittedBox(child: Text("Please Delect Date to see Your Pending List",style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: themBlueColor),))) :
                 
                  information ?

                  Center(child: Padding(
                    padding: const EdgeInsets.only(left: 10,right: 10),
                    child: Text("Please Choose Date, To See Your Pending Complaints",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.black54),),
                  )) :
                  
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: ListView.builder(
                      itemCount: showPendingComplainList.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          title: 
                          Container(
                           
                            height: height*0.15,
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
                                      
                                      leading: Image.asset("assets/images/complain_icon.png",height: 80,width:60,color: Colors.black45,),
                                      title: Column(
                                        children: [

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.calendar_today),
                                                  Text(showPendingComplainList[index]['complaindate'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black45),)
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Icons.lock_clock),
                                                  Text(showPendingComplainList[index]['complaintime'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color:  Colors.black45),)
                                                ],
                                              )
                                            ],
                                          ),

                                          SizedBox(
                                            height: 5,
                                          ),

                                          Row(
                                            children: [
                                              FittedBox(child: Text(showPendingComplainList[index]['complaintnumber'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black54),))
                                            ],
                                          ),

                                          Row(
                                            children: [
                                              Flexible(child: Text(showPendingComplainList[index]['complainttext'].toString(),maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Righteous',fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black87),))
                                            ],
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              Flexible(child: Text(showPendingComplainList[index]['complaintstatus'].toString(),maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Righteous',fontSize: 16,fontWeight: FontWeight.w600,color: Colors.red),))
                                            ],
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
                      }
                    ),
                  ) 
                  
                  // :

                  //Center(child: FittedBox(child: Text("Please Select Date to see Your Pending Complain List",style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: themBlueColor),)))      


                             
              
                )
              ],
            )  
    
          ),
        ),
       ),
      
    );
  }
}