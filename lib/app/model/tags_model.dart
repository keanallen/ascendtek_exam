// To parse this JSON data, do
//
//     final tagModel = tagModelFromJson(jsonString);

import 'dart:convert';

List<TagModel> tagModelFromJson(String str) =>
    List<TagModel>.from(json.decode(str).map((x) => TagModel.fromJson(x)));

String tagModelToJson(List<TagModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TagModel {
  TagModel({
    required this.className,
    required this.objectId,
    required this.tagname,
  });

  String className;
  String objectId;

  String tagname;

  factory TagModel.fromJson(Map<String, dynamic> json) => TagModel(
        className: json["className"],
        objectId: json["objectId"],
        tagname: json["tagname"],
      );

  Map<String, dynamic> toJson() => {
        "className": className,
        "objectId": objectId,
        "tagname": tagname,
      };
}
