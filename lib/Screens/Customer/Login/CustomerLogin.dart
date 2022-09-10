import 'dart:convert';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerLoginModel.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerVerify.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/NoExistingCustomer/NoExistingCustomer.dart';
import 'package:eurovision/Screens/Customer/NoInternent/NoInternetCustomerLogin.dart';
import 'package:eurovision/Screens/Customer/Registration/CustomerRegistration.dart';
import 'package:eurovision/Screens/Engineer/Login/EngineerLogin.dart';
import 'package:eurovision/Screens/WelCome/WelCome.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:eurovision/bloc/CustomerLogin_bloc.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerLogin extends StatelessWidget {
  static String? customerid;
  static String? token,
      customertypeid,
      customertypename,
      customername,
      customercode,
      customermobile,
      customermail,
      customeraddress;

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
      home: CustomerLoginScreen(),
    );
  }
}

class CustomerLoginScreen extends StatefulWidget {
  @override
  _CustomerLoginScreenState createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  final styleWelcome = TextStyle(
      fontSize: 30, fontWeight: FontWeight.w700, color: themWhiteColor);
  final styleLogin = TextStyle(
      fontSize: 50, fontWeight: FontWeight.w700, color: themWhiteColor);
  final styleForgotPassword = TextStyle(
      fontSize: 100, fontWeight: FontWeight.w600, color: themWhiteColor);

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _hidePassword = true;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;

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
      // Navigator.of(context, rootNavigator: true).push( MaterialPageRoute(builder: (context) => NoInternetCustomerLogin()));
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NoInternetCustomerLogin()));
    }
  }

  //// checking internet connectivity end

  ////////////Customer Login Start///////////
  Future<CustomerLoginModel> customerLoginProcess(
      String contact, String password) async {
    String customerLogin_url = loginApi;
    final http.Response response = await http.post(
      Uri.parse(customerLogin_url),
      headers: <String, String>{'Accept': 'application/json'},
      body: {
        'data1': contact,
        'data2': password,
      },
    );

    if (response.statusCode == 200) {
      return CustomerLoginModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }

  // ! BackButtonInterceptor
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    // Fluttertoast.showToast(
    //   msg: 'Sorry can not back here',
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   timeInSecForIosWeb: 1,
    //   backgroundColor: themBlueColor
    // );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WelComeScreen(),
      ),
    );
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => WelComeScreen(),
    //   ),
    //   (route) => true,
    // );
    // exit(0);
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BackButtonInterceptor.add(myInterceptor);
    _checkInternetConnection();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    BackButtonInterceptor.remove(myInterceptor);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<CustomerLoginBloc>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: themWhiteColor,
      appBar: AppBar(
        backwardsCompatibility: false,
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
              padding: const EdgeInsets.only(left: 10, top: 50),
              child: Text(
                "Login",
                style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
            ),
          ),
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
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowGlow();
          return false;
        },
        child: Form(
          key: _formkey,
          // autovalidate: _autovalidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                Container(
                  // height: height * 0.7,

                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 30),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email/Phone No",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: themBlueColor),
                            )),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding:
                            EdgeInsets.only(left: 10, right: 10, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffEFF3F6),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ]),
                          child: StreamBuilder<String>(
                              stream: bloc.loginEmail,
                              //Instead of TextEditingController, bloc carrying input value by calling loginEmail
                              builder: (context, snapshot) {
                                return TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 20),
                                      hintText: "Enter email or phone",
                                      labelText: "email/phone",
                                      errorText: snapshot.error?.toString(),
                                      border: InputBorder.none
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(20)
                                      // )

                                      ),
                                  onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                );
                              }),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: themBlueColor),
                            )),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xffEFF3F6),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),

                                // BoxShadow(
                                //   color: Color.fromRGBO(0, 0, 0, 0.1),
                                //   offset: Offset(6,2),
                                //   blurRadius: 6.0,
                                //   spreadRadius: 3.0

                                // ),
                                // BoxShadow(
                                //   color: Color.fromRGBO(255, 255, 255, 0.9),
                                //   offset: Offset(-6,-2),
                                //   blurRadius: 6.0,
                                //   spreadRadius: 3.0
                                // )
                              ]),
                          child: StreamBuilder<String>(
                              stream: bloc.loginPassword,
                              //Instead of TextEditingController, bloc carrying input value by calling loginPassword
                              builder: (context, snapshot) {
                                return TextField(
                                  obscureText: _hidePassword,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.only(left: 20),
                                      hintText: "Enter user password",
                                      labelText: "password",
                                      errorText: snapshot.error?.toString(),
                                      border: InputBorder.none,
                                      // border: OutlineInputBorder(
                                      //   borderRadius: BorderRadius.circular(20)
                                      // )

                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hidePassword = !_hidePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            size: 17.0,
                                            color: themBlueColor,
                                          ))),
                                  onChanged: bloc.changeLoginPassword,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginPassword
                                );
                              }),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20, top: 20),
                        child: _buildLoginButton(),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: _buildForgotPassword()),
                      ),

                      SizedBox(
                        height: 50,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildRrgistration()],
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        height: height * 0.1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [_buildEngineer()],
                        ),
                      ),

                      // Padding(
                      //   padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    final bloc = Provider.of<CustomerLoginBloc>(context, listen: false);
    return StreamBuilder<bool>(
        stream: bloc.isValid,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: snapshot.hasError || !snapshot.hasData
                ? null
                : () async {
                    print("submit successfully");
                    _checkInternetConnection();
                    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Home()));
                    print("email /////////////" +
                        AesEncryption.encryptAES(
                            _emailController.text.toString()));
                    print("password //////////////" +
                        AesEncryption.encryptAES(
                            _passwordController.text.toString()));

                    try {
                      var response = await customerLoginProcess(
                          AesEncryption.encryptAES(
                              _emailController.text.toString()),
                          AesEncryption.encryptAES(
                              _passwordController.text.toString()));
                      print(response);
                      bool res = response.status;

                      if (res == true) {
                        SharedPreferences customerPrefs =
                            await SharedPreferences.getInstance();
                        SharedPreferences userPrefs =
                            await SharedPreferences.getInstance();
                        userPrefs.setString("user", "customer");

                        // CustomerLogin.customermail= response.customermail;
                        // CustomerLogin.customername=response.customername;
                        // CustomerLogin.customertypeid=response.customertypeid;
                        // CustomerLogin.customertypename=response.customertypename;
                        var message = response.message;
                        // CustomerLogin.token =response.authtoken;
                        // CustomerLogin.customerid =response.customerid;
                        // CustomerLogin.customermobile=response.customermobile;
                        // CustomerLogin.customeraddress=response.customeraddress;
                        // CustomerLogin.customercode=response.customercode;

                        // SharedPreferences prefs = await SharedPreferences.getInstance();
                        // prefs.setBool("isLoggedIn", true);

                        customerPrefs.setString(
                            "email", response.customermail.toString());
                        customerPrefs.setString(
                            "contact", response.customermobile.toString());
                        customerPrefs.setString(
                            "name", response.customername.toString());
                        customerPrefs.setString(
                            "token", response.authtoken.toString());
                        customerPrefs.setString(
                            "customerId",
                            AesEncryption.encryptAES(
                                response.customerid.toString()));
                        customerPrefs.setString(
                            "customerCode", response.customercode.toString());
                        customerPrefs.setString("customerTypeName",
                            response.customertypename.toString());
                        customerPrefs.setString("customerAddress",
                            response.customeraddress.toString());
                        customerPrefs.setString("gst", response.gst.toString());
                        print(
                            "customerid = ${AesEncryption.encryptAES(response.customerid.toString())}");

                        // print("email"+ CustomerLogin.customermail.toString());
                        //  print("token .............."+ CustomerLogin.token.toString());

                        // scaffoldKey.currentState!.showSnackBar(
                        //   SnackBar(
                        //     content:Row(
                        //       children: [
                        //         Icon(Icons.check,size: 32),
                        //         const SizedBox(width: 16),
                        //         Expanded(
                        //           child: Text(message.toString(),style: TextStyle(fontSize: 20),)
                        //         ),
                        //       ],
                        //     ),
                        //     backgroundColor: Colors.green,
                        //     duration: Duration(seconds: 10),
                        //     shape: StadiumBorder(),
                        //     margin: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        //     behavior: SnackBarBehavior.floating,
                        //     elevation: 10,
                        //   )
                        // );

                        Fluttertoast.showToast(
                            // msg: message.toString(),
                            msg: "Login successful!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: themBlueColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => CustomerHome()));
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CustomerHome()));
                      }

                      if (res == false) {
                        Fluttertoast.showToast(
                            msg: response.message.toString(),
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: themBlueColor,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        //scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("User Dose not Exist".toString())));
                        // Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //         builder: (context) => NoExistingCustomer()));
                      }
                    } catch (e) {
                      scaffoldKey.currentState!.showSnackBar(SnackBar(
                          content: Text("Wrong Credentials".toString())));
                    }
                  },
            child: Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: snapshot.hasError || !snapshot.hasData
                    ? Colors.grey
                    : themBlueColor,
              ),
              child: Text(
                "Login",
                style: TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
            ),
          );
        });
  }

  Widget _buildForgotPassword() {
    return Container(
        child: InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => CustomerVerify()));
            },
            child: Text(
              "Forgot Password !",
              style: TextStyle(
                  fontFamily: 'AkayaKanadaka',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            )));
  }

  Widget _buildRrgistration() {
    return Container(
        child: Row(
      children: [
        Text(
          "New User ?  ",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        SizedBox(
          width: 2,
        ),
        InkWell(
          child: Text(
            "Register here. !!",
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: themBlueColor),
          ),
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                builder: (context) => RegistrationCustomer()));
          },
        )
      ],
    ));
  }

  Widget _buildEngineer() {
    return Container(
        child: Row(
      children: [
        Text(
          "Are You Engineer ?  ",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        SizedBox(
          width: 2,
        ),
        InkWell(
            onTap: () {
              // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) => EngineerLogin()));
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => EngineerLogin()));
            },
            child: Text(
              "Click here. !!",
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: themBlueColor),
            ))
      ],
    ));
  }
}
