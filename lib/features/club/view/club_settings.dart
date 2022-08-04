import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conveneapp/apis/firebase/user.dart';
import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/authentication/model/user_info.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/view/club_info_edit.dart';
import 'package:conveneapp/features/club/view/members_page.dart';
import 'package:conveneapp/features/dashboard/controller/user_info_controller.dart';
import 'package:conveneapp/theme/palette.dart';

class ClubSettingsView extends ConsumerStatefulWidget {
  const ClubSettingsView({Key? key}) : super(key: key);

  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ClubSettingsView(),
      );
  @override
  _ClubSettingsViewState createState() => _ClubSettingsViewState();
}

class _ClubSettingsViewState extends ConsumerState<ClubSettingsView> {
  @override
  Widget build(BuildContext context) {
    final _currentlySelectedClub = ref.watch(currentlySelectedClub);
    final _userInfoController = ref.watch(userInfoController).asData!.value;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "${_currentlySelectedClub!.name} Settings",
          style: const TextStyle(color: Palette.niceBlack),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Container(
                height: 125,
                width: 125,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  image: _currentlySelectedClub.coverImage != null
                      ? DecorationImage(image: NetworkImage(_currentlySelectedClub.coverImage!))
                      : null,
                ),
                child: Builder(
                  builder: (context) {
                    if (_currentlySelectedClub.coverImage == null) {
                      return Center(
                        child: Text(
                          _currentlySelectedClub.name.substring(0, 1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<UserInfo>(
                future: ref.watch(userApiProvider).getFutureUser(uid: _currentlySelectedClub.adminId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "Club owned by " + snapshot.data!.name!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    );
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  List<UserInfo> members = [];
                  for (var member in _currentlySelectedClub.members) {
                    UserInfo user = await ref.watch(userApiProvider).getFutureUser(uid: member);
                    members.add(user);
                  }
                  Navigator.push(context, MembersPage.route(_currentlySelectedClub, members));
                },
                child: const SettingsListTile(
                  title: "Club Members",
                  iconData: Icons.people,
                  showTrailing: true,
                ),
              ),
            ),
            if (_userInfoController.uid == _currentlySelectedClub.adminId)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => Navigator.push(context, ClubInfoEditView.route()),
                  child: const SettingsListTile(
                    title: "Edit Club Profile",
                    iconData: Icons.edit,
                    showTrailing: true,
                  ),
                ),
              ),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                Clipboard.setData(ClipboardData(text: _currentlySelectedClub.id));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Club ID Copied!"),
                ));
              },
              child: const SettingsListTile(
                title: "Invite To Club",
                iconData: Icons.share,
                primaryColor: Colors.blue,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MediumButton(
                elevation: 0,
                backgroundColor: Colors.red.shade50,
                child: const Text(
                  "Leave Club",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () async {
                  final userId = ref.watch(currentUserController).asData?.value.uid;
                  await ref.read(currentClubsController.notifier).removeFromClub(
                        club: _currentlySelectedClub,
                        memberId: userId!,
                      );
                  Navigator.popUntil(context, (route) => false);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData iconData;
  final Color? primaryColor;
  final bool? showTrailing;

  const SettingsListTile({
    Key? key,
    required this.title,
    required this.iconData,
    this.subtitle,
    this.showTrailing,
    this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool haveSubtitle = subtitle != null;

    return Container(
      decoration: BoxDecoration(
        color: Palette.niceGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: haveSubtitle ? 65 : 50,
            decoration: BoxDecoration(
              color: primaryColor ?? Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              iconData,
              color: Palette.niceGrey,
            ),
          ),
          Expanded(
            child: ListTile(
              dense: true,
              title: Text(
                title,
                style: TextStyle(color: primaryColor ?? Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              subtitle: haveSubtitle
                  ? Text(
                      subtitle!,
                      style: const TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.w500),
                    )
                  : null,
              trailing: showTrailing == true
                  ? Icon(
                      Icons.navigate_next,
                      color: primaryColor ?? Colors.black,
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
