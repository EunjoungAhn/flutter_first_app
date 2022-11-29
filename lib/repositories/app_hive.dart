import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';
import '../models/medicine_history.dart';

class AppHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());
    Hive.registerAdapter<MedicineHistory>(MedicineHistoryAdapter());

    await Hive.openBox<Medicine>(AppHiveBox.medicine);
    await Hive.openBox<MedicineHistory>(AppHiveBox.medicineHistory);
  }
}

class AppHiveBox {
  static const String medicine = 'medicine';
  static const String medicineHistory = 'medicine_history';
}