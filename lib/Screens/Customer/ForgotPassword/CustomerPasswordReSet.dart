import 'dart:convert';

import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerPasswordResetModel.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerOtpVerify.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerVerify.dart';
import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CustomerPasswordReSet extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerPasswordReSetScreen(),
    );
  }
}

class CustomerPasswordReSetScreen extends StatefulWidget {
  

  @override
  _CustomerPasswordReSetScreenState createState() => _CustomerPasswordReSetScreenState();
}

class _CustomerPasswordReSetScreenState extends State<CustomerPasswordReSetScreen> {

  late TextEditingController  _enterNewPasswordController,_reEnterNewPasswordController;
  String ? newPassword,newReEnterPasswoprd;

  GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
  bool _autovalidate = false;
  // global key for form.

  bool _hidePassword = true;

  String msg="";
  var message,invalidUpdate="";


  Future<CustomerPasswordResetModel> customerReSetPasswordProcess() async {
    var customerReSetPasswordUrl= customerReSetPasswordApi;
    final http.Response response = await http.post(
        Uri.parse(customerReSetPasswordUrl),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          "customerid":CustomerVerify.customerid.toString(),
          "password": AesEncryption.encryptAES(_reEnterNewPasswordController.text.toString())
          
         
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

      
      print('Update Password body');
      print(response.body);
       return CustomerPasswordResetModel.fromJson(json.decode(response.body));
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
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerOtpVerify()));
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
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerLogin()));
      },
       child: Row(
        children: [
          Text("Login",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor)),
          Icon(Icons.arrow_forward_ios,color: themWhiteColor,),
          
        ],
      ),
    );
  }

  
  Widget _buildEnterNewPasswordTextField(){
    return  TextFormField(
      obscureText: true,
      controller: _enterNewPasswordController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        hintText: "Enter New Password",
        hintStyle: TextStyle(fontSize: 12),
        //labelText: "customer name",
        
        //border: InputBorder.none
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0)
        )
          
      ),
      validator: (String ? value){
        if(value!.isEmpty){
          return 'Password is required!';
        }
        return null;
      },
        
      onSaved: (String ? value) {
        newPassword= value!;
      },
    );
  }

 

  Widget _buildReEnterNewPasswordTextField(){
    return  TextFormField(
      obscureText: _hidePassword,
      controller: _reEnterNewPasswordController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        hintText: "Re-Enter New Password",
        hintStyle: TextStyle(fontSize: 12),
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
            size: 17.0
          )
        ),
        //labelText: "customer name",
        
        //border: InputBorder.none
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0)
        )

          
      ),
      validator: (String ? value){
        if(value!.isEmpty){
          return 'Re Password is required!';
        }

        if(_enterNewPasswordController.text.toString()!=_reEnterNewPasswordController.text.toString())
        {
          return 'Password miss Matched!';
        }
        return null;
      },
        
      onSaved: (String ? value) {
        newReEnterPasswoprd= value!;
      },
    );
  }

  Widget _buildUpdatePasswordButton(){
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(themBlueColor),
      ),
      icon: Icon(Icons.security ),
      label: Text("Update",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
      onPressed: () async{

        if(_formkey.currentState!.validate()){
          try{
            var response =await customerReSetPasswordProcess();
            var message=response.message;
            bool res=response.status;

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
              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerLogin()));
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
          }
          catch(err){

          }

          _formkey.currentState!.save();
        }
        
      }, 
      
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _enterNewPasswordController=TextEditingController();
    _reEnterNewPasswordController=TextEditingController();
    
  }
  @override
  Widget build(BuildContext context) {

    double width= MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themWhiteColor,
      appBar: AppBar(

         
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
                  child: Text("Reset Password",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
      ),
      
      body: Form(
        key: _formkey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
        // autovalidate: _autovalidate,
        child: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            color: themWhiteColor,
        
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
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //           children: [
                  
                //             _builderBackButton(),
                //             _builderLoginkButton()
                          
                //           ],
                //         ),
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
                      children:[
      
                        Container(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                width: width,
                                height: height*0.5,
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
                                            Text("Step 3",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                                            SizedBox(height: 5,),
                                            FittedBox(child: Text("Update Password Here......",style: TextStyle(fontFamily: 'WorkSans',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45),))
                                          ]  
                                        ),
                                      ),
                                    ),
                      
                                    
                                    SizedBox(
                                      height: 100,
                                    ),
                      
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width,
                                      height: 20,
                                      child: FittedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text("Enter New Password",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                                        ),
                                      ),
                                    ),
                      
                                    SizedBox(
                                      height: 5,
                                    ),
                      
                                    _buildEnterNewPasswordTextField(),
                      
                                    SizedBox(
                                      height: 10,
                                    ),
                      
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width,
                                      height: 20,
                                      child: FittedBox(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: Text("Re-Enter New Password ",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                                        ),
                                      ),
                                    ),
                      
                                    SizedBox(height: 5),
                      
                                    _buildReEnterNewPasswordTextField(),
                      
                                    SizedBox(height: 10),
                      
                                    SizedBox(
                                      width: width,
                                      child: _buildUpdatePasswordButton()
                                    ),

                                    invalidUpdate=="invalid" ?
                                    Flexible(child: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: Colors.red)))
      
                                    : Flexible(child: Text(msg,overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyle(fontFamily: 'WorkSans',fontSize: 20,fontWeight: FontWeight.w700,color: themBlueColor))),

                                    SizedBox(
                                      height: 10,
                                    )
                      
                                  ],
                                ),
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
        ),
      )
      
    );
  }

  void updateMsg() {
    setState(() {
      invalidUpdate="";
      msg="Updating..";
    });
  }

  void updateFalse() {
    setState(() {
      invalidUpdate="invalid";
      msg=message;
    });
  }
}