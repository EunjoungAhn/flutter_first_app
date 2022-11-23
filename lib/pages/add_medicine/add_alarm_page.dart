import 'dart:io';

import 'package:first_app/components/app_colors.dart';
import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'components/add_page_widget.dart';

class AddAlarmPage extends StatefulWidget {
  const AddAlarmPage({
    required this.medicineImage,
    required this.medicineName,
    super.key
  });

  final File? medicineImage;
  final String medicineName;

  @override
  State<AddAlarmPage> createState() => _AddAlarmPageState();
}

class _AddAlarmPageState extends State<AddAlarmPage> {
  final _alarms = <String>{
    '10:00',
    '12:00',
    '13:00',
  };

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
              children: alarmWidgets,
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

// 시간을 리스트 형식으로 중복(set)처리해서 출력
  List<Widget> get alarmWidgets {
    //위젯을 받는 childern을 만든다.
    final children = <Widget>[];
      children.addAll(
        _alarms.map(
          (alarmTime) => AlarmBox(
          time: alarmTime,
          onPressMinus: () {  
            setState(() {
              _alarms.remove(alarmTime);
            });
          },
        )),
      );
      children.add(AddAlarmButton(
        onPressed: () {  
          final now = DateTime.now();
          //now.minute 으로 출력하면 03분으로 안나온다.
          //그래서 DateTime을 포맷해서 출력한다.
          final nowTime = DateFormat('HH:mm').format(now); 
          setState(() {
            _alarms.add(nowTime); 
          });
        },
      ));
    return children;
  }
}

// 반복되는 부분 위젯으로
class AlarmBox extends StatelessWidget {
  const AlarmBox({
    Key? key, required this.time, required this.onPressMinus,
  }) : super(key: key);

  final String time;
  final VoidCallback onPressMinus;

  @override
  Widget build(BuildContext context) {
    // 반환할 시간 값을 다시 DateTime으로 바꾸어 주기
    final initTime = DateFormat('HH:mm').parse(time);

    return Row(children: [
      Expanded(
        flex: 1,// 공간 크기 지정
        //위젯 안에서 처리하는 것이 아닌 밖에서 onPressed 처리
        child: IconButton(onPressed: onPressMinus, 
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
                initialDateTime: initTime,
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

class TimePickerBottomSheet extends StatelessWidget {
  const TimePickerBottomSheet({
    Key? key, required this.initialDateTime,
  }) : super(key: key);
  final DateTime initialDateTime;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(
      children: [
        SizedBox( // CupertinoDatePicker만 넣으면 에러가 난다.
        //그 이유는 height 이 있어야 하기 때문이다.
          height: 200,
          child: CupertinoDatePicker(
            onDateTimeChanged: (dateTime){},
            mode: CupertinoDatePickerMode.time,// 시간 선택 설정
            initialDateTime: initialDateTime,
            ),
          ),
          const SizedBox(width: regularSpace),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(onPressed: () {
                  
                }, 
                child: Text('취소'),
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
                child: ElevatedButton(onPressed: () {
                  
                },
                style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
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
    Key? key, required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
        textStyle: Theme.of(context).textTheme.subtitle1),
      onPressed: onPressed,
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