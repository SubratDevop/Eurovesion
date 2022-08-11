// To parse this JSON data, do
//
//     final engineerOtpVerifyModel = engineerOtpVerifyModelFromJson(jsonString);

import 'dart:convert';

EngineerOtpVerifyModel engineerOtpVerifyModelFromJson(String str) => EngineerOtpVerifyModel.fromJson(json.decode(str));

String engineerOtpVerifyModelToJson(EngineerOtpVerifyModel data) => json.encode(data.toJson());

class EngineerOtpVerifyModel {
    EngineerOtpVerifyModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.engineerid,
    });

    String message;
    String data;
    bool status;
    String engineerid;

    factory EngineerOtpVerifyModel.fromJson(Map<String, dynamic> json) => EngineerOtpVerifyModel(
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
