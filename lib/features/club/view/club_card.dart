import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/club/model/personal_club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubCard extends ConsumerWidget {
  final PersonalClubModel club;
  final Future<void> Function()? onShareTap;
  ClubCard({
    Key? key,
    required this.club,
    this.onShareTap,
  }) : super(key: key);

  late final _shareProgresNotfier = ValueNotifier(false);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Palette.niceBlack,
              radius: 24,
              child: Builder(
                builder: (context) {
                  return Text(club.name.substring(0, 1));
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: CustomText(text: club.name)),
                ],
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
              valueListenable: _shareProgresNotfier,
              builder: (_, isSharing, __) {
                return IconButton(
                  onPressed: () async {
                    if (onShareTap != null && !isSharing) {
                      _shareProgresNotfier.value = true;
                      await onShareTap!();
                      _shareProgresNotfier.value = false;
                    }
                  },
                  icon: isSharing
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor,
                          ),
                        )
                      : const Icon(Icons.share),
                );
              })
        ],
      ),
    );
  }
}
