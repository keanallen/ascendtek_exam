import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:ascendtek_exam/app/views/home/upload_page.dart';
import 'package:ascendtek_exam/app/widgets/custom_drawer.dart';
import 'package:ascendtek_exam/app/widgets/post_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var home = Get.put<HomeController>(HomeController());

    QueryBuilder _queryBuilder;

    if (home.queryTags.isNotEmpty) {
      _queryBuilder = QueryBuilder(ParseObject("Uploads"));

      _queryBuilder.whereContainedIn('tags',
          [...home.queryTags.map((element) => element.tagname).toList()]);
      _queryBuilder.includeObject(["uploader"]);
      _queryBuilder.orderByDescending('createdAt');
    } else {
      _queryBuilder = QueryBuilder(ParseObject("Uploads"));
      _queryBuilder.includeObject(["uploader"]);
      _queryBuilder.orderByDescending('createdAt');
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton(
                isDense: false,
                items: home.tags
                    .map((element) => DropdownMenuItem(
                          child: Text(element.tagname),
                          value: element.tagname,
                        ))
                    .toList(),
                icon: const Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
                onChanged: (value) {
                  home.addQueryTag(value.toString());
                  setState(() {});
                },
              ),
            ),
          )
        ],
        bottom: PreferredSize(
            child: Obx(() => Container(
                  width: context.width,
                  height: home.queryTags.isNotEmpty ? 50 : 0,
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tags:",
                        style: Get.textTheme.caption,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: home.queryTags
                              .map((element) => Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue[100],
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  padding: const EdgeInsets.all(4),
                                  margin: const EdgeInsets.all(2),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          home.queryTags.removeWhere(
                                              (element2) =>
                                                  element2.tagname
                                                      .toLowerCase() ==
                                                  element.tagname
                                                      .toLowerCase());

                                          setState(() {});
                                        },
                                        child: const Icon(
                                          Icons.clear,
                                          size: 10,
                                        ),
                                      ),
                                      Text(element.tagname.toString()),
                                    ],
                                  )))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                )),
            preferredSize: home.queryTags.isNotEmpty
                ? const Size.fromHeight(50)
                : const Size.fromHeight(0)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const UploadPage()),
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      drawer: CustomDrawer(home: home),
      body: Container(
        width: context.width,
        height: context.height,
        padding: EdgeInsets.only(top: home.queryTags.isEmpty ? 0 : 40),
        child: ParseLiveListWidget<ParseObject>(
          key: UniqueKey(),
          query: _queryBuilder,
          childBuilder: (context, snapshot) {
            if (snapshot.failed) {
              return const Text("Something went wrong");
            } else if (snapshot.hasData) {
              var name = snapshot.loadedData!.get('uploader').get("name");
              var postId = snapshot.loadedData!.get('objectId');
              return VisibilityDetector(
                key: Key(postId),
                onVisibilityChanged: (info) {
                  var visiblePercentage = info.visibleFraction * 100;

                  home.viewPost(
                      postId, home.user.value.objectId!, visiblePercentage);
                },
                child: PostImage(
                  postId: postId,
                  home: home,
                  uploaderId:
                      snapshot.loadedData!.get('uploader').get('objectId'),
                  uploader: name,
                  avatar: home.getNameAvatar(baseName: name),
                  imageUrl: snapshot.loadedData!.get('image'),
                  tags: snapshot.loadedData!.get('tags'),
                  likes: snapshot.loadedData!.get('liked') ?? [],
                  viewers: snapshot.loadedData!.get('viewers'),
                ),
              );
            } else {
              return const ListTile(
                leading: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
