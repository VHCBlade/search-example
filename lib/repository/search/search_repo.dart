import 'package:search_example/repository/search/search_data.dart';

abstract class SearchRepository {
  /// Executes the search using the [searchString]
  ///
  /// Returns a future that will complete with the result of the query.
  Future<List<SearchData>> search(String searchString);
}
