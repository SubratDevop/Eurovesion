import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:ev_testing_app/AES256encryption/Encrypted.dart';
import 'package:ev_testing_app/Api/Api.dart';
import 'package:ev_testing_app/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:ev_testing_app/Model/EngineerModel/EngineerLogin.dart';
import 'package:ev_testing_app/Screens/Customer/Login/CustomerLogin.dart';
import 'package:ev_testing_app/Screens/Engineer/ForgotPassword/EngineerVerify.dart';
import 'package:ev_testing_app/Screens/Engineer/Home/EngineerHome.dart';
import 'package:ev_testing_app/Screens/Engineer/NoExistingUser%20copy/NoExistingEngineer.dart';
import 'package:ev_testing_app/Screens/Engineer/NoInternent/NoInternetEngineerLogin.dart';
import 'package:ev_testing_app/bloc/EnginerLogin_bloc.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:ev_testing_app/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EngineerLogin extends StatelessWidget {
  static String? engineertourId;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  final styleWelcome = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.w700, color: themWhiteColor);
  final styleLogin = const TextStyle(
      fontSize: 50, fontWeight: FontWeight.w700, color: themWhiteColor);
  final styleForgotPassword = const TextStyle(
      fontSize: 100, fontWeight: FontWeight.w600, color: themWhiteColor);

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;
  bool _hidePassword = true;

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
      Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => NoInternetEngineerLogin()));
    }
  }
  //// checking internet connectivity end

  ////////////Engineer Login Start///////////
  Future<EngineerLoginModel> enginnerLoginProcess() async {
    print(
        "email  " + AesEncryption.encryptAES(_emailController.text.toString()));
    print("password  " +
        AesEncryption.encryptAES(_passwordController.text.toString()));
    String engineerLogin_url = engineerLoginApi;

    final http.Response response = await http.post(
      Uri.parse(engineerLogin_url),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "userid": AesEncryption.encryptAES(_emailController.text
            .toString()), //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=:Cja/tSJxRFWpJW90d+XP6w==:AAAAAAAAAAAAAAAAAAAAAA==
        "password": AesEncryption.encryptAES(_passwordController.text
            .toString()) //AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=:/6KmFiSZViMIx20b8nrzjQ==:AAAAAAAAAAAAAAAAAAAAAA==
        // user id : AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=:q36fNMaoOV8Eoz0RJsUtQg==:AAAAAAAAAAAAAAAAAAAAAA==
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );

    if (response.statusCode == 200) {
      print("Engineer Body " + response.body);
      var mess = json.decode(response.body)['message'];
      print("message Body " + mess.toString());

      return EngineerLoginModel.fromJson(json.decode(response.body));
    } else {
      Fluttertoast.showToast(
          msg: "Please Check Login Credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: themeToastColor,
          textColor: Colors.white,
          fontSize: 16.0);

      throw Exception('Failed to create album.');
    }
  }
  ////////////Engineer Login End///////////

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkInternetConnection();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    /// screen Orientation start///////////
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    /// screen Orientation end///////////

    final bloc = Provider.of<EngineerLoginBloc>(context, listen: false);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themWhiteColor,
      appBar: AppBar(
        backwardsCompatibility: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: Colors.transparent,
        toolbarHeight: height * 0.2,
        elevation: 0.0,
        title: const Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Padding(
              padding: EdgeInsets.only(left: 10, top: 80),
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
            child: const Center(
              child: FittedBox(
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
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
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            // autovalidate: _autovalidate,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  color: themWhiteColor,
                  height: height * 0.7,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 50,
                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Email/Phone No",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: themBlueColor),
                            )),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEFF3F6),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),

                                // BoxShadow(
                                //   color: Color.fromRGBO(0, 0, 0, 0.1),
                                //   offset: Offset(6,2),
                                //   blurRadius: 6.0,
                                //   spreadRadius: 3.0

                                // // ),
                                // BoxShadow(
                                //   color: Color.fromRGBO(255, 255, 255, 0.9),
                                //   offset: Offset(-6,-2),
                                //   blurRadius: 6.0,
                                //   spreadRadius: 3.0
                                // )
                              ]),
                          child: StreamBuilder<String>(
                              stream: bloc.loginEmail,
                              //Instead of TextEditingController, bloc carrying input value by calling loginEmail
                              builder: (context, snapshot) {
                                return TextField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(left: 20),
                                      hintText: "Enter email/phone no.",
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

                      const Padding(
                        padding: EdgeInsets.only(left: 10),
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

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEFF3F6),
                              borderRadius: BorderRadius.circular(0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
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
                                      contentPadding:
                                          const EdgeInsets.only(left: 20),
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
                                              size: 17.0))),
                                  onChanged: bloc.changeLoginPassword,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginPassword
                                );
                              }),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 20),
                        child: _buildButton(),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: _buildForgotPassword()),
                      ),

                      const SizedBox(
                        height: 50,
                      ),

                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [_buildEngineer()],
                      ))

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     _buildRrgistration()
                      //   ],

                      // ),

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

  Widget _buildButton() {
    final bloc = Provider.of<EngineerLoginBloc>(context, listen: false);
    return StreamBuilder<bool>(
        stream: bloc.isValid,
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: snapshot.hasError || !snapshot.hasData
                ? null
                : () async {
                    print("submit successfully");

                    _checkInternetConnection();
                    // print("1   "+AesEncryption.encryptAES(_emailController.text.toString()));
                    // print("2  "+AesEncryption.encryptAES(_passwordController.text.toString()));

                    // enginnerLoginProcess();

                    try {
                      var response = await enginnerLoginProcess();
                      bool status = response.status; //engineerid:"23"
                      if (status) {
                        SharedPreferences engPrefs =
                            await SharedPreferences.getInstance();
                        SharedPreferences userPrefs =
                            await SharedPreferences.getInstance();
                        userPrefs.setString("user", "eng");

                        engPrefs.setString(
                            "email", response.engineeremail.toString());
                        engPrefs.setString(
                            "contact", response.engineermobile.toString());
                        engPrefs.setString(
                            "name", response.engineername.toString());
                        engPrefs.setString(
                            "token", response.authtoken.toString());
                        engPrefs.setString(
                            "engineerId",
                            AesEncryption.encryptAES(
                                response.engineerid.toString()));
                        engPrefs.setString("engineerDecryptId",
                            response.engineerid.toString());
                        engPrefs.setString(
                            "engineerTourId", response.engineerid.toString());
                        EngineerLogin.engineertourId =
                            response.engineerid.toString();
                        print(response.engineerid.toString());
                        engPrefs.setString("typeId", response.typeid);
                        engPrefs.setString(
                            "employeeType", response.employeetype.toString());
                        engPrefs.setString(
                            "branchid", response.branchid.toString());
                        engPrefs.setString(
                            "branchname", response.branchname.toString());
                        engPrefs.setString(
                            "branchaddress", response.branchaddress.toString());
                        engPrefs.setString(
                            "Engineer id = "
                            "engineerimage",
                            response.engineerimage.toString());

                        print(" id eng ///////// " +
                            engPrefs.getString("engineerId").toString());
//AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=:q36fNMaoOV8Eoz0RJsUtQg==:AAAAAAAAAAAAAAAAAAAAAA==
                        Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                                builder: (context) => EngineerHome()));
                      }

                      if (status == false) {
                        Fluttertoast.showToast(
                            msg: response.message,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: themeToastColor,
                            textColor: Colors.white,
                            fontSize: 16.0);

                        // Navigator.of(context, rootNavigator: true).push(
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             NoExistingUserEngineer()));
                      }
                    } catch (e) {
                      Fluttertoast.showToast(
                          msg: e.toString(),
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: themeToastColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }

                    // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>Home()));
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
              child: const Text(
                "Login",
                style: const TextStyle(
                    fontFamily: 'TimesNewRoman',
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: themWhiteColor),
              ),
            ),
          );
        });
  }

  Widget _buildForgotPassword() {
    return InkWell(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .push(MaterialPageRoute(builder: (context) => EngineerVerify()));
      },
      child: Container(
          child: const Text(
        "Forgot Password !",
        style: TextStyle(
            fontFamily: 'AkayaKanadaka',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black54),
      )),
    );
  }

  Widget _buildEngineer() {
    return Container(
        child: Row(
      children: [
        const Text(
          "Are You Customer ?  ",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(
          width: 2,
        ),
        InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => CustomerLogin()));
            },
            child: const Text(
              "Please Go Back here. !!",
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
