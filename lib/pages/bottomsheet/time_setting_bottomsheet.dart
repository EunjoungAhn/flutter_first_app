import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/app_colors.dart';
import '../../components/app_constants.dart';
import '../../components/app_widgets.dart';

// ignore: must_be_immutable
class TimeSettingBottomSheet extends StatelessWidget {
  const TimeSettingBottomSheet({
    Key? key, 
    required this.initialTime, 
    this.submitTitle = '선택',
    this.bottomWidget, 
  }) : super(key: key);

  final String initialTime;
  final Widget? bottomWidget;
  final String submitTitle;
  // final AddMedicineService service;
  // must_be_immutable 처리

  @override
  Widget build(BuildContext context) {
    // 반환할 시간 값을 다시 DateTime으로 바꾸어 주기
    final initialTimeData = DateFormat('HH:mm').parse(initialTime);
    final now = DateTime.now();
    final initialDateTime = DateTime(now.year, now.month, now.day, initialTimeData.hour, initialTimeData.minute);
  DateTime setDateTime = initialDateTime; // final이 아닌 내부에서 값이 변경될 수 있어서.

    return BottomSheetBody(
      children: [
        SizedBox( // CupertinoDatePicker만 넣으면 에러가 난다.
        //그 이유는 height 이 있어야 하기 때문이다.
          height: 200,
          child: CupertinoDatePicker(
            // TimePicker에서 변경한 값은 파라미터로 계속 받고 있었다.
            onDateTimeChanged: (dateTime){
              setDateTime = dateTime;
            },
            mode: CupertinoDatePickerMode.time,// 시간 선택 설정
            initialDateTime: initialDateTime,
            ),
          ),
          const SizedBox(width: smallSpace),
          //bottomWidget 이 null이 아니면 위젯을 그릴꺼다
          if(bottomWidget != null) bottomWidget!,
          const SizedBox(width: smallSpace),
          Row(children: [
            Expanded(
              child: SizedBox(
                height: submitButtonHeight,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context), 
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
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.subtitle1,
                  ),
                  onPressed: () => Navigator.pop(context, setDateTime),
                child: Text(submitTitle),
                ),
              ),
            ),
          ],)
        ],
      );
  }
}