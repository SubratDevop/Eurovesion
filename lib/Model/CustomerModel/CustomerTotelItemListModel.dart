// To parse this JSON data, do
//
//     final customerTotelItemListModel = customerTotelItemListModelFromJson(jsonString);

// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

CustomerTotelItemListModel customerTotelItemListModelFromJson(String str) =>
    CustomerTotelItemListModel.fromJson(json.decode(str));

String customerTotelItemListModelToJson(CustomerTotelItemListModel data) =>
    json.encode(data.toJson());

class CustomerTotelItemListModel {
  CustomerTotelItemListModel({
    required this.status,
    required this.data,
  });

  bool status;
  List<Datum> data;

  factory CustomerTotelItemListModel.fromJson(Map<String, dynamic> json) =>
      CustomerTotelItemListModel(
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
    required this.customerid,
    required this.itemid,
    required this.modelno,
    required this.quantity,
    required this.machineno,
    required this.billno,
    required this.price,
    required this.instalationdate,
    required this.entryat,
    required this.isactive,
    required this.itemname,
    required this.categoryid,
    required this.amcnumber,
    // required  this.fromdate,
    // required  this.todate,
    required this.pdflink,
    required this.totalpmcall,
    required this.totalactivepmcall,
    required this.totalpendingpmcall,
  });

  String id;
  String customerid;
  String itemid;
  String modelno;
  String quantity;
  String machineno;
  String billno;
  String price;
  DateTime instalationdate;
  DateTime entryat;
  String isactive;
  String itemname;
  String categoryid;
  String amcnumber;
  // String fromdate;
  // DateTime todate;
  String pdflink;
  int totalpmcall;
  int totalactivepmcall;
  int totalpendingpmcall;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        customerid: json["customerid"],
        itemid: json["itemid"],
        modelno: json["modelno"],
        quantity: json["quantity"],
        machineno: json["machineno"],
        billno: json["billno"],
        price: json["price"],
        instalationdate: DateTime.parse(json["instalationdate"]),
        entryat: DateTime.parse(json["entryat"]),
        isactive: json["isactive"],
        itemname: json["itemname"],
        categoryid: json["categoryid"],
        amcnumber: json["amcnumber"] == null ? null : json["amcnumber"],
        // fromdate: json["fromdate"] == null ? null : DateTime.parse(json["fromdate"]),
        // todate: json["todate"] == null ? null : DateTime.parse(json["todate"]),
        pdflink: json["pdflink"] == null ? null : json["pdflink"],
        totalpmcall: json["totalpmcall"] == null ? null : json["totalpmcall"],
        totalactivepmcall: json["totalactivepmcall"] == null
            ? null
            : json["totalactivepmcall"],
        totalpendingpmcall: json["totalpendingpmcall"] == null
            ? null
            : json["totalpendingpmcall"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customerid": customerid,
        "itemid": itemid,
        "modelno": modelno,
        "quantity": quantity,
        "machineno": machineno,
        "billno": billno,
        "price": price,
        "instalationdate":
            "${instalationdate.year.toString().padLeft(4, '0')}-${instalationdate.month.toString().padLeft(2, '0')}-${instalationdate.day.toString().padLeft(2, '0')}",
        "entryat": entryat.toIso8601String(),
        "isactive": isactive,
        "itemname": itemname,
        "categoryid": categoryid,
        "amcnumber": amcnumber == null ? null : amcnumber,
        // "fromdate": fromdate == null ? null : "${fromdate.year.toString().padLeft(4, '0')}-${fromdate.month.toString().padLeft(2, '0')}-${fromdate.day.toString().padLeft(2, '0')}",
        // "todate": todate == null ? null : "${todate.year.toString().padLeft(4, '0')}-${todate.month.toString().padLeft(2, '0')}-${todate.day.toString().padLeft(2, '0')}",
        "pdflink": pdflink == null ? null : pdflink,
        "totalpmcall": totalpmcall == null ? null : totalpmcall,
        "totalactivepmcall":
            totalactivepmcall == null ? null : totalactivepmcall,
        "totalpendingpmcall":
            totalpendingpmcall == null ? null : totalpendingpmcall,
      };
}
