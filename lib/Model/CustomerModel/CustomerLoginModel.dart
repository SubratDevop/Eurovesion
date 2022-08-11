// To parse this JSON data, do
//
//     final customerLoginModel = customerLoginModelFromJson(jsonString);

import 'dart:convert';

CustomerLoginModel customerLoginModelFromJson(String str) => CustomerLoginModel.fromJson(json.decode(str));

String customerLoginModelToJson(CustomerLoginModel data) => json.encode(data.toJson());

class CustomerLoginModel {
    CustomerLoginModel({
      required  this.message,
      required  this.status,
      required  this.customerid,
      required  this.authtoken,
      required  this.customertypeid,
      required  this.customertypename,
      required  this.customername,
      required  this.customercode,
      required  this.customermobile,
      required  this.customermail,
      required  this.customeraddress,
      required  this.gst,
    });

    String message;
    bool status;
    String customerid;
    String authtoken;
    String customertypeid;
    String customertypename;
    String customername;
    String customercode;
    String customermobile;
    String customermail;
    String customeraddress;
    dynamic gst;

    factory CustomerLoginModel.fromJson(Map<String, dynamic> json) => CustomerLoginModel(
        message: json["message"],
        status: json["status"],
        customerid: json["customerid"],
        authtoken: json["authtoken"],
        customertypeid: json["customertypeid"],
        customertypename: json["customertypename"],
        customername: json["customername"],
        customercode: json["customercode"],
        customermobile: json["customermobile"],
        customermail: json["customermail"],
        customeraddress: json["customeraddress"],
        gst: json["gst"], 
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "customerid": customerid,
        "authtoken": authtoken,
        "customertypeid": customertypeid,
        "customertypename": customertypename,
        "customername": customername,
        "customercode": customercode,
        "customermobile": customermobile,
        "customermail": customermail,
        "customeraddress": customeraddress,
        "gst": gst,
    };
}
