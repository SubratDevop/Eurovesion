// To parse this JSON data, do
//
//     final customerItemsModel = customerItemsModelFromJson(jsonString);

import 'dart:convert';

CustomerItemsModel customerItemsModelFromJson(String str) => CustomerItemsModel.fromJson(json.decode(str));

String customerItemsModelToJson(CustomerItemsModel data) => json.encode(data.toJson());

class CustomerItemsModel {
    CustomerItemsModel({
      required  this.message,
      required  this.data,
      required  this.status,
    });

    String message;
    String data;
    bool status;

    factory CustomerItemsModel.fromJson(Map<String, dynamic> json) => CustomerItemsModel(
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
