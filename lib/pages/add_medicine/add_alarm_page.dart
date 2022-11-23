import 'dart:io';

import 'package:first_app/components/app_colors.dart';
import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_widgets.dart';
import 'package:first_app/main.dart';
import 'package:first_app/services/add_medicin_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'components/add_page_widget.dart';

class AddAlarmPage extends StatelessWidget {
  AddAlarmPage({
    required this.medicineImage,
    required this.medicineName,
    super.key
  });

  final File? medicineImage;
  final String medicineName;

  final service = AddMedicineService();

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
            child: AnimatedBuilder(
              animation: service,
              builder: (context, _) {
                return ListView(
                  children: alarmWidgets,
                );
              }, 
            ),
          ),
      ],
    ),
    bottomNavigationBar: BottomSubmitButton(
      onPressed: () async {
        bool result = false;
        // 1. add alarm
        for(var alarm in service.alarms){
          result = await notification.addNotifcication(
            medicineId: 0,
            alarmTimeStr: alarm,
            title: '$alarm 약 먹을 시간이에요!',
            body: '$medicineName 복약했다고 알려주세요!',
          );
          
          if(!result){
            showPermissionDenied(context, permission: '알람');
          }
        }
        // 2. save image (local dir)

        // 3. add medicine model (local DB, hive)
      },
      text: '완료',
    ),
    );
  }

// 시간을 리스트 형식으로 중복(set)처리해서 출력
  List<Widget> get alarmWidgets {
    //위젯을 받는 childern을 만든다.
    final children = <Widget>[];
      children.addAll(
        service.alarms.map(
          (alarmTime) => AlarmBox(
          time: alarmTime,
          service: service,
        )),
      );
      children.add(AddAlarmButton(
        service: service,
      ));
    return children;
  }
}

// 반복되는 부분 위젯으로
class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key, required this.time, required this.service,
  }) : super(key: key);

  final String time;
  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {

    return Row(children: [
      Expanded(
        flex: 1,// 공간 크기 지정
        //위젯 안에서 처리하는 것이 아닌 밖에서 onPressed 처리
        child: IconButton(onPressed: () {
          service.removeAlarm(time);
        }, 
        icon: const Icon(CupertinoIcons.minus_circle),),
      ),
      Expanded(
        flex: 5,
        child: TextButton(
          style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle2),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
              return TimePickerBottomSheet(
                initialTime: time,
                service: service,
                );
              },
            );
          },
          child: Text(time)),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class TimePickerBottomSheet extends StatelessWidget {
  TimePickerBottomSheet({
    Key? key, required this.initialTime, required this.service,
  }) : super(key: key);

  final String initialTime;
  final AddMedicineService service;
  DateTime? _setDateTime; // final이 아닌 내부에서 값이 변경될 수 있어서.
  // must_be_immutable 처리

  @override
  Widget build(BuildContext context) {
    // 반환할 시간 값을 다시 DateTime으로 바꾸어 주기
    final initialDateTime = DateFormat('HH:mm').parse(initialTime);

    return BottomSheetBody(
      children: [
        SizedBox( // CupertinoDatePicker만 넣으면 에러가 난다.
        //그 이유는 height 이 있어야 하기 때문이다.
          height: 200,
          child: CupertinoDatePicker(
            // TimePicker에서 변경한 값은 파라미터로 계속 받고 있었다.
            onDateTimeChanged: (dateTime){
              _setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,// 시간 선택 설정
            initialDateTime: initialDateTime,
            ),
          ),
          const SizedBox(width: regularSpace),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
                  child: const Text('취소'),
                style: ElevatedButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.subtitle1,
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: smallSpace),
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                  ),
                  onPressed: () {
                  service.setAlarm(
                    prevTime: initialTime,
                    setTime: _setDateTime ?? initialDateTime,
                  );
                  Navigator.pop(context);
                },
                child: const Text('선택'),
                ),
              ),
            ),
          ],)
        ],
      );
  }
}

class AddAlarmButton extends StatelessWidget {
  const AddAlarmButton({
    Key? key, required this.service,
  }) : super(key: key);

  final AddMedicineService service;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: service.addNowAlarm,
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