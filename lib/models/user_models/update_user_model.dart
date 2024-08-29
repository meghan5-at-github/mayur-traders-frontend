// To parse this JSON data, do
//
//     final updateUserRequestModel = updateUserRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateUserRequestModel updateUserRequestModelFromJson(String str) => UpdateUserRequestModel.fromJson(json.decode(str));

String updateUserRequestModelToJson(UpdateUserRequestModel data) => json.encode(data.toJson());

class UpdateUserRequestModel {
  String name;
  String emailId;
  String phoneNumber;
  String role;
  String address;
  String vehicleNumber;
  String joiningDate;

  UpdateUserRequestModel({
    required this.name,
    required this.emailId,
    required this.phoneNumber,
    required this.role,
    required this.address,
    required this.vehicleNumber,
    required this.joiningDate,
  });

  factory UpdateUserRequestModel.fromJson(Map<String, dynamic> json) => UpdateUserRequestModel(
    name: json["name"],
    emailId: json["email_id"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    address: json["address"],
    vehicleNumber: json["vehicle_number"],
    joiningDate: json["joining_date"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email_id": emailId,
    "phone_number": phoneNumber,
    "role": role,
    "address": address,
    "vehicle_number": vehicleNumber,
    "joining_date": joiningDate
  };
}
