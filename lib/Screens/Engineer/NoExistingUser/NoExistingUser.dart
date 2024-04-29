import 'dart:async';


import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/Screens/Engineer/Login/EngineerLogin.dart';
import 'package:flutter/material.dart';

class NoEngExisting extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoExistingUserScreen(),
    );
  }
}

class NoExistingUserScreen extends StatefulWidget {
  
  @override
  _NoExistingUserScreenState createState() => _NoExistingUserScreenState();
}

class _NoExistingUserScreenState extends State<NoExistingUserScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // BackButtonInterceptor.add(myInterceptor);
  //  Timer(Duration(seconds: 3),()=>Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>CustomerLogin())));
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
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

      // endDrawer: Container(
      //   width: MediaQuery.of(context).size.width*0.7,
      //   child: MyDrawer()
      // ),
      
      // body: Container(
      //   child: Center(
      //     child: Image.asset("assets/images/empty_cart.png"),
      //   ),
      // ),

      body:  NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        }, 
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/no_existing_user.png",height: 200,width: 200,),
                SizedBox(
                  height: 10,
                ),
                FittedBox(child: Text('You Are Not An Existing User !!!!',maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),)),
                SizedBox(height: 10,),
                ElevatedButton(
                  onPressed:(){
                    Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerLogin()));
                  }, 
                 child: Text("Back"))
                // SizedBox(
                //   height: 10,
                // ),
                // InkWell(
                //   onTap: (){
                //      Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> Login()));
                //   },
                //   child: Text('Click here',style: TextStyle(decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.wavy,color: themColor,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),)
                // )
              ],
              
            ),
          ),
        ),
      ),
      
    );
  }
}