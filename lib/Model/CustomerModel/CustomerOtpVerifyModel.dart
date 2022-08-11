// To parse this JSON data, do
//
//     final customerOtpVerifyModel = customerOtpVerifyModelFromJson(jsonString);

import 'dart:convert';

CustomerOtpVerifyModel customerOtpVerifyModelFromJson(String str) => CustomerOtpVerifyModel.fromJson(json.decode(str));

String customerOtpVerifyModelToJson(CustomerOtpVerifyModel data) => json.encode(data.toJson());

class CustomerOtpVerifyModel {
    CustomerOtpVerifyModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.customerid,
    });

    String message;
    String data;
    bool status;
    String customerid;

    factory CustomerOtpVerifyModel.fromJson(Map<String, dynamic> json) => CustomerOtpVerifyModel(
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
