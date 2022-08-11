// To parse this JSON data, do
//
//     final engineerTourListMOdel = engineerTourListMOdelFromJson(jsonString);

import 'dart:convert';

EngineerTourListMOdel engineerTourListMOdelFromJson(String str) => EngineerTourListMOdel.fromJson(json.decode(str));

String engineerTourListMOdelToJson(EngineerTourListMOdel data) => json.encode(data.toJson());

class EngineerTourListMOdel {
    EngineerTourListMOdel({
       required this.status,
       required this.data,
    });

    bool status;
    List<Datum> data;

    factory EngineerTourListMOdel.fromJson(Map<String, dynamic> json) => EngineerTourListMOdel(
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
      required  this.tourid,
      required  this.engineerid,
      required  this.teritory,
      required  this.depdate,
      required  this.deptime,
      required  this.arrdate,
      required  this.arrtime,
      required  this.duration,
      required  this.dailyallowance,
      required  this.otherexp,
      required  this.advancepaid,
      required  this.grandtotal,
      required  this.status,
      required  this.approvedby,
      required  this.pdfLink,
      required  this.branchid,
      required  this.username,
      required  this.engineername,
      required  this.engineerphone,
      required  this.engineeremail,
    });

    String tourid;
    String engineerid;
    String teritory;
    DateTime depdate;
    String deptime;
    DateTime arrdate;
    String arrtime;
    String duration;
    String dailyallowance;
    String otherexp;
    String advancepaid;
    String grandtotal;
    String status;
    dynamic approvedby;
    String pdfLink;
    String branchid;
    String username;
    String engineername;
    String engineerphone;
    String engineeremail;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        tourid: json["tourid"],
        engineerid: json["engineerid"],
        teritory: json["teritory"],
        depdate: DateTime.parse(json["depdate"]),
        deptime: json["deptime"],
        arrdate: DateTime.parse(json["arrdate"]),
        arrtime: json["arrtime"],
        duration: json["duration"],
        dailyallowance: json["dailyallowance"],
        otherexp: json["otherexp"],
        advancepaid: json["advancepaid"],
        grandtotal: json["grandtotal"],
        status: json["status"],
        approvedby: json["approvedby"],
        pdfLink: json["pdf_link"],
        branchid: json["branchid"],
        username: json["username"],
        engineername: json["engineername"],
        engineerphone: json["engineerphone"],
        engineeremail: json["engineeremail"],
    );

    Map<String, dynamic> toJson() => {
        "tourid": tourid,
        "engineerid": engineerid,
        "teritory": teritory,
        "depdate": "${depdate.year.toString().padLeft(4, '0')}-${depdate.month.toString().padLeft(2, '0')}-${depdate.day.toString().padLeft(2, '0')}",
        "deptime": deptime,
        "arrdate": "${arrdate.year.toString().padLeft(4, '0')}-${arrdate.month.toString().padLeft(2, '0')}-${arrdate.day.toString().padLeft(2, '0')}",
        "arrtime": arrtime,
        "duration": duration,
        "dailyallowance": dailyallowance,
        "otherexp": otherexp,
        "advancepaid": advancepaid,
        "grandtotal": grandtotal,
        "status": status,
        "approvedby": approvedby,
        "pdf_link": pdfLink,
        "branchid": branchid,
        "username":username,
        "engineername": engineername,
        "engineerphone": engineerphone,
        "engineeremail": engineeremail,
    };
}

// enum Engineeremail { ASIMA_GMAIL_COM }

// final engineeremailValues =  EnumValues({
//     "asima@gmail.com": Engineeremail.ASIMA_GMAIL_COM
// });

// enum Ername { ASIMA_NANDA_JENA }

// final ernameValues = EnumValues({
//     "Asima Nanda jena": Ername.ASIMA_NANDA_JENA
// });

// class EnumValues<T> {
//     Map<String, T> map;
//     Map<T, String> reverseMap;

//    EnumValues(this.map);

//     Map<T, String> get reverse {
//         if (reverseMap == null) {
//             reverseMap = map.map((k, v) => new MapEntry(v, k));
//         }
//         return reverseMap;
//     }
// }
