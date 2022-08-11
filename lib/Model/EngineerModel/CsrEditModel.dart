// To parse this JSON data, do
//
//     final csrEditModel = csrEditModelFromJson(jsonString);

import 'dart:convert';

CsrEditModel csrEditModelFromJson(String str) => CsrEditModel.fromJson(json.decode(str));

String csrEditModelToJson(CsrEditModel data) => json.encode(data.toJson());

class CsrEditModel {
    CsrEditModel({
      required  this.message,
      required  this.data,
      required  this.status,
    });

    String message;
    String data;
    bool status;

    factory CsrEditModel.fromJson(Map<String, dynamic> json) => CsrEditModel(
        message: json["message"],
        data: json["data"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "data": data,
        "status": status,
    };
}
