import 'dart:convert';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/Model/CustomerModel/CustomerComplainModel.dart';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CustomerTotalComplain.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class CustomerCreateComplain extends StatelessWidget {
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
      home: CustomerComplainScreen(),
    );
  }
}

class CustomerComplainScreen extends StatefulWidget {
  @override
  _CustomerComplainScreenState createState() => _CustomerComplainScreenState();
}

class _CustomerComplainScreenState extends State<CustomerComplainScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;
  bool _isVisible = false;
  String? selectComplainType;
  String? selectItemForComplainType;

  var itemTypeForComplain = [];

  var CustomerComplainTypeList = [];

  String? item = "item";
  String? itemId, complainId;
  String? selectComplainId;

  TextEditingController _complainController = TextEditingController();

  bool loading=false;

  ////////////Customer Login Start///////////
  Future<CustomerComplainModel> customerComplainProcess(
      String complainControllerText, String itemId) async {
    //  print("create complain H"+customerId.toString());
    //  print("create complain  HH"+CustomerHome.token.toString());
    //   print("create complain HHH "+Comp.toString());
    String customerComplainUrl = customerComplainApi;

    final http.Response response = await http.post(
      Uri.parse(customerComplainUrl),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'customerid': CustomerHome.customerId.toString(),
        'token': CustomerHome.customerToken.toString(),
        'complainttext': complainControllerText,
        'itemid': itemId
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );

    if (response.statusCode == 200) {
      return CustomerComplainModel.fromJson(json.decode(response.body));
    } else {
     
      throw Exception('Failed to create Complain.');
    }
  }

// Future<CustomerGetItemTypeComplainMOdel>
  Future fetchCustomerItemforComplain() async {
    String customerGetItemforComplainTypeUrl = customerGetItemforComplainTypeApi;
    print("fetchCustomerItemforComplain called");
    final http.Response response = await http.post(
      Uri.parse(customerGetItemforComplainTypeUrl),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'customerid': CustomerHome.customerId.toString(),
        
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );

    if (response.statusCode == 200) {
      setState(() {
        var items = json.decode(response.body)['data'] ?? [];

        itemTypeForComplain = items;
      });

      return itemTypeForComplain;
      // return CustomerGetItemTypeComplainMOdel.fromJson(
      //     json.decode(response.body));
    } else {
      // Fluttertoast.showToast(
      //   msg: "Please Check Login Credentials",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.CENTER,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.green,
      //   textColor: Colors.white,
      //   fontSize: 16.0
      // );

      throw Exception('Failed to get item.');
    }
  }

  Future fetchCustomerComplainType() async {
    String customerGetComplainTypeUrl = customerGetComplainTypeApi;
    print("fetchCustomerComplainType called");
    final response = await http.get(Uri.parse(customerGetComplainTypeUrl));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var items = json.decode(response.body)['data'] ?? [];
      // CustomerComplainTypeList = items;

      setState(() {
        var items = json.decode(response.body)['data'] ?? [];

        CustomerComplainTypeList = items;
      }); // categoryname
      // print(items);
      print(response.body);
      return CustomerComplainTypeList;
      // return CustomerGetComplainTypeMOdel.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchCustomerItemforComplain();

    setState(() {
      fetchCustomerComplainType();
      fetchCustomerItemforComplain();

      // fetchCustomerItemforComplain();
      //  itemTypeForComplain =  fetchCustomerItemforComplain();
      //  print("item For omplaintype -"+ itemTypeForComplain);
    });
    // fetchCustomerComplainType();
    print("init created");
  }

  ////////////Customer Login End///////////
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: themWhiteColor,
      key: scaffoldKey,

      appBar: AppBar(
         
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: themBlueColor,
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light),
        backgroundColor: themBlueColor,
        toolbarHeight: height * 0.1,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: themWhiteColor,
            size: 40,
          ),
          onPressed: () {
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context, rootNavigator: true)
                .push(MaterialPageRoute(builder: (context) => CustomerHome()));
          },
        ),
        centerTitle: true,
        title: Text(
          "Create Complain",
          style: TextStyle(
              fontFamily: 'TimesNewRoman',
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: themWhiteColor),
        ),
      ),

      // appBar: AppBar(
      //   backgroundColor: themBlueColor,
      //   elevation: 0.0,
      //   title: Center(child: Text('Create Complain',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',fontWeight: FontWeight.w800,fontSize: 20),),),
      //   leading: IconButton(
      //     icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
      //     onPressed: (){
      //       //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
      //       Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerHome()));
      //     },
      //   ),
      // ),

      endDrawer: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          child: CustomerDrawer()),

      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return false;
        },
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            // autovalidate: _autovalidate,
            child: Padding(
              padding: EdgeInsets.only(left: 10, bottom: 10, right: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: Colors.red,
                      width: width,
                      height: 100,
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/complain_icon.png", //EdgeInsets.only(left: 10, top: 20, bottom: 10)
                                height: 80,
                                width: 60,
                                color: themBlueColor,
                              ),
                              Container(
                                  width: width * 0.7,
                                  child: FittedBox(
                                      child: Text(
                                    'You can raise Complain against any work here.',
                                    style: TextStyle(
                                        color: Colors.black38,
                                        fontFamily: 'AkayaKanadaka',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20),
                                  )))
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            itemTypeForComplain.isEmpty
                                ? Center(child: Text("No data found"))
                                : Container(
                                    width: width * 0.5,
                                    child: Text(
                                      "Item",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontFamily: 'RobotoMono',
                                          fontSize: 20,
                                          color: Colors.black87),
                                    )),
                            Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width - 10,
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: const Icon(
                                  Icons.arrow_drop_down_circle,
                                  color: Colors.black45,
                                  size: 20,
                                ),
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.black12))),
                                value: selectItemForComplainType,
                                onChanged: (String? itemValue) {
                                  setState(() {
                                    _isVisible = true;
                                    selectItemForComplainType = itemValue;

                                    //  itemId =  list['itemid'].toString();
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'Item  required' : null,
                                items: itemTypeForComplain.map((list) {
                                  itemId = list['itemid'].toString();
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        list['item_name'].toString(),
                                        style: TextStyle(
                                            fontFamily: 'RobotoMono',
                                            fontSize: 20,
                                            color: Colors.black87),
                                      ),
                                    )),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                      child: Container(
                        height: 180,
                        //color: Color(0xffeeeeee),
                        color: themWhiteColor,
                        // padding: EdgeInsets.all(10.0),
                        child: new ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 180.0,
                          ),
                          child: new Scrollbar(
                            child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: SizedBox(
                                height: 160.0,
                                child: new TextFormField(
                                  maxLength: 500,
                                  maxLengthEnforcement:MaxLengthEnforcement.enforced,
                                  maxLines: 100,
                                  controller: _complainController,
                                  decoration: new InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: "Fill Your Complain",
                                    hintStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.w300),
                                    labelText: "Complain",
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Please fill up!';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: Visibility(
                          visible: _isVisible,
                          child:ElevatedButton.icon(
                              icon: Icon(Icons.arrow_forward),
                              label: FittedBox(
                                  child: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              )),
                              style: ElevatedButton.styleFrom(
                                // primary: themBlueColor,
                                // onPrimary: Colors.white,
                                backgroundColor: themBlueColor,
                                
                                shadowColor: themBlueColor,
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(0))),
                                elevation: 10,
                              ),
                              onPressed: () async {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    showLoaderDialog(context);
                                  });
                                  try {
                                    var response =
                                        await customerComplainProcess(
                                            _complainController.text.toString(),
                                            itemId.toString());
                                    print(response);
                                    bool res = response.status;
                                    var message = response.message;

                                    if (res == true) {
                                      Fluttertoast.showToast(
                                          msg: message.toString(),
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                          setState(() {
                                            
                                          });
                                          
                                          Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context) =>CustomerTotalComplain()));
                                      
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                " Sorry can't placed a complain"
                                                    .toString())));
                                  }

                                  _formkey.currentState!.save();
                                }
                              }),
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}
