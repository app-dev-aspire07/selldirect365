// To parse this JSON data, do
//
//     final getTruckByIdModel = getTruckByIdModelFromJson(jsonString);

import 'dart:convert';

GetTruckByIdModel getTruckByIdModelFromJson(String str) =>
    GetTruckByIdModel.fromJson(json.decode(str));

String getTruckByIdModelToJson(GetTruckByIdModel data) =>
    json.encode(data.toJson());

class GetTruckByIdModel {
  bool? status;
  Data? data;

  GetTruckByIdModel({this.status, this.data});

  factory GetTruckByIdModel.fromJson(Map<String, dynamic> json) =>
      GetTruckByIdModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"status": status, "data": data?.toJson()};
}

class Data {
  int? truckFormId;
  List<String>? images;
  String? address;
  int? isQuote;
  int? isFavorite;
  String? desc;
  List<Field>? fields;

  Data({
    this.truckFormId,
    this.images,
    this.address,
    this.isQuote,
    this.isFavorite,
    this.desc,
    this.fields,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    truckFormId: json["truck_form_id"],
    images: List<String>.from(json["images"].map((x) => x)),
    address: json["address"],
    isQuote: json["is_quote"],
    isFavorite: json["is_favorite"],
    desc: json["desc"],
    fields: List<Field>.from(json["fields"].map((x) => Field.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "truck_form_id": truckFormId,
    "images": List<dynamic>.from(images!.map((x) => x)),
    "address": address,
    "is_quote": isQuote,
    "is_favorite": isFavorite,
    "desc": desc,
    "fields": List<dynamic>.from(fields!.map((x) => x.toJson())),
  };
}

class Field {
  int? fieldId;
  String? fieldName;
  int? optionId;
  String? optionValue;

  Field({this.fieldId, this.fieldName, this.optionId, this.optionValue});

  factory Field.fromJson(Map<String, dynamic> json) => Field(
    fieldId: json["field_id"],
    fieldName: json["field_name"],
    optionId: json["option_id"],
    optionValue: json["option_value"],
  );

  Map<String, dynamic> toJson() => {
    "field_id": fieldId,
    "field_name": fieldName,
    "option_id": optionId,
    "option_value": optionValue,
  };
}
