// To parse this JSON data, do
//
//     final customerTotalComplainListModel = customerTotalComplainListModelFromJson(jsonString);

import 'dart:convert';

CustomerTotalComplainListModel customerTotalComplainListModelFromJson(String str) => CustomerTotalComplainListModel.fromJson(json.decode(str));

String customerTotalComplainListModelToJson(CustomerTotalComplainListModel data) => json.encode(data.toJson());

class CustomerTotalComplainListModel {
    CustomerTotalComplainListModel({
      required  this.status,
      required  this.data,
    });

    bool status;
    List<Datum> data;

    factory CustomerTotalComplainListModel.fromJson(Map<String, dynamic> json) => CustomerTotalComplainListModel(
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
      required  this.id,
      required  this.customerid,
      required  this.complaintnumber,
      required  this.complainttext,
      required  this.complaintstatus,
      required  this.flagid,
      required  this.assignedto,
      required  this.entryby,
      required  this.entryat,
      required  this.isactive,
    });

    String id;
    String customerid;
    String complaintnumber;
    String complainttext;
    String complaintstatus;
    String flagid;
    dynamic assignedto;
    String entryby;
    DateTime entryat;
    String isactive;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        customerid: json["customerid"],
        complaintnumber: json["complaintnumber"],
        complainttext: json["complainttext"],
        complaintstatus: json["complaintstatus"],
        flagid: json["flagid"],
        assignedto: json["assignedto"],
        entryby: json["entryby"],
        entryat: DateTime.parse(json["entryat"]),
        isactive: json["isactive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "customerid": customerid,
        "complaintnumber": complaintnumber,
        "complainttext": complainttext,
        "complaintstatus": complaintstatus,
        "flagid": flagid,
        "assignedto": assignedto,
        "entryby": entryby,
        "entryat": entryat.toIso8601String(),
        "isactive": isactive,
    };
}
