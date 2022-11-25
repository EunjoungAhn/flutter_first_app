import 'package:first_app/components/app_colors.dart';
import 'package:first_app/components/app_constants.dart';
import 'package:first_app/pages/add_medicine/add_medicine_page.dart';
import 'package:first_app/pages/history/history_page.dart';
import 'package:first_app/pages/today/today_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //페이지가 있는 리스트를 만든다. - 하단 버튼들을 클릭 했을때 작동할 페이지
  int _currentIndex = 0;
  final _pages = [
    // Container(color: Colors.blue), // 임시 페이지 이동시 만든 컨테이너
    TodayPage(),
    const HistoryPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: pagePadding,
        child: SafeArea(child: _pages[_currentIndex]),
      ),
      // 가운데 + 버튼 
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddMedicien,
        child: const Icon(CupertinoIcons.add),
      ),
      floatingActionButtonLocation:
        FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  BottomAppBar _buildBottomAppBar() {
    return BottomAppBar(
          //elevation: 0, //바텀 네이게이션 그림자 설정
          child: Container(
            height: kBottomNavigationBarHeight, //material 자체에서 네비게이션 높이를 지정해준 것
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // row 정렬
              children: [
                CupertinoButton(
                  onPressed: () => _onCurrentPage(0),
                  child: Icon(
                    CupertinoIcons.add,
                    color: _currentIndex == 0
                        ? AppColors.primaryColor
                        : Colors.grey[350], 
                  ), 
                ),
                CupertinoButton(
                  child: Icon(
                    CupertinoIcons.text_badge_checkmark,
                    color: _currentIndex == 1
                        ? AppColors.primaryColor
                        : Colors.grey[350], 
                    ), 
                  onPressed: () => _onCurrentPage(1),
                ),
              ],
            ),
          ),
        );
  }

  void _onCurrentPage(int pageIndex) {
    setState(() {
      //고정된 화면에서 페이지 이동
      _currentIndex = pageIndex;
    });
  }


  void _onAddMedicien(){
    // 새로운 레아이웃 페이지로 이동
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const AddMedicinePage()));
  }

}