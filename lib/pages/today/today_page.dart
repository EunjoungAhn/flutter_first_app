import 'package:flutter/material.dart';

class TodayPage extends StatelessWidget {
  const TodayPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        '오늘 복용할 약은?',
        style: Theme.of(context).textTheme.headline4,
        )
    ],);
  }
}