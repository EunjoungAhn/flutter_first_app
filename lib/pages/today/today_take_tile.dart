import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_page_route.dart';
import 'package:first_app/models/medicine_alarm.dart';
import 'package:first_app/models/medicine_history.dart';
import 'package:first_app/pages/bottomsheet/time_setting_bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import 'image_detail_page.dart';

class BeforeTakeTile extends StatelessWidget {
  const BeforeTakeTile({
    Key? key, required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
      MedicineImageButton(imagePath: medicineAlarm.imagePath, ),
      const SizedBox(width: smallSpace,),
      const Divider( // 영역 구분감을 주기위해 추가
        height: 1,
        thickness: 2.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildTileBody(textStyle, context),
        ),
      ),
      _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
          Text(
            medicineAlarm.alarmTime,
            style: textStyle,
            ),
            const SizedBox(height: 6,),// 다음 줄 구분감을 주기 위해 높이 지정
            Wrap(
            // 3가지의 텍스트 구분으로 나누기위해 row -> 영역이 넘쳐서 에러를 
            // Wrap으로 감싸서 다음줄로 이동
            crossAxisAlignment: WrapCrossAlignment.center,
              children: [ 
              Text('${medicineAlarm.name},', style: textStyle),
              TileActionButton(
                  onTap: () { // 현재 시작으로 저장되면서 이미지가 쌓이는 처리
                    historyRepository.addHistory(
                      MedicineHistory(
                        medicinedId: medicineAlarm.id,
                        medicineKey: medicineAlarm.key,
                        alarmTime: medicineAlarm.alarmTime, 
                        takeTime: DateTime.now(),
                        imagePath: medicineAlarm.imagePath,
                        name: medicineAlarm.name,
                      ),
                    );
                  },
                  title: '지금',
                ),
              Text('|', style: textStyle),
              TileActionButton(
                onTap: () => _onPreviousTake(context), 
                title: '아까',
                ),
              Text('먹었어요!,', style: textStyle),
            ],
          )
        ];
  }

  void _onPreviousTake(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => 
      TimeSettingBottomSheet(
        initialTime: medicineAlarm.alarmTime,
      ),
    ).then((takeDateTime) {
      // takeDateTime이 null 값이 던가 아님, DateTime이 아니면 다음 코드를 수행하지 않는다.
      if(takeDateTime == null || takeDateTime is! DateTime){
        return;
      }

      historyRepository.addHistory(
        MedicineHistory(
          medicinedId: medicineAlarm.id,
          medicineKey: medicineAlarm.key,
          alarmTime: medicineAlarm.alarmTime, 
          takeTime: takeDateTime,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ),
      );
    });
  }

}



class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key, 
    required this.medicineAlarm, 
    required this.history,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;
  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;

    return Row(
      children: [
      Stack( // 이미지를 겹겹히 쌓는 것
        children: [
          MedicineImageButton(imagePath: medicineAlarm.imagePath, ),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green.withOpacity(0.7),
            child: const Icon(
              CupertinoIcons.check_mark,
              color: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(width: smallSpace,),
      const Divider( // 영역 구분감을 주기위해 추가
        height: 1,
        thickness: 2.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _buildTileBody(textStyle, context),
        ),
      ),
      _MoreButton(medicineAlarm: medicineAlarm),
      ],
    );
  }

  List<Widget> _buildTileBody(TextStyle? textStyle, BuildContext context) {
    return [
          // Text Bold처리
          Text.rich(
              TextSpan(
                text: '${medicineAlarm.alarmTime} -> ',
                style: textStyle,
                children: [
                  TextSpan( // string 타입을 DateTime으로 바꾸기
                    text: DateFormat('HH:mm').format(history.takeTime),
                    style: textStyle?.copyWith(fontWeight: FontWeight.w500)
                  ),
                ],         
              )
            ),
            const SizedBox(height: 6,),// 다음 줄 구분감을 주기 위해 높이 지정
            Wrap(
            // 3가지의 텍스트 구분으로 나누기위해 row -> 영역이 넘쳐서 에러를 
            // Wrap으로 감싸서 다음줄로 이동
            crossAxisAlignment: WrapCrossAlignment.center,
              children: [ 
              Text('${medicineAlarm.name},', style: textStyle),
              TileActionButton(
                onTap: () => _onTap(context),
                title: takeTimeStr,
              ),
              Text('먹었어요!', style: textStyle),
            ],
          )
        ];
  }

  String get takeTimeStr => DateFormat('HH:mm').format(history.takeTime);

// StatelessWidget여서 BuildContext를 받아와서 사용한다. Statefull 위젯은 매개변수로 받아와서 사용해도 된다.
  void _onTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => 
      TimeSettingBottomSheet(
        initialTime: takeTimeStr,
        submitTitle: '수정',
        bottomWidget: TextButton(
          onPressed: () {
            historyRepository.deleteHistory(history.key);
            Navigator.pop(context);
          },
          child: Text(
            '복약 시간을 지우고 싶어요.',
            style: Theme.of(context).textTheme.bodyText2,
          ),
        ),
      ),
    ).then((takeDateTime) {
      // takeDateTime이 null 값이 던가 아님, DateTime이 아니면 다음 코드를 수행하지 않는다.
      if(takeDateTime == null || takeDateTime is! DateTime){
        return;
      }

      historyRepository.updateHistory(
        key: history.key,
        history: MedicineHistory(
          medicinedId: medicineAlarm.id,
          medicineKey: medicineAlarm.key,
          alarmTime: medicineAlarm.alarmTime, 
          takeTime: takeDateTime,
          imagePath: medicineAlarm.imagePath,
          name: medicineAlarm.name,
        ), 
      );
    });
  }

}

class _MoreButton extends StatelessWidget {
  const _MoreButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: () {
        medicineRepository.deleteMedicine(medicineAlarm.key);
      },
      child: const Icon(CupertinoIcons.ellipsis_vertical),
      );
  }
}

class MedicineImageButton extends StatelessWidget {
  const MedicineImageButton({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // 이미지 경로가 null 이면 사진이 안 띄도록 처리
      onPressed: imagePath == null
      ? null
      : () {
        Navigator.push(context,
        FadePageRoute(page: ImageDetailPage(imagePath: imagePath!)));
      },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: imagePath == null ?
        null 
        : FileImage(File(imagePath!)),
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