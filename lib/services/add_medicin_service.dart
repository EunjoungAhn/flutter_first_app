import 'package:first_app/main.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

//service에 with ChangeNotifier 을 달고 
//setState가 필요한 부분의 함수에 notifyListeners를 추가
//이후 사용할 곳에 AnimatedBuilder에 넣어서 적용해 주어야 한다.
class AddMedicineService with ChangeNotifier{
AddMedicineService(int updateMedicineId){
  final isUpdate = updateMedicineId != -1; // -1 만 넣으면 헤깔리니 명확하기 하기 위해 변수 처리
  if(isUpdate){ // 업데이트일 경우 기존의 set 데이터를 지우고 수정할 값을 넣어주기
    final updateAlarms = medicineRepository.medicineBox.values
      .singleWhere((medicine) => medicine.id == updateMedicineId)
      .alarms;

    _alarms.clear();
    _alarms.addAll(updateAlarms);
  }
}

  final _alarms = <String>{
    '10:00',
    '12:00',
    '13:00',
  };

  Set<String> get alarms => _alarms;

  void addNowAlarm(){
    final now = DateTime.now();
    //now.minute 으로 출력하면 03분으로 안나온다.
    //그래서 DateTime을 포맷해서 출력한다.
    final nowTime = DateFormat('HH:mm').format(now); 

    _alarms.add(nowTime);
    notifyListeners();// setState 했던것 처럼 화면 변화가 일어 난다.
  }

  void removeAlarm(String alarmTime){
    _alarms.remove(alarmTime);
    notifyListeners();
  }

  void setAlarm({required String prevTime, required DateTime setTime}){
    _alarms.remove(prevTime);
    
    final setTimeStr = DateFormat('HH:mm').format(setTime);
    _alarms.add(setTimeStr);

    notifyListeners();
  }
}