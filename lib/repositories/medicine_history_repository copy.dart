import 'dart:developer';

import '../models/medicine_history.dart';
import 'package:first_app/repositories/app_hive.dart';
import 'package:hive/hive.dart';


class MedicineHistoryRepository {
  Box<MedicineHistory>? _historyBox;

  Box<MedicineHistory> get historyBox {
    _historyBox ??= Hive.box<MedicineHistory>(AppHiveBox.medicineHistory); // 여기 if문을 한번이라도 거쳤으면
    return _historyBox!; // null이 절대
  }

  void addHistory(MedicineHistory medicine) async {
    int key = await historyBox.add(medicine);

    log('[addHistory] add (key:$key) $medicine');
    log('result ${historyBox.values.toList()}');
  }

  void deleteHistory(int key) async {
    await historyBox.delete(key);

    log('[deleteHistory] delete (key:$key)');
    log('result ${historyBox.values.toList()}');
  }

  void updateHistory({
    required int key,
    required MedicineHistory medicine,
  }) async {
    await historyBox.put(key, medicine);

    log('[updateHistory] update (key:$key) $medicine');
    log('result ${historyBox.values.toList()}');
  }

}