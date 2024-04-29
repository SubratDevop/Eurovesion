// ignore_for_file: unused_field

import 'dart:convert';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/Model/CustomerModel/CustomerItemsModel.dart';
import 'package:eurovision/Screens/Customer/CustomeItems/CustomerItems.dart';
import 'package:eurovision/Screens/Customer/Home/CustomerHome.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatelessWidget {
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
      home: AddItemScreen(),
    );
  }
}

class AddItemScreen extends StatefulWidget {
  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  // global key for form.
  bool _autovalidate = false;
  String? selectComplainType;
  String? selectItemForComplainType;
  String? partsValue, msg;

  var itemTypeForComplain = [];

  var AddItemTypeList = [];
  String? date = "";

  DateTime currentDate_start = DateTime.now();

  String? item = "item";

  // bool? res;

  TextEditingController _complainController = TextEditingController();

  TextEditingController _modelNoController = TextEditingController();
  TextEditingController _quantityNoController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _MCcontroller = TextEditingController();
  TextEditingController _billController = TextEditingController();
  String? itemId;

  ////////////Customer Login Start///////////
  // Future<AddItemModel> AddItemProcess() async {
  //   //  print("create complain H"+customerId.toString());
  //   //  print("create complain  HH"+CustomerHome.token.toString());
  //   //   print("create complain HHH "+Comp.toString());
  //   String AddItemUrl = AddItemApi;

  //   final http.Response response = await http.post(
  //     Uri.parse(AddItemUrl),
  //     headers: <String, String>{
  //       // 'Accept': 'application/json',
  //       // 'Content-type': 'application/json',
  //       'Accept': 'application/json'
  //     },

  //     body: {
  //       'customerid': CustomerHome.customerId.toString(),
  //       'token': CustomerHome.customerToken.toString(),
  //       'complainttext': _complainController.text.toString(),
  //     },
  //     // body: {
  //     //   'email': email,
  //     //   'password': password,
  //     // }
  //   );

  //   if (response.statusCode == 200) {
  //     return AddItemModel.fromJson(json.decode(response.body));
  //   } else {
  //     // Fluttertoast.showToast(
  //     //   msg: "Please Check Login Credentials",
  //     //   toastLength: Toast.LENGTH_SHORT,
  //     //   gravity: ToastGravity.CENTER,
  //     //   timeInSecForIosWeb: 1,
  //     //   backgroundColor: Colors.green,
  //     //   textColor: Colors.white,
  //     //   fontSize: 16.0
  //     // );

  //     throw Exception('Failed to create album.');
  //   }
  // }

// Submit AddItem
  Future<CustomerItemsModel> fetchcustomerMachineRegistrationProcess(
      String itemId,
      String modelNo,
      String quantityNum,
      String priceNum,
      String mcNo,
      String billNo,
      String installationDate) async {
    String customerMachineRegistrationUrl = customerMachineRegistrationApi;

    final http.Response response = await http.post(
      Uri.parse(customerMachineRegistrationUrl),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },
      body: {
        "customerid": CustomerHome.customerId.toString(),
        "token": CustomerHome.customerToken.toString(),
        "item_select": itemId,
        "model_No": modelNo,
        "quantity_Num": quantityNum,
        "price_Num": priceNum,
        "mc_No": mcNo,
        "bill_No": billNo,
        "installation_Date": installationDate
      },
    );

    if (response.statusCode == 200) {
      return CustomerItemsModel.fromJson(json.decode(response.body));
    } else {
      print("status false123");
      throw Exception('Failed to get item.');
    }
  }

// Future<CustomerGetItemTypeComplainMOdel>
  Future fetchCustomerItemforComplain() async {
    String customerAddItemUrl = customerAddItemTypeApi;
    print("fetchCustomerItemforComplain called");
    final http.Response response = await http.post(
      Uri.parse(customerAddItemUrl),
      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        'customerid': CustomerHome.customerId.toString(),
        'token': CustomerHome.customerToken
      },
      // body: {
      //   'email': email,
      //   'password': password,
      // }
    );
print("**********" + response.statusCode.toString());
print(CustomerHome.customerId.toString());
print(CustomerHome.customerToken.toString());
    if (response.statusCode == 200) {
      setState(() {
        var items = json.decode(response.body)['data'] ?? [];
        print("*****************" + response.body.toString());

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

  // Future fetchAddItemType() async {
  //   String customerGetComplainTypeUrl = customerGetComplainTypeApi;
  //   print("fetchAddItemType called");
  //   final response = await http.get(Uri.parse(customerGetComplainTypeUrl));

  //   if (response.statusCode == 200) {
  //     // If the server did return a 200 OK response,
  //     // then parse the JSON.
  //     // var items = json.decode(response.body)['data'] ?? [];
  //     // AddItemTypeList = items;

  //     setState(() {
  //       var items = json.decode(response.body)['data'] ?? [];

  //       AddItemTypeList = items;
  //     }); // categoryname
  //     // print(items);
  //     print(response.body);
  //     return AddItemTypeList;
  //     // return CustomerGetComplainTypeMOdel.fromJson(jsonDecode(response.body));
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load album');
  //   }
  // }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime pickedDate = (await showDatePicker(
        context: context,
        initialDate: currentDate_start,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050)))!;
    if (pickedDate != currentDate_start)
      setState(() {
        currentDate_start =
            pickedDate; // change current state value to picked value
        print("start date" + currentDate_start.toString());

        var dateTime = DateTime.parse("${currentDate_start}");
        print("start date 2" + dateTime.toString());

        var formate1 =
            "${dateTime.year.toString()}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
        // "${dateTime.year}-${dateTime.month}-${dateTime.day}"; //change format to dd-mm-yyyyy

        var formate2 =
            "${dateTime.month}/${dateTime.day}/${dateTime.year}"; //change format t0 yyy-mm-dd

        date = formate1.toString();
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchCustomerItemforComplain();

    setState(() {
      // fetchAddItemType();
      fetchCustomerItemforComplain();

      // fetchCustomerItemforComplain();
      //  itemTypeForComplain =  fetchCustomerItemforComplain();
      //  print("item For omplaintype -"+ itemTypeForComplain);
    });
    // fetchAddItemType();
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
        centerTitle: true,
        title: Text(
          "Add Item",
          style: TextStyle(
              fontFamily: 'TimesNEwRoman',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: themWhiteColor),
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
                .push(MaterialPageRoute(builder: (context) => CustomerHome()));
          },
        ),
        // flexibleSpace: ClipPath(
        //   clipper: Customshape(),
        //   child: Container(
        //     //height: height*0.2,
        //     width: MediaQuery.of(context).size.width,
        //     color: themBlueColor,
        //     child: Center(
        //       child: FittedBox(
        //         child: Padding(
        //           padding: const EdgeInsets.only(left: 10),
        //           child: Text(
        //             "Add Item",
        //             style: TextStyle(
        //                 fontFamily: 'TimesNEwRoman',
        //                 fontSize: 30,
        //                 fontWeight: FontWeight.w800,
        //                 color: themWhiteColor),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ),
        // ),
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

      // endDrawer: Container(
      //     width: MediaQuery.of(context).size.width * 0.7,
      //     child: CustomerDrawer()),

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
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // itemTypeForComplain.isEmpty
                            //     ? Center(child: CircularProgressIndicator())
                            //     :
                            Container(
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
                                // isExpanded: true,
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
                                    selectItemForComplainType = itemValue;

                                    //  itemId =  list['itemid'].toString();
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'Item  required' : null,
                                items: itemTypeForComplain.map((list) {
                                  // itemId = list['itemid'].toString();
                                  itemId = list['categoryid'].toString();
                                  return DropdownMenuItem(
                                    value: list['id'].toString(),
                                    child: FittedBox(
                                        child: Padding(
                                      padding: const EdgeInsets.only(left: 0),
                                      child: Text(
                                        // list['item_name'].toString(),
                                        list['itemname'].toString(),
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
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.4,
                            child: Text(
                              "Model No",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.50,
                            height: 60,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _modelNoController,
                                  decoration: InputDecoration(
                                    // contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    // errorText: snapshot.error?.toString(),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Model no is required";
                                    }
                                  },
                                  // onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.4,
                            child: Text(
                              "Quantity",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.50,
                            height: 60,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _quantityNoController,
                                  decoration: InputDecoration(
                                    // contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    // errorText: snapshot.error?.toString(),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Quantity is required";
                                    }
                                  },
                                  // onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.4,
                            child: Text(
                              "Price",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.50,
                            height: 60,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _priceController,
                                  decoration: InputDecoration(
                                    // contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    // errorText: snapshot.error?.toString(),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Price is required";
                                    }
                                  },
                                  // onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.4,
                            child: Text(
                              "M/C",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.50,
                            height: 60,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _MCcontroller,
                                  decoration: InputDecoration(
                                    // contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    // errorText: snapshot.error?.toString(),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "M/C is required";
                                    }
                                  },
                                  // onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: width * 0.4,
                            child: Text(
                              "Bill No",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.50,
                            height: 60,
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: TextFormField(
                                  keyboardType: TextInputType.name,
                                  controller: _billController,
                                  decoration: InputDecoration(
                                    // contentPadding: EdgeInsets.only(bottom: 10),
                                    hintText: "",
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    // errorText: snapshot.error?.toString(),
                                  ),
                                  validator: (String? value) {
                                    if (value!.isEmpty) {
                                      return "Bill No is required";
                                    }
                                  },
                                  // onChanged: bloc.changeLoginEmail,
                                  //Instead of TextEditingController,  bloc carrying changing input value by calling loginEmail
                                )))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            alignment: Alignment.centerLeft,
                            width: width * 0.4,
                            height: 60,
                            child: Text(
                              "Installation date",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontFamily: 'RobotoMono',
                                  fontSize: 20,
                                  color: Colors.black87),
                            )),
                        Container(
                            width: width * 0.45,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                date.toString(),
                                style: TextStyle(
                                    fontFamily: 'RobotoMono',
                                    fontSize: 20,
                                    color: Colors.black87),
                              ),
                            )),
                        Container(
                            width: 30,
                            child: IconButton(
                                onPressed: () {
                                  _selectStartDate(context);
                                  setState(() {
                                    print(date.toString());
                                  });
                                },
                                icon: Icon(Icons.calendar_today)))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(left: 0, right: 0, top: 0),
                    //   child: Container(
                    //     height: 180,
                    //     // color: Color(0xffeeeeee),
                    //     color: themWhiteColor,
                    //     // padding: EdgeInsets.all(10.0),
                    //     child: new ConstrainedBox(
                    //       constraints: BoxConstraints(
                    //         maxHeight: 180.0,
                    //       ),
                    //       child: new Scrollbar(
                    //         child: new SingleChildScrollView(
                    //           scrollDirection: Axis.vertical,
                    //           reverse: true,
                    //           child: SizedBox(
                    //             height: 160.0,
                    //             child: new TextFormField(
                    //               maxLength: 500,
                    //               maxLengthEnforcement:MaxLengthEnforcement.enforced,
                    //               maxLines: 100,
                    //               controller: _complainController,
                    //               decoration: new InputDecoration(
                    //                 border: OutlineInputBorder(),
                    //                 hintText: "Fill Your Complain",
                    //                 hintStyle: TextStyle(
                    //                     fontFamily: 'Raleway',
                    //                     fontWeight: FontWeight.w300),
                    //                 labelText: "Complain",
                    //               ),
                    //               validator: (String? value) {
                    //                 if (value!.isEmpty) {
                    //                   return 'Please fill up!';
                    //                 }
                    //                 return null;
                    //               },
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: width,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(themBlueColor),
                        ),
                        child: Text("Submit"),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            if (date == "") {
                              print("null");

                             ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Date is required")));
                            } else {
                              //  Navigator.of(context, rootNavigator: true)
                              //             .push(MaterialPageRoute(
                              //                 builder: (context) =>
                              //                     CustomerItems()));
                              //   setState(() {
                              //     print("item id = ${itemId}");
                              //   });
                              try {
                                var response =
                                    await fetchcustomerMachineRegistrationProcess(
                                  itemId.toString(),
                                  _modelNoController.text,
                                  _quantityNoController.text,
                                  _priceController.text,
                                  _MCcontroller.text,
                                  _billController.text,
                                  date.toString(),
                                );
                                bool res = response.status;
                                var message = response.message;
                                // setState(() {
                                //   msg = response.message;
                                // });

                                if (res == true) {
                                  setState(() {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (context) =>
                                                CustomerItems()));
                                  });

                                Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themBlueColor
    );
                                }

                                if (res == false) {
                                                  Fluttertoast.showToast(
      msg: msg.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: themBlueColor
    );
                                }
                              }
                               catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(msg.toString())));
                              }
                            }

                            _formkey.currentState!.save();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text("Please Enter Essential Fields")));
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
