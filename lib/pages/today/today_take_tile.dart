import 'dart:io';

import 'package:first_app/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../components/app_constants.dart';
import '../../components/app_page_route.dart';
import '../../main.dart';
import '../../models/medicine_alarm.dart';
import '../../models/medicine_history.dart';
import '../bottomsheet/time_setting_bottomsheet.dart';
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
      _MedicineImageButton(medicineAlarm: medicineAlarm),
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
              TileActionButton(onTap: () {}, title: '지금',),
              Text('|', style: textStyle),
              TileActionButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => 
                    TimeSettingBottomSheet(initialTime: medicineAlarm.alarmTime,
                    ),
                  ).then((takeDateTime) {
                    // takeDateTime이 null 값이 던가 아님, DateTime이 아니면 다음 코드를 수행하지 않는다.
                    if(takeDateTime == null || takeDateTime is! DateTime){
                      return;
                    }

                    historyRepository.addHistory(MedicineHistory(
                      medicinedId: medicineAlarm.id,
                    alarmTime: medicineAlarm.alarmTime, 
                    takeTime: takeDateTime,
                    ));
                  });
                }, 
                title: '아까',
                ),
              Text('먹었어요!,', style: textStyle),
            ],
          )
        ];
  }
}

class AfterTakeTile extends StatelessWidget {
  const AfterTakeTile({
    Key? key, required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
      children: [
      _MedicineImageButton(medicineAlarm: medicineAlarm),
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
                  TextSpan(
                    text: '20:19',
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
              TileActionButton(onTap: () {}, title: '지금',),
              Text('|', style: textStyle),
              TileActionButton(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => 
                    TimeSettingBottomSheet(initialTime: medicineAlarm.alarmTime,
                    ),
                  ).then((takeDateTime) {
                    // takeDateTime이 null 값이 던가 아님, DateTime이 아니면 다음 코드를 수행하지 않는다.
                    if(takeDateTime == null || takeDateTime is! DateTime){
                      return;
                    }

                    historyRepository.addHistory(MedicineHistory(
                      medicinedId: medicineAlarm.id,
                    alarmTime: medicineAlarm.alarmTime, 
                    takeTime: takeDateTime,
                    ));
                  });
                }, 
                title: '아까',
                ),
              Text('먹었어요!,', style: textStyle),
            ],
          )
        ];
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

class _MedicineImageButton extends StatelessWidget {
  const _MedicineImageButton({
    Key? key,
    required this.medicineAlarm,
  }) : super(key: key);

  final MedicineAlarm medicineAlarm;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      // 이미지 경로가 null 이면 사진이 안 띄도록 처리
      onPressed: medicineAlarm.imagePath == null
      ? null
      : () {
        Navigator.push(context,
        FadePageRoute(page: ImageDetailPage(medicineAlarm: medicineAlarm)));
      },
      child: CircleAvatar(
        radius: 40,
        foregroundImage: medicineAlarm.imagePath == null ?
        null 
        : FileImage(File(medicineAlarm.imagePath!)),
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