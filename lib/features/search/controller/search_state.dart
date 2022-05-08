part of 'search_controller.dart';

class SearchState extends Equatable {
  final SearchInput searchInput;
  final List<SearchBookModel> books;
  final FormzStatus status;

  const SearchState({
    this.searchInput = const SearchInput.pure(),
    this.books = const [],
    this.status = FormzStatus.pure,
  });

  SearchState copyWith({
    SearchInput? searchInput,
    List<SearchBookModel>? books,
    FormzStatus? status,
  }) {
    return SearchState(
      searchInput: searchInput ?? this.searchInput,
      books: books ?? this.books,
      status: status ?? this.status,
    );
  }

  static const empty = SearchState();

  @override
  List<Object?> get props => [searchInput, books, status];
}
