// To parse this JSON data, do
//
//     final csrEntryModel = csrEntryModelFromJson(jsonString);

import 'dart:convert';

CsrEntryModel csrEntryModelFromJson(String str) => CsrEntryModel.fromJson(json.decode(str));

String csrEntryModelToJson(CsrEntryModel data) => json.encode(data.toJson());

class CsrEntryModel {
    CsrEntryModel({
      required this.message,
      required  this.data,
      required  this.status,
    });

    String message;
    String data;
    bool status;

    factory CsrEntryModel.fromJson(Map<String, dynamic> json) => CsrEntryModel(
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
