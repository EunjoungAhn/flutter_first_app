import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

//service에 with ChangeNotifier 을 달고 
//setState가 필요한 부분의 함수에 notifyListeners를 추가
//이후 사용할 곳에 AnimatedBuilder에 넣어서 적용해 주어야 한다.
class AddMedicineService with ChangeNotifier{
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