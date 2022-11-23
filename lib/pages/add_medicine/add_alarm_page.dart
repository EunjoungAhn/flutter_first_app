import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage({
    required this.medicineImage,
    required this.medicineName,
    super.key
  });

  final File? medicineImage;
  final String medicineName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: AddPageBody(//공통 컴포넌트로 분리
      children: [
        Text(
          '매일 복약 잊지 말아요!',
          style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: largeSpace),
          Expanded(// Expanded- 컬럼에서 내가 가지고 있는 영역을 다 그릴수 있는 
            child: ListView(
              children: const [
              AlarmBox(),
              AlarmBox(),
              AlarmBox(),
              AddAlarmBox(),
            ],
            ),
          ),
      ],
    ),
    bottomNavigationBar: BottomSubmitButton(onPressed: () {
      
    },
    text: '완료',
    ),
    );
  }
}

// 반복되는 부분 위젯으로
class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        flex: 1,// 공간 크기 지정
        child: IconButton(onPressed: () {
          
        }, icon: const Icon(CupertinoIcons.minus_circle),),
      ),
      Expanded(
        flex: 5,
        child: TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle2),
          onPressed: () {
          
        }, child: const Text('18:00')),
      )
    ],);
  }
}

class AddAlarmBox extends StatelessWidget {
  const AddAlarmBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: () {
        
      },
      child: Row(
        children: const [
          Expanded(
            flex: 1,
            child: Icon(CupertinoIcons.plus_circle_fill),
            ),
          Expanded(
            flex: 5,
            child: Center(child: Text('복용시간 추가')),
          )
        ],
      ),
    );
  }
}