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
import 'package:intl/intl.dart';
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

    // 리스트 sort 작업
    medicineAlarms.sort(
      (a, b) => DateFormat('HH:mm')
    .parse(a.alarmTime)
    .compareTo(DateFormat('HH:mm').parse(b.alarmTime)),
  );


    return Column(
      children: [
        const Divider(height: 1, thickness: 1.0,),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: smallSpace),
            itemCount: medicineAlarms.length,
            itemBuilder: (context, index) {
            // 이러한 위젯을 반환한다는 처리를 위해 return을 꼭 넣는다.
            return _buildListTile(medicineAlarms[index]);
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

Widget _buildListTile(MedicineAlarm medicineAlarm){
  return ValueListenableBuilder(// 변경됨 것을 알기위해
    valueListenable: historyRepository.historyBox.listenable(),
    builder: (context, Box<MedicineHistory> historyBox, _) {// historyBox가 변경될때마다
    // valueListenable가 호출이되면서 historyBox를 읽을 수 있게 된다.
      if(historyBox.values.isEmpty){
          return BeforeTakeTile(
          medicineAlarm: medicineAlarm,
        );
      }

      final todayTakeHistory = historyBox.values.singleWhere(
        (history) => 
          history.medicinedId == medicineAlarm.id && 
          history.medicineKey == medicineAlarm.key && 
          history.alarmTime == medicineAlarm.alarmTime &&
        isToday(history.takeTime, DateTime.now()),
        orElse: () => MedicineHistory(
          medicinedId: -1,
          alarmTime: '',
          takeTime: DateTime.now(),
          medicineKey: -1,
          imagePath: null,
          name: '',
        ),
      );

      if(todayTakeHistory.medicinedId == -1 && 
      todayTakeHistory.alarmTime == ''){
        return BeforeTakeTile(
          medicineAlarm: medicineAlarm
        );
      }

      return AfterTakeTile(
        medicineAlarm: medicineAlarm,
        history: todayTakeHistory,
      );
    },
  );
}

// 년, 월, 일이 같은지 체크하는 함수 / 내부 함수 중 - .takeTime.difference(DateTime.now()).inDays == 0 24시간 하루가 지났는지 안 지났는지 확인 가능
bool isToday(DateTime source, DateTime destination){
  return source.year == destination.year &&
  source.month == destination.month &&
  source.day == destination.day;
}