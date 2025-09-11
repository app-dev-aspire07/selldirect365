// To parse this JSON data, do
//
//     final getFormFieldModel = getFormFieldModelFromJson(jsonString);

import 'dart:convert';

GetFormFieldModel getFormFieldModelFromJson(String str) => GetFormFieldModel.fromJson(json.decode(str));

String getFormFieldModelToJson(GetFormFieldModel data) => json.encode(data.toJson());

class GetFormFieldModel {
    bool? status;
    int? mainCategoryId;
    List<Datum>? data;

    GetFormFieldModel({
        this.status,
        this.mainCategoryId,
        this.data,
    });

    factory GetFormFieldModel.fromJson(Map<String, dynamic> json) => GetFormFieldModel(
        status: json["status"],
        mainCategoryId: json["main_category_id"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "main_category_id": mainCategoryId,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? fieldId;
    String? fieldName;
    String? fieldLabel;
    int? isOptional;
    int? isManual;
    List<Option>? options;

    Datum({
        this.fieldId,
        this.fieldName,
        this.fieldLabel,
        this.isOptional,
        this.isManual,
        this.options,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        fieldId: json["field_id"],
        fieldName: json["field_name"],
        fieldLabel: json["field_label"],
        isOptional: json["is_optional"],
        isManual: json["is_manual"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "field_id": fieldId,
        "field_name": fieldName,
        "field_label": fieldLabel,
        "is_optional": isOptional,
        "is_manual": isManual,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
    };
}

class Option {
    int? id;
    String? optionValue;
    String? icon;

    Option({
        this.id,
        this.optionValue,
        this.icon,
    });

    factory Option.fromJson(Map<String, dynamic> json) => Option(
        id: json["id"],
        optionValue: json["option_value"],
        icon: json["icon"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "option_value": optionValue,
        "icon": icon,
    };
}

