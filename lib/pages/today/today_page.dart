//패키지에서 접근
import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_page_route.dart';
import 'package:first_app/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//내 파일 안에서 접근하는
import '../../models/medicine.dart';
import '../../models/medicine_alarm.dart';

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
        const Divider(height: 1, thickness: 2.0,),
        Expanded(
          child: ValueListenableBuilder(
            valueListenable: medicineRepository.medicineBox.listenable(),
            builder: _bilderMedicineListView, 
          ),
        ),
      ],
    );
  }

  Widget _bilderMedicineListView(context, Box<Medicine> box, _) {
    final medicines = box.values.toList();
    //medicine list
    final medicineAlarms = <MedicineAlarm>[];

    for(var medicine in medicines){
      for(var alarm in medicine.alarms){
        medicineAlarms.add(MedicineAlarm(
          medicine.id, 
          medicine.name,
          medicine.imagePath,
          alarm,
          medicine.key,// model class인 Medicine extends HiveObject를 해야 key 값을 가져온다.
        ));
      }
    }


    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: smallSpace),
      itemCount: medicineAlarms.length,
      itemBuilder: (context, index) {
      return MedicineListTile(
        medicineAlarm: medicineAlarms[index],
      );
    },// itemBuilder를 그려주고 어떤 위젯을 다음에 그려줄지 
    // 정해줄때 사용가능 
    separatorBuilder: (context, index) {
      return const Divider(
        height: regularSpace,
      );
    },
    );
  }
}

class MedicineListTile extends StatelessWidget {
  const MedicineListTile({
    Key? key, required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Container(

      child: Row(
        children: [
        CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.push(context,
            FadePageRoute(page: Scaffold(
              appBar: AppBar(
                leading: const CloseButton(),
              ),
              body: Center(
                child: Image.file(File(medicineAlarm.imagePath!),
                ),
              ),
              )));
          },
          child: CircleAvatar(
            radius: 40,
            foregroundImage: medicineAlarm.imagePath == null ?
            null 
            : FileImage(File(medicineAlarm.imagePath!)),
          ),
        ),
        const SizedBox(width: smallSpace,),
        const Divider( // 영역 구분감을 주기위해 추가
          height: 1,
          thickness: 2.0,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${medicineAlarm.alarmTime}',
                style: textStyle,
                ),
                const SizedBox(height: 6,),// 다음 줄 구분감을 주기 위해 높이 지정
                Wrap(
                // 3가지의 텍스트 구분으로 나누기위해 row -> 영역이 넘쳐서 에러를 
                // Wrap으로 감싸서 다음줄로 이동
                crossAxisAlignment: WrapCrossAlignment.center,
                  children: [ 
                  Text('${medicineAlarm.name},', style: textStyle),
                  TileActionButton(onTap: () {}, title: '지금',),
                  Text('|', style: textStyle),
                  TileActionButton(onTap: () {}, title: '아까',),
                  Text('먹었어요!,', style: textStyle),
                ],
              )
            ],
          ),
        ),
        CupertinoButton(
          onPressed: () {
            medicineRepository.deleteMedicine(medicineAlarm.key);
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