// To parse this JSON data, do
//
//     final engineerVerifyModel = engineerVerifyModelFromJson(jsonString);

import 'dart:convert';

EngineerVerifyModel engineerVerifyModelFromJson(String str) => EngineerVerifyModel.fromJson(json.decode(str));

String engineerVerifyModelToJson(EngineerVerifyModel data) => json.encode(data.toJson());

class EngineerVerifyModel {
    EngineerVerifyModel({
      required  this.message,
      required  this.data,
      required  this.status,
      required  this.engineerid,
    });

    String message;
    String data;
    bool status;
    String engineerid;

    factory EngineerVerifyModel.fromJson(Map<String, dynamic> json) => EngineerVerifyModel(
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
