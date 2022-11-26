class MedicineAlarm{
  MedicineAlarm(this.id, this.name, this.imagePath, this.alarmTime, this.key);

  final int id; // unique
  final String name;
  final String? imagePath;
  final String alarmTime;
  final int key;
}