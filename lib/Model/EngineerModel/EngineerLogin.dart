// To parse this JSON data, do
//
//     final engineerLoginModel = engineerLoginModelFromJson(jsonString);

import 'dart:convert';

EngineerLoginModel engineerLoginModelFromJson(String str) =>
    EngineerLoginModel.fromJson(json.decode(str));

String engineerLoginModelToJson(EngineerLoginModel data) =>
    json.encode(data.toJson());

class EngineerLoginModel {
  EngineerLoginModel({
    required this.message,
    required this.status,
    required this.engineerid,
    required this.authtoken,
    required this.typeid,
    required this.employeetype,
    required this.branchid,
    required this.branchname,
    required this.branchaddress,
    required this.engineername,
    required this.engineermobile,
    required this.engineeremail,
    required this.engineerimage,
  });

  String message;
  bool status;
  String engineerid;

  String authtoken;
  String typeid;
  String employeetype;
  String branchid;
  String branchname;
  String branchaddress;
  String engineername;
  String engineermobile;
  String engineeremail;
  String engineerimage;

  factory EngineerLoginModel.fromJson(Map<String, dynamic> json) =>
      EngineerLoginModel(
        message: json["message"],
        status: json["status"],
        engineerid: json["engineerid"],
        authtoken: json["authtoken"],
        typeid: json["typeid"],
        employeetype: json["employeetype"],
        branchid: json["branchid"],
        branchname: json["branchname"],
        branchaddress: json["branchaddress"],
        engineername: json["engineername"],
        engineermobile: json["engineermobile"],
        engineeremail: json["engineeremail"],
        engineerimage: json["engineerimage"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "engineerid": engineerid,
        "authtoken": authtoken,
        "typeid": typeid,
        "employeetype": employeetype,
        "branchid": branchid,
        "branchname": branchname,
        "branchaddress": branchaddress,
        "engineername": engineername,
        "engineermobile": engineermobile,
        "engineeremail": engineeremail,
        "engineerimage": engineerimage,
      };
}
