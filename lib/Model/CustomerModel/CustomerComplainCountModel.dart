// To parse this JSON data, do
//
//     final customerComplainCountModel = customerComplainCountModelFromJson(jsonString);

import 'dart:convert';

CustomerComplainCountModel customerComplainCountModelFromJson(String str) => CustomerComplainCountModel.fromJson(json.decode(str));

String customerComplainCountModelToJson(CustomerComplainCountModel data) => json.encode(data.toJson());

class CustomerComplainCountModel {
    CustomerComplainCountModel({
      required  this.status,
      required  this.data,
    });

    bool status;
    List<Datum> data;

    factory CustomerComplainCountModel.fromJson(Map<String, dynamic> json) => CustomerComplainCountModel(
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
      required  this.totalComplain,
      required  this.totalPendingComplain,
      required  this.totalCompletedComplain,

    });

    int totalComplain;
    int totalPendingComplain;
    int totalCompletedComplain;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        totalComplain: json["total_complain"] == null ? null : json["total_complain"],
        totalPendingComplain: json["total_pending_complain"] == null ? null : json["total_pending_complain"],
        totalCompletedComplain: json["total_completed_complain"] == null ? null : json["total_completed_complain"],
    );

    Map<String, dynamic> toJson() => {
        "total_complain": totalComplain == null ? null : totalComplain,
        "total_pending_complain": totalPendingComplain == null ? null : totalPendingComplain,
        "total_completed_complain": totalCompletedComplain == null ? null : totalCompletedComplain,
    };
}
