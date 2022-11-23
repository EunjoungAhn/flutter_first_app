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
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children
          ),
        ),
      );
  }
}

class BottomSubmitButton extends StatelessWidget {
  const BottomSubmitButton({super.key, required this.onPressed, required this.text});
  final VoidCallback? onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SafeArea(// ios x 이상에서만 동작 하단의 네비게이션 바와 노치를 침범하지 않게 설정
      child: Padding(
        // 하단 버튼의 여백 설정
        padding: submitButtonBoxPadding,
        child: SizedBox(// 하단 버튼 사이즈 조절
          height: submitButtonHeight,
          child: ElevatedButton( // onPressed: null은 버튼 disable 효과
            
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
            child: Text(text),
            ),
        ),
      ),
    );
  }
}