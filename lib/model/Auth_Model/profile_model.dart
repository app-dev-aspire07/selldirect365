// To parse this JSON data, do
//
//     final userProfileModel = userProfileModelFromJson(jsonString);

import 'dart:convert';

UserProfileModel userProfileModelFromJson(String str) => UserProfileModel.fromJson(json.decode(str));

String userProfileModelToJson(UserProfileModel data) => json.encode(data.toJson());

class UserProfileModel {
    bool? status;
    Data? data;

    UserProfileModel({
        this.status,
        this.data,
    });

    factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    int? id;
    String? name;
    String? email;
    String? mobileNumber;
    dynamic userImage;
    String? role;
    DateTime? createdAt;

    Data({
        this.id,
        this.name,
        this.email,
        this.mobileNumber,
        this.userImage,
        this.role,
        this.createdAt,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobile_number"],
        userImage: json["user_image"],
        role: json["role"],
        createdAt: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "user_image": userImage,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
    };
}
