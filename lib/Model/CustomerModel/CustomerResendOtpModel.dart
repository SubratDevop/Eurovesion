// To parse this JSON data, do
//
//     final customerResendOtpModel = customerResendOtpModelFromJson(jsonString);

import 'dart:convert';

CustomerResendOtpModel customerResendOtpModelFromJson(String str) => CustomerResendOtpModel.fromJson(json.decode(str));

String customerResendOtpModelToJson(CustomerResendOtpModel data) => json.encode(data.toJson());

class CustomerResendOtpModel {
    CustomerResendOtpModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.customerid,
    });

    String message;
    String data;
    bool status;
    String customerid;

    factory CustomerResendOtpModel.fromJson(Map<String, dynamic> json) => CustomerResendOtpModel(
        message: json["message"],
        data: json["data"],
        status: json["status"],
        customerid: json["customerid"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
        "status": status,
        "customerid": customerid,
    };
}
