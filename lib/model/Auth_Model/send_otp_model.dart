// To parse this JSON data, do
//
//     final otpSentModel = otpSentModelFromJson(jsonString);

import 'dart:convert';

OtpSentModel otpSentModelFromJson(String str) => OtpSentModel.fromJson(json.decode(str));

String otpSentModelToJson(OtpSentModel data) => json.encode(data.toJson());

class OtpSentModel {
    bool? status;
    bool? otpSent;

    OtpSentModel({
        this.status,
        this.otpSent,
    });

    factory OtpSentModel.fromJson(Map<String, dynamic> json) => OtpSentModel(
        status: json["status"],
        otpSent: json["otp_sent"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "otp_sent": otpSent,
    };
}
