import 'package:conveneapp/apis/books_finder/books_finder.dart';
import 'package:conveneapp/features/search/model/model.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

part 'search_state.dart';

final searchController =
    AutoDisposeStateNotifierProvider<SearchController, SearchState>(
  (ref) {
    return SearchController(
      booksFinderApi: ref.watch(
        booksFinderApiProvider,
      ),
    );
  },
);

class SearchController extends StateNotifier<SearchState> {
  final BooksFinderApi _booksFinderApi;
  SearchController({required BooksFinderApi booksFinderApi})
      : _booksFinderApi = booksFinderApi,
        super(
          SearchState.empty,
        );

  ///- used for resetting the state back to default
  void resetStateIfSearchInputIsEmpty(String value) {
    if (value.isNotEmpty) return;

    state = SearchState.empty;
    return;
  }

  void debounceOnSearchInputChanged(String value) {
    if (value.isEmpty) {
      state = SearchState.empty;
      return;
    }
    final searchInput = SearchInput.dirty(value);

    state = state.copyWith(
      searchInput: searchInput,
    );
    _fetchBooks();
    return;
  }

  Future<void> _fetchBooks() async {
    if (state.status.isSubmissionInProgress || !state.searchInput.valid) {
      return;
    }

    state = state.copyWith(status: FormzStatus.submissionInProgress);
    final result = await _booksFinderApi.searchBooks(state.searchInput.value);
    state = state.copyWith(
      status: FormzStatus.submissionSuccess,
      books: result,
    );
  }
}
