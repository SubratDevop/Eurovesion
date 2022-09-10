import 'dart:async';
import 'dart:io';
import 'package:eurovision/Screens/Customer/Registration/CustomerRegistration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NoInternetCustomerRegistration extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    /// screen Orientation end///////////
    return MaterialApp(

       builder: (context, child) {  // Preventing app text font size from Any device font size configuration
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      
      debugShowCheckedModeBanner: false,
      home: NoInternetScreen(),
    );
  }
}

class NoInternetScreen extends StatefulWidget {
  
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      //BackButtonInterceptor.add(myInterceptor);
      Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>RegistrationCustomer())));
  }

  @override
  void dispose() {
   // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   Fluttertoast.showToast(
  //     msg: 'Sorry can not back here',
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.BOTTOM,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: themColor
  //   );
  //   //print("BACK BUTTON!"); // Do some stuff.
  //   return true;
  // }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFe1e8ee),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),  // for change Drawer icon color
       
        // leading: IconButton(
        //   icon: Icon(Icons.keyboard_arrow_left,color: Colors.black,size: 40,),
         
        //   onPressed: (){
        //     //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
        //     Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CurvedBottomNavigationBar()));
        //   },
        // ),
        // title:(
        //   // alignment: Alignment.center,
        //   Text('Go To Home',style: TextStyle(color:Colors.black54,fontSize: 20.0,fontWeight: FontWeight.bold,fontFamily: "Roboto"))
        // ),
      ),


      
      
      
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/no_internent.jpg",height: 300,fit: BoxFit.fill,),
              Text('No Internet',style: TextStyle(color: Colors.red,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 25),),
              SizedBox(height: 5,),
              FittedBox(child: Text('Please Check Internet Connectivity',style: TextStyle(color: Colors.red,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 25),))
            ],
         
          ),
        ),
      ),
      
    );
  }
}