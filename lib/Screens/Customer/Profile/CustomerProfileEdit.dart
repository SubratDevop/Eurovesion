import 'dart:convert';
import 'dart:io';
import 'package:eurovision/Model/CustomerModel/CustomerProfileEditModel.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/NoInternent/NoInternetCustomerRegistration.dart';
import 'package:eurovision/Screens/Customer/Profile/CustomerProfile.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProfileEdit extends StatelessWidget {
  static String? name, customerType, contactNo, email, address , gst;

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
      home: CustomerProfileEditScreen(),
    );
  }
}

class CustomerProfileEditScreen extends StatefulWidget {
  @override
  _CustomerProfileEditScreenState createState() =>
      _CustomerProfileEditScreenState();
}

class _CustomerProfileEditScreenState extends State<CustomerProfileEditScreen> {
  late SharedPreferences customerPrefs;

  //// checking internet connectivity start
  bool _isConnected = true;

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
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => NoInternetCustomerRegistration()));
    }
  }
  //// checking internet connectivity end

  late String _name, _email, _contactNumber, _address, _GST;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactNumberController;
  late TextEditingController _addressController;
  late TextEditingController _gstController;

  final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>(); // snackbar message

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;

  Future<CustomerProfileEditModel> profileEditProcess() async {
    String customerEditPrifile_url = customerProfileEditApi;
    final http.Response response = await http.post(
      Uri.parse(customerEditPrifile_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'customerid': CustomerHome.customerId.toString(),
        'token': CustomerHome.customerToken.toString(),
        'customer_name': _nameController.text.toString(),
        'customer_address': _addressController.text.toString(),
        'customer_email': _emailController.text.toString(),
        'customer_phone': _contactNumberController.text.toString(),
        'customer_image': CustomerProfile.image.toString(),
        'gst_no': _gstController.text.toString()
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
    //var responsebody=jsonDecode(jsonDecode(response.body));
    //if(responsebody['status']==)
    if (response.statusCode == 200) {
      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      print('Profile update body');
      print(response.body);

      return CustomerProfileEditModel.fromJson(json.decode(response.body));
    } else {
      print('Profile update body');
      print(response.body);

      // print("error enter ed"+msg);

      // Fluttertoast.showToast(
      //   msg: "Existing Customer",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
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

    _checkInternetConnection();

    UpdateProfile();

  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    Widget _buildCustomerName() {
      return Container(
          // decoration: BoxDecoration(
          //   color: Color(0xffEFF3F6),
          //   borderRadius: BorderRadius.circular(0),
          //   boxShadow: [

          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ]
          // ),

          child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Customer Name",
          hintStyle: TextStyle(fontSize: 12),
          //labelText: "customer name",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Customer Name is required!';
          }
          return null;
        },
        onSaved: (String? value) {
          _name = value!;
        },
      ));
    }

    Widget _buildEmail() {
      return Container(
          // decoration: BoxDecoration(
          //   color: Color(0xffEFF3F6),
          //   borderRadius: BorderRadius.circular(0),
          //   boxShadow: [

          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ]
          // ),

          child: TextFormField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Email",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "email",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Email is Required';
          }

          if (!RegExp(
                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
              .hasMatch(value)) {
            return 'Please enter a valid email Address';
          }

          return null;
        },
        onSaved: (String? value) {
          _email = value!;
        },
      ));
    }

    Widget _buildContactNumber() {
      return Container(
          // decoration: BoxDecoration(
          //   color: Color(0xffEFF3F6),
          //   borderRadius: BorderRadius.circular(0),
          //   boxShadow: [

          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ]
          // ),

          child: TextFormField(
        maxLength: 10,
        maxLengthEnforcement:MaxLengthEnforcement.enforced,
        controller: _contactNumberController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Contact Number",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Contact Number.",

          // border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Mobile Number is required!';
          }

          if (value.length != 10) {
            return 'Mobile Number is less than 10';
          }
          return null;
        },
        onSaved: (String? value) {
          _contactNumber = value!;
        },
      ));
    }

    Widget _buildGSTno() {
      return Container(
          // decoration: BoxDecoration(
          //   color: Color(0xffEFF3F6),
          //   borderRadius: BorderRadius.circular(0),
          //   boxShadow: [

          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ]
          // ),

          child: TextFormField(
        controller: _gstController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter GST NO",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Address",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        onSaved: (String? value) {
          _GST = value!;
        },
      ));
    }

    Widget _buildAddress() {
      return Container(
          // decoration: BoxDecoration(
          //   color: Color(0xffEFF3F6),
          //   borderRadius: BorderRadius.circular(0),
          //   boxShadow: [

          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5),
          //       spreadRadius: 5,
          //       blurRadius: 7,
          //       offset: Offset(0, 3), // changes position of shadow
          //     ),
          //   ]
          // ),

          child: TextFormField(
        controller: _addressController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Address",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Address",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Address is required!';
          }
          return null;
        },
        onSaved: (String? value) {
          _address = value!;
        },
      ));
    }

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: themWhiteColor,
      appBar: AppBar(
         
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: themBlueColor,
        elevation: 0.0,
        title: Center(
          child: Text(
            'Profile',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'AkayaKanadaka',
                fontWeight: FontWeight.w800,
                fontSize: 30),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
            size: 40,
          ),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => CustomerProfile()));
          },
        ),
      ),
      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: CustomerDrawer()),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: Form(
          key: _formkey,
          // autovalidate: _autovalidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: width,
                    height: height * 0.1,
                    color: themBlueColor,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: 20, bottom: 10, left: 20),
                        child: FittedBox(
                            child: Text(
                          "You can change Profile details here....",
                          style: TextStyle(
                              fontFamily: 'AkayaKanadaka',
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                              color: themWhiteColor),
                        )),
                      ),
                    ),
                  ),

                  //////////////////

                  Container(
                    width: width,
                    height: height * 0.5,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Customer Name",
                                    style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: themBlueColor),
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: _buildCustomerName(),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Email",
                                    style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: themBlueColor),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: _buildEmail()),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Contact No",
                                    style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: themBlueColor),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: _buildContactNumber()),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, bottom: 0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "GST No",
                                    style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: themBlueColor),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: _buildGSTno()),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, top: 10, bottom: 0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Address",
                                    style: TextStyle(
                                        fontFamily: "WorkSans",
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: themBlueColor),
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child: _buildAddress()),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: height * 0.09,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: SizedBox(
                          height: 50,
                          width: width,
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: 10, left: 5, right: 5),
                            child: ElevatedButton.icon(
                                icon: Icon(Icons.app_registration),
                                label: Text(
                                  "Save Profile",
                                  style: TextStyle(
                                      fontFamily: 'AkayaKanadaka',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: themWhiteColor),
                                ),
                                style: ElevatedButton.styleFrom(
                              backgroundColor: themBlueColor,
                                  shadowColor: Colors.white60,
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(0))),
                                  elevation: 10,
                                ),
                                //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  _checkInternetConnection();

                                  if (_formkey.currentState!.validate()) {
                                    // showLoaderDialog(context); //showing loader
                                    var response = await profileEditProcess();
                                    bool resStatus = response.status;
                                    var resMessage = response.message;

                                    setState(() {
                                      CustomerProfileEdit.name =
                                          response.customername.toString();
                                      CustomerProfileEdit.customerType =
                                          response.customertypename.toString();
                                      CustomerProfileEdit.contactNo =
                                          response.customermobile.toString();
                                      CustomerProfileEdit.email =
                                          response.customermail.toString();
                                      CustomerProfileEdit.address =
                                          response.customeraddress.toString();
                                      CustomerProfileEdit.gst =
                                          response.gst.toString();
                                          

                                      CustomerProfile.name =
                                          CustomerProfileEdit.name.toString();

                                      customerPrefs.setString("email",
                                          CustomerProfileEdit.email.toString());
                                      customerPrefs.setString(
                                          "contact",
                                          CustomerProfileEdit.contactNo
                                              .toString());
                                      customerPrefs.setString("name",
                                          CustomerProfileEdit.name.toString());

                                      customerPrefs.setString(
                                          "customerTypeName",
                                          CustomerProfileEdit.customerType
                                              .toString());
                                      customerPrefs.setString(
                                          "customerAddress",
                                          CustomerProfileEdit.address
                                              .toString());
                                      customerPrefs.setString(
                                          "gst",
                                          CustomerProfileEdit.gst
                                              .toString());
                                    });

                                    if (resStatus == true) {
                                      //Navigator.pop(context);  //hide loader
                                      Fluttertoast.showToast(
                                          msg: resMessage.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      setState(() {
                                        CustomerHome.customerName =
                                            customerPrefs.getString("name");
                                      });

                                      Navigator.of(context, rootNavigator: true)
                                          .push(MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerProfile()));
                                    }
                                  }

                                  // catch(err){

                                  // if(passwordController.text.toString()==confirmPasswordController.text.toString()){

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Sorry Cann't Update Profile"
                                                  .toString())));
                                  //  }

                                  //  Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ExistingUser()));
                                  // Fluttertoast.showToast(
                                  //  msg: "not sufficient",
                                  //   toastLength: Toast.LENGTH_SHORT,
                                  //   gravity: ToastGravity.CENTER,
                                  //   timeInSecForIosWeb: 1,
                                  //   backgroundColor: Colors.red,
                                  //   textColor: Colors.white,
                                  //   fontSize: 16.0
                                  // );

                                  //  }

                                  //  }

                                  _formkey.currentState!.save();
                                }),
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
      ),
    );
  }

  void UpdateProfile() async {
    customerPrefs = await SharedPreferences.getInstance();

    setState(() {
      CustomerProfileEdit.email = customerPrefs.getString("email");
      CustomerProfileEdit.contactNo = customerPrefs.getString("contact");
      CustomerProfileEdit.name = customerPrefs.getString("name");
      CustomerProfileEdit.customerType =
          customerPrefs.getString("customerTypeName");
      CustomerProfileEdit.address = customerPrefs.getString("customerAddress");
      CustomerProfileEdit.gst = customerPrefs.getString("gst");

      // _nameController=TextEditingController(text: CustomerHome.name.toString() );

      _nameController = TextEditingController(
          text: CustomerProfileEdit.name.toString() == null
              ? CustomerHome.customerName.toString()
              : CustomerProfileEdit.name.toString());
      _emailController = TextEditingController(
          text: CustomerProfileEdit.email.toString() == null
              ? CustomerHome.customerEmail.toString()
              : CustomerProfileEdit.email.toString());
      _contactNumberController = TextEditingController(
          text: CustomerProfileEdit.contactNo.toString() == null
              ? CustomerHome.customerContact.toString()
              : CustomerProfileEdit.contactNo.toString());
      _addressController = TextEditingController(
          text: CustomerProfileEdit.address.toString() == null
              ? CustomerHome.customerAddress.toString()
              : CustomerProfileEdit.address.toString());
      _gstController = TextEditingController(
          text: CustomerProfileEdit.gst.toString() == null
              ? CustomerHome.customerGst.toString()
              : CustomerProfileEdit.gst.toString());        

      print("????????????????????? " + CustomerProfileEdit.email.toString());
    });
  }
}
