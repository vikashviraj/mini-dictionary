import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

class FloatingButton extends StatelessWidget {
  const FloatingButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Get.snackbar('Network','Check');
      },
      tooltip: 'Increment',
      child: const Icon(Ionicons.videocam_outline),
    );
  }
}