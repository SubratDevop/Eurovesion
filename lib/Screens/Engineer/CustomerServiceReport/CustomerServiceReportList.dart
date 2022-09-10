import 'dart:convert';
import 'package:eurovision/AES256encryption/Encrypted.dart';
import 'package:eurovision/Api/Api.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/CustomerServiceReportPdfView.dart';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/EditCustomerServiceReport.dart';
import 'package:eurovision/Screens/Engineer/Home/EngineerHome.dart';
import 'package:eurovision/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';



class CustomerServiceReportList extends StatelessWidget {
 
  static String ? date,starttime,endtime,action_taken,spare_name,cust_sign,eng_sign,servicetypename,producttypename,complainnaturename,
  complaintext,complainid,complaintnumber,csrno,csrid,customerName,customerType,customerAddress,customerMobile,customerEmailId,pdflink;

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
      home: CustomerServiceReportListScreen(),
    );
  }
}

class CustomerServiceReportListScreen extends StatefulWidget {
  const CustomerServiceReportListScreen({ Key? key }) : super(key: key);

  @override
  _CustomerServiceReportListScreenState createState() => _CustomerServiceReportListScreenState();
}

class _CustomerServiceReportListScreenState extends State<CustomerServiceReportListScreen> {


  List showCsrList=[];
  fetchCSRList() async {
    
    var csrList_url= engineerGeneratedCsrListApi;
    
    var response = await http.post(
      Uri.parse(csrList_url),

      headers: <String, String>{
        // 'Accept': 'application/json',
        // 'Content-type': 'application/json',
        'Accept': 'application/json'
      },

      body: {
        "engineer_id": EngineerHome.engId.toString()
       
      },

    );
    // print(response.body);
    if(response.statusCode == 200){
      var items = json.decode(response.body)['data'] ?? [];
     
      print('all csr list body');
      print(items);
      
      setState(() {
        showCsrList = items;
       
      });

      print("CSR List "+ showCsrList.toString());
      
      if(showCsrList.length==0){

       // Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(builder: (context)=>NoItemInMyOrders()));

      }

    }else{
      showCsrList = [];
     
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCSRList();
  }

  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
        // title: Align(
        //   alignment: Alignment.topLeft,
        //   child: FittedBox(
        //     child: Padding(
        //       padding: const EdgeInsets.only(left: 10,top: 0),
        //       child: Text("CSR List",style: TextStyle(fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.w700,color: themWhiteColor),),
        //     ),
        //   ),
        // ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductList()));
            Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> EngineerHome()));
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
                  child: Text("CSR List",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
                ),
              ),
            ),
          ),
        ),
       
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: EngineerDrawer()
      ),

      body: 
      showCsrList.length==0 ?
      Center(
        child: Text("Sorry !! You have No CSR... ",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: Colors.black45),),
      ) :

      
      ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: showCsrList.length,
        itemBuilder: (context,index){
          return ListTile(
            title: 

            InkWell(
              onTap: (){

                setState(() {
                  CustomerServiceReportList.starttime=showCsrList[index]['starttime'].toString();
                  CustomerServiceReportList.endtime=showCsrList[index]['endtime'].toString();
                  CustomerServiceReportList.date=showCsrList[index]['csrdate'].toString();
                  CustomerServiceReportList.csrno=showCsrList[index]['csrno'].toString();
                  CustomerServiceReportList.csrid= AesEncryption.encryptAES(showCsrList[index]['csrid'].toString());
                  CustomerServiceReportList.action_taken=showCsrList[index]['actiontaken'].toString();
                  CustomerServiceReportList.spare_name=showCsrList[index]['partsname'].toString();
                  CustomerServiceReportList.eng_sign=showCsrList[index]['engsign'].toString();
                  CustomerServiceReportList.cust_sign=showCsrList[index]['custsign'].toString();
                  CustomerServiceReportList.complaintext=showCsrList[index]['complainttext'].toString();
                  CustomerServiceReportList.complainid=showCsrList[index]['complainid'].toString();
                  CustomerServiceReportList.customerName=showCsrList[index]['customername'].toString();
                  CustomerServiceReportList.customerType=showCsrList[index]['customertypename'].toString();
                  CustomerServiceReportList.customerMobile=showCsrList[index]['mobile'].toString();
                  CustomerServiceReportList.customerEmailId=showCsrList[index]['emailid'].toString();
                  CustomerServiceReportList.customerAddress=showCsrList[index]['customeraddress'].toString();
                  CustomerServiceReportList.servicetypename=showCsrList[index]['servicetypename'].toString();
                  CustomerServiceReportList.complainnaturename=showCsrList[index]['complainnaturename'].toString();
                  CustomerServiceReportList.complaintnumber=showCsrList[index]['complaintnumber'].toString();
                  CustomerServiceReportList.producttypename=showCsrList[index]['producttype'].toString();
                });

                print("Service +++++++++++++++++++++++++"+showCsrList[index]['servicetypename'].toString());
                
                Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>EditCustomerServiceReport()));
              },
              child: IntrinsicHeight(
               
                child: Container(
                  width: width,
                  height: height*0.31, //0.24
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: themWhiteColor,
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                           // leading: Image.asset("assets/images/csr_list.png",height: 100,width:100,color: Colors.black45,),
                           //leading: ,
                            title: Column(
                              children: [

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset("assets/images/csr_list.png",height: 50,width:50,color: Colors.black45,),
                                  ],
                                ),
            
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Start",style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black45),),
                                        Icon(Icons.lock_clock),
                                        Text(showCsrList[index]['starttime'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black45),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.date_range),
                                        Text(showCsrList[index]['csrdate'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color:  Colors.black45),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("End",style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black45),),
                                        Icon(Icons.lock_clock),
                                        Text(showCsrList[index]['endtime'].toString(),style: TextStyle(fontFamily: 'Righteous',fontSize: 12,fontWeight: FontWeight.w700,color:  Colors.black45),)
                                      ],
                                    )
                                  ],
                                ),
            
                                SizedBox(
                                  height: 5,//2
                                ),
            
                                Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      height: 20,
                                      child: FittedBox(child: Text(showCsrList[index]['csrno'].toString(),style: TextStyle(fontFamily: 'Righteous',fontWeight: FontWeight.w700,color: Colors.black54),))
                                    )
                                  ],
                                ),
            
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Engineer Name",style: TextStyle(fontFamily: 'WorkSans',fontWeight: FontWeight.w700,color: Colors.black54,fontSize: 16),),
                                    Container(
                                      height: 15,
                                      child: FittedBox(child: Text(showCsrList[index]['engineername'].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black87),))
                                    )
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Customer Name",style: TextStyle(fontFamily: 'WorkSans',fontWeight: FontWeight.w700,color: Colors.black54,fontSize: 16),),
                                    Container(
                                      height: 15,
                                      child: FittedBox(child: Text(showCsrList[index]['customername'].toString(),style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Colors.black87),))
                                    )
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      tooltip: "PDF",
                                      onPressed: (){
                                        CustomerServiceReportList.pdflink=showCsrList[index]['pdf_link'].toString();
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>CustomerServiceReportPdfView()));
                                      }, 
                                      icon: Icon(Icons.book,color: themBlueColor,)
                                    ),

                                    IconButton(
                                      tooltip: 'Download',
                                      onPressed: (){
                                         _launchURL();
                                      }, 
                                      icon: Icon(Icons.download,color: themBlueColor,)
                                    ),

                                    IconButton(
                                      tooltip: 'Edit CSR',
                                      onPressed: (){

                                        setState(() {
                                          CustomerServiceReportList.starttime=showCsrList[index]['starttime'].toString();
                                          CustomerServiceReportList.endtime=showCsrList[index]['endtime'].toString();
                                          CustomerServiceReportList.date=showCsrList[index]['csrdate'].toString();
                                          CustomerServiceReportList.csrno=showCsrList[index]['csrno'].toString();
                                          CustomerServiceReportList.csrid= AesEncryption.encryptAES(showCsrList[index]['csrid'].toString());
                                          CustomerServiceReportList.action_taken=showCsrList[index]['actiontaken'].toString();
                                          CustomerServiceReportList.spare_name=showCsrList[index]['partsname'].toString();
                                          CustomerServiceReportList.eng_sign=showCsrList[index]['engsign'].toString();
                                          CustomerServiceReportList.cust_sign=showCsrList[index]['custsign'].toString();
                                          CustomerServiceReportList.complaintext=showCsrList[index]['complainttext'].toString();
                                          CustomerServiceReportList.complainid=showCsrList[index]['complainid'].toString();
                                          CustomerServiceReportList.customerName=showCsrList[index]['customername'].toString();
                                          CustomerServiceReportList.customerType=showCsrList[index]['customertypename'].toString();
                                          CustomerServiceReportList.customerMobile=showCsrList[index]['mobile'].toString();
                                          CustomerServiceReportList.customerEmailId=showCsrList[index]['emailid'].toString();
                                          CustomerServiceReportList.customerAddress=showCsrList[index]['customeraddress'].toString();
                                          CustomerServiceReportList.servicetypename=showCsrList[index]['servicetypename'].toString();
                                          CustomerServiceReportList.complainnaturename=showCsrList[index]['complainnaturename'].toString();
                                          CustomerServiceReportList.complaintnumber=showCsrList[index]['complaintnumber'].toString();
                                          CustomerServiceReportList.producttypename=showCsrList[index]['producttype'].toString();
                                        });
                                        Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=>EditCustomerServiceReport()));
                                      }, 
                                      icon: Icon(Icons.edit,color: themBlueColor,)
                                    )


                                  ],
                               
                                 // child:   Text("Edit",style: TextStyle(fontFamily: 'WorkSans',fontWeight: FontWeight.w900,color: Colors.red,fontSize: 16),),
                                )
                              
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
          ); 
        }
      )

      
    );
  }

  void _launchURL() async {
    if (!await launchUrl(Uri.parse(CustomerServiceReportList.pdflink.toString()))) throw 'Could not launch $CustomerServiceReportList.pdflink.toString()';
  }
}