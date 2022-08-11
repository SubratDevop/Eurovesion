import 'dart:async';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:ev_testing_app/Screens/Customer/Home/CustomerHome.dart';
import 'package:ev_testing_app/Screens/Customer/Login/CustomerLogin.dart';
import 'package:ev_testing_app/Screens/Engineer/Home/EngineerHome.dart';
import 'package:ev_testing_app/Screens/WelCome/WelCome.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ev_testing_app/Screens/SplashScreen/NoInternetSplashScreen.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  
 // static String ? email,contact,name,token,customerId,customerCode,customerTypeName,customerAddress;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenHome(),
      
    );
  }
}

class SplashScreenHome extends StatefulWidget {

  @override
  _SplashScreenHomeState createState() => _SplashScreenHomeState();
}

class _SplashScreenHomeState extends State<SplashScreenHome> {

  //// checking internet connectivity start
  bool _isConnected=true;
  // This function is triggered when the floating button is pressed
  Future<void> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
      }
    } on SocketException catch (err) {
      setState(() {
        _isConnected = false;
      });
      print(err);
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoInternetSplashScreen()));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    _checkInternetConnection();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    Fluttertoast.showToast(
      msg: 'Sorry can not back here',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red
    );
    //print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  void startTimer() {
    Timer(Duration(seconds: 2), () {
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Welcome()));
    //  chooseUser(); //It will redirect  after 3 seconds
    });
  }
    
  void chooseUser() async{

    
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    var user=userPrefs.getString("user");

    if(user==null){
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerLogin()));
    }
    if(user=="customer"){
     navigateCustomer();
    //Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerHome()));
    }

    if(user=="eng"){
    //navigateEngineer();
      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>EngineerHome()));
    }
  }


  //// checking internet connectivity end
  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: width,
        height: height,
        child: Center(
          child: Container(
            width: width,
            height: height*0.6,
            child: Column(
              children: [
                Image.asset("assets/images/logo.png",width: 300,height: 300,),
                SizedBox(height: 20,),
                SizedBox(
               
               
                child: Shimmer.fromColors(
                  baseColor: themBlueColor,
                  highlightColor: Colors.white,
                  child: FittedBox(
                    child: Text(
                      'EUROVESION',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'TimesNewRoman',
                        fontSize: 50.0,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )
              ],
            ),
          ),
        ),


      ),
    
      
    );
  }

  void navigateCustomer() async{
     SharedPreferences customerPrefs = await SharedPreferences.getInstance();
     setState(() {
      // SplashScreen.email=customerPrefs.getString("email")!;
      // SplashScreen.contact=customerPrefs.getString("contact");
      // SplashScreen.name=customerPrefs.getString("name");
      // SplashScreen.token=customerPrefs.getString("token");
      // SplashScreen.customerId=customerPrefs.getString("customerId");
      // SplashScreen.customerCode=customerPrefs.getString("customerCode");
      // SplashScreen.customerTypeName=customerPrefs.getString("customerTypeName");
      // SplashScreen.customerAddress=customerPrefs.getString("customerAddress");
      
      // print("Name  .........."+SplashScreen.name.toString());
    });

    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerHome()));


  }
}