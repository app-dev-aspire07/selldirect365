// To parse this JSON data, do
//
//     final getTrucksModel = getTrucksModelFromJson(jsonString);

import 'dart:convert';

GetTrucksModel getTrucksModelFromJson(String str) => GetTrucksModel.fromJson(json.decode(str));

String getTrucksModelToJson(GetTrucksModel data) => json.encode(data.toJson());

class GetTrucksModel {
    bool? status;
    List<Datum>? data;

    GetTrucksModel({
        this.status,
        this.data,
    });

    factory GetTrucksModel.fromJson(Map<String, dynamic> json) => GetTrucksModel(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class Datum {
    int? truckFormId;
    List<String>? images;
    String? address;
    String? desc;
    String? brand;
    String ?model;
    String? color;
    String? year;
    String ?price;

    Datum({
        this.truckFormId,
        this.images,
        this.address,
        this.desc,
        this.brand,
        this.model,
        this.color,
        this.year,
        this.price,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        truckFormId: json["truck_form_id"],
        images: List<String>.from(json["images"].map((x) => x)),
        address: json["address"],
        desc: json["desc"],
        brand: json["Brand"],
        model: json["Model"],
        color: json["Color"],
        year: json["Year"],
        price: json["Price"],
    );

    Map<String, dynamic> toJson() => {
       "truck_form_id": truckFormId,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "address": address,
        "desc": desc,
        "Brand": brand,
        "Model": model,
        "Color": color,
        "Year": year,
        "Price": price,
    };
}
