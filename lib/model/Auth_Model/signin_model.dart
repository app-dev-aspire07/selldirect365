// To parse this JSON data, do
//
//     final signinModel = signinModelFromJson(jsonString);

import 'dart:convert';

SigninModel signinModelFromJson(String str) => SigninModel.fromJson(json.decode(str));

String signinModelToJson(SigninModel data) => json.encode(data.toJson());

class SigninModel {
    bool? status;
    String? message;
    String? role;
    String? token;

    SigninModel({
        this.status,
        this.message,
        this.role,
        this.token,
    });

    factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
        status: json["status"],
        message: json["message"],
        role: json["role"],
        token: json["token"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "role": role,
        "token": token,
    };
}
