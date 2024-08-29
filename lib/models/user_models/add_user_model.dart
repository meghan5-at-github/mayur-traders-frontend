// To parse this JSON data, do
//
//     final addUserRequesModel = addUserRequesModelFromJson(jsonString);

import 'dart:convert';

AddUserRequesModel addUserRequesModelFromJson(String str) => AddUserRequesModel.fromJson(json.decode(str));

String addUserRequesModelToJson(AddUserRequesModel data) => json.encode(data.toJson());

class AddUserRequesModel {
  String name;
  String emailId;
  String password;
  String phoneNumber;
  String role;
  String address;
  String vehicleNumber;
  String joiningDate;
  bool isDeleted;

  AddUserRequesModel({
    required this.name,
    required this.emailId,
    required this.password,
    required this.phoneNumber,
    required this.role,
    required this.address,
    required this.vehicleNumber,
    required this.joiningDate,
    required this.isDeleted,
  });

  factory AddUserRequesModel.fromJson(Map<String, dynamic> json) => AddUserRequesModel(
    name: json["name"],
    emailId: json["email_id"],
    password: json["password"],
    phoneNumber: json["phone_number"],
    role: json["role"],
    address: json["address"],
    vehicleNumber: json["vehicle_number"],
    joiningDate: json["joining_date"],
    isDeleted: json["is_deleted"]
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email_id": emailId,
    "password": password,
    "phone_number": phoneNumber,
    "role": role,
    "address": address,
    "vehicle_number": vehicleNumber,
    "joining_date": joiningDate,
    "is_deleted": isDeleted,
  };
}



// To parse this JSON data, do
//
//     final addUserResponseModel = addUserResponseModelFromJson(jsonString);



AddUserResponseModel addUserResponseModelFromJson(String str) => AddUserResponseModel.fromJson(json.decode(str));

String addUserResponseModelToJson(AddUserResponseModel data) => json.encode(data.toJson());

class AddUserResponseModel {
  int status;
  String message;

  AddUserResponseModel({
    required this.status,
    required this.message,
  });

  factory AddUserResponseModel.fromJson(Map<String, dynamic> json) => AddUserResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}


