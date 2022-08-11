import 'dart:async';
import 'package:ev_testing_app/Screens/Customer/CustomerComplainPage/CustomerTotalComplain.dart';
import 'package:ev_testing_app/Screens/Customer/Home/CustomerHome.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoTotalComplain extends StatelessWidget {
  

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
      home: NoTotalComplainScreen(),
    );
  }
}

class NoTotalComplainScreen extends StatefulWidget {
 
  @override
  _NoTotalComplainScreenState createState() => _NoTotalComplainScreenState();
}

class _NoTotalComplainScreenState extends State<NoTotalComplainScreen> {

  


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
    //Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>CustomerTotalComplain())));
  }
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return Scaffold(

      body:  NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        }, 

        child: Container(

          width: width,
          height: height,

          child: Center(

            child: Container(
              width: width,
              height: height*0.4,
              
              child: Center(
                child: Column(
                  children: [
                    Image.asset("assets/images/no_complain_icon.png",height: 200,width:200,color: Colors.black54),

                    FittedBox(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text("No Complaints",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: Colors.black45),),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 5,right: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.arrow_back),
                          label: FittedBox(child: Text('Back', style: TextStyle(color: Colors.white,fontSize: 16),)),
                          style: ElevatedButton.styleFrom(
                            primary: themBlueColor,
                            onPrimary: Colors.white,
                            shadowColor: themBlueColor,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                            elevation: 10,
                          ),
                          onPressed: () {
                            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));                      
                          }
                        ),
                      ),
                    ),
                    
                  ]  
                ),
              )
            ),

              
          ),
        ),
      ),
    
      
    );
  }
}