import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/model/club_history_model.dart';
import 'package:conveneapp/features/club/view/club_history_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubHistory extends StatelessWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const ClubHistory(),
      );

  const ClubHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const ClubHistoryView(),
    );
  }
}

class ClubHistoryView extends ConsumerWidget {
  const ClubHistoryView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return ref.watch(clubHistoryProvider).map(
          data: (data) {
            if (data.value.isLeft()) {
              return const Center(
                child: Text("Error retrieving books"),
              );
            }
            //trying to get the data if it is right
            List<ClubHistoryModel> books = data.value.getOrElse(() => []);
            if (books.isEmpty) {
              return Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Image(
                      image: const AssetImage("assets/defaultstates/empty history.png"),
                      height: (MediaQuery.of(context).size.height * 0.3),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Currently this club has no history of books',
                  ),
                ],
              ));
            } else {
              return ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, count) {
                  return ClubHistoryCard(clubHistory: books[count]);
                },
              );
            }
          },
          loading: (_) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
          error: (error) => Center(
            child: Text(error.toString()),
          ),
        );
  }
}
