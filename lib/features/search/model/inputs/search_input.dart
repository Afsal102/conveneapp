import 'package:formz/formz.dart';

class SearchInput extends FormzInput<String, SearchInputValidationError> {
  const SearchInput.pure([String input = '']) : super.pure(input);

  const SearchInput.dirty(String value) : super.dirty(value);

  @override
  SearchInputValidationError? validator(String value) {
    if (value.isEmpty) {
      return SearchInputValidationError.invalid;
    }
    return null;
  }
}

enum SearchInputValidationError { invalid }
