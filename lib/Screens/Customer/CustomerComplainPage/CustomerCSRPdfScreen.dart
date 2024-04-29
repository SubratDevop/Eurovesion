// import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:eurovision/Screens/Customer/CustomerComplainPage/CusstmerCSRView.dart';
import 'package:eurovision/Screens/Customer/SideNavigationDrawer/CustomerDrawer/CustomerDrawer.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:eurovision/CustomShape/CustomAppBarShape/Customshape.dart';
import 'package:eurovision/Screens/Engineer/CustomerServiceReport/CustomerServiceReportList.dart';
import 'package:eurovision/Screens/Engineer/SideNavigationDrawer/EngineerDrawer/EngineerDrawer.dart';
import 'package:eurovision/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';


class CustomerCSRPdfScreen extends StatelessWidget {
  const CustomerCSRPdfScreen({ Key? key }) : super(key: key);

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
      home: CustomerCSRPdfScreenScreen(),
      
    );
  }
}

class CustomerCSRPdfScreenScreen extends StatefulWidget {
 

  @override
  _CustomerCSRPdfScreenScreenState createState() => _CustomerCSRPdfScreenScreenState();
}

class _CustomerCSRPdfScreenScreenState extends State<CustomerCSRPdfScreenScreen> {

//  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  String  pdfUrl =  CusstmerCSRView.csrPdfUrl!;
  bool _isLoading = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // pdfUrl= CustomerServiceReportList.pdflink.toString();
    if(pdfUrl.toString() == ""){
      _isLoading = true;
    }else{
      _isLoading = false;
    }

    // loadPdfDocument();
  }

  @override
  Widget build(BuildContext context) {

    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    

    return Scaffold(
      backgroundColor: themWhiteColor,
      appBar: AppBar(
        // automaticallyImplyLeading: true,
         
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: themBlueColor,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light
        ),

        backgroundColor: themBlueColor,
        
        elevation: 0.0,
        title: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,top: 0),
              child: Text("CSR PDF View",style: TextStyle(fontFamily: 'AkayaKanadaka',fontSize: 30,fontWeight: FontWeight.w700,color: themWhiteColor),),
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left,color: Colors.white,size: 40,),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CusstmerCSRView()));
            // Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(builder: (context)=> CustomerServiceReportList()));
          // Navigator.pop(context);
          }
          ,
        ),
       
       
      ),

      endDrawer: Container(
        width: MediaQuery.of(context).size.width*0.7,
        child: CustomerDrawer()
      ),

      body: Center(

        child: 
         _isLoading
        ? Center(child: CircularProgressIndicator())
      : PDF(
        swipeHorizontal: true,
      ).cachedFromUrl(pdfUrl.toString()),

       
       

        // : PDFViewer(
        //     document: pdfDocument,
        //     //zoomSteps: 1,
        //   ),

      ),

    
    );
  }
}