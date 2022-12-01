import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../../components/app_constants.dart';
import '../../models/medicine_history.dart';
import '../../main.dart';

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
    final histories = historyBox.values.toList();
      return ListView.builder(
        itemCount: histories.length,
        itemBuilder: (context, index) {
          final history = histories[index];
          return Row(
            children: [
              Text(
              // '2022\n12.01.목'       - 로케일 값을 한글로 설정(설정을 위해 main에 initializeDateFormatting() import)
              DateFormat('yyyy\nMM.dd E', 'ko_KR').format(history.takeTime),
              textAlign: TextAlign.center,

              style: Theme.of(context).textTheme.subtitle2!.copyWith(
                height: 1.6,
                leadingDistribution: TextLeadingDistribution.even,
              ),
            )
          ],
        );
      },
    );
  }
}