import 'dart:io';

import 'package:first_app/components/app_constants.dart';
import 'package:first_app/components/app_widgets.dart';
import 'package:first_app/pages/add_medicine/add_alarm_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../components/app_page_route.dart';
import 'components/add_page_widget.dart';

class AddMedicinePage  extends StatefulWidget {
  const AddMedicinePage ({super.key});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  final _nameController = TextEditingController();
  File? _medicineImage;

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
      ), //AddPageBody 라는 공통 컴포넌트 함수화 처리
      body: SingleChildScrollView(
        child: AddPageBody( children: [
                Text(
                  '어떤 약이에요?',
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(height: largeSpace),
                Center(
                  child: _MedicineImageButton(
                    changeImageFile: (File? value) {
                      _medicineImage = value;
                    },
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
                  // 키보드를 눌러서 끄면 비활성화가 처리가 안되어서 화면 변화를 적용하려고
                  // listen으로 해주어도 된다.
                  onChanged: (_) { // 파라미터 사용 안함
                    setState(() { });
                  },
                ),
              ],
            ),
      ),
    bottomNavigationBar: BottomSubmitButton(
      onPressed: _nameController.text.isEmpty // .text는 항상 값이 있기 때문에 .isEmpty로 확인해주어야 한다.
        ? null 
        : _onAddAlarmPage,
        text: '다음',
      )
    );
  }

void _onAddAlarmPage() { 
    Navigator.push(
      context,
      FadePageRoute( // 기존의 MaterialPageRoute에서 ios와 android 화면 통일을위해 fade 효과로 커스텀
        page: AddAlarmPage(
          medicineImage: _medicineImage,
          medicineName: _nameController.text
        ),
      ),
    );
  }
}



class _MedicineImageButton extends StatefulWidget {
  const _MedicineImageButton({super.key, required this.changeImageFile});

  //안쪽(MedicineImageButton)에서만 사용되는 이미지 파일을 밖에서도 쓸 수 있도록 설정
  final ValueChanged<File?> changeImageFile;

  @override
  State<_MedicineImageButton> createState() => _MedicineImageButtonState();
}

class _MedicineImageButtonState extends State<_MedicineImageButton> {
  File? _pickedImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      child: CupertinoButton(
        onPressed: _showBottomSheet,
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
    );
  }

  void _showBottomSheet() {
      // 아래에서 시트가 나오는 설정
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return PickImageBottomSheet(
            onPressedCamera: ()=> _onPressed(ImageSource.camera),
            onPressedGallery: () => _onPressed(ImageSource.gallery),
            );
      });
    }

// 같은 로직을 반복함으로 파라미터를 넣어서 함수화 처리
  void _onPressed(ImageSource source) {
    ImagePicker()
    .pickImage(source: source)
    .then((xfile) {
    if (xfile != null){
      // 이미지가 null이 아닐때만 실행하고
      setState(() {
        _pickedImage = File(xfile.path);
        // _pickedImage이 사용되는 곳에서
        widget.changeImageFile(_pickedImage);
      });
    }
    //이미지가 있던 없던 시트 끄기
    Navigator.maybePop(context);
    }).onError((error, stackTrace) {
      // show setting
      Navigator.pop(context);
      showPermissionDenied(context, permission: '카메라 및 갤러리 접근');
    });
  }
}

class PickImageBottomSheet extends StatelessWidget {
  const PickImageBottomSheet({
    super.key,
    required this.onPressedCamera,
    required this.onPressedGallery
    });

  // onPressed를 받아서 처리하려고 class 변수로 설정
  final VoidCallback onPressedCamera;
  final VoidCallback onPressedGallery;

  @override
  Widget build(BuildContext context) {
    return BottomSheetBody(children: [
          TextButton(
            onPressed: onPressedCamera,
            child: const Text('카메라로 촬영'),
          ),
          TextButton(
            onPressed: onPressedGallery,
            child: const Text('앨범에서 가져오기'),
        ),
      ],
    );
  }
}