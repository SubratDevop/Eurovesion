// To parse this JSON data, do
//
//     final customerPasswordResetModel = customerPasswordResetModelFromJson(jsonString);

import 'dart:convert';

CustomerPasswordResetModel customerPasswordResetModelFromJson(String str) => CustomerPasswordResetModel.fromJson(json.decode(str));

String customerPasswordResetModelToJson(CustomerPasswordResetModel data) => json.encode(data.toJson());

class CustomerPasswordResetModel {
    CustomerPasswordResetModel({
      required  this.message,
      required  this.status,
      required  this.customerid,
    });

    String message;
    bool status;
    String customerid;

    factory CustomerPasswordResetModel.fromJson(Map<String, dynamic> json) => CustomerPasswordResetModel(
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
