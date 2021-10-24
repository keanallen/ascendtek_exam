import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({
    Key? key,
    required this.home,
  }) : super(key: key);

  final HomeController home;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Obx(
        () => ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: Center(
                    child: FittedBox(
                      child: Text(
                        home.getNameAvatar(),
                        style: Get.textTheme.headline4!
                            .copyWith(color: Colors.blue[200]),
                      ),
                    ),
                  ),
                ),
                accountName: Text(home.user.value.objectId != null
                    ? home.user.value.get('name')
                    : "Wew"),
                accountEmail: Text(home.user.value.objectId != null
                    ? home.user.value.emailAddress!
                    : "Wew"),
              ),
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Logout'),
                  Icon(
                    Icons.logout,
                    color: Colors.grey,
                  ),
                ],
              ),
              onTap: () => home.logout(),
            )
          ],
        ),
      ),
    );
  }
}
