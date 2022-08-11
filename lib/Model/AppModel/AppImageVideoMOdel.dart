// // To parse this JSON data, do
// //
// //     final appImageVideoMOdel = appImageVideoMOdelFromJson(jsonString);

// import 'dart:convert';

// AppImageVideoMOdel appImageVideoMOdelFromJson(String str) => AppImageVideoMOdel.fromJson(json.decode(str));

// String appImageVideoMOdelToJson(AppImageVideoMOdel data) => json.encode(data.toJson());

// class AppImageVideoMOdel {
//     AppImageVideoMOdel({
//       required  this.status,
//       required  this.data,
//       required  this.message,
//     });

//     bool status;
//     Data data;
//     String message;

//     factory AppImageVideoMOdel.fromJson(Map<String, dynamic> json) => AppImageVideoMOdel(
//         status: json["status"],
//         data: Data.fromJson(json["data"]),
//         message: json["message"],
//     );

//     Map<String, dynamic> toJson() => {
//         "status": status,
//         "data": data.toJson(),
//         "message": message,
//     };
// }

// class Data {
//     Data({
//       required  this.firsttext,
//       required  this.firstimage,
//       required  this.secondtext,
//       required  this.secondimage,
//       required  this.video,
//     });

//     String firsttext;
//     String firstimage;
//     String secondtext;
//     String secondimage;
//     String video;

//     factory Data.fromJson(Map<String, dynamic> json) => Data(
//         firsttext: json["firsttext"],
//         firstimage: json["firstimage"],
//         secondtext: json["secondtext"],
//         secondimage: json["secondimage"],
//         video: json["video"],
//     );

//     Map<String, dynamic> toJson() => {
//         "firsttext": firsttext,
//         "firstimage": firstimage,
//         "secondtext": secondtext,
//         "secondimage": secondimage,
//         "video": video,
//     };
// }