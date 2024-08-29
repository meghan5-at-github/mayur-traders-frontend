// To parse this JSON data, do
//
//     final getUsersListResponseModel = getUsersListResponseModelFromJson(jsonString);

import 'dart:convert';

GetUsersListResponseModel getUsersListResponseModelFromJson(String str) =>
    GetUsersListResponseModel.fromJson(json.decode(str));

String getUsersListResponseModelToJson(GetUsersListResponseModel data) =>
    json.encode(data.toJson());

class GetUsersListResponseModel {
  int status;
  String message;
  List<UsersList>? data;

  GetUsersListResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  factory GetUsersListResponseModel.fromJson(Map<String, dynamic> json) {
    if (json["data"] != null) {
      return GetUsersListResponseModel(
        status: json["status"],
        message: json["message"],
        data: List<UsersList>.from(
            json["data"].map((x) => UsersList.fromJson(x))),
      );
    } else {
      return GetUsersListResponseModel(
          status: json["status"], message: json["message"]);
    }
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class UsersList {
  int id;
  String userId;
  String name;
  String emailId;
  String phoneNumber;
  String role;
  String vehicleNumber;
  String joiningDate;
  int isDeleted;
  DateTime createdAt;
  DateTime updatedAt;
  String password;
  String address;

  UsersList({
    required this.id,
    required this.userId,
    required this.name,
    required this.emailId,
    required this.phoneNumber,
    required this.role,
    required this.vehicleNumber,
    required this.joiningDate,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.password,
    required this.address,
  });

  factory UsersList.fromJson(Map<String, dynamic> json) => UsersList(
        id: json["id"],
        userId: json["userId"] ?? "",
        name: json["name"] ?? "",
        emailId: json["email_id"] ?? "",
        phoneNumber: json["phone_number"] ?? "",
        role: json["role"] ?? "",
        vehicleNumber: json["vehicle_number"] ?? "",
        joiningDate: json["joining_date"] ?? "",
        isDeleted: json["is_deleted"] ?? 0,
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        password: json["password"] ?? "",
        address: json["address"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "name": name,
        "email_id": emailId,
        "phone_number": phoneNumber,
        "role": role,
        "vehicle_number": vehicleNumber,
        "joining_date":
            joiningDate, //"${joiningDate.year.toString().padLeft(4, '0')}-${joiningDate.month.toString().padLeft(2, '0')}-${joiningDate.day.toString().padLeft(2, '0')}",
        "is_deleted": isDeleted,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "password": password,
        "address": address,
      };
}
