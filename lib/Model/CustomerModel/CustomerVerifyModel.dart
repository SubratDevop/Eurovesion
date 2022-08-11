// To parse this JSON data, do
//
//     final customerVerifyModel = customerVerifyModelFromJson(jsonString);

import 'dart:convert';

CustomerVerifyModel customerVerifyModelFromJson(String str) => CustomerVerifyModel.fromJson(json.decode(str));

String customerVerifyModelToJson(CustomerVerifyModel data) => json.encode(data.toJson());

class CustomerVerifyModel {
    CustomerVerifyModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.customerid,
    });

    String message;
    String data;
    bool status;
    String customerid;

    factory CustomerVerifyModel.fromJson(Map<String, dynamic> json) => CustomerVerifyModel(
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
