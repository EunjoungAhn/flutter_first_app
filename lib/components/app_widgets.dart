import 'package:first_app/components/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class BottomSheetBody extends StatelessWidget {
  const BottomSheetBody({super.key, required this.children});
  
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: pagePadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

void showPermissionDenied(
  BuildContext context, {
  required String permission,
  }){// context는 타입없이 주면 dynamic으로 설정되니 표기 해주어야 한다.
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(// SnackBar은 4초가 기본으로 출력된다.
            content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$permission 권한이 없습니다.'),
            const TextButton(
              onPressed: openAppSettings, 
            child: Text('설정창으로 이동'),)
          ],
        )),
      );
}