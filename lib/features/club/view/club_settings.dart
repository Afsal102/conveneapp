import 'dart:io';

import 'package:conveneapp/apis/firebase/club.dart';

import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/core/loading.dart';
import 'package:conveneapp/core/utility/utils.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ClubSettingsView extends ConsumerStatefulWidget {
  const ClubSettingsView({
    Key? key,
  }) : super(key: key);

  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ClubSettingsView(),
      );

  @override
  _ClubSettingsViewState createState() => _ClubSettingsViewState();
}

class _ClubSettingsViewState extends ConsumerState<ClubSettingsView> {
  final TextEditingController descriptionController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    descriptionController.text = ref.read(currentlySelectedClub)!.description ?? "";
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
  }

  void selectImage() async {
    var pickedImage = await pickImage(ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void editClub(
    String clubId,
    String description,
    String? currentCoverImage,
  ) async {
    final _currentlySelectedClub = ref.read(currentlySelectedClub);
    final _clubApiProvider = ref.read(clubApiProvider);

    showProgressDialog(context);
    final imageUrl = await _clubApiProvider.uploadClubImage(
      clubId: clubId,
      currentCoverImage: currentCoverImage,
      coverImage: _image,
    );

    await _clubApiProvider.updateClubInfo(
      clubId: clubId,
      description: description,
      coverImageUrl: imageUrl,
    );

    ref
        .read(currentlySelectedClub.state)
        .update((state) => _currentlySelectedClub!.copyWith(coverImage: imageUrl, description: description));

    hideProgressDialog(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final _currentlySelectedClub = ref.watch(currentlySelectedClub);
    final screenSize = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        final currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Edit ${_currentlySelectedClub!.name}",
              style: const TextStyle(color: Palette.niceBlack),
            )),
        body: ListView(
          children: [
            if (_currentlySelectedClub.coverImage != null || _image != null)
              Container(
                height: screenSize.height / 4,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                  image: _image != null
                      ? DecorationImage(image: FileImage(_image!), fit: BoxFit.cover)
                      : _currentlySelectedClub.coverImage != null
                          ? DecorationImage(image: NetworkImage(_currentlySelectedClub.coverImage!), fit: BoxFit.cover)
                          : null,
                ),
              ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Description',
                style: TextStyle(
                  fontSize: 18,
                  color: Palette.niceBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Write a few words about who this club is for or just a general introduction to the club."),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: descriptionController,
                maxLength: 50,
                maxLines: 5,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    hintText: "This group is all about cool fantasy books.."),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MediumButton(
                onPressed: selectImage,
                child: const Center(
                  child: Text(
                    'Add/Change Cover Photo',
                    style: TextStyle(
                      fontSize: 16,
                      color: Palette.niceWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MediumButton(
                onPressed: () =>
                    editClub(_currentlySelectedClub.id, descriptionController.text, _currentlySelectedClub.coverImage),
                child: const Center(
                  child: Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 16,
                      color: Palette.niceWhite,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
