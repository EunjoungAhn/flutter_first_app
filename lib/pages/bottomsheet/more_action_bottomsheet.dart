import 'package:first_app/components/app_widgets.dart';
import 'package:flutter/material.dart';

class MoreActionBottomSheet extends StatelessWidget {
  const MoreActionBottomSheet({
    super.key,
    required this.onPressedModify,
    required this.onPressedDeleteOnlymedicine,
    required this.onPressedDeleteAll,
    });

  // onPressed를 받아서 처리하려고 class 변수로 설정
  final VoidCallback onPressedModify;
  final VoidCallback onPressedDeleteOnlymedicine;
  final VoidCallback onPressedDeleteAll;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
          TextButton(
            onPressed: onPressedModify,
            child: const Text('약 정보 수정'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: onPressedDeleteOnlymedicine,
            child: const Text('약 정보 삭제'),
        ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: onPressedDeleteAll,
            child: const Text('약 기록과 함께 약 정보 삭제'),
        ),
      ],
    );
  }
}