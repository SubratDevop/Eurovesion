// To parse this JSON data, do
//
//     final engineerProfileEditModel = engineerProfileEditModelFromJson(jsonString);

import 'dart:convert';

EngineerProfileEditModel engineerProfileEditModelFromJson(String str) => EngineerProfileEditModel.fromJson(json.decode(str));

String engineerProfileEditModelToJson(EngineerProfileEditModel data) => json.encode(data.toJson());

class EngineerProfileEditModel {
    EngineerProfileEditModel({
      required this.engineerid,
      required  this.branchid,
      required  this.branchname,
      required  this.branchaddress,
      required  this.engineername,
      required  this.engineermobile,
      required  this.engineeremail,
      required  this.engineerimage,
      required  this.message,
      required  this.data,
      required  this.status,
    });

    String engineerid;
    String branchid;
    String branchname;
    String branchaddress;
    String engineername;
    String engineermobile;
    String engineeremail;
    String engineerimage;
    String message;
    String data;
    bool status;

    factory EngineerProfileEditModel.fromJson(Map<String, dynamic> json) => EngineerProfileEditModel(
        engineerid: json["engineerid"],
        branchid: json["branchid"],
        branchname: json["branchname"],
        branchaddress: json["branchaddress"],
        engineername: json["engineername"],
        engineermobile: json["engineermobile"],
        engineeremail: json["engineeremail"],
        engineerimage: json["engineerimage"],
        message: json["message"],
        data: json["data"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "engineerid": engineerid,
        "branchid": branchid,
        "branchname": branchname,
        "branchaddress": branchaddress,
        "engineername": engineername,
        "engineermobile": engineermobile,
        "engineeremail": engineeremail,
        "engineerimage": engineerimage,
        "message": message,
        "data": data,
        "status": status,
    };
}
