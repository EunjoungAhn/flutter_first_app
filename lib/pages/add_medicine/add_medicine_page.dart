import 'package:first_app/components/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddMedicinePage  extends StatefulWidget {
  const AddMedicinePage ({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
      ),
      body: GestureDetector(
        //키보드를 아무 화면의 위치를 누르면 사라지게 설정
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Padding(
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              '어떤 약이에요?',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: largeSpace),
            Center(
              child: 
              CircleAvatar(
                radius: 40,
                child: CupertinoButton(
                  onPressed: () {},
                  child: const Icon(
                    CupertinoIcons.photo_camera_solid,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: largeSpace + regularSpace),
            Text(
              '약 이름',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            TextFormField(
              controller: _nameController,
              maxLength: 20,
              keyboardType: TextInputType.text, //키보드 타입 설정, 이메일..등등
              textInputAction: TextInputAction.done, // 완료 버튼으로 설정
              style: Theme.of(context).textTheme.bodyText1,
              decoration: InputDecoration(
                hintText: '복용할 약 이름을 기입해주세요.',
                hintStyle: Theme.of(context).textTheme.bodyText2,
                contentPadding: textFieldContentPadding,
              ),
            ),
          ],
            ),
        ),
      ),
    bottomNavigationBar: SafeArea(// ios x 이상에서만 동작 하단의 네비게이션 바와 노치를 침범하지 않게 설정
      child: Padding(
        // 하단 버튼의 여백 설정
        padding: submitButtonBoxPadding,
        child: SizedBox(// 하단 버튼 사이즈 조절
          height: submitButtonHeight,
          child: ElevatedButton(
            onPressed: () {  },
            style: ElevatedButton.styleFrom(textStyle: Theme.of(context).textTheme.subtitle1),
            child: Text('다음'),
            ),
        ),
      ),
    ),
    );
  }
}