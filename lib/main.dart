import 'package:first_app/components/app_themes.dart';
import 'package:first_app/repositories/app_hive.dart';
import 'package:first_app/repositories/medicine_history_repository.dart';
import 'package:first_app/repositories/medicine_repository.dart';
import 'package:first_app/services/app_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'pages/home_page.dart';

final notification = AppNotificationService();
final hive = AppHive();
final medicineRepository = MedicineRepository();
final historyRepository = MedicineHistoryRepository();
void main() async {
  WidgetsFlutterBinding.ensureInitialized;

  initializeDateFormatting(); // 날짜 포멧을 한글로 받아오기 위한 import

  // openBox가 되지 않고 앱이 실행하면 에러가 발생함으로 awit 추가
  await hive.initializeHive();
  //runApp이 되기전에 꼭 hive를 초기화 하고 앱 실행

  notification.initializeTimeZone();
  notification.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: AppThemes.lightTheme,
      home: const HomePage(),
      // 기기 폰트 사이즈에 의존하고 싶지않다면
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: child!,
	    ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
    ),
  );
  }
}
