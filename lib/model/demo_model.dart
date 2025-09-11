// To parse this JSON data, do
//
//     final demoModel = demoModelFromJson(jsonString);

import 'dart:convert';

DemoModel demoModelFromJson(String str) => DemoModel.fromJson(json.decode(str));

String demoModelToJson(DemoModel data) => json.encode(data.toJson());

class DemoModel {
    String? id;
    String? name;
    String? email;
    String? role;
    DateTime? createdAt;
    DateTime? updatedAt;
    int? v;

    DemoModel({
        this.id,
        this.name,
        this.email,
        this.role,
        this.createdAt,
        this.updatedAt,
        this.v,
    });

    factory DemoModel.fromJson(Map<String, dynamic> json) => DemoModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "role": role,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
    };
}
