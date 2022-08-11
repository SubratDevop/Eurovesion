// To parse this JSON data, do
//
//     final customerProfileEditModel = customerProfileEditModelFromJson(jsonString);

import 'dart:convert';

CustomerProfileEditModel customerProfileEditModelFromJson(String str) => CustomerProfileEditModel.fromJson(json.decode(str));

String customerProfileEditModelToJson(CustomerProfileEditModel data) => json.encode(data.toJson());

class CustomerProfileEditModel {
    CustomerProfileEditModel({
      required  this.customerid,
      required  this.customertypeid,
      required  this.customertypename,
      required  this.customername,
      required  this.customercode,
      required  this.customermobile,
      required  this.customermail,
      required  this.customeraddress,
      required  this.gst,
      required  this.customerimage,
      required  this.message,
      required  this.data,
      required  this.status,
    });

    String customerid;
    String customertypeid;
    String customertypename;
    String customername;
    String customercode;
    String customermobile;
    String customermail;
    String customeraddress;
    String gst;
    String customerimage;
    String message;
    String data;
    bool status;

    factory CustomerProfileEditModel.fromJson(Map<String, dynamic> json) => CustomerProfileEditModel(
        customerid: json["customerid"],
        customertypeid: json["customertypeid"],
        customertypename: json["customertypename"],
        customername: json["customername"],
        customercode: json["customercode"],
        customermobile: json["customermobile"],
        customermail: json["customermail"],
        customeraddress: json["customeraddress"],
        gst: json["gst"],
        customerimage: json["customerimage"],
        message: json["message"],
        data: json["data"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "customerid": customerid,
        "customertypeid": customertypeid,
        "customertypename": customertypename,
        "customername": customername,
        "customercode": customercode,
        "customermobile": customermobile,
        "customermail": customermail,
        "customeraddress": customeraddress,
        "gst": gst,
        "customerimage": customerimage,
        "message": message,
        "data": data,
        "status": status,
    };
}





































// // To parse this JSON data, do
// //
// //     final customerProfileEditModel = customerProfileEditModelFromJson(jsonString);

// import 'dart:convert';

// CustomerProfileEditModel customerProfileEditModelFromJson(String str) => CustomerProfileEditModel.fromJson(json.decode(str));

// String customerProfileEditModelToJson(CustomerProfileEditModel data) => json.encode(data.toJson());

// class CustomerProfileEditModel {
//     CustomerProfileEditModel({
//       required  this.customerid,
//       required  this.customertypeid,
//       required  this.customertypename,
//       required  this.customername,
//       required  this.customercode,
//       required  this.customermobile,
//       required  this.customermail,
//       required  this.customeraddress,
//       required  this.gst,
//       required  this.customerimage,
//       required  this.message,
//       required  this.data,
//       required  this.status,
//     });

//     String customerid;
//     String customertypeid;
//     String customertypename;
//     String customername;
//     String customercode;
//     String customermobile;
//     String customermail;
//     String customeraddress;
//     String gst;
//     String customerimage;
//     String message;
//     String data;
//     bool status;

//     factory CustomerProfileEditModel.fromJson(Map<String, dynamic> json) => CustomerProfileEditModel(
//         customerid: json["customerid"],
//         customertypeid: json["customertypeid"],
//         customertypename: json["customertypename"],
//         customername: json["customername"],
//         customercode: json["customercode"],
//         customermobile: json["customermobile"],
//         customermail: json["customermail"],
//         customeraddress: json["customeraddress"],
//         gst: json["gst"],
//         customerimage: json["customerimage"],
//         message: json["message"],
//         data: json["data"],
//         status: json["status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "customerid": customerid,
//         "customertypeid": customertypeid,
//         "customertypename": customertypename,
//         "customername": customername,
//         "customercode": customercode,
//         "customermobile": customermobile,
//         "customermail": customermail,
//         "customeraddress": customeraddress,
//         "gst": gst,
//         "customerimage": customerimage,
//         "message": message,
//         "data": data,
//         "status": status,
//     };
// }
