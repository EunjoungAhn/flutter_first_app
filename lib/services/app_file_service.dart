import 'dart:io';

import 'package:path_provider/path_provider.dart';

// 저장하고하 하는 이미지를 리턴 받으면 filePath로 리턴해 준다.
Future<String> saveImageToLocalDirectory(File image) async {
  final documentDirectory = await getApplicationDocumentsDirectory(); // 경로를 받아온다.
  final folderPath = documentDirectory.path + '/medicien/images'; // 저장된 폴더 path가지만 담는다.
  final filePath = folderPath + '/${DateTime.now().millisecondsSinceEpoch}.png'; // 유니크한 파일명을 만드려고 millisecondsSinceEpoch 사용 

  await Directory(folderPath).create(recursive: true); // 폴더를 만든다.

  final newFile = File(filePath);
  newFile.writeAsBytesSync(image.readAsBytesSync());

  return filePath;
}