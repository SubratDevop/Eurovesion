import 'dart:io';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/CustomerServiceReportList.dart';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/EditCustomerServiceReport.dart';
import 'package:eurovision/Screens/Engineer/EngineerCustomerRegistration/EngineerCustomerRegistration.dart';
import 'package:eurovision/Screens/Engineer/EngineerTour/EngineerTour.dart';
import 'package:eurovision/Screens/Engineer/EngineerTour/EngineerTourList.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/Login/EngineerLogin.dart';
import 'package:eurovision/Screens/Engineer/Profile/EngineerProfile.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EngineerDrawer extends StatelessWidget {
  static String? name;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DrawerScreen(),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  // late SharedPreferences customerPrefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// screen Orientation end///////////

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Color expansionTileIconColor;

    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowGlow();
        return false;
      },
      child: Container(
        color: Colors.white,
        child: Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Hi ! "),
              accountEmail: Text(EngineerDrawer.name.toString()),
              // // currentAccountPicture:
              // // Image.network('https://hammad-tariq.com/img/profile.png'),

              decoration: BoxDecoration(color: themBlueColor),
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.home,
                color: Colors.black54,
                size: 25,
              ),
              title: Text('Home',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => EngineerHome()));
              },
            ),

            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.person,
                color: Colors.black54,
                size: 25,
              ),
              title: Text('Profile',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => EngineerProfile()));
              },
            ),

            // Divider(height: 2,),

            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.person_add,
                color: Colors.black54,
                size: 25,
              ), //30
              title: Text('Customer Registration',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            EngineerCustomerRegistration()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.list,
                color: Colors.black54,
                size: 25,
              ),
              title: Text('CSR List',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            CustomerServiceReportList()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.card_travel,
                color: Colors.black54,
                size: 25,
              ),
              title: Text('Tour',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => EngineerTour()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.tour,
                color: Colors.black54,
                size: 25,
              ),
              
              
              // Image.asset(
              //   "assets/images/tourList.png",
              //   height: 20,
              //   width: 20,
              //   color: Colors.black54,
              // )
            
              // Icon(
              //   Icons.liquor_outlined,
              //   color: Colors.black54,
              //   size: 25,
              // )
              
              title: Text('Tour List',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => EngineerTourList()));
              },
            ),

            // ListTile(
            //   focusColor: themWhiteColor,
            //   leading: Icon(Icons.person,color: Colors.black54,size: 30,),
            //   title: Text('Create Complain',style: TextStyle(color: Colors.black54,fontFamily: 'RobotoMono',fontWeight: FontWeight.bold,fontSize: 14)),
            //   onTap: () {

            //    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerCreateComplain()));

            //   },
            // ),

            Divider(
              height: 2.0,
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(Icons.logout),
              title: Text('Sign Out',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () async {
                SharedPreferences customerPrefs =
                    await SharedPreferences.getInstance();
                customerPrefs.clear();
                SharedPreferences userPrefs =
                    await SharedPreferences.getInstance();
                userPrefs.clear();
                SharedPreferences engPrefs =
                    await SharedPreferences.getInstance();
                engPrefs.clear();
                
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>EngineerLogin()));

              },
            ),

            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(Icons.exit_to_app),
              title: Text('Exit',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () => exit(0),
            ),
            Divider(
              height: 2.0,
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> getUserDetails() async {
    SharedPreferences engPrefs = await SharedPreferences.getInstance();
    setState(() {
      // customerPrefs = await SharedPreferences.getInstance();
      EngineerDrawer.name = engPrefs.getString("name");
    });

    print("vvvv " + EngineerDrawer.name.toString());
  }
}
