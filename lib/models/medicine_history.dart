import 'package:hive/hive.dart';

part 'medicine_history.g.dart';

@HiveType(typeId: 2) // 모델이 2번째이니 typeId를 2로 지정
class MedicineHistory extends HiveObject{ // @HiveType(typeId: 1) 는 1부터 시작
  MedicineHistory({
    required this.medicinedId, 
    required this.alarmTime, 
    required this.takeTime,     
    required this.medicineKey,
    required this.name,
    required this.imagePath,
  });

  @HiveField(0) // @HiveField(0) 는 0부터 시작
  final int medicinedId; // unique

  @HiveField(1)
  final String alarmTime;

  @HiveField(2)
  final DateTime takeTime;

  @HiveField(3, defaultValue: -1)
  final int medicineKey;

  @HiveField(4, defaultValue: '')
  final String name;

  @HiveField(5)
  final String? imagePath;


  @override
  String toString() {
    return '{medicinedId: $medicinedId, alarmTime: $alarmTime, takeTime: $takeTime, medicineKey: $medicineKey, name: $name, imagePath: $imagePath,}';
  }
}