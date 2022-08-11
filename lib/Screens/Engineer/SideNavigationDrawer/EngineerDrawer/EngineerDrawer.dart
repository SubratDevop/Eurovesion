import 'dart:io';
import 'package:ev_testing_app/Screens/Engineer/CustomerServiceReport/CustomerServiceReportList.dart';
import 'package:ev_testing_app/Screens/Engineer/CustomerServiceReport/EditCustomerServiceReport.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerCustomerRegistration/EngineerCustomerRegistration.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerTour/EngineerTour.dart';
import 'package:ev_testing_app/Screens/Engineer/EngineerTour/EngineerTourList.dart';
import 'package:ev_testing_app/Screens/Engineer/Home/EngineerHome.dart';
import 'package:ev_testing_app/Screens/Engineer/Login/EngineerLogin.dart';
import 'package:ev_testing_app/Screens/Engineer/Profile/EngineerProfile.dart';
import 'package:ev_testing_app/constants/constants.dart';
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
              accountName: const Text("Hi ! "),
              accountEmail: Text(EngineerDrawer.name.toString()),
              // // currentAccountPicture:
              // // Image.network('https://hammad-tariq.com/img/profile.png'),

              decoration: const BoxDecoration(color: themBlueColor),
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: const Icon(
                Icons.home,
                color: Colors.black54,
                size: 25,
              ),
              title: const Text('Home',
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
              leading: const Icon(
                Icons.person,
                color: Colors.black54,
                size: 25,
              ),
              title: const Text('Profile',
                  style: const TextStyle(
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
              leading: const Icon(
                Icons.person_add,
                color: Colors.black54,
                size: 25,
              ), //30
              title: const Text('Customer Registration',
                  style: const TextStyle(
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
              leading: const Icon(
                Icons.list,
                color: Colors.black54,
                size: 25,
              ),
              title: const Text('CSR List',
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
              leading: const Icon(
                Icons.card_travel,
                color: Colors.black54,
                size: 25,
              ),
              title: const Text('Tour',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 15),),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => const EngineerTour()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: const Icon(
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
              
              title: const Text('Tour List',
                  style: const TextStyle(
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

            const Divider(
              height: 2.0,
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out',
                  style: const TextStyle(
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
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => EngineerLogin()));
              },
            ),

            ListTile(
              focusColor: themWhiteColor,
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Exit',
                  style: const TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () => exit(0),
            ),
            const Divider(
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
