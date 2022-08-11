// // To parse this JSON data, do

// To parse this JSON data, do
//
//     final engineerAssignmentModel = engineerAssignmentModelFromJson(jsonString);

import 'dart:convert';

EngineerAssignmentModel engineerAssignmentModelFromJson(String str) => EngineerAssignmentModel.fromJson(json.decode(str));

String engineerAssignmentModelToJson(EngineerAssignmentModel data) => json.encode(data.toJson());

class EngineerAssignmentModel {
    EngineerAssignmentModel({
      required  this.status,
      required  this.totalAssignCount,
      required  this.data,
    });

    bool status;
    int totalAssignCount;
    List<Datum> data;

    factory EngineerAssignmentModel.fromJson(Map<String, dynamic> json) => EngineerAssignmentModel(
        status: json["status"],
        totalAssignCount: json["total_assign_count"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "total_assign_count": totalAssignCount,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
      required  this.id,
      required  this.engineerid,
      required  this.complainid,
      required  this.complaindate,
      required  this.assignedfordate,
      required  this.isactive,
      required  this.complaintnumber,
      required  this.complainttext,
      required  this.csrStatus,
    });

    String id;
    String engineerid;
    String complainid;
    String complaindate;
    String assignedfordate;
    String isactive;
    String complaintnumber;
    String complainttext;
    bool csrStatus;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        engineerid: json["engineerid"],
        complainid: json["complainid"],
        complaindate: json["complaindate"],
        assignedfordate: json["assignedfordate"],
        isactive: json["isactive"],
        complaintnumber: json["complaintnumber"],
        complainttext: json["complainttext"],
        csrStatus: json["csr_status"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "engineerid": engineerid,
        "complainid": complainid,
        "complaindate": complaindate,
        "assignedfordate": assignedfordate,
        "isactive": isactive,
        "complaintnumber": complaintnumber,
        "complainttext": complainttext,
        "csr_status": csrStatus,
    };
}






// //
// //     final engineerAssignmentModel = engineerAssignmentModelFromJson(jsonString);

// import 'dart:convert';

// EngineerAssignmentModel engineerAssignmentModelFromJson(String str) => EngineerAssignmentModel.fromJson(json.decode(str));

// String engineerAssignmentModelToJson(EngineerAssignmentModel data) => json.encode(data.toJson());

// class EngineerAssignmentModel {
//     EngineerAssignmentModel({
//       required  this.status,
//       required  this.data,
//     });

//     bool status;
//     List<Datum> data;

//     factory EngineerAssignmentModel.fromJson(Map<String, dynamic> json) => EngineerAssignmentModel(
//         status: json["status"],
//         data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     };
// }

// class Datum {
//     Datum({
//       required  this.id,
//       required  this.engineerid,
//       required  this.complainid,
//       required  this.complaintnumber,
//       required  this.complainttext,
//       required  this.complaindate,
//       required  this.assignedfordate,
//       required  this.isactive,
//       required  this.totalAssignCount,
//       required  this.csrStatus,
//     });

//     String id;
//     String engineerid;
//     String complainid;
//     String complaintnumber;
//     String complainttext;
//     String complaindate;
//     String assignedfordate;
//     String isactive;
//     int totalAssignCount;
//     bool csrStatus;

//     factory Datum.fromJson(Map<String, dynamic> json) => Datum(
//         id: json["id"],
//         engineerid: json["engineerid"],
//         complainid: json["complainid"],
//         complaintnumber: json["complaintnumber"],
//         complainttext: json["complainttext"],
//         complaindate: json["complaindate"],
//         csrStatus: json["csr_status"],
//         assignedfordate: json["assignedfordate"],
//         isactive: json["isactive"],
//         totalAssignCount: json["total_assign_count"],
        
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "engineerid": engineerid,
//         "complainid": complainid,
//         "complaintnumber": complaintnumber,
//         "complainttext": complainttext,
//         "complaindate": complaindate,
//         "assignedfordate": assignedfordate,
//         "isactive": isactive,
//         "total_assign_count": totalAssignCount,
//         "csr_status": csrStatus,
//     };
// }
