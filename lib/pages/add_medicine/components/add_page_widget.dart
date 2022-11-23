import 'package:flutter/material.dart';

import '../../../components/app_constants.dart';

//공통 컴포넌트로 분리
class AddPageBody extends StatelessWidget {
  const AddPageBody({super.key, required this.children});
final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        //키보드를 아무 화면의 위치를 누르면 사라지게 설정
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView( // 키보드가 올라 왔는데 overflowed 된다면, 스크롤 가능한 영역으로 감싸주면 된다.
          child: Padding(
            padding: pagePadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
            ),
          ),
        ),
      );
  }
}