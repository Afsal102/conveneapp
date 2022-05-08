import 'package:books_finder/books_finder.dart';
import 'package:conveneapp/features/search/model/search_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final booksFinderApiProvider =
    Provider<BooksFinderApi>((ref) => BooksFinderApi());

class BooksFinderApi {
  Future<List<SearchBookModel>> searchBooks(String name) async {
    final books = await queryBooks(name,
        maxResults: 20, //TODO: How many books do we want to display
        printType: PrintType.books,
        orderBy: OrderBy.relevance,
        reschemeImageLinks: true);

    return books.map((book) {
      return SearchBookModel(
        title: book.info.title,
        authors: book.info.authors,
        pageCount: book.info.pageCount,
        coverImage: book.info.imageLinks.isEmpty
            ? null
            : book.info.imageLinks["thumbnail"].toString(),
      );
    }).toList();
  }
}
