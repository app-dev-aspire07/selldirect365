// To parse this JSON data, do
//
//     final getCategoriesModel = getCategoriesModelFromJson(jsonString);

import 'dart:convert';

GetCategoriesModel getCategoriesModelFromJson(String str) => GetCategoriesModel.fromJson(json.decode(str));

String getCategoriesModelToJson(GetCategoriesModel data) => json.encode(data.toJson());

class GetCategoriesModel {
    bool? status;
    List<Datum>? data;

    GetCategoriesModel({
        this.status,
        this.data,
    });

    factory GetCategoriesModel.fromJson(Map<String, dynamic> json) => GetCategoriesModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? name;
    String? icon;

    Datum({
        this.id,
        this.name,
        this.icon,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "icon": icon,
    };
}
