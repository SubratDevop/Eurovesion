import 'dart:convert';

import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerOtpVerifyModel.dart';
import 'package:eurovision/Model/CustomerModel/CustomerResendOtpModel.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerPasswordReSet.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerVerify.dart';
import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CustomerOtpVerify extends StatelessWidget {

  static String ? forgotPasswordOtp;
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    
      debugShowCheckedModeBanner: false,
      home: CustomerOtpVerifyScreen(),
    );
  }
}

class CustomerOtpVerifyScreen extends StatefulWidget {
 
  @override
  _CustomerOtpVerifyScreenState createState() => _CustomerOtpVerifyScreenState();
}

class _CustomerOtpVerifyScreenState extends State<CustomerOtpVerifyScreen> {

  bool _pinSuccess = false;
  bool _hideOTP = true;    
  final _formKey = GlobalKey<FormState>();
  String  ? otp;

  String msg="",resendOtpMsg="";

  var invalidOtp="";

  String ? message;


  //bool isLoading=false;
  Future<CustomerOtpVerifyModel> veryfyCustomerOtpProcess() async {

    print("oto user  "+ AesEncryption.encryptAES(otp.toString()));
    var customerOtpVerify_url= customerOtpVerifyApi;
    final http.Response response = await http.post(
        Uri.parse(customerOtpVerify_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "customerid":CustomerVerify.customerid.toString(),
          "otp": AesEncryption.encryptAES(otp.toString()),
         
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // setState(() {
      //   isLoading=false; 
      // });

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      print('verify otp body');
      print(response.body);
       return CustomerOtpVerifyModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");
    
     // isLoading = false;
    
      // Fluttertoast.showToast(
      //   msg: "Please fill Up All Details",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to create album.');
    }
  }

  Future<CustomerResendOtpModel> customerReSendOtpProcess() async {
    var customerReSendOtp_url= customerReSendOtpApi;
    final http.Response response = await http.post(
        Uri.parse(customerReSendOtp_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "customerid":CustomerVerify.customerid.toString(),
          
         
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      // setState(() {
      //   isLoading=false; 
      // });

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      print('resend otp body');
      print(response.body);
       return CustomerResendOtpModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");
    
     // isLoading = false;
    
      // Fluttertoast.showToast(
      //   msg: "Please fill Up All Details",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to create album.');
    }
  }


  

  Widget _builderBackButton(){
    return InkWell(
      onTap: (){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerVerify()));
      },
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios,color: themWhiteColor),
          Text("Back",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
        ],
      ),
    );
  }

  Widget _builderLoginkButton(){
    return InkWell(
      onTap: (){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerLogin()));
      },
       child: Row(
        children: [
          Text("Login",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.black54)),
          Icon(Icons.arrow_forward_ios,color: Colors.black54,),
          
        ],
      ),
    );
  }


  Widget _buildOtpTextField(){
    return OTPTextField(
      length: 6,
      width: 320,
      fieldWidth: 40,
      style: TextStyle(fontSize: 30),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onChanged: (pin){
        setState(() {
          otp=pin;
          
        });

      },
      onCompleted: (pin) {
        setState(() {
          
          otp=pin;
          _pinSuccess = true;
        });
      },
    );
  }

  Widget _buildVerifyOtpButton(){
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(themBlueColor),
      ),
      icon: Icon(Icons.security_update_good ),
      label: Text("Otp Verify",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
      onPressed: () async{

        var response=await veryfyCustomerOtpProcess();
        bool res=response.status;
        message=response.message.toString();

        updateMsg();
        
        if(res==true){
          
          Fluttertoast.showToast(
            msg: message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );

          Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerPasswordReSet()));
        }

        else{
          
          updateFalse();
          Fluttertoast.showToast(
            msg: message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );

        }  


      }, 
      
    );
  }

  Widget _buildResendOtpButton(){
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(themBlueColor),
      ),
      icon: Icon(Icons.star),
      label: Text("ReSend Otp",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
      onPressed: () async{
        
        setState(() {
          resendOtpMsg="";
        });

        print(otp!.length.toString());
        var response=await customerReSendOtpProcess();
        var message=response.message;
        bool res=response.status;

        if(res==true){

         
          

          updateReSendOtpMsg();
          Fluttertoast.showToast(
            msg: message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );


        }

        else{
          updateReSendOtpFalse();
          Fluttertoast.showToast(
            msg: message.toString(),
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0
          );

        }
       // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerPasswordReSet()));
      }, 
      
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    
    otp="5";  
  }

  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themWhiteColor,
      
      appBar: AppBar(

        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: themBlueColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),

        backgroundColor: Colors.transparent,
        toolbarHeight: height*0.1,
        elevation: 0.0,
        title: Center(child: Text('',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerLogin()));
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
                  child: Text("Verify Otp ",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
      ),


      body: SingleChildScrollView(
        child: Container(
          width: width,
          height: height,
          child: Column(
            children: [

              // Container(
              //   width: width,
              //   height: height*0.15,
              //   color: themWhiteColor,
              //   child: Align(
              //     alignment: Alignment.bottomLeft,
              //     child: Padding(
              //       padding: const EdgeInsets.only(left: 10,bottom: 20),
              //       child: Container(
              //         width: width,
              //         height: 20,
              //         child: Align(
              //           alignment: Alignment.topRight,
              //           child: _builderLoginkButton(),
              //         )
                      
              //       ),
              //     ),
              //   ),
              // ),
              
              Container(
                width: width,
                height: height*0.85,
          
                child: Container(
                  width: width,
                  height: height*0.85,
                 
      
                  child: Column(
                    children: [

                      Container(
                        width: width,
                        height: height*0.1,
                        decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                        color: themWhiteColor),
                        child: Center(
                          child: Column(
                            children: [
                              Text("Step 2",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                              SizedBox(height: 5,),
                              Text("Please Enter Otp From Registered Email...",style: TextStyle(fontFamily: 'WorkSans',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45),)
                            ]  
                          ),
                        ),
                      ),


                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100,left: 5,right: 5,bottom: 50),
                          child: Container(
                            width: width,
                            height: height*0.5,
                            child: Column(
                              children: [
                               
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: width,
                                  height: 20,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text("Enter Otp",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                                    ),
                                  ),
                                ),

                                _buildOtpTextField(),

                                SizedBox(
                                  height: 5,
                                ),

                                otp!.length.toInt()<6 ?
                                Container(
                                  alignment: Alignment.center,
                                  width: width,
                                  height: 20,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: FittedBox(child: Text("Please Fill Up Otp Field!",style: TextStyle(fontFamily: 'WorkSans',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.red),)),
                                    ),
                                  ),
                                ) 
                                
                                :SizedBox(
                                  width: width,
                                  child: _buildVerifyOtpButton()
                                ),

                                invalidOtp=="invalid" ?
                                Flexible(child: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.red)))
    
                                : Flexible(child: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: themBlueColor))),
      

                                SizedBox( height: 20,),

                                Container(
                                  alignment: Alignment.center,
                                  width: width,
                                  height: 20,
                                  child: FittedBox(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: FittedBox(child: Text("If Otp is not sent, Click Resend Otp",style: TextStyle(fontFamily: 'WorkSans',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black38),)),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 5,
                                ),

                                Align(
                                  alignment: Alignment.centerRight,
                                  child: _buildResendOtpButton()
                                ),

                                invalidOtp=="invalid" ?
                                Flexible(child: Text(resendOtpMsg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.red)))
    
                                : Flexible(child: Text(resendOtpMsg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: themBlueColor))),

                                SizedBox(
                                  height: 5,
                                ),
                    
                              ],
                            ),
                    
                    
                          ),
                        ),
                        
                      ),
                    ]  
                  ),
      
                ),
              )
            ],
          ),
      
        ),
      )
      
    );
  }

  void updateMsg() {
    setState(() {
      invalidOtp="";
      msg="Otp Verifying...";
    });
  }

  void updateReSendOtpMsg() {
    setState(() {
      
      invalidOtp="";

      resendOtpMsg="Check Email...";
    });
  }

  void updateFalse() {
    setState(() {
      invalidOtp="invalid";
      msg=message!;
    });
  }

   void updateReSendOtpFalse() {
    setState(() {

      invalidOtp="invalid";
      resendOtpMsg=message!;
    });
  }

}