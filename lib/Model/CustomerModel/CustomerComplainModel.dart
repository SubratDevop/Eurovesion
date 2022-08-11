// To parse this JSON data, do
//
//     final customerComplainModel = customerComplainModelFromJson(jsonString);

import 'dart:convert';

CustomerComplainModel customerComplainModelFromJson(String str) => CustomerComplainModel.fromJson(json.decode(str));

String customerComplainModelToJson(CustomerComplainModel data) => json.encode(data.toJson());

class CustomerComplainModel {
    CustomerComplainModel({
      required  this.message,
      required  this.data,
      required  this.status,
    });

    String message;
    String data;
    bool status;

    factory CustomerComplainModel.fromJson(Map<String, dynamic> json) => CustomerComplainModel(
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
