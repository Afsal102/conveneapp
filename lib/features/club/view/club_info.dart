import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubInfoView extends ConsumerStatefulWidget {
  final ClubModel club;
  const ClubInfoView({Key? key, required this.club}) : super(key: key);

  @override
  _ClubInfoViewState createState() => _ClubInfoViewState();
}

class _ClubInfoViewState extends ConsumerState<ClubInfoView> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      children: [
        if (widget.club.coverImage != null)
          Container(
            height: screenSize.height / 4.5,
            decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage(widget.club.coverImage!),
                  fit: BoxFit.cover,
                )),
          ),
        if (widget.club.description != null && widget.club.description!.isNotEmpty)
          Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.transparent,
            ),
            child: ExpansionTile(
              textColor: Colors.black,
              iconColor: Colors.black,
              collapsedIconColor: Colors.black,
              collapsedTextColor: Colors.black,
              title: Text(
                "About ${widget.club.name}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    widget.club.description!,
                    maxLines: 25,
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
