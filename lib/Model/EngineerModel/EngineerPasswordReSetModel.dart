// To parse this JSON data, do
//
//     final engineerPasswordReSetModel = engineerPasswordReSetModelFromJson(jsonString);

import 'dart:convert';

EngineerPasswordReSetModel engineerPasswordReSetModelFromJson(String str) => EngineerPasswordReSetModel.fromJson(json.decode(str));

String engineerPasswordReSetModelToJson(EngineerPasswordReSetModel data) => json.encode(data.toJson());

class EngineerPasswordReSetModel {
    EngineerPasswordReSetModel({
      required  this.message,
      required  this.status,
      required  this.customerid,
    });

    String message;
    bool status;
    String customerid;

    factory EngineerPasswordReSetModel.fromJson(Map<String, dynamic> json) => EngineerPasswordReSetModel(
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
