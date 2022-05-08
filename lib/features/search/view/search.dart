import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/search/controller/search_controller.dart';
import 'package:conveneapp/features/search/view/search_book_card.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  static route() {
    return MaterialPageRoute(
      builder: (context) => const SearchPage(),
      fullscreenDialog: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.niceGrey,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(4),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search Book',
                        border: InputBorder.none,
                        suffixIcon: Icon(
                          Icons.search,
                          color: Palette.niceBlack,
                        ),
                      ),
                      maxLines: 1,
                      onChanged: (value) {
                        final controller = ref.read(searchController.notifier);

                        controller.resetStateIfSearchInputIsEmpty(value);

                        EasyDebounce.debounce(
                          'book-search',
                          const Duration(
                            milliseconds: 1200,
                          ),
                          () {
                            controller.debounceOnSearchInputChanged(value);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SearchView()
        ],
      ),
    );
  }
}

class DefaultView extends StatelessWidget {
  final String text;
  final String imagePath;
  const DefaultView({
    Key? key,
    required this.text,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Image(
                image: AssetImage(imagePath),
                height: (MediaQuery.of(context).size.height * 0.3),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomText(
              text: text,
            ),
          ],
        ),
      ),
    );
  }
}

class SearchView extends ConsumerWidget {
  const SearchView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(searchController);
    final submissionStatus = state.status;
    if (submissionStatus.isPure) {
      return const DefaultView(
        text: "Enter something into search",
        imagePath: "assets/defaultstates/search.png",
      );
    }

    if (submissionStatus.isSubmissionInProgress) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (submissionStatus.isSubmissionSuccess) {
      final books = state.books;
      if (books.isEmpty) {
        return const DefaultView(
          text: "There were no results for this search",
          imagePath: "assets/defaultstates/empty search.png",
        );
      }
      return Expanded(
        child: ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return GestureDetector(
              onTap: () {
                return Navigator.pop(context, book);
              },
              child: SearchBookCard(book: book),
            );
          },
        ),
      );
    }

    //TODO(afzal): handle error UI's once books api is migrated
    return const Offstage();
  }
}
