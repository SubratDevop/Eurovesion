import 'dart:collection';
import 'dart:convert';
import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Model/CustomerModel/CustomerVerifyModel.dart';
import 'package:eurovision/Screens/Customer/ForgotPassword/CustomerOtpVerify.dart';
import 'package:eurovision/Screens/Customer/Login/CustomerLogin.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class CustomerVerify extends StatelessWidget {
  
  static String ? customerid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomerVerifyScreen(),
    );
  }
}

class CustomerVerifyScreen extends StatefulWidget {
  

  @override
  _CustomerVerifyScreenState createState() => _CustomerVerifyScreenState();
}

class _CustomerVerifyScreenState extends State<CustomerVerifyScreen> {

  GlobalKey<FormState> _formkey =GlobalKey<FormState>(); 
  bool _autovalidate = false;
  // global key for form.

  String msg="";
  var message,invalidUser="";


  bool isLoading=false;
  Future<CustomerVerifyModel> veryfyCustomerProcess() async {
    var customerVerify_url= customerVerifyApi;
    final http.Response response = await http.post(
        Uri.parse(customerVerify_url),
        headers: <String, String>{
          // 'Accept': 'application/json',
          //'Content-type': 'application/json',
          'Accept': 'application/json'
        },

        body: {
          'email_mobile': AesEncryption.encryptAES(_emailPhoneController.text.toString()),
         
        },
        // body: {
        //   'email': email,
        //   'password': password,
        // }
    );
      //var responsebody=jsonDecode(jsonDecode(response.body));
      //if(responsebody['status']==)
    if (response.statusCode == 200) {

      setState(() {
        isLoading=false; 
      });

      // final responseBody=json.decode(response.body);
      // SignIn.token=responseBody['auth_token'];
      // return responseBody;

      
      print('verify customer body');
      print(response.body);
       return CustomerVerifyModel.fromJson(json.decode(response.body));
    } else {
     // print("error enter ed");
    
      isLoading = false;
    
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

  late TextEditingController _emailPhoneController;

  late String emailOrPhone;

  
  Widget _buildEmailPhoneTextField(){
    return  TextFormField(
      controller: _emailPhoneController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10),
        hintText: "Enter Your Register Email",
        hintStyle: TextStyle(fontSize: 12),
        //labelText: "customer name",
        
        //border: InputBorder.none
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0)
        )
          
      ),
      validator: (String ? value){
        if(value!.isEmpty){
          return 'Email is required!';
        }
        return null;
      },
        
      onSaved: (String ? value) {
        emailOrPhone = value!;
      },

    );
  }

  Widget _buildVerifyUserButton(){
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(themBlueColor),
      ),
      icon: Icon(Icons.arrow_forward ),
      label: Text("Verify",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
      onPressed: () async{

        if(_formkey.currentState!.validate()){
          try{


            updateMsg();
           
            // showDialog(
            //   context: context,
            //   builder: (BuildContext context) => new AlertDialog(
            //     title: Container(
            //       width: 50,
            //       height: 50,
            //       child: CircularProgressIndicator()
            //     ),
            //     content: new Text("Loading..."),
            //     actions: <Widget>[
            //       new IconButton(
            //           icon: new Icon(Icons.close),
            //           onPressed: () {
            //             Navigator.pop(context);
            //           })
            //     ],
            //   ));


            // isLoading

            //    ? new Center(child: new CircularProgressIndicator()) :
            //     Text("");
             
            var response=await veryfyCustomerProcess();
            bool res=response.status;
            message =response.message.toString();
            var customerid=response.customerid.toString();
            if(res==true){
             
              CustomerVerify.customerid=customerid.toString();

             // updateMsg();
              Fluttertoast.showToast(
                msg: message.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0
              );
              Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerOtpVerify()));
            }
            if(res==false){

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

            Fluttertoast.showToast(
              msg: "Invalid Credentials",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0
            );

            }

          _formkey.currentState!.save();

        }
      
      }, 
      
    );
 }
 

  Widget _builderBackButton(){
    return InkWell(
      onTap: (){
        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerLogin()));
      },
      child: Row(
        children: [
          Icon(Icons.arrow_back_ios,color: themWhiteColor),
          Text("Back",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailPhoneController=TextEditingController();
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
                  child: Text("Verify User ",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
      ),


      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: Form(
          key: _formkey,
          // autovalidate: _autovalidate,
          autovalidateMode: AutovalidateMode.onUserInteraction,
         
            child: SingleChildScrollView(
              child: Container(
                width: width,
                height: height,
                color: themWhiteColor,
      
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
                            Text("Step 1",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                            SizedBox(height: 5,),
                            Text("Please Enter Registered Email...",style: TextStyle(fontFamily: 'WorkSans',fontSize: 15,fontWeight: FontWeight.w700,color: Colors.black45),)
                          ]  
                        ),
                      ),
                    ),
      
                    Container(
                    
                    width: width,
                    height: height*0.5,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150,left: 5,right: 5,bottom: 50),
                      
                      child: Container(
                        width: width,
                        
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: width,
                              height: 20,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0),
                                  child: Text("Enter Register Email",style: TextStyle(fontFamily: 'WorkSans',fontSize: 35,fontWeight: FontWeight.w700,color: themBlueColor),),
                                ),
                              ),
                            ),
                                    
                            SizedBox(
                              height: 5,
                            ),
      
      
                            _buildEmailPhoneTextField(),         
                            
                            SizedBox(height: 10,
                            ),
      
                            
                            SizedBox(
                              width: width,
                              child: _buildVerifyUserButton(),
                            ),
      
                            invalidUser=="invalid" ?
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
                  ],
                ),
      
      
              ),
            ),
            
        ),
      ),
      
      
      
    );
  }

  void updateMsg() {
    setState(() {
      invalidUser="";
      msg="Verifying..";
    });
  }

  void updateFalse() {
    setState(() {
      invalidUser="invalid";
      msg=message;
    });
  }

 
}