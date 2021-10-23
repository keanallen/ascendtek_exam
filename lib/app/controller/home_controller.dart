// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ascendtek_exam/app/model/tags_model.dart';
import 'package:ascendtek_exam/app/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomeController extends GetxController {
  var user = ParseUser(null, null, null).obs;
  var searchTag = TextEditingController();
  var tags = <TagModel>[].obs;
  var selectedTags = <TagModel>[].obs;
  var filteredTags = <TagModel>[].obs;
  var imagePath = "".obs;
  XFile? image;

  @override
  void onInit() async {
    user.value = await ParseUser.currentUser();
    getTags();
    super.onInit();
  }

  getNameAvatar() {
    String avatar = "";
    var name = user.value.get('name');
    if (name.toString().contains(" ")) {
      var part1 = name.toString().split(" ")[0][0];
      var part2 = name.toString().split(" ")[1][0];
      avatar = "$part1$part2";
    } else {
      avatar = name.toString()[0];
    }

    return avatar;
  }

  Future getTags() async {
    ParseObject tag = ParseObject("Tags");
    QueryBuilder query = QueryBuilder(tag);
    var response = await query.query();
    if (response.success) {
      tags.value = tagModelFromJson(response.results.toString());
    }
  }

  void filterTag(String tag) {
    filteredTags.clear();
    var matchTag = tags.where(
        (element) => element.tagname.toLowerCase().contains(tag.toLowerCase()));
    if (tag.isNotEmpty) {
      filteredTags.addAll(matchTag);
    }
  }

  void addTag(String tag) async {
    var matchTag = tags.where(
        (element) => element.tagname.toLowerCase().contains(tag.toLowerCase()));
    if (matchTag.isEmpty) {
      CustomDialog.spiner(label: 'Saving Tag...');
      ParseObject _tags = ParseObject("Tags");
      _tags.set('tagname', tag.capitalize);
      var response = await _tags.save();
      Get.close(1);
      if (response.success) {
        var body = jsonDecode(response.results!.first.toString());
        TagModel newTag = TagModel.fromJson(body);
        tags.add(newTag);
        selectedTags.add(newTag);
        searchTag.clear();
      }
    }
  }

  void uploadImage() async {
    try {
      ImageSource source = await CustomDialog.selectImageSource();
      image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 90,
      );
      imagePath.value = image!.path;
    } catch (e) {
      print("=== EXCEPTION MESSAGE ===");
      print(e);
      print("=== END EXCEPTION MESSAGE ===");
    }
  }

  Future shareImage() async {
    CustomDialog.spiner(label: 'Sharing...');
    ParseFile file = ParseFile(File(imagePath.value));
    var response = await file.upload();
    if (response.success) {
      var img = response.results!.first as ParseFile;
      String imgUrl = img.url!;

      var me = await ParseUser.currentUser();
      ParseObject upload = ParseObject("Uploads");
      upload.set('uploader', me);
      upload.set('image', imgUrl);
      upload.set(
          'tags', selectedTags.map((element) => element.tagname).toList());
      var res = await upload.save();
      Get.close(1);
      if (res.success) {
        selectedTags.clear();
        imagePath.value = "";
        CustomDialog.alert(
            title: 'Success',
            content: 'You\'ve successfully uploaded an image!');
      }
    }
  }
}
