// To parse this JSON data, do
//
//     final CustomerReSetPasswordModel = CustomerReSetPasswordModelFromJson(jsonString);

import 'dart:convert';

CustomerReSetPasswordModel CustomerReSetPasswordModelFromJson(String str) => CustomerReSetPasswordModel.fromJson(json.decode(str));

String CustomerReSetPasswordModelToJson(CustomerReSetPasswordModel data) => json.encode(data.toJson());

class CustomerReSetPasswordModel {
    CustomerReSetPasswordModel({
      required  this.message,
      required  this.status,
      required  this.customerid,
    });

    String message;
    bool status;
    String customerid;

    factory CustomerReSetPasswordModel.fromJson(Map<String, dynamic> json) => CustomerReSetPasswordModel(
        message: json["message"],
        status: json["status"],
        customerid: json["customerid"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "customerid": customerid,
    };
}
