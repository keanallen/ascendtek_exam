import 'dart:io';

import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:ascendtek_exam/app/widgets/added_chip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadPage extends StatelessWidget {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var home = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload New Image"),
      ),
      floatingActionButton: Obx(
        () => home.selectedTags.isEmpty
            ? Container()
            : Container(
                width: context.width / 2.5,
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  onPressed: () => home.shareImage(),
                  child: FittedBox(
                    child: Row(
                      children: const [
                        Icon(Icons.share_sharp),
                        Text("Share Image"),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        width: context.width,
        height: context.height,
        child: Obx(() => SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (home.imagePath.isEmpty)
                      Column(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: IconButton(
                                onPressed: () =>
                                    Get.find<HomeController>().uploadImage(),
                                icon: Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 40,
                                  color: Colors.blue[300],
                                )),
                          ),
                          Text(
                            "Click to upload",
                            style: Get.textTheme.caption,
                          ),
                        ],
                      ),
                    if (home.imagePath.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextField(
                              controller: home.searchTag,
                              onChanged: (value) => home.filterTag(value),
                              onSubmitted: (value) => home.addTag(value),
                              decoration: const InputDecoration(
                                hintText: 'Search or Create New Tag...',
                                label: Text("Add Tag"),
                              ),
                            ),
                          ),

                          /// Available Tags
                          if (home.filteredTags.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Results",
                                style: Get.textTheme.headline6,
                              ),
                            ),
                          Wrap(
                            children: List.generate(
                              home.filteredTags.length,
                              (index) => tagChip(
                                tagModel: home.filteredTags[index],
                              ),
                            ),
                          ),

                          /// Selected Image to upload
                          Image.file(File(home.imagePath.value)),

                          /// Added Tags
                          if (home.selectedTags.isNotEmpty)
                            Text(
                              "Tags:",
                              style: Get.textTheme.caption!.copyWith(height: 2),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Wrap(
                              children: List.generate(
                                  home.selectedTags.length,
                                  (index) => AddedChip(
                                        home: home,
                                        index: index,
                                      )),
                            ),
                          ),
                          TextButton(
                              style: TextButton.styleFrom(
                                primary: Colors.red,
                              ),
                              onPressed: () {
                                home.imagePath.value = "";
                                home.selectedTags.clear();
                              },
                              child: const Text("Remove Image"))
                        ],
                      )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}

Widget tagChip({
  tagModel,
}) {
  return InkWell(
      onTap: () {
        var home = Get.find<HomeController>();
        var tagmodel = home.selectedTags.where(
          (p0) => p0.objectId == tagModel.objectId,
        );

        if (tagmodel.isEmpty) {
          if (tagModel != tagmodel) {
            home.selectedTags.add(tagModel);
          }
        }
        home.searchTag.clear();
        Future.delayed(const Duration(milliseconds: 300))
            .then((value) => home.filteredTags.clear());
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrangeAccent,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(
                '${tagModel.tagname}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.blue[300],
              radius: 10.0,
              child: const Icon(
                Icons.add,
                size: 12.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ));
}
