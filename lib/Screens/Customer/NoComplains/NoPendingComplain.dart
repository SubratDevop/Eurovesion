import 'dart:async';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CustomerPendingComplain.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoPendingComplain extends StatelessWidget {
  

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
      home: NoPendingComplainScreen(),
    );
  }
}

class NoPendingComplainScreen extends StatefulWidget {
 
  @override
  _NoPendingComplainScreenState createState() => _NoPendingComplainScreenState();
}

class _NoPendingComplainScreenState extends State<NoPendingComplainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
   // Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>CustomerPendingComplain())));
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(

      body:  NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
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
                            // primary: themBlueColor,
                            // onPrimary: Colors.white,
                            backgroundColor: themBlueColor,
                            shadowColor: themBlueColor,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                            elevation: 10,
                          ),
                          onPressed: () {
                            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerPendingComplain()));                      
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