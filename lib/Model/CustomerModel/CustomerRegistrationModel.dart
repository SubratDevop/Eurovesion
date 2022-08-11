// To parse this JSON data, do
//
//     final customerRegistrationModel = customerRegistrationModelFromJson(jsonString);

import 'dart:convert';

CustomerRegistrationModel customerRegistrationModelFromJson(String str) => CustomerRegistrationModel.fromJson(json.decode(str));

String customerRegistrationModelToJson(CustomerRegistrationModel data) => json.encode(data.toJson());

class CustomerRegistrationModel {
    CustomerRegistrationModel({
        required this.message,
        required this.customerCode,
        required this.data,
        required this.status,
    });

    String message;
    String customerCode;
    String data;
    bool status;

    factory CustomerRegistrationModel.fromJson(Map<String, dynamic> json) => CustomerRegistrationModel(
        message: json["message"],
        customerCode: json["customer_code"],
        data: json["data"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "customer_code": customerCode,
        "data": data,
        "status": status,
    };
}
