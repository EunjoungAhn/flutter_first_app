import 'package:first_app/components/app_colors.dart';
import 'package:flutter/material.dart';

class AppThemes {
  //main의 ThemeData를 잘라서 따로 getter로 설정
  static ThemeData get lightTheme => ThemeData(
  primarySwatch: AppColors.primaryMeterialColor,
  fontFamily: 'GmarketSansTTF',
  scaffoldBackgroundColor: Colors.white,
  splashColor: Colors.white,
  textTheme: _textTheme, //_textTheme을 바라보게 설정
  appBarTheme: _appBarTheme,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

//다크 테마 만들기
static ThemeData get darkTheme => ThemeData(
  primarySwatch: AppColors.primaryMeterialColor,
  fontFamily: 'GmarketSansTTF',
  splashColor: Colors.white,
  textTheme: _textTheme, //_textTheme을 바라보게 설정
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// appBar 테마 만들기
static const AppBarTheme _appBarTheme = AppBarTheme(
  backgroundColor: Colors.white,
  iconTheme: IconThemeData(
    color: AppColors.primaryColor,
  ),
  elevation: 0, //appBar 그림자 없애기
);

  static const TextTheme _textTheme = TextTheme(
    headline4: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w400,
    ),
    subtitle1: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitle2: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyText1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w300,
    ),
    bodyText2: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
    button: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w300,
    ),
  );
}