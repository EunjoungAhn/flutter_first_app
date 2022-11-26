import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 1)
class Medicine extends HiveObject{ // @HiveType(typeId: 1) 는 1부터 시작
  Medicine({     
    required this.id,
    required this.name, 
    required this.imagePath,
    required this.alarms
  });

  @HiveField(0) // @HiveField(0) 는 0부터 시작
  final int id; // unique

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? imagePath;

  @HiveField(3)
  final List<String> alarms;

  @override
  String toString() {
    return '{id: $id, name: $name, imagePath: $imagePath, alarms: $alarms}';
  }
}