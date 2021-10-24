import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostImage extends StatefulWidget {
  const PostImage({
    Key? key,
    this.uploader,
    this.avatar,
    required this.imageUrl,
    this.tags,
    required this.postId,
    required this.likes,
    this.viewers,
    required this.uploaderId,
    required this.home,
  }) : super(key: key);

  final String? avatar;
  final String? uploader;
  final String uploaderId;
  final String imageUrl;
  final String postId;
  final List? tags;
  final List likes;
  final List? viewers;
  final HomeController home;

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  @override
  Widget build(BuildContext context) {
    var myId = widget.home.user.value.objectId;

    bool liked = widget.likes.contains(myId);

    if (widget.viewers != null) {
      widget.viewers!.removeWhere((element) => element == myId);
    }

    return Obx(
      () => !Get.find<HomeController>().deletedPost.contains(widget.postId)
          ? Container(
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
                          child: Text(widget.avatar!),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(widget.uploader!,
                                style: Get.textTheme.subtitle1),
                          ),
                        ),
                        SizedBox(
                            width: 50,
                            child: myId == widget.uploaderId
                                ? Material(
                                    child: IconButton(
                                        onPressed: () {
                                          Get.bottomSheet(
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              child: ListTile(
                                                title:
                                                    const Text("Delete Post"),
                                                leading: const Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red),
                                                onTap: () {
                                                  widget.home.deletePost(
                                                      widget.postId);
                                                },
                                              ),
                                            ),
                                            backgroundColor: Colors.white,
                                          );
                                        },
                                        icon: const Icon(Icons.more_vert)),
                                  )
                                : Container()),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  SizedBox(
                      child: CachedNetworkImage(imageUrl: widget.imageUrl)),

                  /// LIKE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        color: Colors.white,
                        child: SizedBox(
                          height: 60,
                          child: Obx(
                            () => Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  height: 60,
                                  child: IconButton(
                                      onPressed: () {
                                        if (widget.home.tempLiked
                                                .contains(widget.postId) ||
                                            liked) {
                                          Get.find<HomeController>()
                                              .unlikePost(widget.postId);
                                          widget.likes.removeWhere((element) =>
                                              element == widget.postId);
                                        } else {
                                          Get.find<HomeController>()
                                              .likePost(widget.postId);
                                          widget.likes.add(widget.postId);
                                        }
                                      },
                                      icon: Icon(
                                        widget.home.tempLiked
                                                    .contains(widget.postId) ||
                                                liked
                                            ? Icons.favorite
                                            : Icons.favorite_outline,
                                        color: widget.home.tempLiked
                                                    .contains(widget.postId) ||
                                                liked
                                            ? Colors.red
                                            : Colors.black87,
                                      )),
                                ),
                                SizedBox(
                                  child: Text(widget.likes.length > 1
                                      ? widget.likes.length.toString() +
                                          " likes"
                                      : widget.likes.isEmpty
                                          ? ""
                                          : widget.likes.length.toString() +
                                              " like"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          widget.viewers == null
                              ? ""
                              : "Seen by ${widget.viewers!.length} people",
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
                            widget.tags!.length > 1 ? "Tags:" : "Tag:",
                            style: Get.textTheme.caption,
                          ),
                        ),
                        Expanded(
                          child: Wrap(
                            children: List.generate(
                                widget.tags!.length,
                                (index) => Container(
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.only(
                                          bottom: 3, left: 2, right: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        widget.tags![index],
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
            )
          : Container(),
    );
  }
}
