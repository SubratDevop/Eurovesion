// To parse this JSON data, do
//
//     final engineerResendOtpModel = engineerResendOtpModelFromJson(jsonString);

import 'dart:convert';

EngineerResendOtpModel engineerResendOtpModelFromJson(String str) => EngineerResendOtpModel.fromJson(json.decode(str));

String engineerResendOtpModelToJson(EngineerResendOtpModel data) => json.encode(data.toJson());

class EngineerResendOtpModel {
    EngineerResendOtpModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.engineerid,
    });

    String message;
    String data;
    bool status;
    String engineerid;

    factory EngineerResendOtpModel.fromJson(Map<String, dynamic> json) => EngineerResendOtpModel(
        message: json["message"],
        data: json["data"],
        status: json["status"],
        engineerid: json["engineerid"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
        "status": status,
        "engineerid": engineerid,
    };
}
