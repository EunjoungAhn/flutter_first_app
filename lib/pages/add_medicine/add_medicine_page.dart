import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMedicinePage  extends StatelessWidget {
  const AddMedicinePage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        //키보드를 아무 화면의 위치를 누르면 사라지게 설정
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            '어떤 약이에요?',
            style: Theme.of(context).textTheme.headline4,
          ),
          Center(
            child: 
            CircleAvatar(
              radius: 40,
              child: CupertinoButton(
                onPressed: () {},
                child: const Icon(
                  CupertinoIcons.photo_camera_solid,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Text(
            '약 이름',
            style: Theme.of(context).textTheme.subtitle1,
          ),
          TextFormField(),
        ],
          ),
      ),
    bottomNavigationBar: SafeArea(// ios x 이상에서만 동작 하단의 네비게이션 바와 노치를 침범하지 않게 설정
      child: ElevatedButton(
        onPressed: () {  },
        style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
        child: Text('다음'),
        ),
    ),
    );
  }
}