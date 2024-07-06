import 'dart:convert';
import 'dart:io';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerRegistrationModel.dart';
import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/Screens/Customer/NoInternent/NoInternetCustomerRegistration.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegistrationCustomer extends StatelessWidget {
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
      home: RegistrationScreen(),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
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

  bool _hidePassword = true;

  late String _name,
      _branchcode,
      _contactPerson,
      _email,
      _contactNumber,
      _GST,
      _address,
      _password,
      _confirmPassword;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactPersonController = TextEditingController();
  TextEditingController _branchCodeController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _GSTController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _pincodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>(); // snackbar message

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;

  String? customerType_dropdown_id;
  String? stateType_dropdown_id;
  String? districtType_dropdown_id;

  ///////// CustomerType Api Start///////////
  List showCustomerTypeList = [];
  fetchCustomerTypeList() async {
    var showCustomerTypeList_url = customerTypeApi;
    var response = await http.get(
      Uri.parse(showCustomerTypeList_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'] ?? [];

      print('State body');
      print(items);

      setState(() {
        showCustomerTypeList = items;
      });

      if (showCustomerTypeList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showCustomerTypeList = [];
    }
  }
  ///////// CustomerType Api End///////////

  ///////// State Api Start///////////

  List showStateList = [];

  fetchStateList() async {
    var showStateList_url = stateApi;
    var response = await http.get(
      Uri.parse(showStateList_url),
    );
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];

      print('State body');
      print(items);

      setState(() {
        showStateList = items;
      });

      if (showStateList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showStateList = [];
    }
  }

  ///////// State Api End///////////

  ///// District Api Start ///////////
  List showDistrictList = [];

  fetchDistrictList() async {
    print("chicking state id " + stateType_dropdown_id.toString());

    var showDistrictList_url = districtApi;
    var response = await http.post(Uri.parse(showDistrictList_url),
        headers: <String, String>{},
        body: {"stateid": stateType_dropdown_id.toString()});
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      bool status = json.decode(response.body)['status'];
      var message = json.decode(response.body)['message'];

      print("message //" + message.toString());

      print('District body');
      print(items);

      print("status checking");
      print(status.toString());

      if (status == true) {
        setState(() {
          showDistrictList = items;
        });
      }
      if (status == false) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message.toString())));
        setState(() {
          showDistrictList = [];
        });
      }

      if (showDistrictList.length == 0) {
        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }
    } else {
      showDistrictList = [];
    }
  }
  ///// District Api End ///////////

  Future<CustomerRegistrationModel> registrationProcess() async {
    String registration_url = registrationApi;
    final http.Response response = await http.post(
      Uri.parse(registration_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        //'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'customer_type': customerType_dropdown_id.toString(),
        'customer_name': _nameController.text.toString(),
        'branch_name': _branchCodeController.text.toString(),
        'customer_address': _addressController.text.toString(),
        'customer_email': _emailController.text.toString(),
        'customer_phone': _contactNumberController.text.toString(),
        'contact_person': _contactPersonController.text.toString(),
        'customer_password': _confirmPasswordController.text.toString(),
        'customer_state': stateType_dropdown_id.toString(),
        'customer_district': districtType_dropdown_id.toString(),
        'customer_pincode': _pincodeController.text.toString(),
        'gst_no':_GSTController.text.toString()
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );

    print(_GSTController.text.toString());
    //var responsebody=jsonDecode(jsonDecode(response.body));
    //if(responsebody['status']==)
    if (response.statusCode == 200) {
      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      print('Registration body');
      print(response.body);

      return CustomerRegistrationModel.fromJson(json.decode(response.body));
    } else {
      print('else Registration body');
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

    this.fetchCustomerTypeList();
    this.fetchStateList();
    // this.fetchDistrictList();
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

    Widget _branchCode() {
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
        controller: _branchCodeController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Branch code & Name",
          hintStyle: TextStyle(fontSize: 12),
          //labelText: "branch code",

          // border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Branch code & Name is required!';
          }
          return null;
        },
        onSaved: (String? value) {
          _branchcode = value!;
        },
      ));
    }

    Widget _buildContactPerson() {
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
        controller: _contactPersonController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Contact Person",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Contact Person",

          //border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Contact Person is required!';
          }
          return null;
        },
        onSaved: (String? value) {
          _contactPerson = value!;
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

    Widget _buildGST() {
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
        controller: _GSTController,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter GST No",
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

    Widget _buildPinCode() {
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
        maxLength: 6,
        maxLengthEnforcement:MaxLengthEnforcement.enforced,
        controller: _pincodeController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Pincode",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Pincode",

          // border: InputBorder.none
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Pincode is required!';
          }
          return null;
        },
        onSaved: (String? value) {
        },
      ));
    }

    Widget _buildPassword() {
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
        controller: _passwordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _hidePassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(left: 0),
          hintText: "Enter Password",
          hintStyle: TextStyle(fontSize: 12),
          // labelText: "Password",

          //border: InputBorder.none,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(0)
          // )
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Password is required!';
          }

          if (value.length < 2) {
            return 'Password is length is too short!';
          }
          return null;
        },
        onSaved: (String? value) {
          _password = value!;
        },
      ));
    }

    Widget _buildConfirmPassword() {
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
        controller: _confirmPasswordController,
        keyboardType: TextInputType.visiblePassword,
        obscureText: _hidePassword,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(left: 0),
            hintText: "Enter Verify Password",
            hintStyle: TextStyle(fontSize: 12),
            //labelText: "Verify Password",

            // border: InputBorder.none,
            // border: OutlineInputBorder(
            //   borderRadius: BorderRadius.circular(0)
            // ),

            suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _hidePassword = !_hidePassword;
                  });
                },
                icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                    size: 17.0))),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Confirm Password is required!';
          }

          if (value.length < 2) {
            return 'Password is length is too short!';
          }

          if (_passwordController.text.toString() !=
              _confirmPasswordController.text.toString()) {
            return 'Password MissMatch !';
          }
          return null;
        },
        onSaved: (String? value) {
          _confirmPassword = value!;
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
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.2,
        elevation: 0.0,
        title: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, top: 40),
              child: Text(
                "Registration",
                style: TextStyle(
                    fontFamily: 'AkayaKanadaka',
                    fontSize: 40,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
            ),
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
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => CustomerLogin()));
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
                    child: Text(
                      "Eurovesion",
                      style: TextStyle(
                          fontFamily: 'TimesNewRoman',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: themWhiteColor),
                    )),
              ),
            ),
          ),
        ),
      ),

      // appBar: AppBar(
      //   toolbarHeight: height*0.1,
      //   backgroundColor: themBlueColor,
      //   elevation: 0.0,
      //   title: Center(child: Text('Registration',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
      //   leading: IconButton(
      //     icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
      //     onPressed: (){
      //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerLogin()));
      //     },
      //   ),
      // ),

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
            width: width,
            height: height * 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Container(
                  //   alignment: Alignment.bottomLeft,
                  //   width: width,
                  //   height: height*0.1,
                  //   color: themBlueColor,
                  //   child: Align(
                  //     alignment: Alignment.bottomRight,

                  //     child: Padding(

                  //       padding: const EdgeInsets.only(right: 20,bottom: 10),
                  //       child: Text("Please Register here...",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                  //     ),
                  //   ),

                  // ),

                  //////////////////

                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 20, bottom: 2),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Customer Type",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
                              // decoration: BoxDecoration(
                              //   //color: Color(0xffEFF3F6),
                              //   color: themWhiteColor,
                              //   borderRadius: BorderRadius.circular(0),
                              //   boxShadow: [

                              //     BoxShadow(
                              //       color: Colors.grey.withOpacity(0.5),
                              //       spreadRadius: 5,
                              //       blurRadius: 7,
                              //       offset: Offset(0, 3), // changes position of shadow
                              //     ),
                              //   ]
                              //   border: Border(
                              //       bottom: BorderSide(
                              //           color: Colors.black54,
                              //           width: 1.0
                              //       )
                              //   )
                              // ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),

                                value: customerType_dropdown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text('Please Choose Customer',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                onChanged: (itemid) => setState(
                                    () => customerType_dropdown_id = itemid),

                                validator: (value) => value == null
                                    ? 'Customer is required'
                                    : null,
                                items: showCustomerTypeList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['typename'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                                // items:
                                //   ['common', 'Bank',].map<DropdownMenuItem<String>>((String value) {
                                //   return DropdownMenuItem<String>(

                                //     value: value,
                                //     child: FittedBox(child: Padding(
                                //       padding: EdgeInsets.only(left: 0),
                                //       child: Text(value,style: TextStyle(fontFamily: 'RaleWay',fontSize: 18,fontWeight: FontWeight.w800,color: Colors.black54),))
                                //     ),
                                //   );
                                // }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
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
                          customerType_dropdown_id == "2"
                              ? Container(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 0),
                                        child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Branch Code & Name",
                                              style: TextStyle(
                                                  fontFamily: "WorkSans",
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: themBlueColor),
                                            )),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: _branchCode(),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(""),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Contact Person",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: _buildContactPerson()),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 0),
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
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 0),
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
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Select State",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
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
                              //  // color: themWhiteColor,
                              //   // border: Border(
                              //   //     bottom: BorderSide(
                              //   //         color: Colors.black54,
                              //   //         width: 1.0
                              //   //     )
                              //   // )
                              // ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),
                                value: stateType_dropdown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text('Please Choose State',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                onChanged: (itemid) {
                                  setState(() {
                                    stateType_dropdown_id = itemid;
                                    districtType_dropdown_id = null;
                                    fetchDistrictList();
                                  });

                                  print("State Id ///////////////////" +
                                      stateType_dropdown_id.toString());
                                },
                                validator: (value) =>
                                    value == null ? 'State is required' : null,
                                items: showStateList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['statename'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Select District",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Container(
                              height: 70.0,
                              width: MediaQuery.of(context).size.width - 10,
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
                              //   //color: themWhiteColor,
                              //   // border: Border(
                              //   //     bottom: BorderSide(
                              //   //         color: Colors.black54,
                              //   //         width: 1.0
                              //   //     )
                              //   // )
                              // ),
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black54,
                                  size: 30,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black54))),

                                value: districtType_dropdown_id,
                                hint: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text('Please Choose District',
                                      style: TextStyle(
                                          fontFamily: 'RaleWay',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black38)),
                                ),
                                // onChanged: (itemid) =>
                                //     setState(() => districtType_dropdown_id = itemid),
                                onChanged: (itemid) {
                                  setState(() {
                                    districtType_dropdown_id = null;
                                    this.districtType_dropdown_id = itemid;
                                    //stateType_dropdown_id=null;
                                  });
                                  // fetchDistrictList();

                                  print("distric Id ///////////////////" +
                                      districtType_dropdown_id.toString());
                                },
                                validator: (value) => value == null
                                    ? 'District is required'
                                    : null,
                                items: showDistrictList.map((list) {
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['districtname'].toString(),
                                        style: TextStyle(
                                            color: Color(0xff454f63),
                                            fontWeight: FontWeight.w800,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 16),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 0),
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
                              child: _buildGST()),
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
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Pincode",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: _buildPinCode()),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 0),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Password",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: _buildPassword()),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, bottom: 5),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Verify Password",
                                  style: TextStyle(
                                      fontFamily: "WorkSans",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: themBlueColor),
                                )),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: _buildConfirmPassword()),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    height: height * 0.09,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5, left: 5, right: 5),
                        child: SizedBox(
                          height: 50,
                          width: width,
                          child: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ElevatedButton.icon(
                                icon: Icon(Icons.app_registration),
                                label: FittedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Registration",
                                      style: TextStyle(
                                          fontFamily: 'AkayaKanadaka',
                                          fontSize: 40,
                                          fontWeight: FontWeight.w700,
                                          color: themWhiteColor),
                                    ),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                               backgroundColor: themBlueColor,
                                  shadowColor: Colors.white60,
                                  shape: const BeveledRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  elevation: 10,
                                ),
                                //label: Text('Cancel', style: TextStyle(color: Colors.white),),
                                onPressed: () async {
                                  _checkInternetConnection();

                                  if (_formkey.currentState!.validate()) {
                                    //form is valid, proceed further

                                    try {
                                      // if(passwordController.text.toString()!=confirmPasswordController.text.toString()){

                                      //   scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Password Missmatch".toString())));
                                      // }

                                      // showLoaderDialog(context); //showing loader
                                      var response =
                                          await registrationProcess();
                                      bool resStatus = response.status;
                                      var resMessage = response.message;

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

                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .push(MaterialPageRoute(
                                                builder: (context) =>
                                                    CustomerLogin()));
                                      }
                                    } catch (err) {
                                      // if(passwordController.text.toString()==confirmPasswordController.text.toString()){

                                      // scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("You are Existing User".toString())));
                                      //  }

                                      ////////// Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> ExistingUser()));
                                      Fluttertoast.showToast(
                                          msg: "Existing User",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  }

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
}
