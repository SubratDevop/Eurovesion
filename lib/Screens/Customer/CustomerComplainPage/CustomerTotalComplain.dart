import 'dart:convert';
import 'dart:io';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CutomerTotalComplainListModel.dart';
import 'package:eurovision/Screens/Customer/CustomerCreateComplain/CustomerCreateComplain.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/NoComplains/NoTotalComplain.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CustomerTotalComplain extends StatelessWidget {
  
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
      home: CustomerTotalComplainScreen(),
      
    );
  }
}

class CustomerTotalComplainScreen extends StatefulWidget {
  

  @override
  _CustomerTotalComplainScreenState createState() => _CustomerTotalComplainScreenState();
}

class _CustomerTotalComplainScreenState extends State<CustomerTotalComplainScreen> {

  bool information=true;

  List showTotalComplainList=[]; 
  bool isLoading = true;

  Future<CustomerTotalComplainListModel> customerTotalComplainProcess() async {

    String customerTotalComplain_url= customerTotalComplainListApi;
    final http.Response response = await http.post(
        Uri.parse(customerTotalComplain_url),
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

      var status=json.decode(response.body)['status'];
      print("status "+status.toString());

       if(status==false){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoTotalComplain()));

      }

      print("res" + response.body);
      var itemList=json.decode(response.body)['data'] ?? [];

     


      setState(() {
        information=false;
        showTotalComplainList = itemList;

      });

      return CustomerTotalComplainListModel.fromJson(json.decode(response.body));
    } else {
    
      throw Exception('Failed to create album.');
    }
  }

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      customerTotalComplainProcess();
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
                  child: Text("Total Complain",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
       
      ),

      
      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: CustomerDrawer()
      ),

      body: 
      NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        }, 
        child: Column(
          children: [

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
            


            Container(
              width: width,
              height: height*0.75,
              
             // color: Colors.green,
             // child: Text("abc"),

              child: 
              
              information ?

              Center(child: Padding(
                padding: const EdgeInsets.only(left: 10,right: 10),
                child: Text("Please Wait....",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 25,fontWeight: FontWeight.w700,color: Colors.black54),),
              )) :
              
              Padding(
                padding: const EdgeInsets.only(bottom: 5,top: 10),
                child: ListView.builder(
                  itemCount: showTotalComplainList.length,
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
                                  
                                  leading: 

                                  showTotalComplainList[index]['complaintstatus'].toString()=="Pending" ?
                                  
                                  Image.asset("assets/images/complain_icon.png",height: 80,width:60,color: Colors.red,) :
                                  Image.asset("assets/images/complain_icon.png",height: 80,width:60,color: Colors.green,)
                                  ,
                                  title: Column(
                                    children: [

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today),
                                              Text(showTotalComplainList[index]['complaindate'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black45),)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.lock_clock),
                                              Text(showTotalComplainList[index]['complaintime'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color:  Colors.black45),)
                                            ],
                                          )
                                        ],
                                      ),

                                      SizedBox(
                                        height: 5,
                                      ),

                                      Row(
                                        children: [
                                          FittedBox(child: Text(showTotalComplainList[index]['complaintnumber'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 18,fontWeight: FontWeight.w700,color: Colors.black54),))
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Flexible(child: Text(showTotalComplainList[index]['complainttext'].toString(),maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Righteous',fontSize: 16,fontWeight: FontWeight.w900,color: Colors.black87),))
                                        ],
                                      ),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Flexible(
                                            child: 

                                            showTotalComplainList[index]['complaintstatus'].toString()=="Pending" ?
                                          
                                            Text(showTotalComplainList[index]['complaintstatus'].toString(),maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Righteous',fontSize: 16,fontWeight: FontWeight.w600,color: Colors.red),) :
                                            Text(showTotalComplainList[index]['complaintstatus'].toString(),maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: 'Righteous',fontSize: 16,fontWeight: FontWeight.w600,color: Colors.green),) 
                                          )
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
                         
          
            )
          ],
        ),
      ),





    );  
      
  }
}