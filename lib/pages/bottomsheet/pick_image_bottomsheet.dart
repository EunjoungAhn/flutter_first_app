import 'package:first_app/components/app_widgets.dart';
import 'package:flutter/material.dart';

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({
    super.key,
    required this.onPressedCamera,
    required this.onPressedGallery
    });

  // onPressed를 받아서 처리하려고 class 변수로 설정
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
          TextButton(
            onPressed: onPressedCamera,
            child: const Text('카메라로 촬영'),
          ),
          TextButton(
            onPressed: onPressedGallery,
            child: const Text('앨범에서 가져오기'),
        ),
      ],
    );
  }
}