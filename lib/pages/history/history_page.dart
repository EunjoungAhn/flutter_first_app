import 'package:first_app/pages/today/history_empty_widget.dart';
import 'package:first_app/pages/today/today_take_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../components/app_constants.dart';
import '../../main.dart';
import '../../models/medicine.dart';
import '../../models/medicine_history.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:  CrossAxisAlignment.start,
      children: [
        Text('잘 복용 했어요!', 
        style: Theme.of(context).textTheme.headline4,
        ),
        SizedBox(height: regularSpace,),
        const Divider(height: 1, thickness: 1.0,),
          Expanded(
            child: ValueListenableBuilder(// 변경됨 것을 알기위해
              valueListenable: historyRepository.historyBox.listenable(),
              builder: _buildListView
          ),
        ),
      ],
    );
  }

  Widget _buildListView(context, Box<MedicineHistory> historyBox, _) {
    final histories = historyBox.values.toList().reversed.toList(); // 리스트 역순으로 출력

    // 약 복욕이 하나도 없다면 empty 화면을 보여줘라
    if(histories.isEmpty){
      return const HistoryEmpty();
    }

      return ListView.builder(
        itemCount: histories.length,
        itemBuilder: (context, index) {
          final history = histories[index];
          return _TimeTile(history: history);
      },
    );
  }
}

class _TimeTile extends StatelessWidget {
  const _TimeTile({
    Key? key,
    required this.history,
  }) : super(key: key);

  final MedicineHistory history;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Text(
          // '2022\n12.01.목'       - 로케일 값을 한글로 설정(설정을 위해 main에 initializeDateFormatting() import)
            DateFormat('yyyy\nMM.dd E', 'ko_KR').format(history.takeTime),
            textAlign: TextAlign.center,
          
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
              height: 1.6, // 간극
              leadingDistribution: TextLeadingDistribution.even, // 글자 간격 기준으로 자동 설정을 3번째로
            ),
          ),
        ),
      Stack(
        alignment: const Alignment(0.0, -0.3),
        children: const [
          SizedBox(
            height: 130,
            child: VerticalDivider( // 서로로 구분선 넣기
              width: 1,
              thickness: 1,
            ),
          ),
          CircleAvatar(
            radius: 4,
            child: CircleAvatar(
              radius: 3,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
      // 글자 차이 정렬 수정하기
      Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 이미지가 없을때는 버튼이 안보이게 하는 위젯 처리 if문과 동일
            Visibility(
              visible: medicine.imagePath != null,
              child: MedicineImageButton(imagePath: medicine.imagePath),
              ),
              const SizedBox(width: smallSpace,),
              Text( // a는 오전 오후를 나타내는 것이다. / 'ko_KR' 를 지우면 AM, PM으로 출력됨
                DateFormat('a hh:mm', 'ko_KR').format(history.takeTime) +
                  '\n' +
                  medicine.name,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    height: 1.6, // 간극
                    leadingDistribution: TextLeadingDistribution.even, // 글자 간격 기준으로 자동 설정을 3번째로
              ),
            ),
          ],
        ),
      ),
    ],
        );
  }


  Medicine get medicine { // 내가 history.medicinedId에 가지고 있는 아이디와 element.id가 같으면 리턴
    return medicineRepository.medicineBox.values
      .singleWhere(
        (element) => 
          element.id == history.medicinedId &&
          element.key == history.medicineKey,
      orElse: () => Medicine(
        id: -1,
        name: history.name, //'삭제된 약입니다.'
        imagePath: history.imagePath,
        alarms: [],
      ),
    );
  }
}