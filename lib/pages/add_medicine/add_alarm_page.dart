import 'dart:io';

import 'package:first_app/components/app_colors.dart';
import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_widgets.dart';
import 'package:first_app/main.dart';
import 'package:first_app/models/medicine.dart';
import 'package:first_app/services/add_medicin_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../services/app_file_service.dart';
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
            medicineId: medicineRepository.newId,
            alarmTimeStr: alarm,
            title: '$alarm 약 먹을 시간이에요!',
            body: '$medicineName 복약했다고 알려주세요!',
          );

          if(!result){
            return showPermissionDenied(context, permission: '알람');
          }
        }
        
        // 2. save image (local dir)
        String? imageFilePath;
        if (medicineImage != null) {
          imageFilePath = await saveImageToLocalDirectory(medicineImage!);
        }

        // 3. add medicine model (local DB, hive)
        final medicine = Medicine(
          id: medicineRepository.newId, 
          name: medicineName, 
          imagePath: imageFilePath, 
          alarms: service.alarms.toList(),
        );
        medicineRepository.addMedicine(medicine);

        // ignore: use_build_context_synchronously
        Navigator.popUntil(context, (route) => route.isFirst); // 지금까지 쌓인 레이아웃을 벗어나 가장 첫 화면으로 나가고 싶을때 popUntil 사용
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