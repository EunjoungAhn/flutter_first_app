import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddMedicinePage  extends StatefulWidget {
  const AddMedicinePage ({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();
  File? _pickedImage;

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
        child: SingleChildScrollView( // 키보드가 올라 왔는데 overflowed 된다면, 스크롤 가능한 영역으로 감싸주면 된다.
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
                    onPressed: () {
                      // 아래에서 시트가 나오는 설정
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SafeArea(
                            child: Padding(
                              padding: pagePadding,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      ImagePicker()
                                      .pickImage(source: ImageSource.camera)
                                      .then((xfile) {
                                      if (xfile != null){
                                        // 이미지가 null이 아닐때만 실행하고
                                        setState(() {
                                          _pickedImage = File(xfile.path);
                                        });
                                      }
                                      //이미지가 있던 없던 시트 끄기
                                      Navigator.maybePop(context);
                                      });
                                    },
                                    child: const Text('카메라로 촬영'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      ImagePicker()
                                      .pickImage(source: ImageSource.gallery)
                                      .then((xfile) {
                                      if (xfile != null){
                                        setState(() {
                                          _pickedImage = File(xfile.path);
                                        });
                                      }
                                      Navigator.maybePop(context);
                                      });
                                    },
                                    child: const Text('앨범에서 가져오기'),
                                ),
                              ],
                              ),
                            ),
                          );
                      });
                    },
                    // 카메라 사용을 위한 icon의 영역 조절
                    padding: _pickedImage == null? null : EdgeInsets.zero, // 사진 외곽에 잡힌 CupertinoButton의 defult padding 없애기
                    // 이미지가 없을떄 아래의 설정 값으로 출력할 것이다.
                    child: _pickedImage == null 
                    ? const Icon(
                      CupertinoIcons.photo_camera_solid,
                      size: 30,
                      color: Colors.white,
                    )
                    : CircleAvatar(
                      foregroundImage: FileImage(_pickedImage!),
                      radius: 40,
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
            child: const Text('다음'),
            ),
        ),
      ),
    ),
    );
  }
}