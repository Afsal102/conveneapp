import 'dart:io';

import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/utility/utils.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/dashboard/controller/user_info_controller.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UserSettingsPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const UserSettingsPage(),
      );

  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const UserSettingsView(),
    );
  }
}

class UserSettingsView extends ConsumerStatefulWidget {
  const UserSettingsView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserSettingsViewState();
}

class _UserSettingsViewState extends ConsumerState<UserSettingsView> {
  final TextEditingController nameController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    var pickedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void editProfile(
    String uid,
    String name,
    String currentProfilePic,
  ) async {
    ref.read(userApiProvider).updateUser(
          uid: uid,
          profilePic: _image,
          name: name,
          currentProfilePic: currentProfilePic,
        );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userInfoController).asData?.value;
    final currentUser = ref.watch(currentUserController).asData?.value;
    final displayName = user?.name ?? '';
    final profilePic = user?.profilePic ?? '';
    final uid = currentUser?.uid ?? '';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Palette.niceBlack,
              radius: 60,
              backgroundImage: _image != null
                  ? FileImage(_image!)
                  : profilePic.isNotEmpty
                      ? NetworkImage(profilePic) as ImageProvider
                      : null,
              child: Builder(
                builder: (context) {
                  if (_image == null && profilePic.isEmpty) {
                    return Text(
                      displayName.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: selectImage,
              child: Text(
                'Change Profile Photo',
                style: TextStyle(
                  fontSize: 20,
                  color: Palette.niceBlue,
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            BigButton(
              child: const Text('Edit'),
              onPressed: () => editProfile(
                uid,
                nameController.text.trim().isEmpty ? displayName : nameController.text.trim(),
                profilePic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
