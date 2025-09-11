// To parse this JSON data, do
//
//     final getBrandsModel = getBrandsModelFromJson(jsonString);

import 'dart:convert';

GetBrandsModel getBrandsModelFromJson(String str) => GetBrandsModel.fromJson(json.decode(str));

String getBrandsModelToJson(GetBrandsModel data) => json.encode(data.toJson());

class GetBrandsModel {
    bool? status;
    int? fieldId;
    List<Datum>? data;

    GetBrandsModel({
        this.status,
        this.fieldId,
        this.data,
    });

    factory GetBrandsModel.fromJson(Map<String, dynamic> json) => GetBrandsModel(
        status: json["status"],
        fieldId: json["field_id"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "field_id": fieldId,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? id;
    String? optionValue;
    String? icon;
    int? subCategoryId;
    List<int>? mainCategoryIds;
    int? fieldId;

    Datum({
        this.id,
        this.optionValue,
        this.icon,
        this.subCategoryId,
        this.mainCategoryIds,
        this.fieldId,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        optionValue: json["option_value"],
        icon: json["icon"],
        subCategoryId: json["sub_category_id"],
        mainCategoryIds: List<int>.from(json["main_category_ids"].map((x) => x)),
        fieldId: json["field_id"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "option_value": optionValue,
        "icon": icon,
        "sub_category_id": subCategoryId,
        "main_category_ids": List<dynamic>.from(mainCategoryIds!.map((x) => x)),
        "field_id": fieldId,
    };
}
