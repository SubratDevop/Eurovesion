// To parse this JSON data, do
//
//     final customerGetItemTypeComplainMOdel = customerGetItemTypeComplainMOdelFromJson(jsonString);

import 'dart:convert';

CustomerGetItemTypeComplainMOdel customerGetItemTypeComplainMOdelFromJson(
        String str) =>
    CustomerGetItemTypeComplainMOdel.fromJson(json.decode(str));

String customerGetItemTypeComplainMOdelToJson(
        CustomerGetItemTypeComplainMOdel data) =>
    json.encode(data.toJson());

class CustomerGetItemTypeComplainMOdel {
  CustomerGetItemTypeComplainMOdel({
    required this.status,
    required this.data,
  });

  bool status;
  List<Datum> data;

  factory CustomerGetItemTypeComplainMOdel.fromJson(
          Map<String, dynamic> json) =>
      CustomerGetItemTypeComplainMOdel(
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
    required this.itemid,
    required this.isactive,
    required this.itemName,
  });

  String id;
  String itemid;
  String isactive;
  String itemName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        itemid: json["itemid"],
        isactive: json["isactive"],
        itemName: json["item_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "itemid": itemid,
        "isactive": isactive,
        "item_name": itemName,
      };
}
