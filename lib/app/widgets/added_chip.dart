import 'package:ascendtek_exam/app/controller/home_controller.dart';
import 'package:flutter/material.dart';

class AddedChip extends StatelessWidget {
  const AddedChip({
    Key? key,
    required this.home,
    required this.index,
  }) : super(key: key);

  final HomeController home;
  final int index;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Container(
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => home.selectedTags.removeAt(index),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  child: const Icon(
                    Icons.clear,
                    size: 10,
                  ),
                ),
              ),
              Text(home.selectedTags[index].tagname),
            ],
          )),
    );
  }
}
