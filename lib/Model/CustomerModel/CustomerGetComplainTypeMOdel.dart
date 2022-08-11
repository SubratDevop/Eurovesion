// To parse this JSON data, do
//
//     final customerGetComplainTypeMOdel = customerGetComplainTypeMOdelFromJson(jsonString);

import 'dart:convert';

CustomerGetComplainTypeMOdel customerGetComplainTypeMOdelFromJson(String str) =>
    CustomerGetComplainTypeMOdel.fromJson(json.decode(str));

String customerGetComplainTypeMOdelToJson(CustomerGetComplainTypeMOdel data) =>
    json.encode(data.toJson());

class CustomerGetComplainTypeMOdel {
  CustomerGetComplainTypeMOdel({
    required this.status,
    required this.data,
  });

  bool status;
  List<Datum> data;

  factory CustomerGetComplainTypeMOdel.fromJson(Map<String, dynamic> json) =>
      CustomerGetComplainTypeMOdel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.categoryname,
    required this.isactive,
  });

  String id;
  String categoryname;
  String isactive;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryname: json["categoryname"],
        isactive: json["isactive"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryname": categoryname,
        "isactive": isactive,
      };
}
