// To parse this JSON data, do
//
//     final customerPendingComplainListModel = customerPendingComplainListModelFromJson(jsonString);

import 'dart:convert';

CustomerPendingComplainListModel customerPendingComplainListModelFromJson(String str) => CustomerPendingComplainListModel.fromJson(json.decode(str));

String customerPendingComplainListModelToJson(CustomerPendingComplainListModel data) => json.encode(data.toJson());

class CustomerPendingComplainListModel {
    CustomerPendingComplainListModel({
      required  this.status,
      required  this.data,
    });

    bool status;
    List<Datum> data;

    factory CustomerPendingComplainListModel.fromJson(Map<String, dynamic> json) => CustomerPendingComplainListModel(
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
      required  this.complaindate,
      required  this.complaintime,
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
    String complaindate;
    String complaintime;
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
        complaindate: json["complaindate"],
        complaintime: json["complaintime"],
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
        "complaindate": complaindate,
        "complaintime": complaintime,
        "isactive": isactive,
    };
}
