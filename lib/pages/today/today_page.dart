//패키지에서 접근
import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_page_route.dart';
import 'package:first_app/main.dart';
import 'package:first_app/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:first_app/pages/today/today_empty_widget.dart';
import 'package:first_app/pages/today/today_take_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
//내 파일 안에서 접근하는
import '../../models/medicine.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';

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

    // 빈화면일때 뷰 처리
    if(medicines.isEmpty){
      return TodayEmpty();
    }

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


    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0,),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
            return BeforeTakeTile(
              medicineAlarm: medicineAlarms[index],
            );
          },// itemBuilder를 그려주고 어떤 위젯을 다음에 그려줄지 
          // 정해줄때 사용가능 
          separatorBuilder: (context, index) {
            return const Divider(
              height: regularSpace,
            );
          },
          ),
        ),
        const Divider(height: 1, thickness: 1.0,),
      ],
    );
  }
}

