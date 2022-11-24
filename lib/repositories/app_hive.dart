import 'package:hive_flutter/hive_flutter.dart';

import '../models/medicine.dart';

class AppHive {
  Future<void> initializeHive() async {
    await Hive.initFlutter();

    Hive.registerAdapter<Medicine>(MedicineAdapter());

    await Hive.openBox<Medicine>(AppHiveBox.medicine);
  }
}

class AppHiveBox {
  static const String medicine = 'medicine';
}