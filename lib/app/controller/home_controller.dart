import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class HomeController extends GetxController {
  var user = ParseUser(null, null, null).obs;

  @override
  void onInit() async {
    user.value = await ParseUser.currentUser();
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
}
