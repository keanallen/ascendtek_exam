// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:ascendtek_exam/app/model/tags_model.dart';
import 'package:ascendtek_exam/app/views/auth/login_page.dart';
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
  var tempLiked = [].obs;
  var viewedPost = [].obs;
  XFile? image;

  @override
  void onInit() async {
    super.onInit();
    var getUser = await ParseUser.currentUser();

    print("=================================================");
    print(getUser);
    print("=================================================");
    if (getUser == null) {
      Get.offAll(() => const LoginPage());
    } else {
      user.value = getUser;
      getTags();
    }
  }

  getNameAvatar({String baseName = ''}) {
    String avatar = "";
    var name = baseName.isEmpty ? user.value.get('name') : baseName;
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
      upload.set('liked', []);
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

  Future getUploads() async {
    ParseObject uploads = ParseObject("Uploads");
    QueryBuilder query = QueryBuilder(uploads);
    var response = await query.query();
    if (response.success && response.results != null) {
      var body = jsonDecode(response.results.toString());
      print(body);
    }
  }

  void likePost(String postId) async {
    tempLiked.add(postId);
    var me = await ParseUser.currentUser();
    ParseObject post = ParseObject("Uploads");
    post.objectId = postId;

    //post.addRelation('likes', [me]);
    post.setAddUnique('liked', me!.objectId);
    var response = await post.save();
    if (response.success) {
      print('Liked!');
      print(response.success);
    }
  }

  void unlikePost(String postId) async {
    tempLiked.removeWhere((element) => element == postId);

    var me = await ParseUser.currentUser();
    ParseObject post = ParseObject("Uploads");
    post.objectId = postId;

    //post.addRelation('likes', [me]);
    post.setRemove('liked', me!.objectId);
    ;
    var response = await post.save();
    if (response.success) {
      print('UNLiked!');
      print(response.success);
    }
  }

  void viewPost(String postId, String userId, num visibility) async {
    ParseObject uploads = ParseObject("Uploads");
    uploads.objectId = postId;
    print("$postId is $visibility% visible");
    if (visibility >= 80 && !viewedPost.contains(postId)) {
      uploads.setAddUnique('viewers', userId);
      var response = await uploads.save();
      if (response.success) {
        viewedPost.add(postId);
      }
    }
  }

  void logout() async {
    CustomDialog.spiner(label: 'Signing out...');
    await user.value.logout();
    Get.offAll(() => const LoginPage());
  }
}
