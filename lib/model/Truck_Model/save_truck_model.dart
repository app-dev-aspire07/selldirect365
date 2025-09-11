// To parse this JSON data, do
//
//     final saveTruckModel = saveTruckModelFromJson(jsonString);

import 'dart:convert';

SaveTruckModel saveTruckModelFromJson(String str) => SaveTruckModel.fromJson(json.decode(str));

String saveTruckModelToJson(SaveTruckModel data) => json.encode(data.toJson());

class SaveTruckModel {
    bool? status;
    String? message;
    String? id;

    SaveTruckModel({
        this.status,
        this.message,
        this.id,
    });

    factory SaveTruckModel.fromJson(Map<String, dynamic> json) => SaveTruckModel(
        status: json["status"],
        message: json["message"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "id": id,
    };
}
