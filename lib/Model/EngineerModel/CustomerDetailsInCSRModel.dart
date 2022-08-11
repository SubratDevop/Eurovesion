// To parse this JSON data, do
//
//     final customerDetailsInCsrModel = customerDetailsInCsrModelFromJson(jsonString);

import 'dart:convert';

CustomerDetailsInCsrModel customerDetailsInCsrModelFromJson(String str) => CustomerDetailsInCsrModel.fromJson(json.decode(str));

String customerDetailsInCsrModelToJson(CustomerDetailsInCsrModel data) => json.encode(data.toJson());

class CustomerDetailsInCsrModel {
    CustomerDetailsInCsrModel({
      required this.status,
      required this.message,
      required this.data,
    });

    bool status;
    String message;
    List<Datum> data;

    factory CustomerDetailsInCsrModel.fromJson(Map<String, dynamic> json) => CustomerDetailsInCsrModel(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    Datum({
      required this.customerid,
      required this.customertype,
      required this.complainid,
      required this.complaintnumber,
      required this.customername,
      required this.customercode,
      required this.customermobile,
      required this.customermail,
      required this.customeraddress,
      required this.branchcode,
      required this.csrno,
    });

    String customerid;
    String customertype;
    String complainid;
    String complaintnumber;
    String customername;
    String customercode;
    String customermobile;
    String customermail;
    String customeraddress;
    String branchcode;
    String csrno;

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        customerid: json["customerid"],
        customertype: json["customertype"],
        complainid: json["complainid"],
        complaintnumber: json["complaintnumber"],
        customername: json["customername"],
        customercode: json["customercode"],
        customermobile: json["customermobile"],
        customermail: json["customermail"],
        customeraddress: json["customeraddress"],
        branchcode: json["branchcode"],
        csrno: json["csrno"],
    );

    Map<String, dynamic> toJson() => {
        "customerid": customerid,
        "customertype": customertype,
        "complainid": complainid,
        "complaintnumber": complaintnumber,
        "customername": customername,
        "customercode": customercode,
        "customermobile": customermobile,
        "customermail": customermail,
        "customeraddress": customeraddress,
        "branchcode": branchcode,
        "csrno": csrno,
    };
}
