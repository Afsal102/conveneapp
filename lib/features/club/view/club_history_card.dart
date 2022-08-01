import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/club/model/club_history_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClubHistoryCard extends StatelessWidget {
  final ClubHistoryModel clubHistory;
  const ClubHistoryCard({Key? key, required this.clubHistory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Was Due on ',
                      ),
                      Text(
                        DateFormat('MMMM d, yyyy').format(clubHistory.dueDate!),
                        style: const TextStyle(fontWeight: FontWeight.bold, decorationColor: Palette.niceDarkGrey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Flexible(child: CustomText(text: clubHistory.name)),
                  if (clubHistory.authors.isNotEmpty)
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          clubHistory.authors[0],
                          style: const TextStyle(color: Palette.niceDarkGrey),
                        ),
                      ),
                    ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '${clubHistory.pageCount} pages',
                        style: const TextStyle(
                          color: Palette.niceBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          (clubHistory.coverImage == null)
              //if object gets created with no cover image we set to "noimage"
              ? Container()
              : Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3,
                        spreadRadius: -3,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      clubHistory.coverImage!,
                      width: 60,
                      height: 90,
                      cacheWidth: 80,
                      cacheHeight: 120,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
