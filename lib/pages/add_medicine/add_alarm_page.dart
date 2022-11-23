import 'dart:io';

import 'package:flutter/material.dart';

class AddAlarmPage extends StatelessWidget {
  const AddAlarmPage({
    required this.medicineImage,
    required this.medicineName,
    super.key
  });

  final File? medicineImage;
  final String medicineName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
      children: [
        medicineImage == null? Container() : Image.file(medicineImage!), // Image.file 억지로 출력하면 에러가 나니 !로 null을 받지 않겠다 설정
        Text(medicineName),
      ]),
    );
  }
}