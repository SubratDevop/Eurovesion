import 'dart:io';
import 'package:ev_testing_app/Screens/Customer/CustomeItems/AddItem.dart';
import 'package:ev_testing_app/Screens/Customer/CustomeItems/CustomerItems.dart';
import 'package:ev_testing_app/Screens/Customer/CustomerCreateComplain/CustomerCreateComplain.dart';
import 'package:ev_testing_app/Screens/Customer/Home/CustomerHome.dart';
import 'package:ev_testing_app/Screens/Customer/Login/CustomerLogin.dart';
import 'package:ev_testing_app/Screens/Customer/Profile/CustomerProfile.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerDrawer extends StatelessWidget {
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
  late SharedPreferences customerPrefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCustomerNavigationCredentials();
  }

  @override
  Widget build(BuildContext context) {
    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// screen Orientation end///////////

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
              accountEmail: Text(CustomerHome.customerName.toString()),
              // // currentAccountPicture:
              // // Image.network('https://hammad-tariq.com/img/profile.png'),

              decoration: BoxDecoration(color: themBlueColor),
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.home,
                color: Colors.black54,
                size: 30,
              ),
              title: Text('Home',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => CustomerHome()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.person,
                color: Colors.black54,
                size: 30,
              ),
              title: Text('Profile',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => CustomerProfile()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.add_circle_outline,
                color: Colors.black54,
                size: 30,
              ),
              title: Text('Create Complain',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => CustomerCreateComplain()));
              },
            ),
            ListTile(
              focusColor: themWhiteColor,
              leading: Icon(
                Icons.add_shopping_cart_outlined,
                color: Colors.black54,
                size: 30,
              ),
              title: Text('My item',
                  style: TextStyle(
                      color: Colors.black54,
                      fontFamily: 'RobotoMono',
                      fontWeight: FontWeight.bold,
                      fontSize: 14)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => CustomerItems()));
              },
            ),
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
                SharedPreferences engPrefs =
                    await SharedPreferences.getInstance();
                engPrefs.clear();
                SharedPreferences userPrefs =
                    await SharedPreferences.getInstance();
                userPrefs.clear();
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => CustomerLogin()));
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

  Future<void> getCustomerNavigationCredentials() async {
    // setState(() async {
    //   customerPrefs = await SharedPreferences.getInstance();
    //   CustomerDrawer.name=customerPrefs.getString("name");

    // });

    setState(() {});
    customerPrefs = await SharedPreferences.getInstance();
    CustomerDrawer.name = customerPrefs.getString("name");
  }
}
