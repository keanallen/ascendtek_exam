import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:ascendtek_exam/app/views/home/upload_page.dart';
import 'package:ascendtek_exam/app/widgets/added_chip.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var home = Get.put<HomeController>(HomeController());

    ParseObject uploads = ParseObject("Uploads");
    QueryBuilder query = QueryBuilder(uploads);
    query.includeObject(["uploader"]);
    query.orderByDescending('createdAt');

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text('Home'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const UploadPage()),
        child: const Icon(Icons.add_a_photo_outlined),
      ),
      drawer: Drawer(
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
                    Text('Tags'),
                    Icon(
                      Icons.tag,
                      color: Colors.grey,
                    ),
                  ],
                ),
                onTap: () {},
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
      ),
      body: ParseLiveListWidget<ParseObject>(
        shrinkWrap: true,
        query: query,
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
    );
  }
}

class PostImage extends StatelessWidget {
  const PostImage({
    Key? key,
    this.uploader,
    this.avatar,
    required this.imageUrl,
    this.tags,
    required this.postId,
    required this.likes,
    this.viewers,
  }) : super(key: key);

  final String? avatar;
  final String? uploader;
  final String imageUrl;
  final String postId;
  final List? tags;
  final List likes;
  final List? viewers;

  @override
  Widget build(BuildContext context) {
    var home = Get.find<HomeController>();
    var myId = home.user.value.objectId;

    bool liked = likes.contains(myId);

    if (viewers != null) {
      viewers!.removeWhere((element) => element == myId);
    }

    return Container(
      width: context.width,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  child: Text(avatar!),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(uploader!, style: Get.textTheme.subtitle1),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          SizedBox(child: CachedNetworkImage(imageUrl: imageUrl)),

          /// LIKE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Material(
                color: Colors.white,
                child: SizedBox(
                  height: 60,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: 60,
                        child: Obx(() => IconButton(
                            onPressed: () => home.tempLiked.contains(postId) ||
                                    liked
                                ? Get.find<HomeController>().unlikePost(postId)
                                : Get.find<HomeController>().likePost(postId),
                            icon: Icon(
                              home.tempLiked.contains(postId) || liked
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: home.tempLiked.contains(postId) || liked
                                  ? Colors.red
                                  : Colors.black87,
                            ))),
                      ),
                      SizedBox(
                        child: Text(likes.length > 1
                            ? likes.length.toString() + " likes"
                            : likes.isEmpty
                                ? ""
                                : likes.length.toString() + " like"),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  viewers == null ? "" : "Seen by ${viewers!.length} people",
                  style: Get.textTheme.caption,
                ),
              )
            ],
          ),
          Container(
            width: context.width,
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    tags!.length > 1 ? "Tags:" : "Tag:",
                    style: Get.textTheme.caption,
                  ),
                ),
                Expanded(
                  child: Wrap(
                    children: List.generate(
                        tags!.length,
                        (index) => Container(
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.only(
                                  bottom: 3, left: 2, right: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                tags![index],
                                style: Get.textTheme.caption!
                                    .copyWith(color: Colors.blue),
                              ),
                            )),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
