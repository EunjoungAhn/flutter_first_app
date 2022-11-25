import 'package:first_app/components/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //column 기준 좌축 정렬
      children: [
      Text(
        '오늘 복용할 약은?',
        style: Theme.of(context).textTheme.headline4,
        ),
        // 제목 아래 스크롤 가능한 영역 만들기 위해 공간 넣기
        const SizedBox(height: regularSpace),
        Expanded(child: ListView(
          children: [
            MedicineListTile()
          ],
        )),
    ],);
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(
      color: Colors.yellow,
      child: Row(
        children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            
          },
          child: const CircleAvatar(
            radius: 40,
          ),
        ),
        const SizedBox(width: smallSpace,),
        Expanded(
          child: Container(
            color: Colors.white,
            // 2개의 열 디자인을 위해 column
            child: Column(
              children: [
                Text(
                  '22:44',
                  style: textStyle,
                  ),
                  // 3가지의 텍스트 구분으로 나누기위해 row
                  Row(children: [
                    Text('약 이름,', style: textStyle),
                    TileActionButton(onTap: () {}, title: '지금',),
                    Text('|', style: textStyle),
                    TileActionButton(onTap: () {}, title: '아까',),
                    Text('먹었어요!,', style: textStyle),
                  ],)
              ],
            ),
          ),
        ),
        CupertinoButton(
          onPressed: () {
            
          },
          child: const Icon(CupertinoIcons.ellipsis_vertical),
          ),
        ],
      ),
    );
  }
}

class TileActionButton extends StatelessWidget {
  const TileActionButton({
    Key? key,
    required this.onTap,
    required this.title,
  }) : super(key: key);

final VoidCallback onTap;
final String title;

  @override
  Widget build(BuildContext context) {
    final buttonTextStyle = Theme.of(context).textTheme.bodyText2?.copyWith(fontWeight: FontWeight.w500);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          title, 
          style: buttonTextStyle
            ),
      ),
    );
  }
}