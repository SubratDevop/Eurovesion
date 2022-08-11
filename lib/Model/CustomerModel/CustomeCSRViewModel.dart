// To parse this JSON data, do
//
//     final customeCsrViewModel = customeCsrViewModelFromJson(jsonString);

import 'dart:convert';

CustomeCsrViewModel customeCsrViewModelFromJson(String str) => CustomeCsrViewModel.fromJson(json.decode(str));

String customeCsrViewModelToJson(CustomeCsrViewModel data) => json.encode(data.toJson());

class CustomeCsrViewModel {
    CustomeCsrViewModel({
      required  this.status,
      required  this.complaintnumber,
      required  this.data,
    });

    bool status;
    String complaintnumber;
    List<Datum> data;

    factory CustomeCsrViewModel.fromJson(Map<String, dynamic> json) => CustomeCsrViewModel(
        status: json["status"],
        complaintnumber: json["complaintnumber"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "complaintnumber": complaintnumber,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
      required  this.id,
      required  this.csrno,
      required  this.csrdate,
      required  this.starttime,
      required  this.endtime,
      required  this.pdfLink,
      required  this.entryby,
      required  this.entryat,
      required  this.isactive,
    });

    String id;
    String csrno;
    DateTime csrdate;
    String starttime;
    String endtime;
    String pdfLink;
    String entryby;
    DateTime entryat;
    String isactive;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        csrno: json["csrno"],
        csrdate: DateTime.parse(json["csrdate"]),
        starttime: json["starttime"],
        endtime: json["endtime"],
        pdfLink: json["pdf_link"],
        entryby: json["entryby"],
        entryat: DateTime.parse(json["entryat"]),
        isactive: json["isactive"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "csrno": csrno,
        "csrdate": "${csrdate.year.toString().padLeft(4, '0')}-${csrdate.month.toString().padLeft(2, '0')}-${csrdate.day.toString().padLeft(2, '0')}",
        "starttime": starttime,
        "endtime": endtime,
        "pdf_link": pdfLink,
        "entryby": entryby,
        "entryat": entryat.toIso8601String(),
        "isactive": isactive,
    };
}
