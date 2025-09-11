// To parse this JSON data, do
//
//     final getSubCategoriesModel = getSubCategoriesModelFromJson(jsonString);

import 'dart:convert';

GetSubCategoriesModel getSubCategoriesModelFromJson(String str) => GetSubCategoriesModel.fromJson(json.decode(str));

String getSubCategoriesModelToJson(GetSubCategoriesModel data) => json.encode(data.toJson());

class GetSubCategoriesModel {
    bool? status;
    List<Datum>? data;

    GetSubCategoriesModel({
        this.status,
        this.data,
    });

    factory GetSubCategoriesModel.fromJson(Map<String, dynamic> json) => GetSubCategoriesModel(
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
