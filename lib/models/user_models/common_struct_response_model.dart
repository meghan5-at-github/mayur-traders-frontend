// To parse this JSON data, do
//
//     final commonResponseModel = commonResponseModelFromJson(jsonString);

import 'dart:convert';

CommonResponseModel commonResponseModelFromJson(String str) => CommonResponseModel.fromJson(json.decode(str));

String commonResponseModelToJson(CommonResponseModel data) => json.encode(data.toJson());

class CommonResponseModel {
  int status;
  String message;

  CommonResponseModel({
    required this.status,
    required this.message,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
